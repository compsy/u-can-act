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

  desc 'Extend protocols and reschedule the nametingen'
  task reschedule_posttests: :environment do
    puts 'Rescheduling posttests - started'
    protocols_adjusted = 0
    Protocol.all.each do |protocol|
      next unless protocol.duration == 3.weeks
      protocol.duration = 4.weeks
      protocol.save!
      protocols_adjusted += 1
    end
    puts "Adjusted #{protocols_adjusted} protocols."
    nameting_questionnaire_names = [
      'nameting studenten 1x per week',
      'nameting studenten 2x per week',
      'nameting studenten 5x per week',
      'nameting mentoren 1x per week'
    ]
    nameting_ids = []
    nameting_questionnaire_names.each do |questionnaire_name|
      questionnaire = Questionnaire.find_by_name(questionnaire_name)
      if questionnaire.blank?
        puts "ERROR: questionnaire not found: #{questionnaire_name}"
        next
      end
      nameting_ids << questionnaire.id
    end
    responses_rescheduled = 0
    Response.all.each do |response|
      next unless nameting_ids.include?(response.measurement.questionnaire.id)
      response.open_from = TimeTools.increase_by_duration(response.protocol_subscription.start_date,
                                                          2.weeks + 4.days + 13.hours) # Friday 1pm last week
      response.save!
      responses_rescheduled += 1
    end
    puts "Rescheduled #{responses_rescheduled} responses."
    puts 'Rescheduling posttests - done'
  end
end
