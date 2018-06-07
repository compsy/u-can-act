default_protocol_duration = 0 # evt eerder dynamisch afbreken
default_open_duration = 30.hours     # "tot de volgende dag 6 uur"
default_posttest_open_duration = nil
default_reward_points = 100

###############
## kct ##
###############

pr_name = 'kct'
protocol = Protocol.find_by_name(pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = Questionnaire.find_by_name('informed consent studenten december 2017')
raise 'informed consent questionnaire not found' unless protocol.informed_consent_questionnaire
protocol.save!

# Add voormeting
vm_name = 'voormeting studenten'
voormeting_id = Questionnaire.find_by_name(vm_name)&.id
raise "Cannot find questionnaire: #{vm_name}" unless voormeting_id
vm_measurement = protocol.measurements.find_by_questionnaire_id(voormeting_id)
vm_measurement ||= protocol.measurements.build(questionnaire_id: voormeting_id)
vm_measurement.open_from_offset = 0
vm_measurement.period = nil
vm_measurement.open_duration = nil
vm_measurement.reward_points = 0
vm_measurement.save!
