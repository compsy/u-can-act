# frozen_string_literal: true

# Gives access to handy methods to determine past responses of a measurement
module Prefillable
  extend ActiveSupport::Concern

  class_methods do
    # Finds the last response for the response's user and measurement
    # @note the response found may not be part of the same protocol as the given response, but it will be of the same
    # type of questionnaire. This is exactly the behaviour needed by UMO, where a user will at most respond once to a
    # protocol, but all protocols have the same 7 initial measurements
    # @param response [Response] The response whose previous response we want to find
    # @param check_prefilling [Boolean] If set to true (default) the method will return nil if the response does not
    # need profiling. If set to false, the method will always try to find the previous response. This switch was added
    # for compatibility with the {PreviousResponseFinder#find} method
    # @return nil if the measurement doesn't need prefilling or no previous response exists, {#Response} otherwise
    def previous_response(response, check_prefilling=true)
      return nil if check_prefilling && !response&.needs_prefilling?

      Response.joins(:measurement)
              .where(
                filled_out_by_id: response.person.id,
                measurement: { questionnaire_id: response.measurement.questionnaire_id }
              ).completed
              .order(completed_at: :desc)
              .first
    end

    def previous_response_content(response)
      prev_response = previous_response(response)
      values = prev_response&.values

      return values if values.present?

      nil
    end
  end

  def previous_response(*args)
    self.class.previous_response(*args)
  end

  def previous_response_content(*args)
    self.class.previous_response_content(*args)
  end
end
