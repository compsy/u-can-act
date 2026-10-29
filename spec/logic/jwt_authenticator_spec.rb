# frozen_string_literal: true

require 'rails_helper'

describe JwtAuthenticator do
  describe 'auth_from_cookies' do
    let(:person) { FactoryBot.create(:person, :with_auth_user) }
    let(:iat) { Time.now.to_i }
    let(:exp) { iat + 3600 }

    it 'should use the auth from the cookiejar if available' do
      cookies = double('cookies')
      expect(CookieJar).to receive(:read_entry)
        .with(cookies, TokenAuthenticationController::JWT_TOKEN_COOKIE)
        .and_return([{ 'sub' => person.auth_user.auth0_id_string, 'iat' => iat, 'exp' => exp }])
      expect(JWT).to_not receive(:decode)

      # Mock away this function
      expect(described_class).to receive(:store_token_in_cookie)
        .and_return(true)

      result = described_class.auth_from_cookies(cookies)
      expect(result).to eql person
    end

    it 'should store the token in a cookie' do
      cookies = double('cookies')
      token = [{ 'sub' => person.auth_user.auth0_id_string, 'iat' => iat, 'exp' => exp }]
      expect(CookieJar).to receive(:read_entry)
        .with(cookies, TokenAuthenticationController::JWT_TOKEN_COOKIE)
        .and_return(token)
      expect(JWT).to_not receive(:decode)

      cookie = { TokenAuthenticationController::JWT_TOKEN_COOKIE => token }
      expect(CookieJar).to receive(:set_or_update_cookie)
        .with(cookies, cookie)
      expect(CookieJar).to receive(:delete_cookie)
        .with(cookies, TokenAuthenticationController::PERSON_ID_COOKIE)

      result = described_class.auth_from_cookies(cookies)
      expect(result).to eql person
    end

    it 'should not return a person for an expired stored token' do
      cookies = double('cookies')
      expect(CookieJar).to receive(:read_entry)
        .with(cookies, TokenAuthenticationController::JWT_TOKEN_COOKIE)
        .and_return([{ 'sub' => person.auth_user.auth0_id_string, 'iat' => iat - 86_400, 'exp' => iat - 1 }])
      expect(CookieJar).not_to receive(:set_or_update_cookie)

      result = described_class.auth_from_cookies(cookies)
      expect(result).to be_nil
    end

    it 'should not return a person for a stored token without exp' do
      cookies = double('cookies')
      expect(CookieJar).to receive(:read_entry)
        .with(cookies, TokenAuthenticationController::JWT_TOKEN_COOKIE)
        .and_return([{ 'sub' => person.auth_user.auth0_id_string, 'iat' => iat }])
      expect(CookieJar).not_to receive(:set_or_update_cookie)

      result = described_class.auth_from_cookies(cookies)
      expect(result).to be_nil
    end

    it 'should not return a person for a stored token that lives longer than 24 hours' do
      cookies = double('cookies')
      expect(CookieJar).to receive(:read_entry)
        .with(cookies, TokenAuthenticationController::JWT_TOKEN_COOKIE)
        .and_return([{ 'sub' => person.auth_user.auth0_id_string, 'iat' => iat, 'exp' => iat + 30.days.to_i }])
      expect(CookieJar).not_to receive(:set_or_update_cookie)

      result = described_class.auth_from_cookies(cookies)
      expect(result).to be_nil
    end
  end

  describe 'auth_from_params' do
    let(:person) { FactoryBot.create(:person, :with_auth_user) }

    it 'should not do anything with empty params' do
      cookies = double('cookies')
      expect(CookieJar).not_to receive(:read_entry) # it will call the jwt decoder instead
      result = described_class.auth_from_params(cookies, {})
      expect(result).to be_nil
    end

    it 'should return nil if the stuff in the header is not a jwt token' do
      cookies = double('cookies')
      params = { auth: 'this is not a token!' }
      expect(CookieJar).not_to receive(:read_entry) # it will call the jwt decoder instead
      result = described_class.auth_from_params(cookies, params)
      expect(result).to be_nil
    end

    it 'should store the token in a cookie' do
      cookies = double('cookies')
      token = [{ 'sub' => person.auth_user.auth0_id_string, 'iat' => Time.now.to_i, 'exp' => 1.hour.from_now.to_i }]
      expect(CookieJar).not_to receive(:read_entry)
      expect(JWT).to receive(:decode).and_return(token)

      cookie = { TokenAuthenticationController::JWT_TOKEN_COOKIE => token }
      expect(CookieJar).to receive(:set_or_update_cookie)
        .with(cookies, cookie)
      expect(CookieJar).to receive(:delete_cookie)
        .with(cookies, TokenAuthenticationController::PERSON_ID_COOKIE)

      result = described_class.auth_from_params(cookies, auth: 'valid auth')
      expect(result).to eql person
    end

    def signed_token(payload)
      private_key = OpenSSL::PKey::RSA.new(
        Base64.strict_decode64(ENV.fetch('PRIVATE_KEY', nil)),
        ENV.fetch('PRIVATE_KEY_PASSPHRASE', nil)
      )
      JWT.encode(payload.merge('sub' => person.auth_user.auth0_id_string, 'aud' => Knock.token_audience.call),
                 private_key, 'RS256')
    end

    it 'should return a person for a signed token that lives 24 hours' do
      cookies = double('cookies')
      allow(CookieJar).to receive(:set_or_update_cookie)
      allow(CookieJar).to receive(:delete_cookie)

      iat = Time.now.to_i
      token = signed_token('iat' => iat, 'exp' => iat + 24.hours.to_i)
      expect(described_class.auth_from_params(cookies, auth: token)).to eql person
    end

    it 'should not return a person for a signed token that lives longer than 24 hours' do
      cookies = double('cookies')
      expect(CookieJar).not_to receive(:set_or_update_cookie)

      iat = Time.now.to_i
      token = signed_token('iat' => iat, 'exp' => iat + 24.hours.to_i + 60)
      expect(described_class.auth_from_params(cookies, auth: token)).to be_nil
    end

    it 'should not return a person for a signed token without exp' do
      cookies = double('cookies')
      expect(CookieJar).not_to receive(:set_or_update_cookie)

      token = signed_token('iat' => Time.now.to_i)
      expect(described_class.auth_from_params(cookies, auth: token)).to be_nil
    end
  end

  describe 'auth_from_platform_cookie' do
    let(:person) { FactoryBot.create(:person, :with_auth_user) }

    it 'should return nil without a cookie' do
      cookies = double('cookies')
      expect(JWT).not_to receive(:decode)
      expect(described_class.auth_from_platform_cookie(cookies, nil)).to be_nil
    end

    it 'should strip the Bearer prefix and store the token in a cookie' do
      cookies = double('cookies')
      token = [{ 'sub' => person.auth_user.auth0_id_string, 'iat' => Time.now.to_i, 'exp' => 1.hour.from_now.to_i }]
      expect(JWT).to receive(:decode).with('the.jwt', any_args).and_return(token)
      expect(CookieJar).to receive(:set_or_update_cookie)
        .with(cookies, { TokenAuthenticationController::JWT_TOKEN_COOKIE => token })
      expect(CookieJar).to receive(:delete_cookie)
        .with(cookies, TokenAuthenticationController::PERSON_ID_COOKIE)

      expect(described_class.auth_from_platform_cookie(cookies, 'Bearer the.jwt')).to eql person
    end
  end
end
