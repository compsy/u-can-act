# frozen_string_literal: true

module IsJwtAuthenticated
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_auth_user # This calls AuthUser#from_token_payload
  end
end

