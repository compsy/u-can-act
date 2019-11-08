# frozen_string_literal: true

db_title = 'Rating of perceived exertion (RPE) vragenlijst'

db_name1 = 'rpe'
questionnaire = Questionnaire.find_by_name(db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

# TODO: Add the correct heatmap here.
dagboek_content = [
  {
    id: :v1,
    title: 'Hoe was je workout?',
    type: :radio,
    options: [
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
  }
]
questionnaire.content = dagboek_content
questionnaire.title = db_title
questionnaire.save!
