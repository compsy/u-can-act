# frozen_string_literal: true

db_title = 'Wekelijkse vragenlijst'

db_name1 = 'sunday_questionnaire'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Wanneer je terugkijkt op de afgelopen week, kun je dan feedback geven over hoe je deze week hebt ervaren.</p>'
  },
  {
    id: :v1,
    title: 'Mentale vermoeidheid',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    section_start: 'Welzijn',
    labels: ['Altijd vermoeid',
             'Meer vermoeid dan normaal',
             'Normaal',
             'Fit',
             'Erg fit']
  },
  {
    id: :v2,
    title: 'Fysieke vermoeidheid',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: ['Altijd vermoeid',
             'Meer vermoeid dan normaal',
             'Normaal',
             'Fit',
             'Erg fit']
  },
  {
    id: :v3,
    type: :radio,
    show_otherwise: false,
    section_start: 'Blessures, ziekte en/of gezondheidsproblemen in de afgelopen week.',
    title: 'Heb je moeite ervaren met deelname aan training en competitie door blessure, ziekte of andere gezondheidsproblemen in de afgelopen week?',
    options: [
      { title: '0. Volledige deelname zonder gezondheidsproblemen.' },
      { title: '0.5.' },
      { title: '1. Volledige deelname, maar met blessure/ziekte' },
      { title: '1.5.' },
      { title: '2. Verminderde deelname door blessure/ziekte' },
      { title: '2.5.' },
      { title: '3. Kan niet deelnemen door blessure/ziekte' }
    ]
  }, {
    id: :v4,
    type: :radio,
    show_otherwise: false,
    title: 'In welke mate heb je je training volume verminderd door blessure, ziekte of andere gezondheidsproblemen in de afgelopen week?',
    options: [
      { title: '0. Geen vermindering' },
      { title: '0.5.' },
      { title: '1. In geringe mate' },
      { title: '1.5.' },
      { title: '2. In gemiddelde mate' },
      { title: '2.5.' },
      { title: '3. In grote mate' },
      { title: '3.5.' },
      { title: '4. Kan helemaal niet deelnemen (aan training)' }
    ]
  }, {
    id: :v5,
    type: :radio,
    show_otherwise: false,
    title: 'In welke mate hebben blessure, ziekte of andere gezondheidsproblemen een negatieve invloed gehad op je prestatie in de afgelopen week?',
    options: [
      { title: '0. Geen vermindering' },
      { title: '0.5.' },
      { title: '1. In geringe mate' },
      { title: '1.5.' },
      { title: '2. In gemiddelde mate' },
      { title: '2.5.' },
      { title: '3. In grote mate' },
      { title: '3.5.' },
      { title: '4. Kan helemaal niet deelnemen (aan prestatie)' }
    ]
  }, {
    id: :v6,
    type: :radio,
    show_otherwise: false,
    title: 'In welke mate heb je symptomen of gezondheidsklachten ervaren in de afgelopen week?',
    options: [
      { title: '0. Geen symptomen of gezondheidsklachten' },
      { title: '0.5.' },
      { title: '1. In geringe mate' },
      { title: '1.5.' },
      { title: '2. In gemiddelde mate' },
      { title: '2.5.' },
      { title: '3. In grote mate' }
    ]
  },
  {
    id: :v7,
    section_start: 'Feedback',
    title: 'Hoe heb je afgelopen week ervaren?',
    type: :textarea
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
