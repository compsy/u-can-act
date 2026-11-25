# frozen_string_literal: true

require 'rails_helper'

describe 'API with the platform session cookie', type: :request do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:person) { the_auth_user.person }
  let(:platform_url) { 'https://platform.example' }
  let(:jwt) { jwt_auth({ 'sub' => the_auth_user.auth0_id_string }, false) }
  let(:csrf_headers) { { 'X-Requested-With' => 'XMLHttpRequest', 'Origin' => platform_url } }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('BASE_PLATFORM_URL', nil).and_return(platform_url)
  end

  describe 'with only the platform cookie' do
    before { cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = "Bearer #{jwt}" }

    it 'returns the current person' do
      get '/api/v1/person/me'
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['id']).to eq person.id
    end

    it 'accepts the form encoded Bearer prefix' do
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = "Bearer+#{jwt}"
      get '/api/v1/person/me'
      expect(response).to have_http_status(:ok)
    end

    it 'downloads a questionnaire as csv' do
      questionnaire = FactoryBot.create(:questionnaire)
      get "/api/v1/questionnaire/#{questionnaire.key}.csv"
      expect(response).to have_http_status(:ok)
      expect(response.header['Content-Type']).to include 'text/csv'
    end

    it 'returns a 401 for an expired cookie' do
      expired = jwt_auth({ 'sub' => the_auth_user.auth0_id_string,
                           'iat' => 2.hours.ago.to_i, 'exp' => 1.hour.ago.to_i }, false)
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = "Bearer #{expired}"
      get '/api/v1/protocol'
      expect(response).to have_http_status(:unauthorized)
    end

    describe 'GET /api/v1/one_time_response/:otr' do
      let(:otr) { FactoryBot.create(:one_time_response, token: 'theotrtoken', protocol: FactoryBot.create(:protocol)) }

      it 'does not subscribe the person for a cross-site navigation' do
        expect(SubscribeToProtocol).not_to receive(:run!)
        get "/api/v1/one_time_response/#{otr.token}", headers: { 'Sec-Fetch-Site' => 'cross-site' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not subscribe the person for a same-site navigation without the engine session' do
        expect(SubscribeToProtocol).not_to receive(:run!)
        get "/api/v1/one_time_response/#{otr.token}",
            headers: { 'Sec-Fetch-Site' => 'same-site', 'Referer' => "#{platform_url}/" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT /api/v1/person' do
      let(:params) { { person: { locale: 'en' } } }

      it 'updates the person with the header and the platform origin' do
        put '/api/v1/person', params: params, headers: csrf_headers
        expect(response).to have_http_status(:ok)
        expect(person.reload.locale).to eq 'en'
      end

      it 'accepts the platform origin from the referer' do
        put '/api/v1/person', params: params,
                              headers: { 'X-Requested-With' => 'XMLHttpRequest',
                                         'Referer' => "#{platform_url}/questionnaires" }
        expect(response).to have_http_status(:ok)
      end

      it 'returns a 403 without the X-Requested-With header' do
        put '/api/v1/person', params: params, headers: { 'Origin' => platform_url }
        expect(response).to have_http_status(:forbidden)
        expect(person.reload.locale).not_to eq 'en'
      end

      it 'returns a 403 for a foreign origin' do
        put '/api/v1/person', params: params, headers: csrf_headers.merge('Origin' => 'https://evil.example')
        expect(response).to have_http_status(:forbidden)
        expect(person.reload.locale).not_to eq 'en'
      end

      it 'returns a 403 without an origin or referer' do
        put '/api/v1/person', params: params, headers: { 'X-Requested-With' => 'XMLHttpRequest' }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns a 403 when no platform url is configured' do
        allow(ENV).to receive(:fetch).with('BASE_PLATFORM_URL', nil).and_return(nil)
        put '/api/v1/person', params: params, headers: csrf_headers.merge('Origin' => 'http://www.example.com')
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'POST /api/v1/protocol/:id/preview' do
      let(:protocol) { FactoryBot.create(:protocol) }

      it 'renders the preview with the header and the platform origin' do
        post "/api/v1/protocol/#{protocol.name}/preview", headers: csrf_headers
        expect(response).to have_http_status(:ok)
      end

      it 'returns a 403 for a foreign origin' do
        post "/api/v1/protocol/#{protocol.name}/preview",
             headers: csrf_headers.merge('Origin' => 'https://questionnaires.platform.example')
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns a 403 without the X-Requested-With header' do
        post "/api/v1/protocol/#{protocol.name}/preview", headers: { 'Origin' => platform_url }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'with the Authorization header' do
    it 'does not apply the origin check, also with a platform cookie' do
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = 'Bearer not-a-jwt'
      put '/api/v1/person', params: { person: { locale: 'en' } },
                            headers: { 'Authorization' => "Bearer #{jwt}", 'Origin' => 'https://evil.example' }
      expect(response).to have_http_status(:ok)
      expect(person.reload.locale).to eq 'en'
    end

    it 'prefers the header over the platform cookie' do
      other = FactoryBot.create(:auth_user, :with_person)
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] =
        "Bearer #{jwt_auth({ 'sub' => other.auth0_id_string }, false)}"
      get '/api/v1/person/me', headers: { 'Authorization' => "Bearer #{jwt}" }
      expect(response.parsed_body['id']).to eq person.id
    end
  end

  describe 'CORS' do
    it 'allows credentials for the platform origin' do
      get '/api/v1/settings', headers: { 'Origin' => platform_url }
      expect(response.headers['Access-Control-Allow-Origin']).to eq platform_url
      expect(response.headers['Access-Control-Allow-Credentials']).to eq 'true'
    end

    it 'allows credentials in a preflight from the platform origin' do
      options '/api/v1/person', headers: { 'Origin' => platform_url,
                                           'Access-Control-Request-Method' => 'PUT',
                                           'Access-Control-Request-Headers' => 'x-requested-with' }
      expect(response.headers['Access-Control-Allow-Origin']).to eq platform_url
      expect(response.headers['Access-Control-Allow-Credentials']).to eq 'true'
    end

    it 'does not allow credentials for another origin' do
      get '/api/v1/settings', headers: { 'Origin' => 'https://evil.example' }
      expect(response.headers['Access-Control-Allow-Origin']).to eq '*'
      expect(response.headers['Access-Control-Allow-Credentials']).to be_nil
    end

    it 'does not allow credentials for a sibling subdomain' do
      get '/api/v1/settings', headers: { 'Origin' => 'https://questionnaires.platform.example' }
      expect(response.headers['Access-Control-Allow-Credentials']).to be_nil
    end
  end
end
