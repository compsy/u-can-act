# frozen_string_literal: true

nm_name1 = 'nameting studenten'
nameting1 = Questionnaire.find_by_name(nm_name1)
nameting1 ||= Questionnaire.new(name: nm_name1)
nameting1.key = File.basename(__FILE__)[0...-3]
nameting1.content = [{
  id: :v1,
  type: :radio,
  title: 'Ben je definitief gestopt met je opleding (zonder diploma)?',
  options: [
    { title: 'Ja', shows_questions: %i[v2 v3 v4] },
    'Nee'
  ],
  show_otherwise: false
}, {
  id: :v2,
  hidden: true,
  type: :textfield,
  required: true,
  title: 'Wanneer ben je ongeveer gestopt? Als je het niet precies meer weet, vul dan iets in dat zo goed mogelijk in de buurt komt'
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
  labels: ['Helemaal niet', 'helemaal wel']
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
  labels: ['Heel slecht', 'heel goed']
}, {
  id: :v7,
  type: :radio,
  title: 'Zie jij de begeleiding van {{je_begeleidingsinitiatief}} als onderdeel van de school, of vind jij dat de begeleiding van {{je_begeleidingsinitiatief}} los staat van de school?',
  options: [
    'Onderdeel van school',
    'Los van school'
  ],
  show_otherwise: false
}, {
  id: :v8,
  type: :textarea,
  title: 'Hoe zou je de begeleiding die je van {{je_begeleidingsinitiatief}} hebt gekregen beschrijven, in één woord?'
}, {
  id: :v9,
  title: 'Hoe nuttig vond jij de begeleiding die je hebt gekregen van {{je_begeleidingsinitiatief}}?',
  hidden: true,
  type: :range,
  labels: ['Helemaal niet nuttig', 'heel erg nuttig']
}, {
  id: :v10,
  type: :radio,
  title: 'Wil je je eigen data niet-anoniem delen met {{naam_begeleider}}, zodat hij/zij ervan kan leren? <strong>Als je nee aanvinkt blijft je data compleet anoniem!</strong>',
  options: [
    'Ja',
    'Nee'
  ],
  show_otherwise: false
}, {
  id: :v11,
  title: 'Hoe moeilijk was het om zo lang elke week de app in te vullen?',
  type: :range,
  labels: ['Heel moeilijk', 'heel makkelijk']
}, {
  id: :v12,
  title: 'Wat voor cijfer zou je de app geven?',
  type: :range,
  step: 0.5,
  min: 1,
  max: 10,
  labels: ['1', '10']
}, {
  id: :v13,
  title: 'In hoeverre zou je vrienden aanraden om ook mee te doen aan het u-can-act onderzoek?',
  type: :range,
  labels: ['Helemaal niet', 'helemaal wel']
}, {
  id: :v8,
  type: :textarea,
  title: 'Heb je nog tips voor ons om het onderzoek of de app beter te maken in de toekomst?'
}, {
  section_start: '',
  type: :raw,
  content: '<p class="flow-text section-explanation">Ga naar de laatste pagina om je beloning te ontvangen.</p>'
} ]
nameting1.title = 'Eindmeting'
nameting1.save!
