# frozen_string_literal: true

module AuthHelper
  def basic_auth(user, password)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  end
end
