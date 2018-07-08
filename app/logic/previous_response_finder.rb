# frozen_string_literal: true

class PreviousResponseFinder
  class << self
    def find(response)
      return nil unless response.present?
      return nil unless response.measurement.periodical?

      completed_responses = response.protocol_subscription.responses.completed
      return nil if completed_responses.blank?
      return completed_responses.last
    end
  end
end
