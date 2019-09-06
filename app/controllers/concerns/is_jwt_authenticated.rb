# frozen_string_literal: true

module Concerns
  module IsJwtAuthenticated
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_auth_user
    end
  end
end
