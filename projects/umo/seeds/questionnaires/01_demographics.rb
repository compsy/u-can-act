# frozen_string_literal: true

db_title = ''
db_name1 = 'demographics'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

WERKADRES_QUESTIONS = %i[v8_a]
POSTCODE_WERK_QUESTIONS = %i[v8_b_a v8_b_b v8_b_c]

dagboek_content = [
  {
    id: :v1,
    type: :textfield,
    title: 'Wat is uw naam?',
    required: true
  }, {
    id: :v2,
    type: :radio,
    title: 'Wat is uw geslacht?',
    required: true,
    show_otherwise: false,
    options: ['Man', 'Vrouw', 'Anders', 'Zeg ik liever niet']
  }, {
    id: :v3,
    type: :number,
    title: 'In welk jaar bent u geboren?',
    min: 1900,
    max: 2030,
    required: true,
    maxlength: 4
  }, {
    type: :raw,
    content: '<p class="flow-text">Om eventuele verhuizingen van mensen bij te houden, willen wij graag uw woonadres en/of postcode weten. Wilt u hieronder uw adres en/of postcode invullen? Uw adresgegevens zullen nooit gedeeld worden met mensen buiten het onderzoeksteam.</p>'
  }, {
    id: :v4_a,
    type: :textfield,
    title: 'Straat',
    required: false
  }, {
    id: :v4_b,
    type: :number,
    title: 'Huisnummer',
    required: false
  }, {
    id: :v4_c,
    type: :textfield,
    title: 'Postcode',
    required: true
  }, {
    id: :v5,
    type: :dropdown,
    title: 'Wat is uw hoogst voltooide opleiding?',
    options: [
      'Geen opleiding',
      'Basisschool',
      'Middelbare school',
      'Middelbaar beroepsonderwijs (MBO)',
      'Hoger beroepsonderwijs (HBO)',
      'Universiteit (WO)',
      'Anders'
    ],
    required: true
  }, {
    id: :v6,
    type: :dropdown,
    title: 'Wat is uw voornaamste dagelijkse bezigheid?',
    options: [
      { title: 'Student/scholier', shows_questions: WERKADRES_QUESTIONS + POSTCODE_WERK_QUESTIONS },
      { title: 'Zelfstandig ondernemer', shows_questions: WERKADRES_QUESTIONS + POSTCODE_WERK_QUESTIONS },
      { title: 'Werkzaam in loondienst', shows_questions: WERKADRES_QUESTIONS + POSTCODE_WERK_QUESTIONS },
      { title: 'Vrijwilligerswerk', shows_questions: WERKADRES_QUESTIONS },
      'De zorg voor gezin',
      'Geen werk',
      'Anders'
    ],
    required: true
  }, {
    id: :v7,
    type: :radio,
    title: 'Wat is uw netto maandelijks huishoudensinkomen?',
    required: true,
    show_otherwise: false,
    options: [
      'Minder dan 980€',
      'Tussen 980€ en 1870€',
      'Tussen 1870€ en 2680€',
      'Tussen 2680€ en 3800€',
      'Tussen 3800€ en 5460€',
      'Meer dan 5460€',
      'Weet ik niet/zeg ik liever niet'
    ]
  }, {
    id: :v8_a,
    hidden: true,
    type: :radio,
    title: 'Wat is het meest op u van toepassing (in een situatie zonder corona pandemie)?',
    required: true,
    show_otherwise: false,
    options: [
      'Ik werk/studeer altijd op een vast adres (anders dan thuis)',
      'Ik werk/studeer meestal op een vast adres (anders dan thuis)',
      { title: 'Ik werk/studeer altijd thuis', hides_questions: POSTCODE_WERK_QUESTIONS },
      { title: 'Ik werk/studeer op verschillende adressen', hides_questions: POSTCODE_WERK_QUESTIONS }
    ]
  }, {
    id: :v8_b_a,
    hidden: true,
    type: :textfield,
    title: 'Straat',
    required: false
  }, {
    id: :v8_b_b,
    hidden: true,
    type: :number,
    title: 'Huisnummer',
    required: false
  }, {
    id: :v8_b_c,
    hidden: true,
    type: :textfield,
    title: 'Postcode',
    required: true
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
