# frozen_string_literal: true

db_title = 'u-can-act Studenten'

db_name1 = 'dagboek studenten'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek_content = [{
  type: :raw,
  content: 'Vragenlijst dagboek studenten'
  }]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
