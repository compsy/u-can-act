# frozen_string_literal: true

require 'rails_helper'

describe 'SDV launch', type: :request do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:platform_url) { 'https://platform.example' }
  let(:platform_cookie) { "Bearer #{jwt_auth({ 'sub' => the_auth_user.auth0_id_string }, false)}" }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('BASE_PLATFORM_URL', nil).and_return(platform_url)
  end

  def engine_cookie
    jar = ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)
    JSON.parse(jar.signed[CookieJar::COOKIE_LOCATION] || '{}')
  end

  describe 'with a valid platform session cookie' do
    before { cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = platform_cookie }

    it 'redirects to return_to with a 303 and stores the signed engine cookie' do
      get '/sdv/launch', params: { return_to: '/questionnaire/abc?locale=nl' }
      expect(response).to have_http_status(:see_other)
      expect(response.location).to eq 'http://www.example.com/questionnaire/abc?locale=nl'
      expect(engine_cookie[TokenAuthenticationController::JWT_TOKEN_COOKIE.to_s].first['sub'])
        .to eq the_auth_user.auth0_id_string
      expect(engine_cookie).not_to have_key(TokenAuthenticationController::PERSON_ID_COOKIE.to_s)
    end

    it 'accepts the form encoded Bearer prefix' do
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = platform_cookie.sub(' ', '+')
      get '/sdv/launch', params: { return_to: '/questionnaire' }
      expect(response.location).to eq 'http://www.example.com/questionnaire'
    end

    it 'rejects a return_to that is not a string' do
      get '/sdv/launch', params: { return_to: { a: '/questionnaire' } }
      expect(response).to have_http_status(:bad_request)
    end

    it 'redirects to the questionnaire overview without return_to' do
      get '/sdv/launch'
      expect(response).to have_http_status(:see_other)
      expect(response.location).to eq 'http://www.example.com/questionnaire'
    end

    unsafe_paths = %w[//evil.example https://evil.example /\\evil.example evil.example javascript:alert(1)]
    (unsafe_paths + ["/\t/evil.example", "/\n/evil.example"]).each do |unsafe|
      it "rejects return_to #{unsafe.inspect}" do
        get '/sdv/launch', params: { return_to: unsafe }
        expect(response).to have_http_status(:bad_request)
        expect(response.location).to be_nil
        expect(engine_cookie).not_to have_key(TokenAuthenticationController::JWT_TOKEN_COOKIE.to_s)
      end
    end

    it 'does not start a session for a cross-site request' do
      get '/sdv/launch', params: { return_to: '/questionnaire' }, headers: { 'Sec-Fetch-Site' => 'cross-site' }
      expect(response).to have_http_status(:see_other)
      expect(response.location).to eq "#{platform_url}/login"
      expect(engine_cookie).not_to have_key(TokenAuthenticationController::JWT_TOKEN_COOKIE.to_s)
    end
  end

  it 'redirects to the platform login without a platform session cookie' do
    get '/sdv/launch', params: { return_to: '/questionnaire' }
    expect(response).to have_http_status(:see_other)
    expect(response.location).to eq "#{platform_url}/login"
    expect(engine_cookie).not_to have_key(TokenAuthenticationController::JWT_TOKEN_COOKIE.to_s)
  end

  it 'redirects to the platform login for a token with another audience' do
    payload = { 'sub' => the_auth_user.auth0_id_string }
    allow(Knock).to receive(:token_audience).and_return(-> { 'another-audience' })
    cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = "Bearer #{jwt_auth(payload, false)}"
    get '/sdv/launch', params: { return_to: '/questionnaire' }
    expect(response.location).to eq "#{platform_url}/login"
  end

  it 'redirects to the platform login with an invalid platform session cookie' do
    cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = 'Bearer not-a-jwt'
    get '/sdv/launch', params: { return_to: '/questionnaire' }
    expect(response).to have_http_status(:see_other)
    expect(response.location).to eq "#{platform_url}/login"
  end

  describe 'with an invitation session' do
    let(:responseobj) { FactoryBot.create(:response, :invited) }
    let(:invited_person) { responseobj.protocol_subscription.person }
    let(:invitation_token) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

    before do
      get '/', params: { q: "#{invited_person.external_identifier}#{invitation_token.token_plain}" }
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = platform_cookie
    end

    it 'keeps the invitation person on other routes' do
      get "/questionnaire/#{responseobj.uuid}"
      expect(response).not_to have_http_status(:unauthorized)
      expect(engine_cookie[TokenAuthenticationController::PERSON_ID_COOKIE.to_s])
        .to eq invited_person.external_identifier
      expect(engine_cookie).not_to have_key(TokenAuthenticationController::JWT_TOKEN_COOKIE.to_s)
    end

    it 'switches to the platform user only on launch' do
      get '/sdv/launch'
      expect(engine_cookie).not_to have_key(TokenAuthenticationController::PERSON_ID_COOKIE.to_s)
      expect(engine_cookie[TokenAuthenticationController::JWT_TOKEN_COOKIE.to_s].first['sub'])
        .to eq the_auth_user.auth0_id_string
    end
  end
end
