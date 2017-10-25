# frozen_string_literal: true

db_title = 'Webapp Begeleiders'

db_name1 = 'dagboek mentoren'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek_content = [{
  id: :v1,
  type: :radio,
  title: 'Wil je de vragenlijst invullen voor deze student?',
  options: [
    { title: 'Ja', shows_questions: %i[v3] },
    { title: 'Nee', shows_questions: %i[v2] }
  ]
}, {
  id: :v2,
  hidden: true,
  type: :radio,
  title: 'Waarom vul jij de vragenlijst niet in voor deze student?',
  options: [
    'lorem',
    'ipsum',
    'dolor',
    'sid amed'
  ]
}, {
  id: :v3,
  hidden: true,
  title: 'Het bepalen van acties en doelen',
  add_button_label: 'Voeg doel toe',
  remove_button_label: 'Verwijder doel',
  type: :expandable,
  default_expansions: 0,
  max_expansions: 10,
  content: [{
    id: :v3_1,
    type: :textarea,
    title: 'Welke belangrijke actie of reeks aan acties die volgens jou bij
  elkaar horen (bijv. omdat ze hetzelfde doel dienen of kort achter elkaar zijn
                uitgevoerd) heb jij uitgevoerd in de begeleiding van deze student ?
  <em>Acties zijn bijvoorbeeld gesprekken, whatsappjes, oefeningen en huisbezoeken.
  Je mag zelf bepalen of jij jouw actie(s) wilt beschrijven in verhaalvorm of
  in steekwoorden.</em>'
  }, {
    id: :v3_2,
    type: :checkbox,
    title: 'Je hebt zojuist een belangrijke actie of meerdere belangrijke bij
  elkaar horende acties beschreven. Bij welke actiecluster(s) passen deze
  acties volgens jou het beste?',
    options: [
      'Actie 1',
      'Actie 2',
      'Actie 3',
      'Actie 3',
      'Actie 4',
      'Actie 5',
      'Actie 6',
      'Actie 7',
      'Actie 8',
      'Actie 9'
    ]
  }, {
    id: :v3_3,
    type: :checkbox,
    title: 'Aan welke doelen heb jij gewerkt door deze actie(s) uit te voeren?',
    options: [
      'doel 1',
      'doel 2',
      'doel 3',
      'doel 4',
      'doel 5',
      'doel 6',
      'doel 7'
    ]
  }, {
    id: :v3_4,
    type: :range,
    title: 'Hoe belangrijk denk jij dat deze actie (reeks) was om de begeleidingsdoelen van deze student te
behalen?',
    labels: ['lorem ipsum', 'dolor sid amed']
  }, {
    id: :v3_5,
    type: :range,
    title: 'Hoe tevreden ben je met de interactie tussen jou en deze student tijdens deze actie(reeks)?',
    labels: ['lorem ipsum', 'dolor sid amed']
  }]

}, {
  id: :v4,
  hidden: false,
  type: :range,
  title: 'Hoeveel tijd heb je deze week besteed aan de begeleiding van deze student?',
  labels: ['lorem ipsum', 'dolor sid amed']
}, {
  id: :v5,
  hidden: false,
  type: :range,
  title: 'Waren jouw acties in de begeleiding van de student deze week vooral gepland of vooral intuïtief?',
  labels: ['lorem ipsum', 'dolor sid amed']
}, {
  id: :v6,
  hidden: false,
  type: :range,
  title: 'In hoeverre heb jij deze week geprobeerd deze student aan te sporen tot zelfregie?',
  labels: ['lorem ipsum', 'dolor sid amed']
}, {
  id: :v7,
  hidden: false,
  type: :range,
  title: 'In hoeverre heb jij deze week geprobeerd jouw band met deze student te versterken?',
  labels: ['lorem ipsum', 'dolor sid amed']
}, {
  id: :v8,
  hidden: false,
  type: :range,
  title: 'In hoeverre heb jij deze week geprobeerd het zelfvertrouwen van deze student te vergroten?',
  labels: ['lorem ipsum', 'dolor sid amed']
}, {
  id: :v9,
  hidden: false,
  type: :radio,
  title: 'Heb je de begeleiding van deze student deze week (voor meer dan 50%) overgedragen aan een andere persoon?',
  options: [
    { title: 'Ja', shows_questions: %i[v10 v11 v12] },
    { title: 'Nee' }
  ]
}, {
  id: :v10,
  hidden: true,
  type: :textarea,
  title: 'Waarom heb jij de begeleiding (grotendeels) overgedragen?'
}, {
  id: :v11,
  hidden: true,
  type: :textarea,
  title: 'Naar wie heb jij de begeleiding (grotendeels) overgedragen?'
}, {
  id: :v12,
  hidden: true,
  type: :textarea,
  title: 'Wat denkt jij dat diegene deze week heeft gedaan in de begeleiding van deze student?'
}]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
