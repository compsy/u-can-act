# frozen_string_literal: true
db_title = 'Demo vragenlijst' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'demo'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [{
  id: :v1, # 1
  type: :radio,
  show_otherwise: false,
  title: 'Voorbeeld vraag van een radio',
  options: [
    { title: 'Ja', shows_questions: %i[v2] },
    { title: 'Nee', shows_questions: %i[v2] }
  ]
}, {
  id: :v2,
  hidden: true,
  type: :range,
  title: 'Voorbeeld vraag met ranges',
  labels: [ 'heel weinig', 'heel veel' ]
}, {
  id: :v3,
  type: :time,
  hours_from: 0,
  hours_to: 11,
  hours_step: 1,
  title: 'Voorbeeld van een tijd vraag',
  section_start: 'Overige vragen'
}, {
  id: :v4,
  type: :date,
  title: 'Voorbeeld van een datum vraag',
  labels: ['helemaal intuïtief ', 'helemaal gepland']
}, {
  id: :v5,
  type: :textarea,
  title: 'Voorbeeld van een vrij text veld'
}, {
    id: :v6,
    type: :checkbox,
    required: true,
    title: 'Voorbeeld van een checkbox vraag',
    options: [
      {title: 'Antwoord 1', tooltip: 'Tooltip 1'},
      {title: 'Antwoord 2', tooltip: 'Tooltip 2'},
      {title: 'Antwoord 3', tooltip: 'Tooltip 3'}
    ]
}, {
  id: :v7,
  type: :likert,
  title: 'Wat vind u van deze stelling?',
  tooltip: 'some tooltip',
  options: ['helemaal oneens', 'oneens', 'neutraal', 'eens', 'helemaal eens'],
}]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
