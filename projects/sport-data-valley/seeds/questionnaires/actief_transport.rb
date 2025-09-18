# frozen_string_literal: true

db_title = 'Actief Transport'

db_name1 = 'actief_transport'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">ACTIEF TRANSPORT</p><p>De volgende vragen gaan over je beweging vandaag.</p>'
  },
  # Question 1: Did you cycle or walk today?
  {
    id: :v1,
    type: :radio,
    title: 'Heb je vandaag gefietst of gewandeld?',
    options: [
      {
        title: 'Ja',
        shows_questions: %i[v2 v3 v4 v5]
      },
      {
        title: 'Nee',
        shows_questions: %i[v6]
      }
    ],
    required: true,
    show_otherwise: false
  },
  # Question 2: What did you do? (if yes)
  {
    id: :v2,
    type: :checkbox,
    hidden: true,
    title: 'Wat heb je gedaan? (meerdere antwoorden mogelijk)',
    options: [
      { title: 'Fietsen naar school' },
      { title: 'Wandelen naar school' },
      { title: 'Fietsen naar vrienden/supermarkt/sport' },
      { title: 'Wandelen naar vrienden/supermarkt/sport' }
    ],
    show_otherwise: true,
    otherwise_label: 'Andere:',
    required: true
  },
  # Question 3: At what time of day?
  {
    id: :v3,
    type: :checkbox,
    hidden: true,
    title: 'Op welk moment van de dag?',
    options: [
        'Ochtend',
      'Middag',
      'Avond'
    ],
    required: true,
    show_otherwise: false
  },
  # Question 4: How long did you move?
  {
    id: :v4,
    type: :checkbox,
    hidden: true,
    title: 'Hoe lang heb je bewogen?',
    options: [
      'Fietsen: 0-10 minuten',
      'Fietsen: 11-20 minuten',
      'Fietsen: 21-30 minuten',
      'Fietsen: 31-60 minuten',
      'Fietsen: 61-90 minuten',
      'Fietsen: >90 minuten',
      'Wandelen: 0-10 minuten',
      'Wandelen: 11-20 minuten',
      'Wandelen: 21-30 minuten',
      'Wandelen: 31-60 minuten',
      'Wandelen: 61-90 minuten',
      'Wandelen: >90 minuten'
    ],
    required: true,
    show_otherwise: false
  },
  # Question 5: With whom?
  {
    id: :v5,
    type: :radio,
    hidden: true,
    title: 'Met wie?',
    options: [
      { title: 'Alleen' },
      { title: 'Met vrienden' },
      { title: 'Met familie' }
    ],
    show_otherwise: true,
    otherwise_label: 'Andere:',
    required: true
  },
  # Question 6: Why not? (if no)
  {
    id: :v6,
    type: :checkbox,
    hidden: true,
    title: 'Waarom niet? (meerdere opties)',
    options: [
      { title: 'Geen zin' },
      { title: 'Slecht weer' },
      { title: 'Blessure' },
      { title: 'Ik doe dat nooit' }
    ],
    show_otherwise: true,
    otherwise_label: 'Andere:',
    required: true
  },
  # GYMLES Section
  {
    type: :raw,
    content: '<br><p class="flow-text"><strong>GYMLES</strong></p>'
  },
  # Question 7: Did you have PE class today?
  {
    id: :v7,
    type: :radio,
    title: 'Had je vandaag gymles?',
    options: [
      {
        title: 'Ja',
        shows_questions: %i[v8 v9]
      },
      {
        title: 'Nee'
      }
    ],
    required: true,
    show_otherwise: false
  },
  # Question 8: When did PE class take place?
  {
    id: :v8,
    type: :radio,
    hidden: true,
    title: 'Wanneer vond de gymles plaats?',
    options: [
      'Ochtend',
      'Middag'
    ],
    required: true,
    show_otherwise: false
  },
  # Question 9: How long did PE class last?
  {
    id: :v9,
    type: :radio,
    hidden: true,
    title: 'Hoe lang duurde de gymles?',
    options: [
      '1 lesuur',
      '2 lesuren',
      'Meer dan 2 lesuren'
    ],
    required: true,
    show_otherwise: false
  },
  # SPORT Section
  {
    type: :raw,
    content: '<br><p class="flow-text"><strong>SPORT</strong></p>'
  },
  # Question 10: Did you do sports outside school today?
  {
    id: :v10,
    type: :radio,
    title: 'Heb je vandaag gesport buiten school?',
    options: [
      {
        title: 'Ja',
        shows_questions: %i[v11 v12 v13 v14]
      },
      {
        title: 'Nee',
        shows_questions: %i[v15]
      }
    ],
    required: true,
    show_otherwise: false
  },
  # Question 11: What did you do? (if yes)
  {
    id: :v11,
    type: :checkbox,
    hidden: true,
    title: 'Wat heb je gedaan? (meerdere antwoorden mogelijk)',
    options: [
      { title: 'Fitness' },
      { title: 'Voetbal' },
      { title: 'Dans' },
      { title: 'Zwemmen' },
      { title: 'Hockey' },
      { title: 'Vechtsport' }
    ],
    show_otherwise: true,
    otherwise_label: 'Andere:',
    required: true
  },
  # Question 12: When did you do sports?
  {
    id: :v12,
    type: :checkbox,
    hidden: true,
    title: 'Wanneer gesport?',
    options: [
      'Ochtend',
      'Middag',
      'Avond'
    ],
    required: true,
    show_otherwise: false
  },
  # Question 13: How long did you do sports?
  {
    id: :v13,
    type: :radio,
    hidden: true,
    title: 'Hoe lang gesport?',
    options: [
      '0-10 minuten',
      '11-20 minuten',
      '21-30 minuten',
      '31-60 minuten',
      '61-90 minuten',
      '>90 minuten'
    ],
    required: true,
    show_otherwise: false
  },
  # Question 14: With whom did you do sports?
  {
    id: :v14,
    type: :radio,
    hidden: true,
    title: 'Met wie gesport?',
    options: [
      { title: 'Alleen' },
      { title: 'Vrienden' },
      { title: 'Familie' },
      { title: 'Teamgenoten' }
    ],
    show_otherwise: true,
    otherwise_label: 'Andere:',
    required: true
  },
  # Question 15: Why didn't you do sports? (if no)
  {
    id: :v15,
    type: :checkbox,
    hidden: true,
    title: 'Waarom niet gesport?',
    options: [
      { title: 'Ik sport op een andere dag' },
      { title: 'Blessure' },
      { title: 'Slecht weer' },
      { title: 'Geen interesse' }
    ],
    show_otherwise: true,
    otherwise_label: 'Andere:',
    required: true
  },
  # TEVREDENHEID Section
  {
    type: :raw,
    content: '<br><p class="flow-text"><strong>TEVREDENHEID</strong></p>'
  },
  # Question 16: How satisfied are you with how much you exercised and moved today?
  {
    id: :v16,
    type: :range,
    title: 'Hoe tevreden ben je over hoeveel je vandaag hebt gesport?',
    min: 1,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      'Zeer ontevreden',
      'Ontevreden',
      'Gemiddeld',
      'Tevreden',
      'Zeer tevreden'
    ]
  },
  {
    id: :v17,
    type: :range,
    title: 'Hoe tevreden ben je over hoeveel je vandaag hebt bewogen?',
    min: 1,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      'Zeer ontevreden',
      'Ontevreden',
      'Gemiddeld',
      'Tevreden',
      'Zeer tevreden'
    ]
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
