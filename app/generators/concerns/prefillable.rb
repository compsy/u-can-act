# frozen_string_literal: true

# Gives access to handy methods to determine past responses of a measurement
module Prefillable
  extend ActiveSupport::Concern

  # Finds the last response for the response's user and measurement
  # @note the response found may not be part of the same protocol as the given response, but it will be of the same
  # type of questionnaire. This is exactly the behaviour needed by UMO, where a user will at most respond once to a
  # protocol, but all protocols have the same 7 initial measurements
  # @return nil if the measurement doesn't need prefilling or no previous response exists, {#Response} otherwise
  def previous_response(response)
    return nil unless response&.needs_prefilling?

    Response.joins(:measurement)
            .where(
              filled_out_by_id: response.person.id,
              measurement: { questionnaire_id: response.measurement.questionnaire_id }
            ).completed
            .order(completed_at: :desc)
            .first
  end

  def previous_value(response, question_id)
    prev_response = previous_response(response)
    return nil unless prev_response.present?

    prev_response.remote_content&.content&.[](question_id)
  end
end
