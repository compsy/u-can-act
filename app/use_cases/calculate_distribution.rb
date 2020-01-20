# frozen_string_literal: true

class CalculateDistribution < ActiveInteraction::Base
  BATCH_SIZE = 200
  object :questionnaire

  # Calculates the distribution for a questionnaire
  #
  # @param questionnaire [Questionnaire] the current questionnaire
  def execute
    @usable_questions = usable_questions
    @distribution = { 'total' => questionnaire.responses.completed.count }

    offset = 0
    loop do
      response_ids = questionnaire.responses.completed.limit(BATCH_SIZE).offset(offset).pluck(:content)
      break if response_ids.blank?

      process_response_ids(response_ids)
      offset += BATCH_SIZE
    end
    RedisService.set("distribution_#{questionnaire.key}", @distribution.to_json)
  end

  private

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
      .select { |question| %i[number radio likert].include?(question[:type]) }
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
        if content[qid].present?
          initialize_question(question, content[qid])
          @distribution[qid][content[qid]] += 1
        end
      end
    end
  end
end
