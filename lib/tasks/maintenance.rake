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

  desc 'Cancel active subscriptions for target protocols'
  task cancel_target_protocols: :environment do
    target_protocol_names = %w[move_mood_motivation sportpro_profiel sportpro_wekelijks_logboek_protocol].freeze
    dry_run = ENV['DRY_RUN'] == 'true'
    puts "Canceling active subscriptions for: #{target_protocol_names.join(', ')}"
    puts "Dry run: #{dry_run}"

    target_protocol_names.each do |protocol_name|
      protocol = Protocol.find_by(name: protocol_name)
      unless protocol
        puts "- #{protocol_name}: protocol not found"
        next
      end

      active_subscriptions = protocol.protocol_subscriptions.active
      active_count = active_subscriptions.count
      puts "- #{protocol_name}: active subscriptions=#{active_count}"
      next if dry_run

      active_subscriptions.find_each(&:cancel!)
      puts "  canceled=#{active_count}"
    end

    puts 'Done.'
  end
end
