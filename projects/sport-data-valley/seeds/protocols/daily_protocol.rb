# frozen_string_literal: true

pr_name = 'daily_protocol'
protocol = Protocol.find_by_name(pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = 1.day

protocol.save!

# Add questionnaires
questionnaire_name = 'daily_questionnaire'

questionnaire_id = Questionnaire.find_by_name(questionnaire_name)&.id
raise "Cannot find questionnaire: #{questionnaire_name}" unless questionnaire_id

start_time = 8.hours

general_daily_measurement = protocol.measurements.find_by_questionnaire_id(questionnaire_id)
general_daily_measurement ||= protocol.measurements.build(questionnaire_id: questionnaire_id)
general_daily_measurement.open_from_offset = start_time # open right away
general_daily_measurement.period = 1.day # every day
general_daily_measurement.open_duration = 2.days # Open for two days
general_daily_measurement.reward_points = 0
general_daily_measurement.should_invite = true # send invitations
general_daily_measurement.save!


sunday_questionnaire_name = 'sunday_questionnaire'

questionnaire_id = Questionnaire.find_by_name(sunday_questionnaire_name)&.id
raise "Cannot find questionnaire: #{sunday_questionnaire_name}" unless questionnaire_id

sunday_measurement = protocol.measurements.find_by_questionnaire_id(questionnaire_id)
sunday_measurement ||= protocol.measurements.build(questionnaire_id: questionnaire_id)
sunday_measurement.open_from_offset = 6.days + start_time # open on Sunday
sunday_measurement.period = 1.week # every sunday
sunday_measurement.open_duration = 2.days # Open for two days
sunday_measurement.reward_points = 0
sunday_measurement.should_invite = false # send invitations
sunday_measurement.save!
