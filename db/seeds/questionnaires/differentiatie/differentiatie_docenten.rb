# frozen_string_literal: true
db_title = '' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'differentiatie mentoren'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [{
  section_start: 'Dagboek docenten',
  type: :raw,
  content: '<p class="flow-text section-explanation">Denk aan de afgelopen les. Geef voor elke uitspraak aan in welke mate de uitspraak waar is voor jou.</p>'
}, {
  section_start: "Tijdens de afgelopen les…",
  id: :v1,
  title: "… was ik enthousiast.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
}, {
  section_start: "Tijdens de afgelopen les…",
  id: :v1,
  uses: {
    previous: :v1
  }
  title: "{{previous_v1|de vorige meting}} gedaan?",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
}]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!




