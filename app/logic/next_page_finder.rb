# frozen_string_literal: true

class NextPageFinder
  class << self
    include Rails.application.routes.url_helpers

    def get_next_page(current_user:, previous_response: nil, next_response: nil, params: {})
      return previous_response.measurement.redirect_url if previous_response&.measurement&.redirect_url

      # TODO: Check for protocol.otr_protocol? here?
      next_response ||= current_user.my_open_one_time_responses.first
      next_response ||= current_user.my_open_responses.first

      return questionnaire_path(uuid: next_response.uuid, **params) if next_response.present?

      return mentor_overview_index_path if current_user.mentor?

      klaar_path
    end
  end
end
