# frozen_string_literal: true

require 'csv' # Not a gem: in ruby stdlib

class CreateStudents < ActiveInteraction::Base
  array :students

  # Creates students from the given array created with EchoPeople
  #
  # Params:
  # - people: the array containing the people details
  def execute
    plain_text_parser = PlainTextParser.new
    parsed_students = parse_students(students, plain_text_parser)
    amount = create_students(parsed_students)
    puts "Created #{amount}/#{parsed_students.size} students." unless Rails.env.test?
  end

  private

  def parse_students(students, plain_text_parser)
    parsed_students = []
    students.each do |student|
      parsed_students << { first_name: student[:first_name],
                           last_name: student[:last_name],
                           mobile_phone: plain_text_parser.parse_mobile_phone(student[:mobile_phone]),
                           protocol_id: plain_text_parser.parse_protocol_name(student[:protocol_name]),
                           start_date: plain_text_parser.parse_start_date(student[:start_date]) }
    end
    parsed_students
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
