# frozen_string_literal: true

require 'rails_helper'

describe JwtAuthenticator do
  describe 'auth_from_cookies' do
    let(:person) { FactoryBot.create(:person, :with_auth_user) }

    it 'should use the auth from the cookiejar if available' do
      cookies = double('cookies')
      expect(CookieJar).to receive(:read_entry)
        .with(cookies, TokenAuthenticationController::JWT_TOKEN_COOKIE)
        .and_return([{ 'sub' => person.auth_user.auth0_id_string }])
      expect(JWT).to_not receive(:decode)

      # Mock away this function
      expect(described_class).to receive(:store_token_in_cookie)
        .and_return(true)

      result = described_class.auth_from_cookies(cookies)
      expect(result).to eql person
    end

    it 'should store the token in a cookie' do
      cookies = double('cookies')
      token = [{ 'sub' => person.auth_user.auth0_id_string }]
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
      token = [{ 'sub' => person.auth_user.auth0_id_string }]
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
  end
end
