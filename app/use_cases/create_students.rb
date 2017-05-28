# frozen_string_literal: true

require 'csv' # Not a gem: in ruby stdlib

class CreateStudents < ActiveInteraction::Base
  array :students

  # Creates students from the given array created with EchoPeople
  #
  # Params:
  # - people: the array containing the people details
  def execute
    parsed_students = parse_students(students)
    amount = create_students(parsed_students)
    puts "Created #{amount}/#{parsed_students.size} students." unless Rails.env.test?
  end

  private

  def parse_students(students)
    parsed_students = []
    students.each do |student|
      parsed_students << { first_name: student[:first_name],
                           last_name: student[:last_name],
                           mobile_phone: parse_mobile_phone(student[:mobile_phone]),
                           protocol_id: parse_protocol_name(student[:protocol_name]),
                           start_date: parse_start_date(student[:start_date]) }
    end
    parsed_students
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
    # raise "Start date lies in the past: #{start_date}" unless parsed_start_date > Time.zone.now
    raise "Start date is not beginning of day: #{start_date}" unless
      parsed_start_date.beginning_of_day == parsed_start_date
    parsed_start_date
  end

  def create_students(students)
    amount = 0
    students.each do |student|
      next if Person.find_by_mobile_phone(student[:mobile_phone])
      studentobj = Student.create!(first_name: student[:first_name],
                                   last_name: student[:last_name],
                                   mobile_phone: student[:mobile_phone])
      ProtocolSubscription.create!(person: studentobj,
                                   protocol_id: student[:protocol_id],
                                   state: ProtocolSubscription::ACTIVE_STATE,
                                   start_date: student[:start_date])
      amount += 1
    end
    amount
  end
end
