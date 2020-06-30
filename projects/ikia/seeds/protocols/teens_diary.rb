# frozen_string_literal: true

questionnaire_key = 'jongeren_dagboek'

pr_name = File.basename(__FILE__)[0...-3]
diary_protocol = Protocol.find_by(name: pr_name)
diary_protocol ||= Protocol.new(name: pr_name)
diary_protocol.duration = 30.days
diary_protocol.invitation_text = 'Er staat een vragenlijst voor je klaar. Klik op de volgende link om deze in te vullen.'
diary_protocol.save!

questionnaire = Questionnaire.find_by(key: questionnaire_key)
raise "Error: questionnaire for protocol #{pr_name} not found: #{questionnaire_key}" unless questionnaire
questionnaire_id = questionnaire.id

# Morning measurement
diary_measurement = diary_protocol.measurements.find_by(open_from_offset: 6.hours)
diary_measurement ||= diary_protocol.measurements.build(open_from_offset: 6.hours)
diary_measurement.questionnaire_id = questionnaire_id
diary_measurement.redirect_url = ENV['IKIA_CALLBACK_URL']
diary_measurement.period = 1.day              # daily for 30 days
diary_measurement.open_duration = 1.hour      # don't allow people to fill it out the next day
diary_measurement.reminder_delay = 15.minutes # send one reminder after one hour
diary_measurement.stop_measurement = false    # filling out this measurement does not stop the protocol subscription
diary_measurement.should_invite = true        # send invitation (SMS)
diary_measurement.save!

# Afternoon measurement
diary_measurement = diary_protocol.measurements.find_by(open_from_offset: 12.hours)
diary_measurement ||= diary_protocol.measurements.build(open_from_offset: 12.hours)
diary_measurement.questionnaire_id = questionnaire_id
diary_measurement.redirect_url = ENV['IKIA_CALLBACK_URL']
diary_measurement.period = 1.day
diary_measurement.open_duration = 1.hour
diary_measurement.reminder_delay = 15.minutes
diary_measurement.stop_measurement = false
diary_measurement.should_invite = true
diary_measurement.save!

# Evening measurement
diary_measurement = diary_protocol.measurements.find_by(open_from_offset: 18.hours)
diary_measurement ||= diary_protocol.measurements.build(open_from_offset: 18.hours)
diary_measurement.questionnaire_id = questionnaire_id
diary_measurement.redirect_url = ENV['IKIA_CALLBACK_URL']
diary_measurement.period = 1.day
diary_measurement.open_duration = 1.hour
diary_measurement.reminder_delay = 15.minutes
diary_measurement.stop_measurement = false
diary_measurement.should_invite = true
diary_measurement.save!
