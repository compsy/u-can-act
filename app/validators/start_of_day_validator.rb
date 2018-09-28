# frozen_string_literal: true

class StartOfDayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? || start_of_day?(value)

    record.errors.add attribute, I18n.t('validators.only_start_of_day')
  end

  private

  def start_of_day?(datetime)
    datetime == datetime.beginning_of_day
  end
end
