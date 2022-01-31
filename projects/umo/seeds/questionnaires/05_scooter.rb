# frozen_string_literal: true

db_title = ''
db_name1 = 'scooter'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

SCOOTER_QUESTIONS = %i[v26]

dagboek_content = [
  {
    id: :v25,
    type: :radio,
    title: 'Heeft u een scooter/bromfiets/snorfiets?',
    options: [
      { title: 'Ja', shows_questions: SCOOTER_QUESTIONS },
      { title: 'Nee' }
    ],
    required: true,
    show_otherwise: false
  }, {
    id: :v26,
    hidden: true,
    type: :radio,
    title: 'Welke brandstof gebruikt uw scooter/bromfiets/snorfiets?',
    options: %w[Elektrisch Benzine],
    required: true,
    show_otherwise: true
  }, {
    id: :v27,
    type: :radio,
    title: 'Heeft u een motor?',
    options: %w[Ja Nee],
    required: true,
    show_otherwise: false
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
