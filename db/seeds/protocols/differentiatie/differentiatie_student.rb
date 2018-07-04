default_protocol_duration = 35.weeks # evt eerder dynamisch afbreken
default_open_duration = 30.hours     # "tot de volgende dag 6 uur"
default_posttest_open_duration = nil
default_reward_points = 100

###############
## studenten ##
###############

pr_name = 'differentiatie_studenten'
protocol = Protocol.find_by_name(pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = Questionnaire.find_by_name('informed consent studenten december 2017')
raise 'informed consent questionnaire not found' unless protocol.informed_consent_questionnaire
protocol.save!

# Add dagboekmetingen
db_name = 'differentiatie studenten range'
of_offset = 3.days + 12.hours # Thursday noon
dagboekvragenlijst_id = Questionnaire.find_by_name(db_name)&.id
raise "Cannot find questionnaire: #{db_name}" unless dagboekvragenlijst_id
db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id,
                                             open_from_offset: of_offset).first
db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
db_measurement.open_from_offset = of_offset
db_measurement.period = 1.week
db_measurement.open_duration = default_open_duration
db_measurement.reward_points = default_reward_points
db_measurement.stop_measurement = false
db_measurement.should_invite = true
db_measurement.save!
