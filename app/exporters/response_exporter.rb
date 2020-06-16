# frozen_string_literal: true

require 'csv'

class ResponseExporter
  extend Exporters
  QUESTIONNAIRE_HEADERS_KEY = 'questionnaire_headers'

  class << self
    def export_lines(questionnaire_name)
      questionnaire = Questionnaire.find_by(name: questionnaire_name)
      raise 'Questionnaire not found' unless questionnaire

      Enumerator.new do |enum|
        enum << '"' # output a character to the stream right away
        csv_headers = export_headers(questionnaire, bust_cache: false)
        formatted_headers = format_headers(csv_headers)[1..] # strip first char
        enum << formatted_headers + "\n"
        export(questionnaire, csv_headers) do |line|
          enum << line + "\n"
        end
      end
    end

    def export_headers(questionnaire, bust_cache: false)
      RedisCachedCall.cache("#{QUESTIONNAIRE_HEADERS_KEY}_#{questionnaire.key}", bust_cache) do
        headers = {}
        silence_logger do
          questionnaire.responses.completed.find_each do |response|
            next if Exporters.test_phone_number?(response.protocol_subscription.person.mobile_phone)

            # Response has a .values function, which we are using here (i.e., it is not a hash from which we get the
            # values)
            response.values&.each do |key, _value|
              headers[key] = ''
            end
          end
        end
        sort_and_add_default_header_fields(headers)
      end
    end

    private

    def export(questionnaire, headers, &_block)
      silence_logger do
        response_query(questionnaire).each do |response|
          next if Exporters.test_phone_number?(response.protocol_subscription.person.mobile_phone)

          vals = response_hash(response)
          response_values = response.values
          vals.merge!(response_values) if response_values.present?
          yield format_hash(headers, vals)
        end
      end
    end

    def response_query(questionnaire)
      Response.includes(:measurement).where(measurements: { questionnaire_id: questionnaire.id })
              .order(open_from: :asc)
    end

    def sort_and_add_default_header_fields(headers)
      headers = headers.keys.sort { |x, y| format_key(x) <=> format_key(y) }
      headers = %w[response_id filled_out_by_id filled_out_for_id protocol_subscription_id measurement_id] +
                %w[invitation_set_id open_from opened_at completed_at created_at updated_at] + headers
      headers
    end

    def response_hash(response)
      hsh = {
        'response_id' => response.id,
        'filled_out_by_id' => response.filled_out_by&.external_identifier,
        'filled_out_for_id' => response.filled_out_for&.external_identifier,
        'protocol_subscription_id' => response.protocol_subscription_id,
        'measurement_id' => response.measurement_id,
        'invitation_set_id' => response.invitation_set_id
      }
      hsh.merge!(response_hash_time_fields(response, %w[open_from opened_at completed_at created_at updated_at]))
    end

    def response_hash_time_fields(response, fields)
      hsh = {}
      fields.each do |field|
        hsh[field] = format_datetime(response.send(field.to_sym))
      end
      hsh
    end

    def format_key(key)
      # Tokenizes a string with the delimiter '_', and returns the
      # tokens in an array for easy <=> comparison. The tokens in the
      # array are processed individually by the comparable_format method.
      r = []
      t = ''
      key.split('').each do |c|
        if c == '_'
          r << comparable_format(t) if t != ''
          t = ''
        else
          t += c
        end
      end
      r << comparable_format(t) if t != ''
      r
    end

    def comparable_format(key)
      # The comparable format function takes a string (in which no underscores
      # occur, see the explanation for the format_key method), and performs zero
      # padding on the first number in the string up to 9999.
      first, last = find_first_and_last_numbers(key)
      # first, last are the start and end positions of the first and last digits of the first number
      # in the string key. (A number is a substring consisting of consecutive digits only.)
      return key if first == -1

      t = prefix_number(key, first) # find stuff before the number
      len = 4 - (1 + last - first)
      len.times do
        t += '0' # add the zero padding
      end
      t += key[first..(key.size - 1)] # add the number and the rest of the string
      t
    end

    def prefix_number(key, first)
      t = ''
      # if there is no digit in the string, or the string starts with a number, return an empty prefix.
      t += key[0..(first - 1)] if first.positive?
      t
    end

    def find_first_and_last_numbers(key)
      first = -1
      last = -1
      key.split('').each_with_index do |c, i|
        if first == -1
          if c >= '0' && c <= '9'
            # if we haven't seen a digit before, and found a digit, it's both the first and last digit we found
            first = i
            last = i
          end
        elsif c >= '0' && c <= '9'
          # if we already found a digit before, this is the new last digit.
          last = i
        else
          # if we find something that isn't a digit, but we did find a digit earlier
          # (note that first is not -1), then it means we found a number that has now ended.
          # We are only interested in zeropadding the first number in an underscore-delimited
          # substring, hence, we break here.
          break
        end
      end
      [first, last]
    end
  end
end
