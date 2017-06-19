# frozen_string_literal: true

require 'csv'

class DataExporter
  extend Exporters
  class << self
    def export(quby_key, headers, &_block)
      Exporters.silence_logger do
        questionnaire_information_id = QuestionnaireInformation.find_by_quby_key(quby_key).id
        QuestionnaireRequest.where(questionnaire_information_id: questionnaire_information_id)
          .select('id, quby_id, created_at, completed_at, profile_id').find_each do |request|
          valbyvals = QubyService.value_by_values(quby_key, request.quby_id)
          valbyvals['profile_id'] = Hashers::Md5Hasher.calculate_hash(request.profile_id)
          valbyvals['created_at'] = request.created_at.andand.strftime('%d-%m-%Y %H:%M:%S')
          valbyvals['completed_at'] = request.completed_at.andand.strftime('%d-%m-%Y %H:%M:%S')
          yield Exporters.format_hash(headers, valbyvals)
        end
      end
    end

    def export_headers(quby_key)
      headers = {}
      Exporters.silence_logger do
        QubyService.distinct_questionnaire_answers(quby_key).each do |values|
          values.each do |key, value|
            headers[key] = '' unless value.is_a?(Hash)
          end
        end
      end
      headers['profile_id'] = ''
      headers['created_at'] = ''
      headers['completed_at'] = ''
      headers = headers.keys.sort { |x, y| format_key(x) <=> format_key(y) }
      headers
    end

    def export_lines(quby_key)
      Enumerator.new do |enum|
        enum << '"' # output a character to the stream right away
        csv_headers = Exporters::DataExporter.export_headers(quby_key)
        formatted_headers = Exporters.format_headers(csv_headers)[1..-1]
        enum << formatted_headers + "\n"
        Exporters::DataExporter.export(quby_key, csv_headers) do |line|
          enum << line + "\n"
        end
      end
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
