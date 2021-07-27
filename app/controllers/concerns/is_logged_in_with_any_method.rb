# frozen_string_literal: true

module IsLoggedInWithAnyMethod
  extend ActiveSupport::Concern

  # rubocop:disable Rails/LexicallyScopedActionFilter
  included do
    before_action :verify, except: %i[interactive interactive_render from_json]
  end
  # rubocop:enable Rails/LexicallyScopedActionFilter

  private

  def verify
    result = current_user
    return result if result.present?

    # Prevent Knock from rendering an auth error if we didn't specify an authorization header.
    # Instead, we throw our own error.
    if request.headers['Authorization'].present?
      result = authenticate_auth_user
      return result if result.present?
    end

    render(status: :unauthorized, html: 'Je bent niet ingelogd.', layout: 'application')
  end
end
