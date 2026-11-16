# frozen_string_literal: true

# Only accepts Dutch (+31) and Belgian (+32) mobile numbers.
#
# Numbers are stored as entered and sent to MessageBird as is, so spaces and hyphens are
# ignored when checking, but the number itself is not rewritten. Belgian numbers need the
# country code: a national Belgian number (04..) cannot be told apart from a Dutch number
# when the SMS is sent.
#
# Keep in line with base-platform's questionnaires/mobilePhone.js. The only difference is
# that the engine also accepts the international form without '+' (31612345678), which
# the API already stores.
class MobilePhoneValidator < ActiveModel::EachValidator
  ALLOWED_NUMBERS = [
    /\A06\d{8}\z/,             # Dutch, national: 0612345678
    /\A\+?316\d{8}\z/,         # Dutch, international: +31612345678 or 31612345678
    /\A\+?324\d{8}\z/          # Belgian, international: +32470123456 or 32470123456
  ].freeze

  SEPARATORS = /[ -]/

  def self.allowed?(mobile_phone)
    number = mobile_phone.to_s.gsub(SEPARATORS, '')
    ALLOWED_NUMBERS.any? { |pattern| pattern.match?(number) }
  end

  def validate_each(record, attribute, value)
    return if value.blank? || self.class.allowed?(value)

    record.errors.add attribute, I18n.t('validators.only_dutch_or_belgian_mobile_number')
  end
end
