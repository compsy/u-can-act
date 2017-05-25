# frozen_string_literal: true

class CookieJar
  COOKIE_LOCATION = :response_id
  class << self
    def verify_param(jar, response_hash)
      cookie = jar[COOKIE_LOCATION]
      return false if response_hash.nil? || cookie.nil?
      cookie = JSON.parse(cookie)
      response_hash.each do |key, value|
        valid_cookie = cookie[key.to_s] == value
        Rails.logger.debug "Valid cookie = #{cookie[key]} #{key} #{value}"
        return false unless valid_cookie
      end
      true
    end

    def cookies_set?(jar)
      jar[COOKIE_LOCATION].present?
    end

    def set_or_update_cookie(jar, cookie_hash)
      current_cookie = jar[COOKIE_LOCATION]
      unless current_cookie.blank?
        current_cookie = JSON.parse(current_cookie)
        cookie_hash = current_cookie.merge(cookie_hash)
      end
      jar[COOKIE_LOCATION] = cookie_hash.to_json
    end
  end
end
