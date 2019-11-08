# frozen_string_literal: true

db_title = 'Readiness-to-train vragenlijst'

db_name1 = 'rtt'
questionnaire = Questionnaire.find_by_name(db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Selecteer de optie die het beste aansluit, en wanneer u niet helemaal zeker bent van uw antwoord, probeer dan zo goed als mogelijk een antwoord te geven.</p>'
  },
  {
    id: :v1,
    title: 'Readiness-to train',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    #TODO: We have to see how well this will render
    labels: [
      'Onmogelijk te trainen',
      'Niet ready om te trainen',
      'Normaal',
      'Ready om te trainen',
      'Very ready to train'
    ]
  }
]
questionnaire.content = dagboek_content
questionnaire.title = db_title
questionnaire.save!
