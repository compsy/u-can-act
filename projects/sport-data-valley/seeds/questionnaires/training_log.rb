# frozen_string_literal: true

db_title = 'Training log'

db_name1 = 'training_log'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Feedback op de trainingssessie</p>'
  },
  {
    id: :v1,
    title: 'Trainingtype',
    type: :dropdown,
    options: %w[hardlopen fietsen kracht MTB],
    required: true
  },
  {
    id: :v2,
    title: 'Sessietype',
    type: :dropdown,
    options: [
      'herstel',
      'ext uithoudingsvermogen',
      'int uithoudingsvermogen',
      'ext interval',
      'int interval',
      'ext tempo',
      'int tempo',
      'fartlek',
      'anders'
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
    type: :number,
    required: true,
    title: 'Looptijd (min)',
    maxlength: 3,
    min: 0,
    max: 400
  },
  {
    id: :v5,
    title: 'RPE score<br><img src="/images/rpe.jpg" class="questionnaire-image" />',
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
    id: :v6,
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
  }

]

questionnaire.content = dagboek_content
questionnaire.title = db_title
questionnaire.save!
