# frozen_string_literal: true

module Concerns
  module IsLoggedIn
    extend ActiveSupport::Concern

    included do
      before_action :verify_current_user
    end

    private

    def verify_current_user
      @current_user ||= current_user
      return @current_user unless @current_user.nil?
      render(status: 401, plain: 'Je hebt geen toegang tot deze vragenlijst.')
    end
  end
end
