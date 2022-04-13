# frozen_string_literal: true

db_title = ''
db_name1 = 'language_questionnaire'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

dagboek_content = [
  {
    id: :v0,
    type: :radio,
    required: true,
    title: 'Taal | Language',
    options: %w[Nederlands English],
    show_otherwise: false
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
