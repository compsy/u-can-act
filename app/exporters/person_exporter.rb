# frozen_string_literal: true

require 'csv'

class PersonExporter
  extend Exporters
  class << self
    def export_lines
      Enumerator.new do |enum|
        export do |line|
          enum << line + "\n"
        end
      end
    end

    private

    def export(&_block)
      fields = %w[type first_name last_name mobile_phone]
      headers = %w[person_id created_at updated_at] + fields
      yield format_headers(headers)
      silence_logger do
        Person.find_each do |person|
          next if TEST_PHONE_NUMBERS.include?(person.mobile_phone)
          vals = person_hash(person)
          fields.each do |field|
            vals[field] = person.send(field.to_sym)
          end
          yield format_hash(headers, vals)
        end
      end
    end

    def person_hash(person)
      vals = {}
      vals['person_id'] = calculate_hash(person.id)
      vals['created_at'] = format_datetime(person.created_at)
      vals['updated_at'] = format_datetime(person.updated_at)
      vals
    end
  end
end
