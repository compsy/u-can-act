# frozen_string_literal: true

nm_name1 = 'nameting studenten controle'
nameting1 = Questionnaire.find_by(name: nm_name1)
nameting1 ||= Questionnaire.new(name: nm_name1)
nameting1.key = File.basename(__FILE__)[0...-3]
nameting1.content = { questions: [{
  id: :v1,
  type: :radio,
  title: 'Ben je dit schooljaar definitief gestopt met je opleiding?',
  options: [
    { title: 'Ja, ik ben gestopt met mijn opleiding zonder dat ik mijn diploma heb gehaald.', shows_questions: %i[v2 v3 v4] },
    { title: 'Ja, ik ben gestopt nadat ik mijn diploma had gehaald.', shows_questions: %i[v2 v4] },
    { title: 'Nee, ik volg nog steeds dezelfde opleiding.', shows_questions: %i[v5] }
  ],
  show_otherwise: false
}, {
  id: :v2,
  hidden: true,
  type: :date,
  max: '2018/11/01',
  required: true,
  title: 'Wanneer ben je ongeveer gestopt? Als je het niet precies meer weet, vul dan iets in dat zo goed mogelijk in de buurt komt.'
}, {
  id: :v3,
  type: :radio,
  hidden: true,
  title: 'Hoeveel jaar moest je nog ongeveer tot je diploma?',
  options: ['0 tot 1 jaar',
            '1 tot 2 jaar',
            '2 tot 3 jaar',
            '3 jaar of meer'],
  show_otherwise: true
}, {
  id: :v4,
  type: :radio,
  hidden: true,
  title: 'Ben je van plan om met een nieuwe opleiding te starten?',
  options: [
    'Ja',
    'Nee',
    'Weet ik nog niet'
  ],
  show_otherwise: false
}, {
  id: :v5,
  hidden: true,
  type: :range,
  title: 'Hoe zeker ben je ervan dat je jouw opleiding gaat afmaken?',
  labels: ['helemaal niet zeker', 'helemaal zeker']
}, {
  id: :v6,
  type: :checkbox,
  show_otherwise: false,
  title: 'Wat voor cijfer sta/stond je gemiddeld voor al je vakken samen?',
  tooltip: 'Een grove schatting is prima, het hoeft niet precies te kloppen.',
  options: [
    { title: 'Weet ik echt niet', hides_questions: %i[v6_1], shows_questions: %i[v6_2] }
  ]
}, {
  id: :v6_1,
  hidden: false,
  type: :range,
  min: 1,
  max: 10,
  step: 0.5,
  title: '',
  labels: %w[1 10]
}, {
  id: :v6_2,
  title: 'Kun je iets zeggen over hoe je ervoor staat/stond qua cijfers?',
  hidden: true,
  type: :range,
  labels: ['heel slecht', 'heel goed']
}, {
  id: :v11,
  title: 'Hoe vond jij het om ongeveer een half jaar lang de webapp wekelijks in te vullen?',
  type: :range,
  labels: ['heel moeilijk vol te houden', 'heel makkelijk vol te houden']
}, {
  id: :v12,
  title: 'Wat voor cijfer zou je de webapp geven?',
  type: :range,
  step: 0.5,
  min: 1,
  max: 10,
  labels: %w[1 10]
}, {
  id: :v13,
  title: 'Zou je jouw vrienden aanraden om ook mee te doen aan het u-can-act onderzoek?',
  type: :range,
  labels: ['nee, totaal niet', 'ja, zeker wel']
}, {
  id: :v14,
  type: :textarea,
  title: 'Heb je nog tips voor ons om het onderzoek of de webapp beter te maken in de toekomst?'
}, {
  section_start: '',
  type: :raw,
  content: '<p class="flow-text section-explanation">Klik op opslaan om je beloning te ontvangen.</p>'
}], scores: [] }
nameting1.title = 'Eindmeting'
nameting1.save!
