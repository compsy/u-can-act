# frozen_string_literal: true

db_title = 'Training log'

db_name1 = 'training_log'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Feedback op de trainingssessie</p><br><img src="/sport-data-valley/training_log_header.jpg" style="width:100%; max-width: 500px" class="questionnaire-image" />',
  },
  {
    id: :v1,
    title: 'Trainingtype',
    type: :dropdown,
    options: [
      'Badminton',
      'Basketbal',
      'Basketbal',
      'Boksen',
      'Dansen',
      'Fitness / Krachttraining',
      'Golf',
      'Gymnastiek',
      'Handbal',
      'Hardlopen',
      'Hiken',
      'Hockey',
      'Honkbal',
      'IJshockey',
      'Inline skaten',
      'Judo',
      'Karate',
      'Klimmen',
      'Korfbal',
      'Mountainbiken',
      'Paardrijden',
      'Powerliften / bodybuilding',
      'Roeien',
      'Rugby',
      'Schaatsen',
      'Shorttrack',
      'Softbal',
      'Squash',
      'Tennis',
      'Voetbal',
      'Volleybal',
      'Wielrennen',
      'Zeilen',
      'Zwemmen'
    ],
    required: true
  },
  {
    id: :v2,
    title: 'Sessietype',
    type: :dropdown,
    options: [
      'Extensieve duur',
      'Extensieve interval',
      'Extensieve tempo',
      'Herstel',
      'Intensieve duur',
      'Intensieve interval',
      'Intensieve tempo',
      'Kracht',
      'Skills',
      'Sprint',
      'Teamtraining',
      'Techniek',
      'Testen',
      'Vaartspel',
      'Wedstrijd',
      'Wedstrijdvoorbereiding'
    ],
    required: true
  },
  {
    id: :v3,
    type: :date,
    today: true,
    title: 'Begonnen om',
    required: true
  },
  {
    id: :v4,
    type: :time,
    title: '',
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: 'uur',
    minutes_label: 'minuten',
    required: true
  },
  {
    id: :v5,
    type: :number,
    required: true,
    title: 'Tijdsduur (min)',
    maxlength: 4,
    min: 0,
    max: 1440 # 24hrs
  },
  {
    id: :v6,
    title: 'RPE score<br><img src="/sport-data-valley/rpe.jpg" style="width:auto" class="questionnaire-image" />',
    type: :range,
    min: 0,
    max: 10,
    step: 1,
    labels: [
      '0. Rust',
      '1. Heel licht',
      '2. Licht',
      '3. Gemiddeld',
      '4. Pittig',
      '5. Zwaar',
      '6.',
      '7. Heel zwaar',
      '8.',
      '9. Heel, heel zwaar',
      '10. Maximaal'
    ]
  },
  {
    id: :v7,
    title: 'Tevredenheid over training',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: [
      'Totaal ontevreden',
      'Ontevreden',
      'Normaal',
      'Tevreden',
      'Totaal tevreden'
    ]
  },
  {
    id: :v8,
    type: :textarea,
    title: 'Opmerkingen',
    placeholder: 'Vul iets in (optioneel)'
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
