# frozen_string_literal: true

db_title = 'Omgang met anderen'

db_name1 = 'Interpersoonlijk gedrag jongeren16plus'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
likert_options = ['Helemaal niet', 'Matig', 'Heel sterk']
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Met deze vragenlijst onderzoek je hoe je omgaat met andere mensen. Het invullen kost je minder dan 10 minuten.</p>'
  }, {
    id: :v1,
    type: :range,
    title: 'Hoe gelukkig ben je?',
    labels: ['Helemaal niet gelukkig', 'Matig gelukkig', 'Heel erg gelukkig'],
    required: true
  }, {
    section_start: 'De onderstaande punten zijn dingen die moeilijk kunt vinden in het contact met anderen. Kies bij elke vraag het antwoord dat het beste bij je past. <br><br>
  <em>Het is moeilijk voor mij om…</em>',
    id: :v2,
    type: :likert,
    title: '“Nee” te zeggen tegen andere mensen',
    options: likert_options,
    section_end: false
  }, {
    id: :v3,
    type: :likert,
    title: 'Mee te doen met een groep',
    options: likert_options
  }, {
    id: :v4,
    type: :likert,
    title: 'Dingen voor mezelf te houden',
    options: likert_options

  }, {
    id: :v5,
    type: :likert,
    title: 'Iemand te zeggen dat hij/zij moet stoppen met me lastig te vallen',
    options: likert_options
  }, {
    id: :v6,
    type: :likert,
    title: 'Mezelf voor te stellen aan nieuwe mensen',
    options: likert_options
  }, {
    id: :v7,
    type: :likert,
    title: 'Andere mensen te wijzen op problemen die zich voordoen',
    options: likert_options
  }, {
    id: :v8,
    type: :likert,
    title: 'Me assertief en zelfbewust op te stellen tegenover iemand anders',
    options: likert_options
  }, {
    id: :v9,
    type: :likert,
    title: 'Anderen duidelijk te maken dat ik kwaad ben',
    options: likert_options
  }, {
    id: :v10,
    type: :likert,
    title: 'Sociaal en gezellig om te gaan met anderen',
    options: likert_options
  }, {
    id: :v11,
    type: :likert,
    title: 'Genegenheid te tonen aan mensen',
    options: likert_options
  }, {
    id: :v12,
    type: :likert,
    title: 'Op te schieten met mensen',
    options: likert_options
  }, {
    id: :v13,
    type: :likert,
    title: 'Vastberaden te zijn als dit nodig is',
    options: likert_options
  }, {
    id: :v14,
    type: :likert,
    title: 'Een gevoel van liefde te ervaren voor iemand anders',
    options: likert_options
  }, {
    id: :v15,
    type: :likert,
    title: 'Iemand anders te ondersteunen in zijn/haar doelen in het leven',
    options: likert_options
  }, {
    id: :v16,
    type: :likert,
    title: 'Een gevoel van hechte verbondenheid te voelen ten aanzien van andere mensen',
    options: likert_options
  }, {
    id: :v17,
    type: :likert,
    title: 'Echt te geven om de problemen van anderen',
    options: likert_options
  }, {
    id: :v18,
    type: :likert,
    title: 'De noden van iemand anders te laten voorgaan op de mijne',
    options: likert_options
  }, {
    id: :v19,
    type: :likert,
    title: 'Me goed te voelen om het geluk van een ander',
    options: likert_options
  }, {
    id: :v20,
    type: :likert,
    title: 'Andere mensen uit te nodigen voor een gezellig samenzijn met mij',
    options: likert_options
  }, {
    id: :v21,
    type: :likert,
    title: 'Assertief te zijn zonder bezorgd te zijn dat ik andermans gevoelens zou kwetsen',
    options: likert_options,
    section_end: true
  }, {
    section_start: 'De volgende punten gaan over dingen die je teveel kunt doen. Kies bij elke vraag het antwoord dat het beste bij je past:',
    id: :v22,
    type: :likert,
    title: 'Ik geef mezelf te veel bloot aan anderen',
    options: likert_options,
    section_end: false
  }, {
    id: :v23,
    type: :likert,
    title: 'Ik ben te agressief naar andere mensen',
    options: likert_options
  }, {
    id: :v24,
    type: :likert,
    title: 'Ik probeer andere mensen te veel te behagen',
    options: likert_options
  }, {
    id: :v25,
    type: :likert,
    title: 'Ik wil te veel opvallen',
    options: likert_options
  }, {
    id: :v26,
    type: :likert,
    title: 'Ik probeer andere mensen te veel te controleren',
    options: likert_options
  }, {
    id: :v27,
    type: :likert,
    title: 'Ik stel de noden van andere mensen boven de mijne',
    options: likert_options
  }, {
    id: :v28,
    type: :likert,
    title: 'Ik ben al te vrijgevig naar andere mensen toe',
    options: likert_options
  }, {
    id: :v29,
    type: :likert,
    title: 'Ik manipuleer andere mensen te veel om mijn zin te krijgen',
    options: likert_options
  }, {
    id: :v30,
    type: :likert,
    title: 'Ik vertel te veel persoonlijke zaken aan andere mensen',
    options: likert_options
  }, {
    id: :v31,
    type: :likert,
    title: 'Ik ga te veel in discussie met andere mensen',
    options: likert_options
  }, {
    id: :v32,
    type: :likert,
    title: 'Ik laat andere mensen te veel van mij profiteren',
    options: likert_options
  }, {
    id: :v33,
    type: :likert,
    title: 'Ik word te veel emotioneel getroffen door het leed van een ander',
    options: likert_options,
    section_end: true
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
