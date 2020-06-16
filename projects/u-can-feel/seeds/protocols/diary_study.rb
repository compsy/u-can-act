# frozen_string_literal: true

questionnaire_key = 'weekly_diary'

pr_name = File.basename(__FILE__)[0...-3]
diary_protocol = Protocol.find_by_name(pr_name)
diary_protocol ||= Protocol.new(name: pr_name)
diary_protocol.duration = 44.weeks
diary_protocol.invitation_text = 'Je wekelijkse vragenlijst staat voor je klaar. Klik op de volgende link om deze in te vullen.'

ic_name = 'informed_consent'
diary_protocol.informed_consent_questionnaire = Questionnaire.find_by(key: ic_name)
raise "informed consent questionnaire #{ic_name} not found" unless diary_protocol.informed_consent_questionnaire

diary_protocol.save!

questionnaire = Questionnaire.find_by(key: questionnaire_key)
raise "Error: questionnaire for protocol #{pr_name} not found: #{questionnaire_key}" unless questionnaire
questionnaire_id = questionnaire.id

diary_measurement = diary_protocol.measurements.find_by(questionnaire_id: questionnaire_id)
diary_measurement ||= diary_protocol.measurements.build(questionnaire_id: questionnaire_id)
diary_measurement.open_from_offset = 12.hours # if we schedule these at week start, this is saturday noon
# TODO: uncomment me
# diary_measurement.open_from_day = 'saturday' # shift to the next saturday at noon
diary_measurement.period = 1.week # daily for 30 days
diary_measurement.open_duration = 36.hours # don't allow people to fill it out the next day
diary_measurement.reminder_delay = 24.hours # send one reminder sunday at noon
diary_measurement.stop_measurement = false # filling out this measurement does not stop the protocol subscription
diary_measurement.should_invite = true # send invitation (SMS and/or email)
diary_measurement.save!
