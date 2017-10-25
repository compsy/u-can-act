# frozen_string_literal: true

db_title = 'Webapp Begeleiders'

db_name1 = 'dagboek mentoren'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek_content = [{
  id: :v1,
  type: :radio,
  show_otherwise: false,
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
    'Ik heb deze week geen contact gehad met deze student.',
    'Ik ben gestopt met de begeleiding van deze student.',
    'Deze student is gestopt met de opleiding.',
    'Ik heb de begeleiding van deze student overgedragen aan iemand anders'
  ]

}, {
  id: :v3,
  hidden: true,
  title: 'Het bepalen van acties en doelen',
  add_button_label: 'Nog een actie (reeks) toevoegen',
  remove_button_label: 'Verwijder actie (reeks)',
  type: :expandable,
  default_expansions: 1,
  max_expansions: 10,
  content: [{
    id: :v3_1,
    type: :textarea,
    title: 'Welke belangrijke actie of reeks aan acties die volgens jou bij
  elkaar horen (bijv. omdat ze hetzelfde doel dienen of kort achter elkaar zijn
                uitgevoerd) heb jij uitgevoerd in de begeleiding van deze student?
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
      'Laagdrempelig contact leggen; bijv. whatsappen of samen tafeltennissen, wandelen of roken.',
      'Visuele oefeningen uitvoeren; bijv. een netwerkschema op papier uittekenen of in powerpoint gedragsschema’s met deze student uitwerken.',
      'Verbale oefeningen uitvoeren; bijv. een rollenspel spelen, deze student laten presenteren.',
      'Motiverende gesprekstechnieken gebruiken; bijv. vertrouwen naar deze student uitspreken dat zij/hij haar/zijn tentamen kan halen ,deze student aansporen tot het maken van een presentatie of deze student aanmoedigen tijdens een sportevent.',
      'Confronterende gesprekstechnieken gebruiken; bijv. deze student een spreekwoordelijke spiegel voorhouden, aanspreken op onhandig gedrag of provocatief coachen.',
      'Uitleg geven; bijv. deze student informeren over middelengebruik of over de kenmerken ADHD.',
      'Emotionele steun bieden; bijv. empathisch reageren op een nare ervaring van deze student, of deze student een luisterend oor bieden.',
      'De omgeving van deze student betrekken bij de begeleiding; bijv. ouders, vrienden, leraren of hulpverleners uitleg geven over deze student haar/zijn gedrag of handvaten geven om beter met deze student om te gaan.',
      'Hulp vragen aan/overleggen met collega’s of andere professionals; bijv. hulp vragen aan een psycholoog of maatschappelijk werker om mee te helpen/denken in de begeleiding.',
      'Observaties doen; bijv. een voetbalwedstrijd bekijken of deze student observeren tijdens pauzes of lessen.'
    ]
  }, {
    id: :v3_3,
    type: :checkbox,
    title: 'Aan welke doelen heb jij gewerkt door deze actie(s) uit te voeren?',
    options: [
      'De relatie met deze student verbeteren en/of onderhouden; bijv. de band met deze student proberen te verbeteren of laten weten dat je er voor deze student bent.',
      'Emotioneel welzijn van deze student ontwikkelen; bijv. deze student leren om haar/zijn emoties beter onder controle krijgen of om haar/zijn emotie(s) beter aan te laten sluiten op situatie(s).',
      'Vaardigheden van deze student ontwikkelen; bijv. sociale of schoolse vaardigheden trainen, zoals plannen.',
      'Deze student zelfinzicht geven; bijv. deze student inzicht geven in haar/zijn eigen gedrag, emoties, gedachten of relaties met anderen.',
      'Inzicht krijgen in de belevingswereld van deze student; bijv. proberen te achterhalen hoe deze student denkt, of hoe zij/hij zich voelt en waarom zij/hij zo denkt of voelt .',
      'Inzicht krijgen in de omgeving van deze student; bijv. verdiepen in wat zij/hij zoal meemaakt op school of tijdens haar/zijn hobby(s), verdiepen in deze student haar/zijn familiedynamiek of achterhalen met wie hij zoal omgaat.',
      'De omgeving van deze student veranderen; bijv. kennis vergroten bij ouders, vrienden en leraren van deze student, of hen overtuigen om deze student hulp te bieden.'
    ]

  }, {
    id: :v3_4,
    type: :range,
    title: 'Hoe belangrijk denk jij dat deze actie (reeks) was voor de voortgang van deze student in zijn begeleidingstraject?',
    labels: ['niet belangrijk', 'heel belangrijk']
  }, {
    id: :v3_5,
    type: :range,
    title: 'Hoe tevreden ben je met de interactie tussen jou en deze student tijdens deze actie(reeks)?',
    labels: ['ontevreden', 'heel tevreden']
  }]
}, {
  id: :v4,
  hidden: false,
  type: :radio,
  title: 'Hoeveel tijd heb je deze week besteed aan de begeleiding van deze student?',
  options: ['minder dan een half uur',
           'een half uur tot een uur',
           'een uur tot anderhalf uur',
           'anderhalf uur tot twee uur',
           'twee uur tot tweeënhalf uur',
           'tweeënhalf uur tot drie uur',
           'drie uur tot drieënhalf uur',
           'drieënhalf uur tot vier uur']
}, {
  id: :v5,
  hidden: false,
  type: :range,
  title: 'Waren jouw acties in de begeleiding van deze student deze week vooral gepland of vooral intuïtief?',
  labels: ['helemaal intuïtief ', 'helemaal gepland']
}, {
  id: :v6,
  hidden: false,
  type: :range,
  title: 'In hoeverre heb jij deze week geprobeerd  deze student te ondersteunen in het maken van eigen beslissingen?',
  labels: ['niet', 'heel sterk']
}, {
  id: :v7,
  hidden: false,
  type: :range,
  title: 'In hoeverre heb jij deze week geprobeerd deze student het gevoel te geven dat jij er voor hem/haar bent ?',
  labels: ['niet', 'heel sterk']
}, {
  id: :v8,
  hidden: false,
  type: :range,
  title: 'In hoeverre heb jij deze week geprobeerd deze student te ondersteunen om zich bekwaam te voelen? ',
  labels: ['niet', 'heel sterk']
}, {
  id: :v9,
  hidden: false,
  type: :radio,
  show_otherwise: false,
  title: 'Heb je de begeleiding van Henk deze week (voor meer dan 50%) overgedragen aan een andere persoon?',
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
  title: 'Aan wie heb jij de begeleiding (grotendeels) overgedragen?'
}, {
  id: :v12,
  hidden: true,
  type: :textarea,
  title: 'Wat denk jij dat diegene deze week heeft gedaan in de begeleiding van deze student?'
}]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
