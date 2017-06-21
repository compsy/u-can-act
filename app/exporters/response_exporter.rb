# frozen_string_literal: true

require 'csv'

class ResponseExporter
  extend Exporters
  class << self
    def export_lines(questionnaire_name)
      questionnaire = Questionnaire.find_by_name(questionnaire_name)
      raise 'Questionnaire not found' unless questionnaire
      Enumerator.new do |enum|
        enum << '"' # output a character to the stream right away
        csv_headers = export_headers(questionnaire)
        formatted_headers = format_headers(csv_headers)[1..-1] # strip first char
        enum << formatted_headers + "\n"
        export(questionnaire, csv_headers) do |line|
          enum << line + "\n"
        end
      end
    end

    private

    def export(questionnaire, headers, &_block)
      silence_logger do
        Response.includes(:measurement).where(measurements: { questionnaire_id: questionnaire.id })
                .order(open_from: :asc).each do |response|
          vals = response_hash(response)
          response_values = response.values
          vals.merge!(response_values) if response_values.present?
          yield format_hash(headers, vals)
        end
      end
    end

    def export_headers(questionnaire)
      headers = {}
      silence_logger do
        Response.includes(:measurement).where(measurements: { questionnaire_id: questionnaire.id })
                .where.not(content: nil).find_each do |response|
          response.values.each do |key, _value|
            headers[key] = ''
          end
        end
      end
      headers = headers.keys.sort { |x, y| format_key(x) <=> format_key(y) }
      headers = %w[response_id person_id protocol_subscription_id measurement_id open_from] +
                %w[invited_state opened_at completed_at created_at updated_at] + headers
      headers
    end

    def response_hash(response)
      {
        'response_id' => response.id,
        'person_id' => calculate_hash(response.protocol_subscription.person.id),
        'protocol_subscription_id' => response.protocol_subscription.id,
        'measurement_id' => response.measurement.id,
        'open_from' => format_datetime(response.open_from),
        'opened_at' => format_datetime(response.opened_at),
        'completed_at' => format_datetime(response.completed_at),
        'invited_state' => response.invited_state,
        'created_at' => format_datetime(response.created_at),
        'updated_at' => format_datetime(response.updated_at)
      }
    end

    def format_key(key)
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
      first, last = find_first_and_last_numbers(key)
      return key if first == -1
      t = ''
      t += key[0..(first - 1)] if first.positive?
      len = 4 - (1 + last - first)
      len.times do
        t += '0'
      end
      t += key[first..(key.size - 1)]
      t
    end

    def find_first_and_last_numbers(key)
      first = -1
      last = -1
      key.split('').each_with_index do |c, i|
        if first == -1
          if c >= '0' && c <= '9'
            first = i
            last = i
          end
        elsif c >= '0' && c <= '9'
          last = i
        end
      end
      [first, last]
    end
  end
end
