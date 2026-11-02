# frozen_string_literal: true

module IsLoggedIn
  extend ActiveSupport::Concern

  # rubocop:disable Rails/LexicallyScopedActionFilter
  included do
    before_action :verify_current_user, except: %i[interactive interactive_render interactive_post from_json]
  end
  # rubocop:enable Rails/LexicallyScopedActionFilter

  private

  def verify_current_user
    return current_user unless current_user.nil?

    log_cookie
    render(status: :unauthorized, html: I18n.t('questionnaires.not_logged_in'), layout: 'application')
  end
end
