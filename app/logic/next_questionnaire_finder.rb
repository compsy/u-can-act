# frozen_string_literal: true

class NextPageFinder
  def self.get_next_page(first_response = nil)
    first_response ||= current_user.my_open_responses.first
    return questionnaire_path(uuid: first_response.uuid) if first_response.present?

    return mentor_overview_index_path if current_user.mentor?

    klaar_path
  end
end
