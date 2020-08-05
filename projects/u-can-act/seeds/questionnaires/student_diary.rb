# frozen_string_literal: true

db_title = '' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'dagboek studenten'
dagboek1 = Questionnaire.find_by(name: db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [{
  type: :unsubscribe,
  title: 'Klaar met dit schooljaar?',
  content: 'Ben je klaar met dit schooljaar? Klik dan op de knop \'Onderzoek afronden\' om het onderzoek te voltooien. Zo nee, vul dan gewoon de onderstaande vragenlijst in.',
  button_text: 'Onderzoek afronden',
  show_after: (Rails.env.development? ? 1.second.ago : Time.new(2018, 6, 27).in_time_zone)
}, {
  section_start: 'School en Stage',
  type: :raw,
  content: '<p class="flow-text section-explanation">De volgende vragen gaan over school en stage. Je antwoorden zijn helemaal anoniem.</p>'
}, {
  id: :v1,
  type: :radio,
  title: 'Ben je de afgelopen week naar school en/of stage geweest?',
  options: [
    { title: 'Ja', shows_questions: %i[v2 v3 v4 v5 v6] },
    'Nee'
  ],
  show_otherwise: false
}, {
  id: :v2,
  hidden: true,
  type: :range,
  title: 'Wat heb je de afgelopen week <strong>meegemaakt op school en/of stage</strong>?',
  tooltip: 'Neem hierbij een paar ervaringen in gedachten die voor jou belangrijk waren.',
  labels: ['vooral nare dingen', 'vooral leuke dingen']
}, {
  id: :v3,
  hidden: true,
  type: :range,
  title: 'Heb je afgelopen week meestal <strong>dingen op school en/of stage gedaan omdat</strong> je het moest of omdat je het zelf wilde?',
  tooltip: 'Neem hierbij een paar ervaringen in gedachten die voor jou belangrijk waren.',
  labels: ['omdat ik moest', 'omdat ik het zelf wilde']
}, {
  id: :v4,
  hidden: true,
  type: :range,
  title: '<strong>Hoe goed heb je dingen gedaan op school en/of stage</strong> afgelopen week?',
  tooltip: 'Neem hierbij een paar ervaringen in gedachten die voor jou belangrijk waren.',
  labels: ['heel slecht', 'heel goed']
}, {
  id: :v5,
  hidden: true,
  type: :range,
  title: 'Kon je afgelopen week goed <strong>opschieten met vrienden op school en/of stage</strong>?',
  tooltip: 'Neem hierbij een paar ervaringen met vrienden in gedachten die voor jou belangrijk waren.',
  labels: ['heel slecht', 'heel goed']
}, {
  id: :v6,
  hidden: true,
  type: :range,
  title: 'Kon je afgelopen week goed <strong>opschieten met leraren op school en/of begeleiders op stage</strong>?',
  tooltip: 'Neem hierbij een paar ervaringen met leraren (of leidinggevenden op stage) in gedachten die voor jou belangrijk waren.',
  labels: ['heel slecht', 'heel goed']
}, {
  id: :v7,
  type: :range,
  title: '<strong>Hoeveel tijd</strong> heb je afgelopen week besteed aan school, stage en huiswerk bij elkaar?',
  tooltip: 'Een grove gok is prima, het is niet erg als je er een paar uur naast zit.',
  labels: ['0 uur', '40 uur of meer'],
  max: 40
}, {
  id: :v8,
  type: :range,
  title: 'Was dit <strong>genoeg tijd</strong> om goed te presteren op school?',
  labels: ['niet genoeg tijd', 'te veel tijd']
}, {
  id: :v9,
  type: :range,
  title: 'Ben je op dit moment blij met je <strong>keuze voor deze opleiding</strong>?',
  labels: ['niet blij met keuze', 'heel blij met keuze']
}, {
  id: :v10,
  type: :range,
  title: 'Vind je op dit moment dat je <strong>opleiding</strong> bij je past?',
  labels: ['past niet goed', 'past heel goed']
}, {
  id: :v11,
  type: :range,
  title: 'Heb je er op dit moment vertrouwen in dat je dit <strong>schooljaar gaat halen</strong>?',
  labels: ['geen vertrouwen', 'veel vertrouwen'],
  section_end: true
}, {
  section_start: 'Buiten School',
  type: :raw,
  content: '<p class="flow-text section-explanation">De volgende vragen gaan over de tijd die je besteedt buiten school. Je antwoorden zijn helemaal anoniem.</p>'
}, {
  id: :v12,
  type: :range,
  title: 'Wat heb je de afgelopen week <strong>meegemaakt buiten school</strong>?',
  tooltip: 'Neem hierbij een paar ervaringen in gedachten die voor jou belangrijk waren.',
  labels: ['vooral nare dingen', 'vooral leuke dingen']
}, {
  id: :v13,
  type: :checkbox,
  title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken? Je mag meerdere antwoorden geven.',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
}, {
  id: :v14,
  type: :range,
  title: 'Heb je afgelopen week de meeste <strong>dingen buiten school gedaan omdat</strong> je het moest of omdat je het zelf wilde?',
  tooltip: 'Neem hierbij een paar ervaringen in gedachten die voor jou belangrijk waren.',
  labels: ['omdat ik moest', 'omdat ik wilde']
}, {
  id: :v15,
  type: :range,
  title: '<strong>Hoe goed heb je dingen gedaan buiten school</strong> afgelopen week?',
  tooltip: 'Neem hierbij een paar ervaringen in gedachten die voor jou belangrijk waren.',
  labels: ['heel slecht', 'heel goed']
}, {
  id: :v16,
  type: :range,
  title: 'Kon je afgelopen week meestal goed <strong>opschieten met vrienden buiten school</strong>?',
  tooltip: 'Neem hierbij een paar ervaringen met vrienden in gedachten die voor jou belangrijk waren.',
  labels: ['heel slecht', 'heel goed']
}, {
  id: :v17,
  type: :range,
  title: 'Kon je afgelopen week meestal goed <strong>opschieten met ouders/familie buiten school</strong>?',
  tooltip: 'Neem hierbij een paar ervaringen met ouders of familie in gedachten die voor jou belangrijk waren.',
  labels: ['heel slecht', 'heel goed'],
  section_end: true
}, {
  section_start: 'Begeleiding',
  type: :raw,
  content: '<p class="flow-text section-explanation">De volgende vragen gaan over de persoonlijke begeleiding die je krijgt van {{je_begeleidingsinitiatief}}. Je antwoorden zijn helemaal anoniem.</p>'
}, {
  id: :v18,
  type: :radio,
  title: 'Heb je de afgelopen week {{naam_begeleider}} gesproken?',
  options: [
    { title: 'Ja', shows_questions: %i[v19 v20 v21 v22 v23 v24] },
    'Nee'
  ]
}, {
  id: :v19,
  hidden: true,
  type: :range,
  title: 'Kon je afgelopen week goed <strong>opschieten met {{naam_begeleider}}</strong>?',
  labels: ['heel slecht', 'heel goed']
}, {
  id: :v20,
  hidden: true,
  type: :range,
  title: 'Hoe <strong>open</strong> was je <strong>in wat je vertelde</strong> aan {{naam_begeleider}} afgelopen week?',
  labels: %w[gesloten open]
}, {
  id: :v21,
  hidden: true,
  type: :range,
  title: 'Heeft {{naam_begeleider}} je goed geholpen afgelopen week?',
  labels: ['niet goed geholpen', 'heel goed geholpen']
}, {
  id: :v22,
  hidden: true,
  type: :range,
  title: 'In hoeverre voelde jij je afgelopen week gesteund door {{naam_begeleider}} in het maken van je eigen beslissingen?',
  labels: ['niet', 'heel sterk']
}, {
  id: :v23,
  hidden: true,
  type: :range,
  title: 'In hoeverre had jij het gevoel dat {{naam_begeleider}} er voor je was deze week?',
  labels: ['niet', 'heel sterk']
}, {
  id: :v24,
  hidden: true,
  type: :range,
  title: 'In hoeverre gaf {{naam_begeleider}} je afgelopen week het gevoel dat je dingen goed kan?',
  labels: ['niet', 'heel sterk'],
  section_end: true
}, {
  section_start: 'Algemeen',
  type: :raw,
  content: '<p class="flow-text section-explanation">De volgende vraag gaat over jou in het algemeen. Het gaat dit keer dus niet over een specifieke omgeving, zoals eerder in deze vragenlijst. Je antwoord is helemaal anoniem.</p>'
}, {
  id: :v25,
  type: :range,
  title: 'Hoe voelde jij je deze week?',
  labels: ['Heel slecht', 'Heel goed'],
  section_end: true
}]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
