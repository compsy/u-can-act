# frozen_string_literal: true

db_title = ''

db_name1 = 'ostrc_o'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

require File.expand_path('../questionnaire_helpers/complaints.rb', __dir__)

dagboek_content = [
  {
    id: :v_o_1,
    type: :number,
    title: 'Hoeveel uur heb je de afgelopen week gesport?',
    required: true,
    maxlength: 3,
    min: 0,
    max: 100
  },
  {
    id: :v_o_2,
    type: :radio,
    title: 'Heb je de afgelopen 7 dagen hinder ondervonden van <strong>klachten aan het lichaam</strong> tijdens trainingen en/of wedstrijden?',
    tooltip: 'De volgende vragen gaan over mogelijke klachten die je hebt ondervonden tijdens het sporten. Onder sporten verstaan wij trainingen, wedstrijden en fysieke lessen. Let op de klachten betreffen alleen klachten aan het musculaire stelsel. Denk hierbij aan een overbelaste spier, kneuzing, hersenschudding etc.',
    options: [
      { title: 'Ja', shows_questions: %i[v_o_3], numeric_value: 1 },
      { title: 'Nee, ik heb volledig deelgenomen zonder klachten aan het lichaam', numeric_value: 0 }
    ],
    show_otherwise: false
  },
  {
    id: :v_o_3,
    hidden: true,
    type: :checkbox,
    title: 'In welke regio vond(en) de klacht(en) plaats?',
    options: Complaints::all_complaint_options,
    show_otherwise: false,
    required: true
  },
  *Complaints::all_complaint_questions
]

questionnaire.content = {
  questions: dagboek_content,
  scores: [
    { id: :s_o_1, # O-score(?)
      label: 'O-score',
      ids: %i[v_o_2],
      operation: :average,
      round_to_decimals: 0
    }
  ]
}
questionnaire.title = db_title
questionnaire.save!
