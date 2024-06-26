# frozen_string_literal: true

questionnaire_key = 'weekly_diary'
OneTimeResponse.find_by(token: 'weekly_diary')&.destroy if Rails.env.development?

pr_name = File.basename(__FILE__)[0...-3]
diary_protocol = Protocol.find_by(name: pr_name)
diary_protocol ||= Protocol.new(name: pr_name)
diary_protocol.duration = 44.weeks
diary_protocol.invitation_text = nil # Determine invitation text dynamically

# Je kunt alleen meedoen aan de dagboekstudie als je ook mee hebt gedaan aan de cross-sectionele vragenlijsten.
# Dus geen echte informed consent maar wel een kleine disclaimer over de beloning vooraf
ic_name = 'disclaimer_rewards'
diary_protocol.informed_consent_questionnaire = Questionnaire.find_by(key: ic_name)
raise "informed consent questionnaire #{ic_name} not found" unless diary_protocol.informed_consent_questionnaire

diary_protocol.save!

# Add rewards
diary_protocol.rewards.destroy_all
reward = diary_protocol.rewards.create!(threshold: 1, reward_points: 100)
reward.save!
reward = diary_protocol.rewards.create!(threshold: 3, reward_points: 150)
reward.save!

questionnaire = Questionnaire.find_by(key: questionnaire_key)
raise "Error: questionnaire for protocol #{pr_name} not found: #{questionnaire_key}" unless questionnaire
questionnaire_id = questionnaire.id

diary_measurement = diary_protocol.measurements.find_by(questionnaire_id: questionnaire_id)
diary_measurement ||= diary_protocol.measurements.build(questionnaire_id: questionnaire_id)
diary_measurement.open_from_offset = 12.hours # if we schedule these at week start, this is saturday noon
diary_measurement.open_from_day = 'saturday' # shift to the next saturday at noon
diary_measurement.period = 1.week # weekly for 44 weeks
diary_measurement.open_duration = 36.hours # don't allow people to fill it out the next day
diary_measurement.reward_points = 1
diary_measurement.reminder_delay = 24.hours # send one reminder sunday at noon
diary_measurement.redirect_url = '/klaar'
diary_measurement.stop_measurement = false # filling out this measurement does not stop the protocol subscription
diary_measurement.should_invite = true # send invitation (SMS and/or email)
diary_measurement.save!
