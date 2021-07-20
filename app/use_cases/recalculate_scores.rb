# frozen_string_literal: true

class RecalculateScores < ActiveInteraction::Base
  BATCH_SIZE = 200
  object :questionnaire

  # Recalculates the scores for a questionnaire
  #
  # @param questionnaire [Questionnaire] the current questionnaire
  def execute
    @questionnaire_content = questionnaire.content
    offset = 0
    loop do
      response_ids = questionnaire.responses.completed.limit(BATCH_SIZE).offset(offset).pluck(:content)
      break if response_ids.blank?

      recalculate_response_ids(response_ids)
      offset += BATCH_SIZE
    end
    recalculate_distribution
  end

  private

  def recalculate_response_ids(response_ids)
    ResponseContent.where(:id.in => response_ids).pluck(:content, :id).each do |content, rcid|
      # Note that we don't check for csrf_failed here (on purpose)
      # It doesn't hurt to calculate scores for csrf_failed responses.
      next if content.blank? # Can theoretically happen.

      scores = CalculateScores.run!(content: content, questionnaire: @questionnaire_content)
      ResponseContent.find(rcid)&.update!(scores: scores)
    end
  end

  def recalculate_distribution
    # Recalculate the distribution for this questionnaire if there are completed responses
    response_id = questionnaire.responses.completed.limit(1).pick(:id)
    return if response_id.blank?

    CalculateDistributionJob.perform_later(response_id)
  end
end
