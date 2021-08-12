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
    type: :radio,
    title: 'Heb je de afgelopen 7 dagen hinder ondervonden van <strong>fysieke klachten</strong> tijdens het sporten?',
    tooltip: 'De volgende vragen gaan over mogelijke klachten die je hebt ondervonden tijdens het sporten. Onder sporten verstaan wij praktijklessen, trainingen en wedstrijden.',
    options: [
      { title: 'Ja', shows_questions: %i[v_o_2], numeric_value: 1, tooltip: 'Let op: de klachten betreffen alleen blessures / klachten aan het bewegingsapparaat. Denk hierbij aan een overbelaste spier, kneuzing, hersenschudding etc.' },
      { title: 'Nee, ik heb volledig deelgenomen zonder klachten aan mijn lichaam', numeric_value: 0 }
    ],
    show_otherwise: false
  },
  {
    id: :v_o_2,
    hidden: true,
    type: :checkbox,
    title: 'In welke regio vond(en) de klacht(en) plaats?',
    options: Complaints::all_complaint_options(true),
    show_otherwise: false,
    required: true
  },
  *Complaints::all_complaint_questions(true),
  {
    id: :v_o_3,
    type: :number,
    title: 'Hoeveel uur heb je de afgelopen week gesport?',
    required: true,
    maxlength: 3,
    min: 0,
    max: 100
  },
]

questionnaire.content = {
  questions: dagboek_content,
  scores: Complaints::all_complaint_scores(true)
}
questionnaire.title = db_title
questionnaire.save!
