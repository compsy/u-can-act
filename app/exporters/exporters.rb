# frozen_string_literal: true

require 'digest/bubblebabble'

module Exporters
  TEST_PHONE_NUMBERS = [
    '0622708372', # Frank
    '0618654931', # Nick
    '0630737625', # Teun
    '0611055958', # Ando
    '0650748891'  # Mandy
  ].freeze

  def silence_logger
    if ActiveRecord::Base.logger
      old_logger_level = ActiveRecord::Base.logger.level
      ActiveRecord::Base.logger.level = Logger::ERROR
    end
    yield
  ensure
    ActiveRecord::Base.logger&.level = old_logger_level
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

  def calculate_hash(clear_text)
    hash = Digest::MD5.bubblebabble(clear_text.to_s + ENV['PERSON_SALT'])
    hash.split('-')[0..4].join('-')
  end

  def format_datetime(datetime)
    datetime&.strftime('%d-%m-%Y %H:%M:%S')
  end
end
