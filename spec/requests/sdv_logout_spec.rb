# frozen_string_literal: true

require 'rails_helper'

describe 'SDV logout ends the engine session', type: :request do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:other_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:protocol_subscription) do
    FactoryBot.create(:protocol_subscription, person: the_auth_user.person, start_date: 1.week.ago)
  end
  let(:responseobj) do
    FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription, open_from: 10.minutes.ago)
  end
  let(:questionnaire_url) { "/questionnaire/#{responseobj.uuid}" }

  def platform_cookie(auth_user = the_auth_user)
    "Bearer #{jwt_auth({ 'sub' => auth_user.auth0_id_string }, false)}"
  end

  def engine_cookie
    jar = ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)
    JSON.parse(jar.signed[CookieJar::COOKIE_LOCATION] || '{}')
  end

  def relaunch_location(return_to)
    "http://www.example.com/sdv/launch?#{{ relaunch: 1, return_to: return_to }.to_query}"
  end

  def expect_session_ended
    expect(response).to have_http_status(:see_other)
    expect(response.location).to eq relaunch_location(questionnaire_url)
    expect(engine_cookie).not_to have_key(TokenAuthenticationController::JWT_TOKEN_COOKIE.to_s)
  end

  describe 'after a launch from the platform' do
    before do
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = platform_cookie
      get '/sdv/launch', params: { return_to: questionnaire_url }
      expect(engine_cookie).to have_key(TokenAuthenticationController::JWT_TOKEN_COOKIE.to_s)
    end

    it 'keeps the session with the same platform user' do
      get questionnaire_url
      expect(response).to have_http_status(:ok)
    end

    it 'keeps the session when the request has no platform session cookie' do
      cookies.delete(SdvLaunchController::PLATFORM_SESSION_COOKIE)
      get questionnaire_url
      expect(response).to have_http_status(:ok)
    end

    it 'ends the session when the platform session cookie is blank' do
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = ''
      get questionnaire_url
      expect_session_ended
    end

    it 'ends the session when the platform session cookie is not a valid token' do
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = 'Bearer not-a-jwt'
      get questionnaire_url
      expect_session_ended
    end

    it 'ends the session when the platform session belongs to another user' do
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = platform_cookie(other_auth_user)
      get questionnaire_url
      expect_session_ended
    end

    it 'does not accept an answer after the platform logout' do
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = ''
      post '/', params: { response_id: responseobj.id, content: { v1: 'slecht' } }
      expect(response).to have_http_status(:see_other)
      expect(response.location).to eq relaunch_location('/questionnaire')
      expect(responseobj.reload.completed_at).to be_nil
      expect(engine_cookie).not_to have_key(TokenAuthenticationController::JWT_TOKEN_COOKIE.to_s)
    end
  end

  describe 'with an invitation session' do
    let(:invited_response) { FactoryBot.create(:response, :invited) }
    let(:invited_person) { invited_response.protocol_subscription.person }
    let(:invitation_token) { FactoryBot.create(:invitation_token, invitation_set: invited_response.invitation_set) }

    before do
      get '/', params: { q: "#{invited_person.external_identifier}#{invitation_token.token_plain}" }
    end

    it 'keeps the invitation person with a blank platform session cookie' do
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] = ''
      get "/questionnaire/#{invited_response.uuid}"
      expect(response).not_to have_http_status(:unauthorized)
      expect(response).not_to have_http_status(:see_other)
      expect(engine_cookie[TokenAuthenticationController::PERSON_ID_COOKIE.to_s])
        .to eq invited_person.external_identifier
    end
  end
end
