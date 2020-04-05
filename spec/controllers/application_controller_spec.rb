# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController, type: :controller do
  describe 'options' do
    it 'heads okay' do
      get :options
      expect(response).to be_ok
      expect(response.body).to eq ''
    end
  end

  describe 'options route' do
    let(:constraints) { %i[post put patch delete] }

    it 'is okay' do
      constraints.each do |constraint|
        send(constraint, :options)
        expect(response).to be_ok
      end
    end
  end

  describe 'log_cookie' do
    it 'logs an info message with the correct text when cookies enabled' do
      controller.store_verification_cookie
      expect(Rails.logger)
        .to receive(:info)
        .with('Cookies are enabled')
      controller.log_cookie
    end
    it 'logs an info message with the correct text when cookies disabled' do
      expect(Rails.logger)
        .to receive(:info)
        .with('Cookies are NOT enabled for this user!')
      controller.log_cookie
    end
  end

  describe 'store_verification_cookie' do
    controller(ApplicationController) do
      def index
        store_verification_cookie
        render plain: 'done'
      end
    end

    it 'stores the verification cookie' do
      expected = { described_class::TEST_COOKIE => described_class::TEST_COOKIE_ENTRY }
      expect(CookieJar)
        .to receive(:set_or_update_cookie)
        .with(instance_of(ActionDispatch::Cookies::SignedKeyRotatingCookieJar), expected)
      get :index
    end
  end
end
