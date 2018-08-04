# frozen_string_literal: true

require 'rails_helper'

describe TokenAuthenticator do
  describe 'auth' do
    let(:person) { FactoryBot.create(:person) }
    it 'should return the person if it finds someone in the cookiejar' do
      cookies = double('cookies')
      expect(CookieJar).to receive(:read_entry)
        .with(cookies, TokenAuthenticationController::PERSON_ID_COOKIE)
        .and_return(person.external_identifier)
      result = described_class.auth(cookies, 'unused')
      expect(result).to eql person
    end

    it 'should return nil if there is no person in the cookiejar' do
      cookies = double('cookies')
      expect(CookieJar).to receive(:read_entry)
        .with(cookies, TokenAuthenticationController::PERSON_ID_COOKIE)
        .and_return(nil)
      result = described_class.auth(cookies, 'unused')
      expect(result).to be_nil
    end
  end
end
