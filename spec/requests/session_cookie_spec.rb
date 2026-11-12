# frozen_string_literal: true

require 'rails_helper'

describe 'Session cookie', type: :request do
  let!(:env_config) { Rails.application.env_config }

  def session_options_for(env)
    config = Rails::Application::Configuration.new(Rails.root)
    allow(Rails).to receive_messages(env: ActiveSupport::EnvironmentInquirer.new(env),
                                     application: instance_double(Rails.application.class, config: config))
    load Rails.root.join('config/initializers/session_store.rb')
    config.session_options
  end

  def session_set_cookie(options, scheme)
    app = lambda do |env|
      env['rack.session'][:visited] = true
      [200, {}, []]
    end
    stack = ActionDispatch::Cookies.new(ActionDispatch::Session::CookieStore.new(app, options))
    _status, headers, _body = stack.call(Rack::MockRequest.env_for("#{scheme}://www.example.com/").merge(env_config))
    Array(headers['set-cookie']).join("\n").lines.find { |line| line.start_with?('_vsv_session=') }
  end

  it 'is HttpOnly and SameSite=Lax but not Secure in a local environment' do
    set_cookie = session_set_cookie(session_options_for('development'), 'http')
    expect(set_cookie).to match(/;\s*httponly/i)
    expect(set_cookie).to match(/;\s*samesite=lax/i)
    expect(set_cookie).not_to match(/;\s*secure/i)
  end

  %w[production staging].each do |env|
    it "is HttpOnly, SameSite=Lax and Secure in #{env}" do
      set_cookie = session_set_cookie(session_options_for(env), 'https')
      expect(set_cookie).to match(/;\s*httponly/i)
      expect(set_cookie).to match(/;\s*samesite=lax/i)
      expect(set_cookie).to match(/;\s*secure/i)
    end
  end

  it 'uses the session store config of the app' do
    expect(Rails.application.config.session_options).to include(key: '_vsv_session', secure: false)
  end
end
