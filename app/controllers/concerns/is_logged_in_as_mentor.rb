# frozen_string_literal: true

module Concerns
  module IsLoggedInAsMentor
    extend ActiveSupport::Concern

    included do
      before_action :verify_mentor
    end

    private

    def verify_mentor
      return current_user if current_user&.mentor?

      render(status: 401, html: 'Niet ingelogd als mentor.', layout: 'application')
    end
  end
end
