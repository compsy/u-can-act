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

  def process_row(row)
    result = { first_name: row[0],
               last_name: row[1],
               mobile_phone: row[2],
               protocol_name: row[3],
               start_date: row[4] }
    if row.length > 5
      result[:filling_out_for] = row[5]
      result[:filling_out_for_protocol] = row[6]
    end
    result
  end
end
