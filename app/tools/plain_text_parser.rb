# frozen_string_literal: true

class PlainTextParser
  def parse_mobile_phone(mobile_phone)
    return nil if mobile_phone.blank?

    parsed_mobile_phone = mobile_phone.gsub(/[^0-9]+/, '')
    raise "Phone number is not 10 characters long: #{mobile_phone}" unless parsed_mobile_phone.size == 10
    raise "Phone number does not start with 06: #{mobile_phone}" unless parsed_mobile_phone.index('06')&.zero?

    parsed_mobile_phone
  end

  def parse_protocol_name(protocol_name)
    protocol = Protocol.find_by(name: protocol_name)
    raise "No protocol exists by that name: #{protocol_name}" if protocol.blank?

    protocol.id
  end

  def parse_team_name(team_name)
    team = Team.find_by(name: team_name)
    raise "No team exists by that name: #{team_name}" if team.blank?

    team
  end

  def parse_role_title(team_name, role_title)
    team = parse_team_name(team_name)
    role = team.roles.find_by(title: role_title)
    raise "No role exists in that team by that title: #{role_title}" if role.blank?

    role.id
  end

  def parse_start_date(start_date)
    parsed_start_date = Time.zone.parse(start_date)
    raise "Start date is not in the correct format: #{start_date}" if parsed_start_date.blank?
    # raise "Start date lies in the past: #{start_date}" unless parsed_start_date > Time.zone.now
    raise "Start date is not beginning of day: #{start_date}" unless
      parsed_start_date.beginning_of_day == parsed_start_date

    parsed_start_date
  end

  def parse_end_date(end_date)
    parsed_end_date = Time.zone.parse(end_date)
    raise "End date is not in the correct format: #{end_date}" if parsed_end_date.blank?
    raise "End date lies in the past: #{end_date}" unless parsed_end_date > Time.zone.now
    raise "End date is not beginning of day: #{end_date}" unless
      parsed_end_date.beginning_of_day == parsed_end_date

    parsed_end_date
  end

  def parse_filling_out_for(mobile_phone)
    mobile_phone = parse_mobile_phone(mobile_phone)
    person = Person.find_by(mobile_phone: mobile_phone)
    raise "Person #{mobile_phone} does not exist" if person.blank?
    raise "Person #{mobile_phone} is not a student" unless person.role.group == Person::STUDENT

    person.id
  end
end
