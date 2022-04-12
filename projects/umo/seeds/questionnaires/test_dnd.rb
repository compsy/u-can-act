# frozen_string_literal: true

db_title = 'test dnd'
db_name1 = 'test dnd'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

OV_ABONNEMENT_QUESTIONS = %i[v39]

dagboek_content = [
  {
    id: 1,
    type: :radio,
    title: '1',
    options: %w[Ja Nee],
    required: true,
    show_otherwise: false
  },
  {
    id: 2,
    type: :radio,
    title: '2',
    options: %w[Ja Nee],
    required: true,
    show_otherwise: false
  },
  {
    id: 3,
    type: :radio,
    title: '3',
    options: %w[Ja Nee],
    required: true,
    show_otherwise: false
  },
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
