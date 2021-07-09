# frozen_string_literal: true

require 'digest/bubblebabble'

module Exporters
  def self.test_phone_number?(phone_number)
    test_phone_numbers = ENV['TEST_PHONE_NUMBERS']
    return false if test_phone_numbers.blank?

    test_phone_numbers = test_phone_numbers.split(',')
    test_phone_numbers.include?(phone_number)
  end

  def silence_logger
    old_logger_level = nil
    if ActiveRecord::Base.logger
      old_logger_level = ActiveRecord::Base.logger.level
      ActiveRecord::Base.logger.level = Logger::ERROR
    end
    yield
  ensure
    ActiveRecord::Base.logger&.level = old_logger_level if old_logger_level.present?
  end

  def format_hash(headers, hsh)
    r = ''
    headers.each_with_index do |header, idx|
      r += ';' if idx.nonzero?
      r += "\"#{replace_quotes(hsh[header])}\"" unless hsh[header].nil?
    end
    r
  end

  def format_headers(headers)
    r = ''
    headers.each do |header|
      r += ';' if r != ''
      r += "\"#{replace_quotes(header)}\""
    end
    r
  end

  def replace_quotes(text)
    text.to_s.tr('\'', '\\\'').tr('"', '\'')
  end

  def format_datetime(datetime)
    datetime&.strftime('%d-%m-%Y %H:%M:%S')
  end
end
