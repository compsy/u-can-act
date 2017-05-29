# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardController, type: :controller do
  describe 'GET /klaar' do
    it 'should require a response id' do
      get :show
      expect(response).to have_http_status(401)
      expect(response.body).to include('Je kan deze pagina alleen bekijken na het invullen van een vragenlijst.')
    end
    it 'should require a valid response id' do
      expect(CookieJar).to receive(:read_entry)
        .with(instance_of(ActionDispatch::Cookies::SignedCookieJar), TokenAuthenticationController::RESPONSE_ID_COOKIE)
        .and_return('5')

      get :show
      expect(response).to have_http_status(401)
      expect(response.body).to include('Je kan deze pagina alleen bekijken na het invullen van een vragenlijst.')
    end
    it 'should require a completed response' do
      responseobj = FactoryGirl.create(:response)
      expect(CookieJar).to receive(:read_entry)
        .with(instance_of(ActionDispatch::Cookies::SignedCookieJar), TokenAuthenticationController::RESPONSE_ID_COOKIE)
        .and_return(responseobj.id.to_s)

      get :show
      expect(response).to have_http_status(400)
      expect(response.body).to include('Je kan deze pagina pas bekijken als je de vragenlijst hebt ingevuld.')
    end
    it 'does not give an error when the response is completed' do
      responseobj = FactoryGirl.create(:response, :completed)
      expect(CookieJar).to receive(:read_entry)
        .with(instance_of(ActionDispatch::Cookies::SignedCookieJar), TokenAuthenticationController::RESPONSE_ID_COOKIE)
        .and_return(responseobj.id.to_s)

      get :show
      expect(response).to have_http_status(200)
    end
  end
end
