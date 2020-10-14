# frozen_string_literal: true

require 'csv'

class ObjectExporter
  extend Exporters
  class << self
    def export_lines
      Enumerator.new do |enum|
        export(klass, formatted_fields, default_fields) do |line|
          # Encode to ISO-8859-1 because Excel can't handle UTF-8 for some reason.
          enum << "#{line.encode('ISO-8859-1', 'UTF-8', invalid: :replace, undef: :replace)}\n"
        end
      end
    end

    def klass
      raise 'klass not implemented by subclass!'
    end

    def default_fields
      raise 'default_fields not implemented by subclass!'
    end

    def formatted_fields
      raise 'formatted_fields not implemented by subclass!'
    end

    def format_fields(_klass_instance)
      raise 'format_fields(klass_instance) not implemented by subclass!'
    end

    def to_be_skipped?(_klass_instance)
      raise 'to_be_skipped?(klass_instance) not implemented by subclass!'
    end

    private

    def export(klass, formatted_fields, default_fields, &_block)
      headers = formatted_fields + default_fields
      yield format_headers(headers)
      silence_logger do
        klass.find_each do |klass_instance|
          next if to_be_skipped?(klass_instance)

          vals = format_fields(klass_instance)
          default_fields.each do |field|
            vals[field] = klass_instance.send(field.to_sym)
          end
          yield format_hash(headers, vals)
        end
      end
    end
  end
end
