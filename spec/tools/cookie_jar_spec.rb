# frozen_string_literal: true

describe CookieJar do
  let(:jar) { {} }
  describe 'set_or_update_cookie' do
    it 'should return true if all provided params are valid' do
      current_cookie = {
        response_id: '123',
        token: 'whatever'
      }
      jar[described_class::COOKIE_LOCATION] = current_cookie.to_json
      response_hash = { response_id: '123', token: 'whatever' }
      result = described_class.verify_param(jar, response_hash)
      expect(result).to be_truthy
    end

    it 'should return false if any provided param is invalid' do
      current_cookie = {
        response_id: '123',
        token: 'whatever'
      }
      jar[described_class::COOKIE_LOCATION] = current_cookie.to_json
      response_hash = { response_id: '123', token: 'othertoken' }
      result = described_class.verify_param(jar, response_hash)
      expect(result).to be_falsey
    end
  end

  describe 'cookies_set?' do
    it 'should return false if no cookies are set' do
      expect(described_class.cookies_set?(jar)).to be_falsey
    end

    it 'should return true if cookies are set' do
      cookie_hash = { response_id: '123', token: 'othertoken' }
      described_class.set_or_update_cookie(jar, cookie_hash)
      expect(described_class.cookies_set?(jar)).to be_truthy
    end
  end

  describe 'verify_param' do
    it 'should set a cookie when it is not yet set' do
      cookie_hash = { response_id: '123', token: 'othertoken' }
      described_class.set_or_update_cookie(jar, cookie_hash)
      expect(jar).to_not be_blank
      expect(jar.keys).to include(described_class::COOKIE_LOCATION)
      expect(jar[described_class::COOKIE_LOCATION]).to eq cookie_hash.to_json
    end

    it 'should update a cookie if it was set before' do
      current_cookie = {
        response_id: '123',
        token: 'this-should-stay-the-same',
        type: 'and this should not be removed'
      }
      jar[described_class::COOKIE_LOCATION] = current_cookie.to_json

      cookie_hash = { response_id: 'this should change', token: 'this-should-stay-the-same' }
      described_class.set_or_update_cookie(jar, cookie_hash)
      expect(jar.keys).to include(described_class::COOKIE_LOCATION)
      cookie = JSON.parse(jar[described_class::COOKIE_LOCATION])
      expect(cookie.length).to eq 3
      expect(cookie['response_id']).to eq 'this should change'
      expect(cookie['token']).to eq 'this-should-stay-the-same'
      expect(cookie['type']).to eq 'and this should not be removed'
    end
  end
end
