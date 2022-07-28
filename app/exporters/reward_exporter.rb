# frozen_string_literal: true

class RewardExporter < ObjectExporter
  class << self
    def klass
      Person
    end

    def default_fields
      %w[first_name last_name iban mobile_phone email]
    end

    def formatted_fields
      %w[earned person_id]
    end

    def format_fields(person)
      vals = {}
      vals['earned'] = CalculateEarnedEurosByPerson.run!(person: person)
      vals['person_id'] = person.external_identifier
      vals
    end

    def to_be_skipped?(person)
      # For now, only show the students
      person.mentor? || Exporters.test_phone_number?(person.mobile_phone)
    end
  end
end
