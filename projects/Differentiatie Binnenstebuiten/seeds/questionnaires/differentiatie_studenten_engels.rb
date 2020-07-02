# frozen_string_literal: true
db_title = '' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'Differentiatie Binnenstebuiten Scholieren Engels'
dagboek1 = Questionnaire.find_by(name: db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [{
  section_start: 'Dagboek Engels',
  type: :raw,
  content: '<p class="flow-text section-explanation">Hoi! Fijn dat je het dagboek weer invult &#x263a; Denk bij het invullen aan afgelopen les. Geef voor elke uitspraak aan in welke mate de uitspraak waar is voor jou. Je kunt kiezen uit een score van 0 tot 100.</p>'
}, {
  section_start: "Tijdens de afgelopen les…",
  id: :v1,
  title: "… was ik enthousiast.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v2,
  title: "… was ik blij.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v3,
  title: "… voelde ik me fijn.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v4,
  title: "… had ik keuze en vrijheid in de dingen die ik deed.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v5,
  title: "… had ik er vertrouwen in dat ik mijn werk goed kon doen.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v6,
  title: "… pasten de keuzes die ik maakte bij wat ik echt graag wilde.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v7,
  title: "… kon ik goed opschieten met de docent.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v8,
  title: "… kon ik goed opschieten met mijn klasgenoten.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v9,
  title: "… was ik goed in wat ik deed.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v10,
  title: "… had ik een goed gevoel bij de docent.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v11,
  title: "… had ik een goed gevoel bij mijn klasgenoten.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v12,
  title: "… kon ik mijn aandacht er niet bij houden.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v13,
  title: "… bedacht ik me hoe leuk ik het vond.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  section_start: "Ik vond de afgelopen les…",
  id: :v14,
  title: "… leuk.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v15,
  title: "… plezierig.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v16,
  title: "… saai.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v17,
  title: "… interessant.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v18,
  title: "… vervelend.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  section_start: "Tijdens afgelopen les…",
  id: :v19,
  title: "… gaf de docent mij het gevoel dat ik dingen goed kon.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v20,
  title: "… luisterde de docent naar hoe ik dingen wilde aanpakken.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v21,
  title: "… moedigde de docent mij aan samen te werken met klasgenoten.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  id: :v22,
  title: "… had ik het gevoel dat de docent er voor mij was.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar']
},
{
  section_start: 'Laatste dagboek',
  type: :raw,
  content: '<p class="flow-text section-explanation">De laatste vragen gaan niet over de afgelopen les, maar over de lessen op school in het algemeen.  Geef voor elke uitspraak aan in welke mate de uitspraak waar is voor jou.</p>',
  show_after: :only_on_final_questionnaire
},
{
  section_start: "Ik vind het belangrijk dat…",
  id: :v23,
  title: "… ik het gevoel heb dat ik de dingen op school goed kan.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar'],
  show_after: :only_on_final_questionnaire
},
{
  id: :v24,
  title: "… ik keuze en vrijheid heb ik de dingen die ik op school doe.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar'],
  show_after: :only_on_final_questionnaire
},
{
  id: :v25,
  title: "… ik goed met de docent op kan schieten.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar'],
  show_after: :only_on_final_questionnaire
}, {
  id: :v26,
  title: "… ik goed met mijn klasgenoten op kan schieten.",
  type: :range,
  labels: ['helemaal niet waar', 'helemaal waar'],
  show_after: :only_on_final_questionnaire
}]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!




