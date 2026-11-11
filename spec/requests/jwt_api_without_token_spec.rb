# frozen_string_literal: true

require 'rails_helper'

describe 'JWT API routes without a token', type: :request do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:signing_key) do
    OpenSSL::PKey::RSA.new(
      Base64.strict_decode64(ENV.fetch('PRIVATE_KEY', nil)),
      ENV.fetch('PRIVATE_KEY_PASSPHRASE', nil)
    )
  end

  before do
    key = signing_key
    allow(JwtAuth).to receive(:token_secret_signature_key).and_return(-> { key })
  end

  def bearer_header
    { 'Authorization' => "Bearer #{jwt_auth({ 'sub' => the_auth_user.auth0_id_string }, false)}" }
  end

  shared_examples_for 'a JWT API route that refuses a request without a token' do |route|
    it 'returns a 401 after an earlier request with a token' do
      get route, headers: bearer_header
      expect(response).not_to have_http_status(:unauthorized)

      get route
      expect(response).to have_http_status(:unauthorized)
    end
  end

  it_behaves_like 'a JWT API route that refuses a request without a token', '/api/v1/one_time_response/unknown'
  it_behaves_like 'a JWT API route that refuses a request without a token', '/api/v1/questionnaire'
end
