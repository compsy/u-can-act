# frozen_string_literal: true

describe CookieJar do
  let(:jar) { {} }

  describe 'set_or_update_cookie' do
    it 'returns true if all provided params are valid' do
      current_cookie = {
        response_id: '123',
        token: 'whatever'
      }
      jar[described_class::COOKIE_LOCATION] = current_cookie.to_json
      response_hash = { response_id: '123', token: 'whatever' }
      result = described_class.verify_param(jar, response_hash)
      expect(result).to be_truthy
    end

    it 'returns false if any provided param is invalid' do
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

  describe 'delete_cookie' do
    it 'deletes a given cookie' do
      current_cookie = {
        response_id: '123',
        token: 'whatever'
      }
      jar[described_class::COOKIE_LOCATION] = current_cookie.to_json
      response_hash = { response_id: '123' }
      described_class.delete_cookie(jar, :token)
      expect(jar[described_class::COOKIE_LOCATION]).to eq response_hash.to_json
    end

    it 'does nothing with unknown key' do
      current_cookie = {
        response_id: '123',
        token: 'whatever'
      }
      jar[described_class::COOKIE_LOCATION] = current_cookie.to_json
      response_hash = { response_id: '123', token: 'whatever' }
      described_class.delete_cookie(jar, :hihaho)
      expect(jar[described_class::COOKIE_LOCATION]).to eq response_hash.to_json
    end
  end

  describe 'cookies_set?' do
    it 'returns false if no cookies are set' do
      expect(described_class).not_to be_cookies_set(jar)
    end

    it 'returns true if cookies are set' do
      cookie_hash = { response_id: '123', token: 'othertoken' }
      described_class.set_or_update_cookie(jar, cookie_hash)
      expect(described_class).to be_cookies_set(jar)
    end
  end

  describe 'verify_param' do
    it 'sets a cookie when it is not yet set' do
      cookie_hash = { response_id: '123', token: 'othertoken' }
      described_class.set_or_update_cookie(jar, cookie_hash)
      expect(jar).not_to be_blank
      expect(jar.keys).to include(described_class::COOKIE_LOCATION)
      expect(jar[described_class::COOKIE_LOCATION]).to eq cookie_hash.to_json
    end

    it 'updates a cookie if it was set before' do
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
