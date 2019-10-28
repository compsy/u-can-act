# frozen_string_literal: true

module Concerns
  module IsLoggedInWithAnyMethod
    extend ActiveSupport::Concern

    # rubocop:disable Rails/LexicallyScopedActionFilter
    included do
      before_action :verify, except: %i[interactive interactive_render]
    end
    # rubocop:enable Rails/LexicallyScopedActionFilter

    private

    def verify
      result = current_user
      return result if result.present?

      result = authenticate_auth_user
      return result if result.present?

      render(status: :unauthorized, html: 'Je bent niet ingelogd.', layout: 'application')
    end
  end
end
