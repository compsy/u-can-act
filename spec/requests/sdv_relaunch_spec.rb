# frozen_string_literal: true

require 'rails_helper'

describe 'SDV relaunch after the session expires', type: :request do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:person) { the_auth_user.person }
  let(:protocol_subscription) { FactoryBot.create(:protocol_subscription, person: person, start_date: 1.week.ago) }
  let(:responseobj) do
    FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription, open_from: 10.minutes.ago)
  end
  let(:questionnaire_url) { "/questionnaire/#{responseobj.uuid}" }

  def platform_cookie
    "Bearer #{jwt_auth({ 'sub' => the_auth_user.auth0_id_string, 'exp' => 5.minutes.from_now.to_i }, false)}"
  end

  def launch
    cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = platform_cookie
    get '/sdv/launch', params: { return_to: questionnaire_url }
    expect(response).to have_http_status(:see_other)
  end

  def relaunch_location(return_to)
    "http://www.example.com/sdv/launch?#{{ return_to: return_to }.to_query}"
  end

  describe 'when the engine session has expired' do
    before do
      launch
      Timecop.travel(10.minutes.from_now)
    end

    it 'redirects a page request to the launch route with the current path' do
      get questionnaire_url, params: { locale: 'nl' }
      expect(response).to have_http_status(:see_other)
      expect(response.location).to eq relaunch_location("#{questionnaire_url}?locale=nl")
    end

    it 'redirects an answer submit to the launch route for the same questionnaire' do
      post '/', params: { response_id: responseobj.id, content: { v1: 'slecht' } }
      expect(response).to have_http_status(:see_other)
      expect(response.location).to eq relaunch_location(questionnaire_url)
      expect(responseobj.reload.completed_at).to be_nil
    end

    it 'returns a submit for a response of another person to the questionnaire overview' do
      other_response = FactoryBot.create(:response, :invited, open_from: 10.minutes.ago)
      post '/', params: { response_id: other_response.id, content: { v1: 'slecht' } }
      expect(response.location).to eq relaunch_location('/questionnaire')
    end

    it 'keeps a 401 when the platform URL is not configured' do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('BASE_PLATFORM_URL', nil).and_return(nil)
      get questionnaire_url
      expect(response).to have_http_status(:unauthorized)
    end

    it 'keeps a 401 for XHR requests' do
      get questionnaire_url, xhr: true
      expect(response).to have_http_status(:unauthorized)
    end

    it 'opens the questionnaire again after a relaunch with a fresh platform token' do
      launch
      expect(response.location).to eq "http://www.example.com#{questionnaire_url}"
      get questionnaire_url
      expect(response).to have_http_status(:ok)
    end
  end

  it 'keeps a 401 without any SDV or engine session' do
    get questionnaire_url
    expect(response).to have_http_status(:unauthorized)
    post '/', params: { response_id: responseobj.id, content: { v1: 'slecht' } }
    expect(response).to have_http_status(:unauthorized)
  end

  describe 'when the platform session has expired too' do
    before { allow(ENV).to receive(:fetch).and_call_original }

    it 'sends the user to the platform login with a way back to the launch route' do
      allow(ENV).to receive(:fetch).with('BASE_PLATFORM_URL', nil).and_return('https://platform.example')
      allow(ENV).to receive(:fetch).with('HOST_URL', nil).and_return('https://engine.example')
      get '/sdv/launch', params: { return_to: questionnaire_url }
      expect(response).to have_http_status(:see_other)
      relaunch_url = "https://engine.example/sdv/launch?#{{ retry: 1, return_to: questionnaire_url }.to_query}"
      expect(response.location).to eq "https://platform.example/login?#{{ redirect_uri: relaunch_url }.to_query}"
    end

    it 'stops after one round trip to the platform' do
      get '/sdv/launch', params: { return_to: questionnaire_url, retry: 1 }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
