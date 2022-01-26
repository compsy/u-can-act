# frozen_string_literal: true

db_title = ''
db_name1 = 'intake_questionnaire_rheumatism'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Nu volgen enkele vragenlijsten die u maar één keer in hoeft te vullen. Het invullen hiervan kost ongeveer 40 minuten. Daarna ontvangt u dagelijks een vragenlijst die 2 minuten zal kosten.</p>',
  }, {
    id: :v1,
    type: :dropdown,
    title: 'Wat is uw geboortejaar?',
    options: (2005.downto(1910)).map(&:to_s)
  }, {
    id: :v2,
    type: :radio,
    title: 'Wat is uw geslacht?',
    options: %w[m v anders],
    show_otherwise: false
  }, {
    id: :v3,
    type: :dropdown,
    title: 'In welke provincie woont u?',
    options: [
      'Groningen',
      'Friesland (Fryslân)',
      'Drenthe',
      'Overijssel',
      'Flevoland',
      'Gelderland',
      'Utrecht',
      'Noord-Holland',
      'Zuid-Holland',
      'Zeeland',
      'Noord-Brabant',
      'Limburg'
    ]
  }, {
    id: :v4,
    type: :radio,
    title: 'Wat is uw hoogst behaalde diploma?',
    options: [
      'Geen',
      'Lagere school/basisonderwijs',
      'MAVO/MULO/huishoudschool/VBO',
      'HAVO/HBS',
      'VWO/atheneum/gymnasium',
      'MBO/MTS/MEAO',
      'HBO/HEAO',
      'WO of doctoraal'
    ]
  }, {
    id: :v5,
    type: :number,
    title: 'In welk jaar kreeg u de diagnose reumatoïde artritis?',
    maxlength: 4,
    placeholder: 'Vul een jaartal in',
    min: 1921,
    max: 2021,
    required: true
  }, {
    id: :v6,
    type: :textarea,
    title: 'Welke behandeling ontvangt u op dit moment voor uw reumatoïde artritis? (Denk hierbij aan type medicatie, fysiotherapie, revalidatie, etc)',
    required: true
  }, {
    id: :v7,
    type: :radio,
    title: 'Mijn medicatie is in het afgelopen jaar',
    options: ['gelijk gebleven'],
    show_otherwise: true,
    otherwise_label: 'veranderd<br />Indien veranderd: Wat is er veranderd qua dosis en soort medicatie?',
    otherwise_placeholder: 'Vul iets in'
  }, {
    id: :v8,
    type: :checkbox,
    title: 'In welke gewrichten heeft u afgelopen week voornamelijk ontstekingen ervaren? <em>Meedere antwoorden mogelijk</em>',
    options: [
      'Voornamelijk in de handen, polsen, ellebogen of schouders',
      'Voornamelijk in de voeten, enkels, knieën of heupen',
      'Voornamelijk in de nek of wervelkolom',
      'Geen'
    ],
    show_otherwise: false,
    required: true
  }, {
    id: :v9,
    type: :textarea,
    title: 'Heeft u naast reumatoïde artritis andere aandoeningen (gehad) die volgens u invloed hebben op uw vermoeidheid op dit moment?',
    required: true
  }, {
    id: :v10,
    type: :textarea,
    title: 'Heeft u verdere opmerkingen?',
    required: false
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
