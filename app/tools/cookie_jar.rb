# frozen_string_literal: true

class CookieJar
  COOKIE_LOCATION = :ucanact_cookie
  class << self
    def verify_param(jar, response_hash)
      cookie = jar[COOKIE_LOCATION]
      return false if response_hash.nil? || cookie.nil?

      cookie = JSON.parse(cookie)
      response_hash.each do |key, value|
        valid_cookie = cookie[key.to_s] == value
        Rails.logger.debug { "Valid cookie = #{cookie[key]} #{key} #{value}" }
        return false unless valid_cookie
      end
      true
    end

    def cookies_set?(jar)
      jar[COOKIE_LOCATION].present?
    end

    def read_entry(jar, entry)
      cookie = jar[COOKIE_LOCATION]
      return false if entry.nil? || cookie.nil?

      cookie = JSON.parse(cookie)
      cookie = {} unless cookie.is_a?(Hash)
      cookie = cookie.with_indifferent_access
      cookie[entry.to_s]
    end

    def set_or_update_cookie(jar, cookie_hash)
      Rails.logger.debug cookie_hash
      current_cookie = jar[COOKIE_LOCATION]
      if current_cookie.present?
        current_cookie = JSON.parse(current_cookie)
        current_cookie = {} unless current_cookie.is_a?(Hash)
        current_cookie = current_cookie.with_indifferent_access
        cookie_hash = current_cookie.merge(cookie_hash)
      end
      jar[COOKIE_LOCATION] = cookie_hash.to_json
    end

    def delete_cookie(jar, key)
      current_cookie = jar[COOKIE_LOCATION]
      return if current_cookie.blank?

      current_cookie = JSON.parse(current_cookie)
      current_cookie = {} unless current_cookie.is_a?(Hash)
      current_cookie = current_cookie.with_indifferent_access
      return unless current_cookie.key?(key)

      current_cookie.delete(key)
      jar[COOKIE_LOCATION] = current_cookie.to_json
    end
  end
end
