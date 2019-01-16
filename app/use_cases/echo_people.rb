# frozen_string_literal: true

require 'csv' # Not a gem: in ruby stdlib

class EchoPeople < ActiveInteraction::Base
  string :file_name

  # Loads people from the given file name
  #
  # Params:
  # - file_name: the name of the csv file to load
  def execute
    assert_file_existence(file_name)
    echo_people(file_name)
  end

  private

  def assert_file_existence(file_name)
    raise "File #{file_name} does not exist" unless File.file?(file_name)
  end

  def echo_people(file_name)
    people = []
    cnt = 0
    puts 'people = [];nil'
    CSV.foreach(file_name, col_sep: ';') do |row|
      cnt += 1
      next if cnt == 1 # Skip header row

      people << process_row(row)
      puts "people << #{people.last.inspect};nil"
    end
  end

  def process_row(origrow)
    row = origrow.map { |entry| entry.nil? ? entry : entry.strip }
    return create_student_hash(row) if row[0].strip == Person::STUDENT

    create_mentor_hash(row)
  end

  def create_student_hash(row)
    # Student format:
    # type;team_name;role_title;first_name;last_name;gender;mobile_phone;email;protocol_name;start_date;end_date
    {
      team_name: row[1],
      role_title: row[2],
      first_name: row[3],
      last_name: row[4],
      gender: row[5],
      mobile_phone: row[6],
      email: row[7],
      protocol_name: row[8],
      start_date: row[9],
      end_date: row[10]
    }
  end

  def create_mentor_hash(row)
    # Mentor format:
    # type;team_name;role_title;first_name;last_name;gender;mobile_phone;email;protocol_name;start_date;
    # filling_out_for;filling_out_for_protocol;end_date
    {
      team_name: row[1],
      role_title: row[2],
      first_name: row[3],
      last_name: row[4],
      gender: row[5],
      mobile_phone: row[6],
      email: row[7],
      protocol_name: row[8],
      start_date: row[9],
      filling_out_for: row[10],
      filling_out_for_protocol: row[11],
      end_date: row[12]
    }
  end
end
