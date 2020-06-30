# frozen_string_literal: true

db_title = 'Webapp Jongeren'

db_name1 = 'dagboek studenten 2x per week maandag'
dagboek1 = Questionnaire.find_by(name: db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [{
  section_start: 'School',
  type: :raw,
  content: '<p class="flow-text section-explanation">De volgende vragen gaan over school en stage. Je antwoorden zijn anoniem en alleen de onderzoekers kunnen ze zien.</p>'
}, {
  id: :v1,
  type: :range,
  title: '<strong>Hoeveel tijd</strong> heb je sinds afgelopen donderdag besteed aan school, stage en huiswerk bij elkaar opgeteld? Een grove gok is prima, het is niet erg als je er een paar uur naast zit.',
  labels: ['0 uur', '40 uur of meer'],
  max: 40
}, {
  id: :v2,
  type: :range,
  title: 'Was dit <strong>genoeg tijd</strong> om goed te presteren op school?',
  labels: ['niet genoeg tijd', 'te veel tijd']
}, {
  id: :v3,
  type: :range,
  title: 'Ben je op dit moment blij met je <strong>keuze voor deze opleiding</strong>?',
  labels: ['niet blij met keuze', 'heel blij met keuze']
}, {
  id: :v4,
  type: :range,
  title: 'Vind je op dit moment dat je <strong>opleiding</strong> bij je past?',
  labels: ['past niet goed', 'past heel goed']
}, {
  id: :v5,
  type: :range,
  title: 'Heb je er op dit moment vertrouwen in dat je dit <strong>schooljaar gaat halen</strong>?',
  labels: ['geen vertrouwen', 'veel vertrouwen'],
  section_end: true
}, {
  section_start: 'Buiten School',
  type: :raw,
  content: '<p class="flow-text section-explanation">De volgende vragen gaan over de tijd die je besteedt buiten school. Je antwoorden zijn helemaal anoniem en alleen de onderzoekers kunnen ze zien.</p>'
}, {
  id: :v6,
  type: :range,
  title: 'Wat heb je sinds afgelopen donderdag <strong>meegemaakt buiten school</strong>?',
  labels: ['vooral nare dingen', 'vooral leuke dingen']
}, {
  id: :v7,
  type: :checkbox,
  title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken? Je mag meerdere antwoorden geven.',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
}, {
  id: :v8,
  type: :range,
  title: 'Heb je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> buiten school?',
  labels: ['zelf geen invloed', 'zelf veel invloed']
}, {
  id: :v9,
  type: :range,
  title: 'Heb je sinds afgelopen donderdag jouw activiteiten <strong>buiten school vooral gedaan</strong> omdat je het moest doen of omdat je het zelf wilde doen?',
  labels: ['omdat ik moest', 'omdat ik wilde']
}, {
  id: :v10,
  type: :range,
  title: 'Heb je sinds afgelopen donderdag dingen gedaan waar je <strong>trots</strong> op bent?',
  labels: ['helemaal niet', 'heel veel']
}, {
  id: :v11,
  type: :range,
  title: 'Kon je sinds afgelopen donderdag goed <strong>opschieten met vrienden buiten school</strong>?',
  labels: ['heel slecht', 'heel goed']
}, {
  id: :v12,
  type: :range,
  title: 'Kon je sinds afgelopen donderdag goed <strong>opschieten met ouders/familie</strong>?',
  labels: ['heel slecht', 'heel goed'],
  section_end: true
}]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
