# frozen_string_literal: true

class PersonExporter < ObjectExporter
  class << self
    def klass
      Person
    end

    def default_fields
      %w[gender first_name]
    end

    def formatted_fields
      %w[person_id created_at updated_at role title team_name organization_name]
    end

    def format_fields(person)
      vals = {}
      vals = person_properties(person, vals)
      vals = role_properties(person.role, vals)
      team_properties(person.role.team, vals)
    end

    def to_be_skipped?(person)
      Exporters.test_phone_number?(person.mobile_phone)
    end

    private

    def person_properties(person, vals)
      vals['person_id'] = person.external_identifier
      vals['created_at'] = format_datetime(person.created_at)
      vals['updated_at'] = format_datetime(person.updated_at)
      vals
    end

    def role_properties(role, vals)
      vals['role'] = role.group
      vals['title'] = role.title
      vals
    end

    def team_properties(team, vals)
      vals['team_name'] = team.name
      vals['organization_name'] = team.organization.name
      vals
    end
  end
end
