# frozen_string_literal: true

class PreviousResponseFinder
  class << self
    def find(response)
      return nil unless response.present?
      return nil unless response.measurement.periodical?

      completed_responses = response.protocol_subscription.responses.completed

      # Note that we only want responses of the same questionnaire. We should not check for
      # measurements here, as the questionnaire could span multiple measurements.
      completed_responses = completed_responses .select do |resp|
        resp.measurement.questionnaire_id == response.measurement.questionnaire_id
      end

      return nil if completed_responses.blank?

      completed_responses.last
    end

    def find_value(response, question_id)
      previous_response = find(response)
      return nil if previous_response&.values.blank?

      # The keys of the values of a response are usually strings, but to also
      # support symbols, use with_indifferent_access here.
      previous_response.values.with_indifferent_access[question_id]
    end
  end
end
