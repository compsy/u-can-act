# frozen_string_literal: true

db_title = ''
db_name1 = 'fietsen'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

BIKING_QUESTIONS = %i[v22 v23 v24]

dagboek_content = [
  {
    id: :v21,
    type: :radio,
    title: 'Gebruikt u een fiets als vervoermiddel?',
    options: [
      { title: 'Ja', shows_questions: BIKING_QUESTIONS },
      { title: 'Nee' }
    ],
    required: true,
    show_otherwise: false
  }, {
    id: :v22,
    hidden: true,
    type: :radio,
    title: 'Van wie is die fiets?',
    options: [
      'Van mezelf',
      'Geleased (bijv. Swapfiets)',
      'Geleend'
    ],
    required: true,
    show_otherwise: true
  }, {
    id: :v23,
    hidden: true,
    type: :radio,
    title: 'Welke type fiets is die fiets?',
    options: [
      'Stadsfiets',
      'Bakfiets',
      'Sport/Hobby fiets (racefiets, mountainbike)',
      'Elektrische fiets (maximale snelheid 25 km/u)',
      'Speed pedelec (maximale snelheid 45 km/u)',
      'Elektrische bakfiets',
      'Anders'
    ],
    required: true,
    show_otherwise: false
  }, {
    id: :v24,
    hidden: true,
    type: :number,
    title: 'Hoeveel jaar oud is die fiets?',
    min: 0,
    max: 20,
    required: true,
    maxlength: 2
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
