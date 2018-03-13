# frozen_string_literal: true

class PersonExporter < ObjectExporter
  class << self
    def klass
      Person
    end

    def default_fields
      %w[first_name last_name mobile_phone]
    end

    def formatted_fields
      %w[person_id created_at updated_at role title]
    end

    def format_fields(person)
      {
        'person_id' => calculate_hash(person.id),
        'created_at' => format_datetime(person.created_at),
        'updated_at' => format_datetime(person.updated_at),
        'role' => person.role.group,
        'title' => person.role.title
      }
    end

    def to_be_skipped?(person)
      TEST_PHONE_NUMBERS.include?(person.mobile_phone)
    end
  end
end
