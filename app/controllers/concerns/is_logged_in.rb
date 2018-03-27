# frozen_string_literal: true

module Concerns
  module IsLoggedIn
    extend ActiveSupport::Concern

    included do
      before_action :verify_current_user
    end

    private

    def verify_current_user
      return current_user unless current_user.nil?
      log_cookie
      render(status: 401, plain: 'Je hebt geen toegang tot deze vragenlijst.')
    end
  end
end
