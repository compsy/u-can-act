# frozen_string_literal: true

require 'csv'

class InvitationSetExporter
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
      fields = %w[invitation_text]
      headers = %w[invitation_set_id person_id created_at updated_at] + fields
      yield format_headers(headers)
      silence_logger do
        InvitationSet.find_each do |invitation_set|
          next if TEST_PHONE_NUMBERS.include?(invitation_set.person.mobile_phone)
          vals = header_properties(invitation_set)
          fields.each do |field|
            vals[field] = invitation_set.send(field.to_sym)
          end
          yield format_hash(headers, vals)
        end
      end
    end

    def header_properties(invitation_set)
      vals = {
        'invitation_set_id' => invitation_set.id,
        'person_id' => calculate_hash(invitation_set.person.id),
        'created_at' => format_datetime(invitation_set.created_at),
        'updated_at' => format_datetime(invitation_set.updated_at),
      }
      vals
    end
  end
end
