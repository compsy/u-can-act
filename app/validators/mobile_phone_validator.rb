# frozen_string_literal: true

class MobilePhoneValidator < ActiveModel::EachValidator
  ALLOWED_NUMBERS = { '06' => '+316' }.freeze

  def validate_each(record, attribute, value)
    return if value.blank? || starts_with_allowed?(value)
    record.errors.add attribute, I18n.t('validators.only_dutch_number')
  end

  private

  def starts_with_allowed?(mobile_number)
    mobile_start_numbers = mobile_number[0, 2]
    ALLOWED_NUMBERS.key?(mobile_start_numbers)
  end
end
