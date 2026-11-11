# frozen_string_literal: true

module IsAdminAuthenticated
  extend ActiveSupport::Concern

  private

  def authenticate_admin
    name = ENV.fetch('ADMIN_USERNAME', nil)
    password = ENV.fetch('ADMIN_PASSWORD', nil)
    return head(:forbidden) if name.blank? || password.blank?

    http_basic_authenticate_or_request_with(name: name, password: password)
  end
end
