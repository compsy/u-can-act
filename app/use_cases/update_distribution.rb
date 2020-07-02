# frozen_string_literal: true

class UpdateDistribution < ActiveInteraction::Base
  object :questionnaire
  object :response
  include DistributionHelper

  # Updates the distribution for a response
  #
  # @param questionnaire [Questionnaire] the questionnaire of the response
  # @param response [Response] the current response
  def execute
    @distribution = JSON.parse(RedisService.get("distribution_#{questionnaire.key}") || '{}')
    if @distribution.blank?
      CalculateDistribution.run!(questionnaire: questionnaire)
      return
    end
    @usable_questions = usable_questions
    @distribution['total'] += process_response_ids([response.content])
    RedisService.set("distribution_#{questionnaire.key}", @distribution.to_json)
  end
end
