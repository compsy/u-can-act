# frozen_string_literal: true

db_title = 'Korte Vragenlijst'

db_name1 = 'korte_vragenlijst'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Korte vragenlijst over je beweeggedrag vandaag (± 1-2 min)</p><br><p>Deze vragenlijst helpt ons inzicht te krijgen in je dagelijkse beweging en sport activiteiten.</p>'
  },
  {
    id: :v1,
    type: :radio,
    title: 'Heb je vandaag gefietst of gewandeld?',
    options: [
      {
        title: 'Ja',
        shows_questions: %i[v2]
      },
      {
        title: 'Nee'
      }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v2,
    type: :radio,
    hidden: true,
    title: 'Hoe lang heb je in totaal bewogen (fietsen + wandelen)?',
    options: [
      '0-10 min',
      '11-20 min',
      '21-30 min',
      '31-60 min',
      'Meer dan 60 min'
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v3,
    type: :radio,
    title: 'Heb je vandaag gymles gehad?',
    options: [
      {
        title: 'Ja',
        shows_questions: %i[v4]
      },
      {
        title: 'Nee'
      }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v4,
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
  {
    id: :v5,
    type: :radio,
    title: 'Heb je vandaag gesport buiten school?',
    options: [
      {
        title: 'Ja',
        shows_questions: %i[v6]
      },
      {
        title: 'Nee'
      }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v6,
    type: :checkbox,
    hidden: true,
    title: 'Wat voor sport(en) heb je gedaan?',
    options: [
      { title: 'Fitness' },
      { title: 'Voetbal' },
      { title: 'Dans' },
      { title: 'Zwemmen' }
    ],
    show_otherwise: true,
    otherwise_label: 'Andere:',
    required: true
  },
  {
    id: :v7,
    type: :range,
    title: 'Hoe tevreden ben je over je sport vandaag?',
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
    id: :v8,
    type: :range,
    title: 'Hoe tevreden ben je over je beweegdag vandaag?',
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
