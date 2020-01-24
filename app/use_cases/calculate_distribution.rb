# frozen_string_literal: true

class CalculateDistribution < ActiveInteraction::Base
  BATCH_SIZE = 200
  object :questionnaire
  include DistributionHelper

  # Calculates the distribution for a questionnaire
  #
  # @param questionnaire [Questionnaire] the current questionnaire
  def execute
    @distribution = { 'total' => questionnaire.responses.completed.count }
    @usable_questions = usable_questions

    offset = 0
    loop do
      response_ids = questionnaire.responses.completed.limit(BATCH_SIZE).offset(offset).pluck(:content)
      break if response_ids.blank?

      process_response_ids(response_ids)
      offset += BATCH_SIZE
    end
    RedisService.set("distribution_#{questionnaire.key}", @distribution.to_json)
  end
end
