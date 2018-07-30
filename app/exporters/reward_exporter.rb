# frozen_string_literal: true

class RewardExporter < ObjectExporter
  class << self
    def klass
      Person
    end

    def default_fields
      %w[first_name last_name iban]
    end

    def formatted_fields
      %w[earned]
    end

    def format_fields(person)
      vals = {}
      vals['earned'] = CalculateEarnedByPerson.run!(person: person)
      vals
    end

    def to_be_skipped?(person)
      # For now, only show the students
      person.mentor? || Exporters.test_phone_number?(person.mobile_phone)
    end
  end
end
