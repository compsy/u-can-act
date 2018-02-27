# frozen_string_literal: true

module Concerns
  module IsLoggedInAsMentor
    extend ActiveSupport::Concern

    included do
      before_action :verify_mentor
    end

    private

    def verify_mentor
      @current_user ||= current_user
      return @current_user if @current_user&.mentor?
      render(status: 401, plain: 'Niet ingelogd als mentor.')
    end
  end
end
