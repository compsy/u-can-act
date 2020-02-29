# frozen_string_literal: true

module DistributionHelper
  include ConversionHelper
  # This is just the default value for the structure. Imagine the structure not being a hash but just
  # a single value, it would be this value. The reason that everything has to be a hash is so that we
  # can nest combined scores into combined histograms that are constructed recursively. In order for
  # that to work, here we choose a value that is short (because everything is stored in JSON format)
  # and is probably not taken by any of the question IDs.
  VALUE = '_'

  # Consider these as private methods that are (and can only be) tested in their own
  # context, hence there is no specific test suite for this file.
  def usable_questions
    @questionnaire_content = questionnaire.content
    # If there are old questionnaires in the system that no longer have seeds
    # attached to them and are still in the old format, just leave them alone.
    return [] unless @questionnaire_content.is_a?(Hash) &&
                     @questionnaire_content.key?(:questions) && @questionnaire_content.key?(:scores)

    range_questions(@questionnaire_content[:questions]) +
      other_questions(@questionnaire_content[:questions]) +
      checkbox_questions(@questionnaire_content[:questions]) +
      scores(@questionnaire_content[:scores])
  end

  def range_questions(questionnaire_content)
    rg_instance = RangeGenerator.new
    questionnaire_content
      .select { |question| question[:type] == :range }
      .map do |question|
      rg_instance.range_slider_minmax(question).merge(id: question[:id].to_s,
                                                      type: question[:type],
                                                      combines_with: question[:combines_with],
                                                      step: (question[:step] || 1))
    end
  end

  def other_questions(questionnaire_content)
    questionnaire_content
      .select { |question| %i[number radio likert dropdown date].include?(question[:type]) }
      .map do |question|
      { id: question[:id].to_s, type: question[:type], combines_with: question[:combines_with] }
    end
  end

  def checkbox_questions(questionnaire_content)
    questions = []
    questionnaire_content
      .select { |question| %i[checkbox].include?(question[:type]) }
      .each do |question|
      generate_checkbox_options(question).each do |option|
        questions << option
      end
    end
    questions
  end

  def generate_checkbox_options(question)
    options = []
    cur_titles = titles(question, :options)
    return options if cur_titles.size.zero?

    cur_titles.each do |title|
      options << idify(question[:id], title)
    end
    unless question.key?(:show_otherwise) && question[:show_otherwise].blank?
      otherwise_label = QuestionTypeGenerator::OTHERWISE_TEXT
      otherwise_label = question[:otherwise_label] if question[:otherwise_label].present?
      options << idify(question[:id], otherwise_label)
    end
    options.uniq.map { |option| { id: option, type: question[:type], combines_with: nil } }
  end

  def scores(questionnaire_content)
    # skip scores that don't have the :round_to_decimals .key?
    questionnaire_content
      .select { |score| score.key?(:round_to_decimals) }
      .map do |score|
      { id: score[:id].to_s, type: :score, combines_with: nil }
    end
  end

  def initialize_question(question, value, distribution)
    qid = question[:id]
    distribution[qid] ||= {}
    if distribution[qid].blank? && question[:type] == :range
      %i[min max step].each do |prop|
        distribution[qid]["#{VALUE}#{prop}"] = question[prop]
      end
    end
    distribution[qid][value] ||= { VALUE => 0 }
  end

  def process_response_ids(response_ids)
    ResponseContent.where(:id.in => response_ids).pluck(:content, :scores).each do |content, scores|
      next if content.nil? # Can theoretically happen

      all_content = scores.present? ? content.merge(scores) : content
      @usable_questions.each do |question|
        add_to_distribution(question, all_content, @distribution)
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def add_to_distribution(question, content, distribution)
    qid = question[:id]
    return unless content[qid].present?

    initialize_question(question, content[qid], distribution)
    distribution[qid][content[qid]][VALUE] += 1
    return if question[:combines_with].blank?

    question[:combines_with].each do |qid2|
      question2 = @usable_questions.find { |usable_question| usable_question[:id] == qid2.to_s }
      next unless question2.present?

      add_to_distribution(question2, content, distribution[qid][content[qid]])
    end
  end
  # rubocop:enable Metrics/AbcSize
end
