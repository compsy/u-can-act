# frozen_string_literal: true

ic_name1 = 'usc_chan_ic'
informed_consent1 = Questionnaire.find_by(name: ic_name1)
informed_consent1 ||= Questionnaire.new(name: ic_name1)
informed_consent1.key = File.basename(__FILE__)[0...-3]
ic_content = <<~'END'
  <p class="flow-text"><em>Dear research participant,</em></p>
  <p class="flow-text">This is an example of an informed consent questionnaire.</p>
END
informed_consent1.content = { questions: [{
  type: :raw,
  content: ic_content
}, {
  id: :v1,
  type: :checkbox,
  required: true,
  title: '',
  options: [
    'I declare that I understand and agree with the above information.'
  ],
  show_otherwise: false
}], scores: [] }
informed_consent1.title = ''
informed_consent1.save!
