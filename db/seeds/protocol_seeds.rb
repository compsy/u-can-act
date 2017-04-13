# frozen_string_literal: true

=begin
puts 'Generating protocols - Started'
protocol = Protocol.find_by_name('Studentenpilot - 1 keer per week')
protocol ||= Protocol.new(name: 'Studentenpilot - 1 keer per week')
protocol.duration = 3.weeks

voormeting_id = Questionnaire.find_by_name('Voormeting Studenten')&.id
raise 'Cannot find voormeting studenten' unless voormeting_id

vm_measurement = protocol.measurements.find_by_questionnaire_id(voormeting_id)
vm_measurement ||= Measurement.new

protocol.save!
puts 'Generating protocols - Finished'
=end
