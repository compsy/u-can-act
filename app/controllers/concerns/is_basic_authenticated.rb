# frozen_string_literal: true

module IsBasicAuthenticated
  extend ActiveSupport::Concern

  included do
    before_action :http_authenticate
  end

  def http_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      next false unless ENV['API_KEY'].present? && ENV['API_SECRET'].present?

      ActiveSupport::SecurityUtils.secure_compare(username, ENV['API_KEY']) &&
        ActiveSupport::SecurityUtils.secure_compare(password, ENV['API_SECRET'])
    end
  end
end

