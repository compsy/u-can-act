# frozen_string_literal: true

ic_name1 = 'informed_consent'
informed_consent1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
informed_consent1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
informed_consent1.name = ic_name1
ic_content = <<~'END'
  <p class="flow-text"><em>Beste student,</em></p>
  <p class="flow-text">Dit is een voorbeeld van een informed consent.</p>
END
informed_consent1.content = {
  questions: [
    {
      type: :raw,
      content: ic_content
    }, {
      id: :v1,
      type: :checkbox,
      required: true,
      title: '',
      options: [
        'Ik verklaar dat bovenstaande informatie mij duidelijk is en ga hiermee akkoord.'
      ],
      show_otherwise: false
    }
  ], scores: [] }
informed_consent1.title = ''
informed_consent1.save!
