ic_name = 'informed consent scholieren'
informed_consent = Questionnaire.find_by(name: ic_name)
informed_consent ||= Questionnaire.new(name: ic_name)
informed_consent.key = File.basename(__FILE__)[0...-3]
ic_content = <<~'END'
  <p class="flow-text"><em>Toestemming</em></p>
  <p class="flow-text">Ja, ik doe mee aan het onderzoek 'Differentiatie binnenstebuiten'. Ik weet dat mijn antwoorden en de opnames van de lessen geheim blijven en alleen voor onderzoek gebruikt worden. Ik weet ook dat ik altijd om hulp kan vragen wanneer ik vragen lastig vind om te beantwoorden, of wanneer er vragen zijn die ik niet prettig vind om te beantwoorden.</p>
END
informed_consent.content = { questions: [{
  type: :raw,
  content: ic_content
}, {
  id: :v1,
  type: :checkbox,
  required: true,
  title: '',
  options: [
    'Ja, ik geef toestemming'
  ],
  show_otherwise: false
}], scores: [] }
informed_consent.title = 'Differentiatie Binnenstebuiten'
informed_consent.save!
