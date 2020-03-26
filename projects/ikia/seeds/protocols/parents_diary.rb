# frozen_string_literal: true

QUESTIONNAIRE = 'ouders_dagboek'

pr_name = File.basename(__FILE__)[0...-3]
diary_protocol = Protocol.find_by_name(pr_name)
diary_protocol ||= Protocol.new(name: pr_name)
diary_protocol.duration = 30.days
diary_protocol.save!

questionnaire = Questionnaire.find_by(key: QUESTIONNAIRE)
raise "Error: questionnaire for protocol #{pr_name} not found: #{QUESTIONNAIRE}" unless questionnaire
questionnaire_id = questionnaire.id

diary_measurement = diary_protocol.measurements.find_by(questionnaire_id: questionnaire_id)
diary_measurement ||= diary_protocol.measurements.build(questionnaire_id: questionnaire_id)
diary_measurement.open_from_offset = 17.hours # open 5pm the next day
diary_measurement.period = 1.day              # daily for 30 days
diary_measurement.open_duration = 12.hours    # don't allow people to fill it out the next day
diary_measurement.reminder_delay = 1.hour     # send one reminder after one hour
diary_measurement.stop_measurement = false    # filling out this measurement does not stop the protocol subscription
diary_measurement.should_invite = true        # send invitation (SMS)
diary_measurement.redirect_url = '/klaar'     # is overridden by callback_url passed
diary_measurement.save!
