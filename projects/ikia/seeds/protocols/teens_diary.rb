# frozen_string_literal: true

QUESTIONNAIRE = 'jongeren_dagboek'

pr_name = File.basename(__FILE__)[0...-3]
diary_protocol = Protocol.find_by_name(pr_name)
diary_protocol ||= Protocol.new(name: pr_name)
diary_protocol.duration = 30.days
diary_protocol.save!

questionnaire = Questionnaire.find_by(key: QUESTIONNAIRE)
raise "Error: questionnaire for protocol #{pr_name} not found: #{QUESTIONNAIRE}" unless questionnaire
questionnaire_id = questionnaire.id

# Morning measurement
redirect_url = '/?morning_measurement'
diary_measurement = diary_protocol.measurements.find_by(redirect_url: redirect_url)
diary_measurement ||= diary_protocol.measurements.build(redirect_url: redirect_url)
diary_measurement.questionnaire_id = questionnaire_id
diary_measurement.open_from_offset = 0        # open right away + the offset specified by the user
diary_measurement.period = 1.day              # daily for 30 days
diary_measurement.open_duration = 1.hour      # don't allow people to fill it out the next day
diary_measurement.reminder_delay = 15.minutes # send one reminder after one hour
diary_measurement.stop_measurement = false    # filling out this measurement does not stop the protocol subscription
diary_measurement.should_invite = true        # send invitation (SMS)
diary_measurement.save!

# Afternoon measurement
redirect_url = '/?afternoon_measurement'
diary_measurement = diary_protocol.measurements.find_by(redirect_url: redirect_url)
diary_measurement ||= diary_protocol.measurements.build(redirect_url: redirect_url)
diary_measurement.questionnaire_id = questionnaire_id
diary_measurement.open_from_offset = 6.hours # six hours after the first one
diary_measurement.period = 1.day
diary_measurement.open_duration = 1.hour
diary_measurement.reminder_delay = 15.minutes
diary_measurement.stop_measurement = false
diary_measurement.should_invite = true
diary_measurement.save!

# Evening measurement
redirect_url = '/?evening_measurement'
diary_measurement = diary_protocol.measurements.find_by(redirect_url: redirect_url)
diary_measurement ||= diary_protocol.measurements.build(redirect_url: redirect_url)
diary_measurement.questionnaire_id = questionnaire_id
diary_measurement.open_from_offset = 12.hours # twelve hours after the first one
diary_measurement.period = 1.day
diary_measurement.open_duration = 1.hour
diary_measurement.reminder_delay = 15.minutes
diary_measurement.stop_measurement = false
diary_measurement.should_invite = true
diary_measurement.save!
