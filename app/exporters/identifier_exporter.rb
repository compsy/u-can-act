# frozen_string_literal: true

class IdentifierExporter < ObjectExporter
  class << self
    def klass
      Person
    end

    def default_fields
      %w[email mobile_phone]
    end

    def formatted_fields
      %w[person_id]
    end

    def format_fields(person)
      vals = {}
      person_properties(person, vals)
    end

    def to_be_skipped?(person)
      Exporters.test_phone_number?(person.mobile_phone)
    end

    private

    def person_properties(person, vals)
      vals['person_id'] = person.external_identifier
      vals
    end
  end
end
