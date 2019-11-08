# frozen_string_literal: true

db_title = 'Oslo Sports Trauma Research Center (OSTRC) overuse injury vragenlijst'

db_name1 = 'ostrc'
questionnaire = Questionnaire.find_by_name(db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Beantwoord alstublieft de onderstaande vragen, onafhankelijk van of je wel of geen
gezondheidsproblemen hebt ervaren. Selecteer de optie die het beste aansluit, en wanneer u
niet helemaal zeker bent van uw antwoord, probeer dan zo goed als mogelijk een antwoord
te geven.</p>'
  }, {
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'Heb je moeite ervaren met deelname aan training en competitie door blessure, ziekte of andere gezondheidsproblemen in de afgelopen week?',
    options: [
      { title: '0. Volledige deelname zonder gezondheidsproblemen.' },
      { title: '1. Volledige deelname, maar met blessure/ziekte' },
      { title: '2. Verminderde deelname door blessure/ziekte' },
      { title: '3. Kan niet deelnemen door blessure/ziekte' }
    ]
  }, {
    id: :v2,
    type: :radio,
    show_otherwise: false,
    title: 'In welke mate heb je je training volume verminderd door blessure, ziekte of andere gezondheidsproblemen in de afgelopen week?',
    options: [
      { title: '0. Geen vermindering' },
      { title: '1. In geringe mate' },
      { title: '2. In gemiddelde mate' },
      { title: '3. In grote mate' },
      { title: '4. Kan helemaal niet deelnemen (aan training)' }
    ]
  }, {
    id: :v3,
    type: :radio,
    show_otherwise: false,
    title: 'In welke mate hebben blessure, ziekte of andere gezondheidsproblemen een negatieve invloed gehad op je prestatie in de afgelopen week?',
    options: [
      { title: '0. Geen vermindering' },
      { title: '1. In geringe mate' },
      { title: '2. In gemiddelde mate' },
      { title: '3. In grote mate' },
      { title: '4. Kan helemaal niet deelnemen (aan prestatie)' }
    ]
  }, {
    id: :v4,
    type: :radio,
    show_otherwise: false,
    title: 'In welke mate heb je symptomen of gezondheidsklachten ervaren in de afgelopen week?',
    options: [
      { title: '0. Geen symptomen of gezondheidsklachten' },
      { title: '1. In geringe mate' },
      { title: '2. In gemiddelde mate' },
      { title: '3. In grote mate' }
    ]
  }
]
questionnaire.content = dagboek_content
questionnaire.title = db_title
questionnaire.save!
