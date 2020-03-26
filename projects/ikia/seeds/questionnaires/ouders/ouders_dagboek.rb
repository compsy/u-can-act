# frozen_string_literal: true

db_title = 'Dagboekvragenlijst'
db_name1 = 'Dagboek_ouders'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

dagboek_content = [
  {
    section_start: '<strong>De volgende vragen gaan over hoe je je op dit moment voelt.</strong>',
    id: :v1,
    type: :textfield,
    title: 'Ik voel me op dit moment...'
  }, {
    id: :v2,
    type: :radio,
    show_otherwise: false,
    title: 'Merk je dit gevoel ook in je lichaam?',
    options: [
      { title: 'Ja', shows_questions: %i[v3] },
      { title: 'Nee' }
    ]
  }, {
    id: :v3,
    hidden: true,
    type: :drawing,
    title: 'Waar in je lichaam merk je dit?',
    width: 240,
    height: 536,
    image: 'bodymap.png',
    color: '#e57373'
  }, {
    type: :raw,
    content: '<p class="flow-text">Geef bij elk gevoel aan hoe sterk je dit nu voelt:</p>'
  }, {
    id: :v4,
    type: :range,
    title: 'Boos',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v5,
    type: :range,
    title: 'Tevreden',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v6,
    type: :range,
    title: 'Schuldig',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v7,
    type: :range,
    title: 'Vol energie',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v8,
    type: :range,
    title: 'Vrolijk',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v9,
    type: :range,
    title: 'Verdrietig',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v10,
    type: :range,
    title: 'Bang',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v11,
    type: :range,
    title: 'In de war',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v12,
    type: :range,
    title: 'Eenzaam',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v13,
    type: :range,
    title: 'Zenuwachtig',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v14,
    type: :range,
    title: 'Gelukkig',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v15,
    type: :range,
    title: 'Dankbaar',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v16,
    type: :range,
    title: 'Ik weet precies wat ik op dit moment voel',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v17,
    type: :range,
    title: 'Ik ben in de war over hoe ik me voel',
    labels: ['Helemaal niet', 'Heel erg'],
    section_end: true
  }, {
    section_start: '<strong>De volgende vragen gaan over hoe je dag was</strong>',
    id: :v18,
    type: :radio,
    show_otherwise: false,
    title: 'Is er vandaag iets leuks gebeurd?',
    options: [
      { title: 'Ja', shows_questions: %i[v19 v20 v21] },
      { title: 'Nee' }
    ]
  }, {
    id: :v19,
    hidden: true,
    type: :range,
    title: 'Hoe leuk was deze gebeurtenis?',
    labels: ['Een klein beetje leuk', 'Heel erg leuk']
  }, {
    id: :v20,
    hidden: true,
    type: :checkbox,
    required: true,
    title: 'Waar had deze gebeurtenis mee te maken?',
    options: [
      'Met mijzelf',
      'Met mijn ouders of mijn familie',
      'Met mijn vrienden',
      'Met mijn klasgenoten',
      'Met school',
      'Met onbekenden',
      'Met iets wat ik op het nieuws, op internet of in de krant zag'
    ],
    show_otherwise: true,
    otherwise_label: 'Met iets anders, namelijk'
  }, {
    id: :v21,
    hidden: true,
    type: :checkbox,
    required: true,
    title: 'Heb je hier met iemand over gepraat?',
    options: [
      'Nee, met niemand',
      'Ja, met mijn vader of moeder of allebei',
      'Ja, met een vriend of vriendin'
    ],
    show_otherwise: true,
    otherwise_label: 'Ja, met iemand anders, namelijk'
  }, {
    id: :v22,
    type: :radio,
    show_otherwise: false,
    title: 'Is er vandaag iets vervelends gebeurd?',
    options: [
      { title: 'Ja', shows_questions: %i[v23 v24 v25 v26 v27] },
      { title: 'Nee' }
    ]
  }, {
    id: :v23,
    hidden: true,
    type: :range,
    title: 'Hoe vervelend was deze gebeurtenis?',
    labels: ['Een klein beetje vervelend', 'Heel erg vervelend']
  }, {
    id: :v24,
    hidden: true,
    type: :checkbox,
    required: true,
    title: 'Waar had deze gebeurtenis mee te maken?',
    options: [
      'Met mijzelf',
      'Met mijn ouders of mijn familie',
      'Met mijn vrienden',
      'Met mijn klasgenoten',
      'Met school',
      'Met onbekenden',
      'Met iets wat ik op het nieuws, op internet of in de krant zag'
    ],
    show_otherwise: true,
    otherwise_label: 'Met iets anders, namelijk'
  }, {
    id: :v25,
    hidden: true,
    type: :range,
    title: 'Heb je over deze gebeurtenis lopen piekeren?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v26,
    hidden: true,
    type: :range,
    title: 'Heb je geprobeerd niet aan deze gebeurtenis te denken?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v27,
    hidden: true,
    type: :checkbox,
    required: true,
    title: 'Heb je hier met iemand over gepraat?',
    options: [
      'Nee, met niemand',
      'Ja, met mijn vader of moeder of allebei',
      'Ja, met een vriend of vriendin'
    ],
    show_otherwise: true,
    otherwise_label: 'Ja, met iemand anders, namelijk'
  }, {
    id: :v28,
    type: :range,
    title: 'Heb je vandaag gelachen?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v29,
    type: :range,
    title: 'Ben je vandaag buiten geweest?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v30,
    type: :range,
    title: 'Ben je vandaag actief geweest?',
    tooltip: 'Sporten, wandelen, fietsen',
    labels: ['Helemaal niet', 'Heel erg'],
    section_end: true
  }, {
    section_start: '<strong>De volgende vragen gaan over hoe het vandaag tussen jou en je moeder of vader was.</strong>',
    id: :v31,
    type: :range,
    title: 'Heb je vandaag iets leuks gedaan met je vader of moeder?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v32,
    type: :range,
    title: 'Heb je vandaag ruzie gemaakt met je vader of moeder?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v33,
    type: :range,
    title: 'Heb je vandaag geknuffeld met je vader of moeder?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v34,
    type: :range,
    title: 'Was je vader of moeder vandaag boos op jou?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v35,
    type: :range,
    title: 'Hoe leuk of fijn vond je het om bij je vader of moeder te zijn?',
    labels: ['Helemaal niet', 'Heel erg'],
    section_end: true
  },
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
