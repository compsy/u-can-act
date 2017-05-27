# frozen_string_literal: true

require 'csv' # Not a gem: in ruby stdlib

class LoadPeople < ActiveInteraction::Base
  string :file_name

  # Loads people from the given file name
  #
  # Params:
  # - file_name: the name of the csv file to load
  def execute
    assert_file_existence(file_name)
    people = read_csv_into_people(file_name)
    amount = create_people(people)
    puts "Created #{amount}/#{people.size} people."
  end

  private

  def assert_file_existence(file_name)
    raise "File #{file_name} does not exist" unless File.file?(file_name)
  end

  def read_csv_into_people(file_name)
    people = []
    cnt = 0
    CSV.foreach(file_name, col_sep: ';') do |row|
      cnt += 1
      next if cnt == 1 # Skip header row
      people << { first_name: row[0],
                  last_name: row[1],
                  mobile_phone: parse_mobile_phone(row[2]),
                  protocol_id: parse_protocol_name(row[3]),
                  start_date: parse_start_date(row[4]) }
    end
    people
  end

  def parse_mobile_phone(mobile_phone)
    parsed_mobile_phone = mobile_phone.gsub(/[^0-9]+/, '')
    raise "Phone number is not 10 characters long: #{mobile_phone}" unless parsed_mobile_phone.size == 10
    raise "Phone number does not start with 06: #{mobile_phone}" unless parsed_mobile_phone.index('06').zero?
    parsed_mobile_phone
  end

  def parse_protocol_name(protocol_name)
    protocol = Protocol.find_by_name(protocol_name)
    raise "No protocol exists by that name: #{protocol_name}" unless protocol.present?
    protocol.id
  end

  def parse_start_date(start_date)
    parsed_start_date = Time.zone.parse(start_date)
    raise "Time lies in the past: #{start_date}" unless parsed_start_date > Time.zone.now
    parsed_start_date
  end

  def create_people(people)
    amount = 0
    people.each do |person|
      next if Person.find_by_mobile_phone(person[:mobile_phone])
      student = Student.create!(first_name: person[:first_name],
                                last_name: person[:last_name],
                                mobile_phone: person[:mobile_phone])
      ProtocolSubscription.create!(person: student,
                                   protocol_id: person[:protocol_id],
                                   state: ProtocolSubscription::ACTIVE_STATE,
                                   start_date: person[:start_date])
      amount += 1
    end
    amount
  end
end
