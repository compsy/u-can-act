# frozen_string_literal: true

db_title = ''
db_name1 = 'intake_questionnaire_rheumatism'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

EMAIL_REGEX_RHEUMATISM = '^[^@\s]+@[^@\s]+$'

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Nu volgen enkele vragenlijsten die u maar één keer in hoeft te vullen. Het invullen hiervan kost ongeveer 15 tot 20 minuten. Daarna ontvangt u dagelijks een vragenlijst die 2 minuten zal kosten.</p>'
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
    otherwise_label: 'veranderd<br />Indien veranderd: wat is er veranderd qua dosis en soort medicatie?',
    otherwise_placeholder: 'Vul iets in'
  }, {
    id: :v8a,
    type: :radio,
    title: 'Heeft u ontstekingen in uw gewrichten?',
    options: [
      { title: 'ja', shows_questions: %i[v8] },
      'nee'
    ],
    show_otherwise: false
  }, {
    id: :v8,
    hidden: true,
    type: :checkbox,
    title: 'In welke gewrichten heeft u voornamelijk ontstekingen? <em>Meerdere antwoorden mogelijk</em>',
    options: [
      'Voornamelijk in de handen, polsen, ellebogen of schouders',
      'Voornamelijk in de voeten, enkels, knieën of heupen',
      'Voornamelijk in de nek of wervelkolom',
    ],
    show_otherwise: false,
    required: true
  }, {
    id: :v9a,
    type: :radio,
    title: 'Heeft u naast reumatoïde artritis andere aandoeningen (gehad) die volgens u invloed hebben op uw vermoeidheid op dit moment?',
    options: [
      { title: 'ja', shows_questions: %i[v9] },
      'nee'
    ],
    show_otherwise: false
  }, {
    id: :v9,
    hidden: true,
    type: :textarea,
    title: 'Zo ja, welke?',
    required: true
  }, {
    id: :v10,
    type: :textarea,
    title: 'Heeft u verdere opmerkingen?',
    required: false
  }, {
    id: :v11,
    type: :checkbox,
    title: '[optioneel] Mogen wij u benaderen voor één of meerdere van onderstaande opties?',
    options: [
      { title: 'Ja, ik ontvang graag een samenvatting van de resultaten van dit onderzoek.', shows_questions: %i[v12] },
      { title: 'Ja, ik vind het goed als de onderzoekers contact met mij opnemen als daar noodzaak voor is (bijvoorbeeld als het invullen van de vragenlijsten niet goed gaat).', shows_questions: %i[v12] },
      { title: 'Ja, ik vind het goed om benaderd te worden voor vervolgonderzoek. (Wij sturen u in de toekomst eventueel informatie over nieuw onderzoek. U kunt op dat moment zelf beslissen of u wel of niet mee wilt werken aan dat onderzoek.)', shows_questions: %i[v12] }
    ],
    show_otherwise: false,
    required: false
  }, {
    id: :v12,
    hidden: true,
    type: :textfield,
    title: 'Zo ja, vul hier uw emailadres in. Uw emailadres wordt alléén gebruikt voor de opties die u hierboven hebt aangegeven. De antwoorden op de vragenlijst worden niet gekoppeld aan uw emailadres.',
    pattern: EMAIL_REGEX_RHEUMATISM,
    placeholder: 'Vul uw e-mailadres in',
    hint: 'Vul a.u.b. een geldig e-mailadres in.',
    required: true
  }, {
    type: :raw,
    content: '<p class="flow-text">Klik hieronder op \'Opslaan\' om de antwoorden in te leveren en door te gaan naar de volgende vragenlijst.</p>'
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
