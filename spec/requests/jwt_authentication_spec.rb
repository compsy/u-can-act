# frozen_string_literal: true

require 'rails_helper'

describe 'JWT API authentication', type: :request do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:signing_key) do
    OpenSSL::PKey::RSA.new(
      Base64.strict_decode64(ENV.fetch('PRIVATE_KEY', nil)),
      ENV.fetch('PRIVATE_KEY_PASSPHRASE', nil)
    )
  end
  let(:payload) do
    {
      'sub' => the_auth_user.auth0_id_string,
      'aud' => JwtAuth.token_audience&.call,
      'iat' => Time.now.to_i,
      'exp' => 1.hour.from_now.to_i
    }.compact
  end

  def post_with_token(token)
    post '/api/v1/auth_user', headers: { 'Authorization' => "Bearer #{token}" }
  end

  it 'accepts a valid token' do
    post_with_token(JWT.encode(payload, signing_key, 'RS256'))
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body['auth0_id_string']).to eq the_auth_user.auth0_id_string
  end

  it 'accepts a valid token in the token param' do
    post '/api/v1/auth_user', params: { token: JWT.encode(payload, signing_key, 'RS256') }
    expect(response).to have_http_status(:ok)
  end

  it 'returns a 401 for an expired token' do
    expired = payload.merge('iat' => 2.hours.ago.to_i, 'exp' => 1.hour.ago.to_i)
    post_with_token(JWT.encode(expired, signing_key, 'RS256'))
    expect(response).to have_http_status(:unauthorized)
    expect(response.parsed_body['error']).to eq 'auth_user Unauthorized request'
  end

  it 'returns a 401 for a token with a bad signature' do
    post_with_token(JWT.encode(payload, OpenSSL::PKey::RSA.new(2048), 'RS256'))
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns a 401 for a token with another algorithm' do
    post_with_token(JWT.encode(payload, 'a-shared-secret', 'HS256'))
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns a 401 for a token with another audience' do
    post_with_token(JWT.encode(payload.merge('aud' => 'another-audience'), signing_key, 'RS256'))
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns a 401 for a malformed token' do
    post_with_token('not-a-jwt')
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns a 401 without a token' do
    post '/api/v1/auth_user'
    expect(response).to have_http_status(:unauthorized)
  end
end
