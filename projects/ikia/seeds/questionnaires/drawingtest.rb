# frozen_string_literal: true

db_title = '' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'drawingtest'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [
  {
    section_start: '<strong>De volgende vragen gaan over hoe je je op dit moment voelt.</strong>',
    id: :v1,
    type: :textfield,
    title: 'Ik voel me op dit moment...'
  }, {
    id: :v2,
    type: :radio,
    show_otherwise: false,
    title: 'Merk je dit gevoel ook in je lichaam?',
    options: [
      {title: 'Ja', shows_questions: %i[v3 v4]},
      {title: 'Nee'}
    ]
  }, {
    id: :v3,
    type: :drawing,
    title: 'Kleur de plekken in je lichaam waar je merkt dat het sterker wordt',
    width: 240,
    height: 536,
    image: 'bodymap.png',
    color: '#e57373'
  }, {
    id: :v4,
    type: :drawing,
    title: 'Kleur de plekken in je lichaam waar je merkt dat het zwakker wordt',
    width: 240,
    height: 536,
    image: 'bodymap.png',
    color: '#64b5f6'
  }
]

dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
