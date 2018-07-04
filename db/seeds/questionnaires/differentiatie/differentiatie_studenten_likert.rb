# frozen_string_literal: true
db_title = '' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'differentiatie studenten likert'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [{
  section_start: 'Dagboek',
  type: :raw,
  content: '<p class="flow-text section-explanation">Denk aan de afgelopen les. Geef voor elke uitspraak aan in welke mate de uitspraak waar is voor jou.</p>'
}, {
  section_start: "Tijdens de afgelopen les…",
  id: :v1,
  title: "… was ik enthousiast.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v2,
  title: "… was ik blij.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v3,
  title: "… voelde ik me fijn.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v4,
  title: "… had ik keuze en vrijheid in de dingen die ik deed.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v5,
  title: "… had ik er vertrouwen in dat ik mijn werk goed kon doen.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v6,
  title: "… pasten de keuzes die ik maakte bij wat ik echt graag wilde.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v7,
  title: "… kon ik goed opschieten met de docent.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v8,
  title: "… kon ik goed opschieten met mijn klasgenoten.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v9,
  title: "… was ik goed in wat ik deed.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v10,
  title: "… had ik een goed gevoel bij de docent.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v11,
  title: "… had ik een goed gevoel bij mijn klasgenoten.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v12,
  title: "… kon ik mijn aandacht er niet bij houden.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v13,
  title: "… bedacht ik me hoe leuk ik het vond.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  section_start: "Ik vond de afgelopen les…",
  id: :v14,
  title: "… leuk.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v15,
  title: "… plezierig.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v16,
  title: "… saai.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v17,
  title: "… interessant.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v18,
  title: "… vervelend.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  section_start: "Tijdens afgelopen les…",
  id: :v19,
  title: "… gaf de docent mij het gevoel dat ik dingen goed kon.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v20,
  title: "… luisterde de docent naar hoe ik dingen wilde aanpakken.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v21,
  title: "… moedigde de docent mij aan samen te werken met klasgenoten.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
},
{
  id: :v22,
  title: "… had ik het gevoel dat de docent er voor mij was.",
  type: :likert,
  options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
}]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!




