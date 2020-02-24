# frozen_string_literal: true

module Concerns
  module IsLoggedIn
    extend ActiveSupport::Concern

    # rubocop:disable Rails/LexicallyScopedActionFilter
    included do
      before_action :verify_current_user, except: %i[interactive interactive_render from_json]
    end
    # rubocop:enable Rails/LexicallyScopedActionFilter

    private

    def verify_current_user
      return current_user unless current_user.nil?

      log_cookie
      render(status: :unauthorized, html: 'Je bent niet ingelogd.', layout: 'application')
    end
  end
end
