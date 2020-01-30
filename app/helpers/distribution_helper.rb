# frozen_string_literal: true

module DistributionHelper
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
    range_questions(@questionnaire_content) + other_questions(@questionnaire_content)
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
      .select { |question| %i[number radio likert dropdown].include?(question[:type]) }
      .map do |question|
      { id: question[:id].to_s, type: question[:type], combines_with: question[:combines_with] }
    end
  end

  def initialize_question(question, value, distribution)
    qid = question[:id]
    return if distribution[qid].present? && question[:type] == :range

    distribution[qid] ||= {}
    unless question[:type] == :range
      distribution[qid][value] ||= { VALUE => 0 }
      return
    end

    pos = question[:min]
    while pos <= question[:max]
      distribution[qid][pos.to_s] = { VALUE => 0 }
      pos += question[:step]
    end
  end

  def process_response_ids(response_ids)
    ResponseContent.where(:id.in => response_ids).pluck(:content).each do |content|
      @usable_questions.each do |question|
        add_to_distribution(question, content, @distribution)
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
