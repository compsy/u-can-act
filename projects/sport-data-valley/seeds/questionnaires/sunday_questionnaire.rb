# frozen_string_literal: true

db_title = ''

db_name1 = 'sunday_questionnaire'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: { nl: "<h4 class=\"header\">Wekelijkse vragenlijst</h4>",
               en: "<h4 class=\"header\">Weekly questionnaire</h4>" }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Wanneer je terugkijkt op de afgelopen week, kun je dan feedback geven over hoe je deze week hebt ervaren.</p>',
               en: '<p class="flow-text">Looking back on the past week, please provide feedback on how you experienced this week.</p>' }
  },
  {
    id: :v1,
    title: { nl: 'Mentale vermoeidheid', en: 'Fatigue (mental)' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    section_start: { nl: 'Welzijn', en: 'Well-being' },
    labels: [{ nl: 'Altijd vermoeid', en: 'Always tired' },
             { nl: 'Meer vermoeid dan normaal', en: 'More tired than usual' },
             { nl: 'Normaal', en: 'Normal' },
             { nl: 'Fit', en: 'Fit' },
             { nl: 'Erg fit', en: 'Very fit' }]
  },
  {
    id: :v2,
    title: { nl: 'Fysieke vermoeidheid', en: 'Fatigue (physical)' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: [{ nl: 'Altijd vermoeid', en: 'Always tired' },
             { nl: 'Meer vermoeid dan normaal', en: 'More tired than usual' },
             { nl: 'Normaal', en: 'Normal' },
             { nl: 'Fit', en: 'Fit' },
             { nl: 'Erg fit', en: 'Very fit' }]
  },
  {
    id: :v3,
    type: :radio,
    show_otherwise: false,
    section_start: { nl: 'Blessures, ziekte en/of gezondheidsproblemen in de afgelopen week.', en: 'Injuries, illness, and/or health problems in the past week.' },
    title: { nl: 'Heb je moeite ervaren met deelname aan training en competitie door blessure, ziekte of andere gezondheidsproblemen in de afgelopen week?', en: 'Difficulties participating due to injury, illness or other health problems?' },
    options: [
      { title: { nl: '0. Volledige deelname zonder gezondheidsproblemen.', en: '0. Full participation without health problems' } },
      { title: '0.5.' },
      { title: { nl: '1. Volledige deelname, maar met blessure/ziekte', en: '1. Full participation, but with injury/illness' } },
      { title: '1.5.' },
      { title: { nl: '2. Verminderde deelname door blessure/ziekte', en: '2. Reduced participation due to injury/illness' } },
      { title: '2.5.' },
      { title: { nl: '3. Kan niet deelnemen door blessure/ziekte', en: '3. Cannot participate due to injury/illness' } }
    ]
  }, {
    id: :v4,
    type: :radio,
    show_otherwise: false,
    title: { nl: 'In welke mate heb je je training volume verminderd door blessure, ziekte of andere gezondheidsproblemen in de afgelopen week?', en: 'Reduced training volume due to injury, illness or other health problems?' },
    options: [
      { title: { nl: '0. Geen vermindering', en: '0. No reduction' } },
      { title: '0.5.' },
      { title: { nl: '1. In geringe mate', en: '1. To a minor extent' } },
      { title: '1.5.' },
      { title: { nl: '2. In gemiddelde mate', en: '2. To a moderate extent' } },
      { title: '2.5.' },
      { title: { nl: '3. In grote mate', en: '3. To a major extent' } },
      { title: '3.5.' },
      { title: { nl: '4. Kan helemaal niet deelnemen (aan training)', en: '4. Cannot participate (in training) at all' } }
    ]
  }, {
    id: :v5,
    type: :radio,
    show_otherwise: false,
    title: { nl: 'In welke mate hebben blessure, ziekte of andere gezondheidsproblemen een negatieve invloed gehad op je prestatie in de afgelopen week?', en: 'Did injury, illness or other health problems affect your performance?' },
    options: [
      { title: { nl: '0. Geen vermindering', en: '0. No reduction' } },
      { title: '0.5.' },
      { title: { nl: '1. In geringe mate', en: '1. To a minor extent' } },
      { title: '1.5.' },
      { title: { nl: '2. In gemiddelde mate', en: '2. To a moderate extent' } },
      { title: '2.5.' },
      { title: { nl: '3. In grote mate', en: '3. To a major extent' } },
      { title: '3.5.' },
      { title: { nl: '4. Kan helemaal niet deelnemen (aan prestatie)', en: '4. Cannot participate (in performance) at all' } }
    ]
  }, {
    id: :v6,
    type: :radio,
    show_otherwise: false,
    title: { nl: 'In welke mate heb je symptomen of gezondheidsklachten ervaren in de afgelopen week?', en: 'Did you experience symptoms/health complaints?' },
    options: [
      { title: { nl: '0. Geen symptomen of gezondheidsklachten', en: '0. No symptoms/health complaints' } },
      { title: '0.5.' },
      { title: { nl: '1. In geringe mate', en: '1. To a mild extent' } },
      { title: '1.5.' },
      { title: { nl: '2. In gemiddelde mate', en: '2. To a moderate extent' } },
      { title: '2.5.' },
      { title: { nl: '3. In grote mate', en: '3. To a severe extent' } }
    ]
  },
  {
    id: :v7,
    section_start: 'Feedback',
    title: { nl: 'Hoe heb je afgelopen week ervaren?', en: 'How did you experience last week?' },
    type: :textarea
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
