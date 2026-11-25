# frozen_string_literal: true

namespace :maintenance do
  # Run with
  # be rake "maintenance:echo_people[people.csv]"
  desc 'Echo people from a csv file'
  task :echo_people, [:csv_file] => [:environment] do |_, args|
    puts "Echoing people from '#{args[:csv_file]}' - started"
    EchoPeople.run!(file_name: args[:csv_file])
    puts "Echoing people from '#{args[:csv_file]}' - done"
  end

  desc 'Fixing variables in the Mongo responses'
  task fix_responses: :environment do
    puts 'Fixing responses - started'
    FixResponses.run!
    puts 'Fixing responses - done'
  end

  desc 'Scrambling all persons'
  task scramble: :environment do
    puts 'Scrambling people - started'
    ActiveRecord::Base.transaction do
      people = Person.all
      last_mobile_phone = 0
      people.each do |person|
        first = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
        last = (0...10).map { ('a'..'z').to_a[rand(26)] }.join
        person.first_name = first
        person.last_name = last
        person.mobile_phone = "06#{format('%<number>08d', number: last_mobile_phone)}"
        person.email = "#{first}.#{last}@u-can-act.nl"
        person.iban = 'NL20INGB0001234567' unless person.mentor?
        last_mobile_phone += 1
        person.save!
      end
    end
    puts 'Scrambling people - done'
  end

  # Read-only. Run with
  # be rake maintenance:audit_mobile_phones
  desc 'Count people whose mobile phone number is not allowed by MobilePhoneValidator'
  task audit_mobile_phones: :environment do
    numbers = Person.where.not(mobile_phone: [nil, '']).pluck(:mobile_phone)
    invalid = numbers.reject { |number| MobilePhoneValidator.allowed?(number) }
    puts "People with a mobile phone number: #{numbers.size}"
    puts "People with a mobile phone number that is no longer allowed: #{invalid.size}"
    next if invalid.empty?

    puts 'By first three characters (spaces and hyphens removed):'
    prefixes = invalid.map { |number| number.gsub(MobilePhoneValidator::SEPARATORS, '')[0, 3] }
    prefixes.tally.sort_by { |prefix, count| [-count, prefix] }.each do |prefix, count|
      puts "  #{prefix}: #{count}"
    end
  end
end
