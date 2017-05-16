# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionnaireController, type: :controller do
  describe 'GET #index' do
    it 'requires a q parameter' do
      get :show
      expect(response).to have_http_status(404)
      expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
    end
    it 'requires a q parameter that exists' do
      get :show, params: { q: 'something' }
      expect(response).to have_http_status(404)
      expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
    end
    it 'requires a response that is not filled out yet' do
      responseobj = FactoryGirl.create(:response, :completed)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      get :show, params: { q: invitation_token.token }
      expect(response).to have_http_status(404)
      expect(response.body).to include('Je hebt deze vragenlijst al ingevuld.')
    end
    it 'requires a q parameter that is not expired' do
      invitation_token = FactoryGirl.create(:invitation_token)
      get :show, params: { q: invitation_token.token }
      expect(response).to have_http_status(404)
      expect(response.body).to include('Deze vragenlijst kan niet meer ingevuld worden.')
    end
    it 'shows status 200 when everything is correct' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      get :show, params: { q: invitation_token.token }
      expect(response).to have_http_status(200)
      # TODO: maybe add a check for some questionnaire contents
    end
  end
end
