# frozen_string_literal: true
include Rails.application.routes.url_helpers

class NextPageFinder
  def self.get_next_page(current_user:, previous_response: nil, next_response: nil)
    if previous_response&.measurement&.redirect_url
      return previous_response.measurement.redirect_url
    end

    next_response ||= current_user.my_open_responses.first
    return questionnaire_path(uuid: next_response.uuid) if next_response.present?

    return mentor_overview_index_path if current_user.mentor?

    klaar_path
  end
end
