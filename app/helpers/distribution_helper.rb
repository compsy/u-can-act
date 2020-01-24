# frozen_string_literal: true

module DistributionHelper
  # Consider these as private methods that are (and can only be) tested in their own
  # context, hence there is no specific test suite for this file.
  def usable_questions
    questionnaire_content = questionnaire.content
    range_questions(questionnaire_content) + other_questions(questionnaire_content)
  end

  def range_questions(questionnaire_content)
    rg_instance = RangeGenerator.new
    questionnaire_content
      .select { |question| question[:type] == :range }
      .map do |question|
      rg_instance.send(:range_slider_minmax, question).merge(id: question[:id].to_s,
                                                             type: question[:type],
                                                             step: (question[:step] || 1))
    end
  end

  def other_questions(questionnaire_content)
    questionnaire_content
      .select { |question| %i[number radio likert dropdown].include?(question[:type]) }
      .map do |question|
      { id: question[:id].to_s, type: question[:type] }
    end
  end

  def initialize_question(question, value)
    qid = question[:id]
    return if @distribution[qid].present? && question[:type] == :range

    @distribution[qid] ||= {}
    @distribution[qid][value] ||= 0 unless question[:type] == :range
    return unless question[:type] == :range

    pos = question[:min]
    while pos <= question[:max]
      @distribution[qid][pos.to_s] = 0
      pos += question[:step]
    end
  end

  def process_response_ids(response_ids)
    ResponseContent.where(:id.in => response_ids).pluck(:content).each do |content|
      @usable_questions.each do |question|
        qid = question[:id]
        next unless content[qid].present?

        initialize_question(question, content[qid])
        @distribution[qid][content[qid]] += 1
      end
    end
  end
end
