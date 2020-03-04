# frozen_string_literal: true

class NextPageFinder
  class << self
    include Rails.application.routes.url_helpers

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    def get_next_page(current_user:, previous_response: nil, next_response: nil, params: {})
      return previous_response.measurement.redirect_url if previous_response&.measurement&.redirect_url

      # If we come from an OTR, we never want to be redirected to the next response lined up
      return klaar_path if previous_response&.protocol&.otr_protocol?

      next_response ||= current_user.my_open_responses.first

      # We only want to schedule OTRs when we're not in a normal questionnaire
      next_response ||= current_user.my_open_one_time_responses(true).first if previous_response.blank?

      return mentor_overview_index_path if current_user.mentor? && !next_response&.protocol_subscription&.for_myself?

      return questionnaire_path(uuid: next_response.uuid, **params) if next_response.present?

      next_response = current_user.my_open_responses(false).first
      return questionnaire_path(uuid: next_response.uuid, **params) if next_response.present?

      klaar_path
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/AbcSize
  end
end
