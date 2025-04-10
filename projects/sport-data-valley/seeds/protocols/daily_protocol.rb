# frozen_string_literal: true

pr_name = 'daily_protocol'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)

# TODO: We have to come up with the correct length of the protocol.
protocol.duration = 30.days
protocol.invitation_text = 'Je bent uitgenodigd door je coach om een vragenlijst in te vullen.'
protocol.save!

bp_name = 'base-platform-subscription-daily-protocol'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

# Add questionnaires
start_time = 0 # because we want it to use the offset of the start date
reminder_offset = 9.hours # (start time + offset is the time at which the reminder is sent)

# Create a different measurement for each day
days = %w(maandag dinsdag woensdag donderdag vrijdag zaterdag zondag)

DAY_MAPPING = {
  maandag: 'monday',
  dinsdag: 'tuesday',
  woensdag: 'wednesday',
  donderdag: 'thursday',
  vrijdag: 'friday',
  zaterdag: 'saturday',
  zondag: 'sunday'
}

days.each_with_index do |day, offset|

  # Select the correct questionnaire
  questionnaire_name = "daily_questionnaire_#{day}"
  questionnaire_id = Questionnaire.find_by(name: questionnaire_name)&.id
  raise "Cannot find questionnaire: #{questionnaire_name}" unless questionnaire_id

  # Create the measurement for this specific questionnaire
  general_daily_measurement = protocol.measurements.find_by(questionnaire_id: questionnaire_id)
  general_daily_measurement ||= protocol.measurements.build(questionnaire_id: questionnaire_id)

  general_daily_measurement.open_from_offset = start_time
  general_daily_measurement.open_from_day = DAY_MAPPING[day.to_sym]
  general_daily_measurement.period = 1.week # every day for each questionnaire
  general_daily_measurement.open_duration = 1.days # Open for one day
  general_daily_measurement.reward_points = 0
  general_daily_measurement.priority = 1
  general_daily_measurement.should_invite = true # send invitations
  general_daily_measurement.reminder_delay = reminder_offset
  general_daily_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
  general_daily_measurement.only_redirect_if_nothing_else_ready = true
  general_daily_measurement.save!
end

# Separately add the final questionnaire for Sunday
sunday_questionnaire_name = 'sunday_questionnaire'
questionnaire_id = Questionnaire.find_by(name: sunday_questionnaire_name)&.id
raise "Cannot find questionnaire: #{sunday_questionnaire_name}" unless questionnaire_id

sunday_measurement = protocol.measurements.find_by(questionnaire_id: questionnaire_id)
sunday_measurement ||= protocol.measurements.build(questionnaire_id: questionnaire_id)
sunday_measurement.open_from_offset = start_time # open on Sunday
sunday_measurement.open_from_day = 'sunday'
sunday_measurement.period = 1.week # every sunday
sunday_measurement.open_duration = 1.days # Open for one day
sunday_measurement.reward_points = 0
sunday_measurement.priority = 2
sunday_measurement.should_invite = true # send invitations
sunday_measurement.reminder_delay = reminder_offset
sunday_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
sunday_measurement.only_redirect_if_nothing_else_ready = true
sunday_measurement.save!
