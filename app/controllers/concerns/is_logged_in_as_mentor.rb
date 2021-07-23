# frozen_string_literal: true

module IsLoggedInAsMentor
  extend ActiveSupport::Concern

  included do
    before_action :verify_mentor
  end

  private

  def verify_mentor
    return current_user if current_user&.mentor?

    render(status: :unauthorized, html: 'Niet ingelogd als mentor.', layout: 'application')
  end
end
