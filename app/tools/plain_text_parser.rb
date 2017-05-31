# frozen_string_literal: true

class PlainTextParser
  def parse_mobile_phone(mobile_phone)
    parsed_mobile_phone = mobile_phone.gsub(/[^0-9]+/, '')
    raise "Phone number is not 10 characters long: #{mobile_phone}" unless parsed_mobile_phone.size == 10
    raise "Phone number does not start with 06: #{mobile_phone}" unless parsed_mobile_phone.index('06')&.zero?
    parsed_mobile_phone
  end

  def parse_protocol_name(protocol_name)
    protocol = Protocol.find_by_name(protocol_name)
    raise "No protocol exists by that name: #{protocol_name}" unless protocol.present?
    protocol.id
  end

  def parse_start_date(start_date)
    parsed_start_date = Time.zone.parse(start_date)
    # raise "Start date lies in the past: #{start_date}" unless parsed_start_date > Time.zone.now
    raise "Start date is not in the correct format: #{start_date}" unless parsed_start_date.present?
    raise "Start date is not beginning of day: #{start_date}" unless
      parsed_start_date.beginning_of_day == parsed_start_date
    parsed_start_date
  end

  def parse_filling_out_for(mobile_phone)
    mobile_phone = parse_mobile_phone(mobile_phone)
    person = Person.find_by_mobile_phone(mobile_phone)
    raise "Person #{mobile_phone} does not exist" unless person.present?
    raise "Person #{mobile_phone} is not a student" unless person.type == 'Student'
    person.id
  end
end
