# frozen_string_literal: true

db_title = ''
db_name1 = 'deelauto'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

DEELAUTO_QUESTIONS = %i[v31 v32]
DEELFIETS_QUESTIONS = %i[v34]
DEELSCOOTER_QUESTIONS = %i[v36]

dagboek_content = [
  {
    id: :v30,
    type: :radio,
    title: 'Hoe vaak maakt u gemiddeld gebruik van een auto via een deelautoaanbieder?',
    options: [
      'Nooit',
      { title: 'Minder dan een keer per jaar', shows_questions: DEELAUTO_QUESTIONS },
      { title: 'Enkele keren per jaar', shows_questions: DEELAUTO_QUESTIONS },
      { title: 'Eens per maand', shows_questions: DEELAUTO_QUESTIONS },
      { title: 'Een paar keer per maand', shows_questions: DEELAUTO_QUESTIONS },
      { title: 'Iedere week', shows_questions: DEELAUTO_QUESTIONS }
    ],
    required: true,
    show_otherwise: false,
    section_start: 'Deelauto'
  }, {
    id: :v31,
    hidden: true,
    type: :checkbox,
    title: 'Bij welke aanbieder maakt u wel eens gebruik van een deelauto?',
    options: %w[
      MyWheels
      ConnectCar
      StudentCar
      SnappCar
      Greenwheels
      Stapp.in
      Oproepauto
      Witkar
      Car2go
      Juuve
    ],
    required: true,
    show_otherwise: true
  }, {
    id: :v32,
    hidden: true,
    type: :radio,
    title: 'Wat is de afstand van uw huis tot de deelauto ongeveer?',
    options: [
      '1 - 25 meter',
      '25 - 100 meter',
      '100 - 200 meter',
      '200 - 500 meter',
      '500 - 1000 meter',
      'Meer dan 1000 meter'
    ],
    required: true,
    show_otherwise: false
  }, {
    type: :raw,
    content: '<div></div>',
    section_end: true
  }, {
    id: :v33,
    type: :radio,
    title: 'Hoe vaak maakt u gemiddeld gebruik van een fiets via een deelfietsaanbieder (ook OV-fiets)?',
    options: [
      'Nooit',
      { title: 'Minder dan een keer per jaar', shows_questions: DEELFIETS_QUESTIONS },
      { title: 'Enkele keren per jaar', shows_questions: DEELFIETS_QUESTIONS },
      { title: 'Eens per maand', shows_questions: DEELFIETS_QUESTIONS },
      { title: 'Een paar keer per maand', shows_questions: DEELFIETS_QUESTIONS },
      { title: 'Iedere week', shows_questions: DEELFIETS_QUESTIONS }
    ],
    required: true,
    show_otherwise: false,
    section_start: 'Deelfiets'
  }, {
    id: :v34,
    hidden: true,
    type: :checkbox,
    title: 'Bij welke aanbieder maakt u wel eens gebruik van een deelfiets?',
    options: [
      'OV-fiets',
      'NextBike',
      'Hello-Bike',
      'Donkey Republic',
      'Flickbike',
      'Ofo',
      'MoBike',
      'oBike'
    ],
    required: true,
    show_otherwise: true
  }, {
    type: :raw,
    content: '<div></div>',
    section_end: true
  }, {
    id: :v35,
    type: :radio,
    title: 'Hoe vaak maakt u gemiddeld gebruik van een scooter via een deelscooteraanbieder?',
    options: [
      'Nooit',
      { title: 'Minder dan een keer per jaar', shows_questions: DEELSCOOTER_QUESTIONS },
      { title: 'Enkele keren per jaar', shows_questions: DEELSCOOTER_QUESTIONS },
      { title: 'Eens per maand', shows_questions: DEELSCOOTER_QUESTIONS },
      { title: 'Een paar keer per maand', shows_questions: DEELSCOOTER_QUESTIONS },
      { title: 'Iedere week', shows_questions: DEELSCOOTER_QUESTIONS }
    ],
    required: true,
    show_otherwise: false,
    section_start: 'Deelscooter'
  }, {
    id: :v36,
    hidden: true,
    type: :checkbox,
    title: 'Bij welke aanbieder maakt u wel eens gebruik van een deelscooter?',
    options: [
      'Go sharing',
      'Felyx'
    ],
    required: true,
    show_otherwise: true
  }, {
    type: :raw,
    content: '<div></div>',
    section_end: true
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
