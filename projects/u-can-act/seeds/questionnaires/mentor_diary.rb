# frozen_string_literal: true

db_title = '' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'dagboek mentoren'
dagboek1 = Questionnaire.find_by(name: db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [{
  id: :v1, # 1
  type: :radio,
  show_otherwise: false,
  title: 'Heb je deze week acties ondernomen in de begeleiding van {{deze_student}}?',
  options: [
    { title: 'Ja', shows_questions: %i[v3 v4 v5 v6 v7 v8 v9] },
    { title: 'Nee', shows_questions: %i[v2] }
  ]
}, {
  id: :v2,
  hidden: true,
  type: :radio,
  title: 'Waarom heb je deze week geen acties ondernomen in de begeleiding van {{deze_student}}?',
  options: [
    'Ik heb deze week geen contact gehad met {{deze_student}}.',
    { title: 'Ik ben gestopt met de begeleiding van {{deze_student}}.',
      shows_questions: %i[v14 v15],
      stop_subscription: true,
      tooltip: 'Let op: als je deze optie selecteert word je hierna niet meer gevraagd om vragenlijsten in te vullen over {{deze_student}}.' },
    { title: '{{Deze_student}} is gestopt met de opleiding.',
      shows_questions: %i[v16 v17 v18] },
    { title: 'Ik heb de begeleiding van {{deze_student}} overgedragen aan iemand anders.',
      shows_questions: %i[v10 v11 v12 v13] }
  ]
}, {
  id: :v3, # 2
  hidden: true,
  title: '',
  add_button_label: 'Nog een actie(reeks) toevoegen',
  remove_button_label: 'Verwijder actie(reeks)',
  type: :expandable,
  default_expansions: 1,
  max_expansions: 10,
  content: [{
    section_start: 'Actie(reeks)',
    id: :v3_1, # 2.1
    type: :textarea,
    required: true,
    title: 'Welke belangrijke actie, of reeks aan acties die volgens jou bij
      elkaar horen (bijv. omdat ze hetzelfde doel dienen of kort achter elkaar zijn
      uitgevoerd), heb jij uitgevoerd in de begeleiding van {{deze_student}}?',
    tooltip: 'Acties zijn bijvoorbeeld gesprekken, whatsappjes, oefeningen en huisbezoeken. Je mag jouw actie(s) kort beschrijven in steekwoorden of in verhaalvorm.'
  }, {
    id: :v3_2, # 2.2
    type: :checkbox,
    required: true,
    title: 'In welke categorie(ën) past de zojuist beschreven actie(reeks) volgens jou het beste?',
    options: [
      { title: 'Laagdrempelig contact leggen', tooltip: 'bijv. whatsappen of samen tafeltennissen, wandelen of roken.' },
      { title: 'Visuele oefeningen uitvoeren', tooltip: 'bijv. een netwerkschema op papier uittekenen of in Powerpoint gedragsschema’s met {{deze_student}} uitwerken.' },
      { title: 'Verbale oefeningen uitvoeren', tooltip: 'bijv. een rollenspel spelen of {{deze_student}} laten presenteren.' },
      { title: 'Motiveren', tooltip: 'bijv. vertrouwen naar {{deze_student}} uitspreken dat {{hij_zij_student}} {{zijn_haar_student}} tentamen kan halen, {{deze_student}} aansporen tot het maken van een presentatie of {{deze_student}} aanmoedigen tijdens een sportevent.' },
      { title: 'Confronteren', tooltip: 'bijv. {{deze_student}} een spreekwoordelijke spiegel voorhouden, aanspreken op onhandig gedrag of provocatief coachen.' },
      { title: 'Uitleg geven', tooltip: 'bijv. {{deze_student}} informeren over middelengebruik of over de kenmerken van ADHD.' },
      { title: 'Ondersteunen van schoolwerk', tooltip: 'bijv. {{deze_student}} helpen met plannen of samen met {{deze_student}} {{zijn_haar_student}} leerstof doornemen.' },
      { title: 'Emotionele steun bieden', tooltip: 'bijv. empathisch reageren op een nare ervaring van {{deze_student}}, of {{deze_student}} een luisterend oor bieden.' },
      { title: 'De omgeving van {{deze_student}} betrekken bij de begeleiding', tooltip: 'bijv. ouders, vrienden, leraren of hulpverleners uitleg geven over {{deze_student}} {{zijn_haar_student}} gedrag of vragen om mee te helpen in de begeleiding van {{deze_student}}.' },
      { title: 'Hulp vragen aan/overleggen met collega’s of andere professionals', tooltip: 'bijv. hulp vragen aan een psycholoog of maatschappelijk werker om mee te helpen/denken in de begeleiding van {{deze_student}}.' },
      { title: 'Observaties doen', tooltip: 'bijv. een voetbalwedstrijd bekijken of {{deze_student}} observeren tijdens pauzes of lessen.' }
    ],
    otherwise_tooltip: 'kies dit cluster alleen wanneer de door jouw gekozen actie niet bij andere clusters past.'
  }, {
    id: :v3_3, # 2.3
    type: :checkbox,
    required: true,
    title: 'Aan welke doelen heb jij gewerkt door deze actie(s) uit te voeren?',
    options: [
      { title: 'De relatie met {{deze_student}} verbeteren en/of onderhouden', tooltip: 'bijv. de band met {{deze_student}} proberen te verbeteren of laten weten dat je er voor {{deze_student}} bent.' },
      { title: 'Emotioneel welzijn van {{deze_student}} ontwikkelen', tooltip: 'bijv. {{deze_student}} leren om {{zijn_haar_student}} emoties beter onder controle te krijgen of om {{zijn_haar_student}} emotie(s) beter aan te laten sluiten op situatie(s).' },
      { title: 'Vaardigheden van {{deze_student}} ontwikkelen', tooltip: 'bijv. sociale of schoolse vaardigheden trainen, zoals plannen. Of {{deze_student}} trainen hoe {{hij_zij_student}} beter met probleemsituaties om kan gaan.' },
      { title: '{{Deze_student}} zelfinzicht geven', tooltip: 'bijv. {{deze_student}} inzicht geven in {{zijn_haar_student}} eigen gedrag, emoties, gedachten of relaties met anderen.' },
      { title: 'Inzicht krijgen in de belevingswereld van {{deze_student}}', tooltip: 'bijv. proberen te achterhalen hoe {{deze_student}} denkt, of hoe {{hij_zij_student}} zich voelt en waarom {{hij_zij_student}} zo denkt of voelt.' },
      { title: 'Inzicht krijgen in de omgeving van {{deze_student}}', tooltip: 'bijv. verdiepen in wat {{hij_zij_student}} zoal meemaakt op school of tijdens {{zijn_haar_student}} hobby(\'s), verdiepen in {{deze_student}} {{zijn_haar_student}} familiedynamiek of achterhalen met wie {{hij_zij_student}} zoal omgaat.' },
      { title: 'De omgeving van {{deze_student}} veranderen', tooltip: 'bijv. kennis vergroten bij ouders, vrienden en leraren van {{deze_student}}, of hen overtuigen om {{deze_student}} hulp te bieden.' }
    ],
    otherwise_tooltip: 'kies dit cluster alleen wanneer het door jouw gekozen doel niet bij andere clusters past.'
  }, {
    id: :v3_4, # 2.4
    type: :range,
    title: 'Hoe belangrijk denk jij dat deze actie(reeks) was voor de voortgang van {{deze_student}} in {{zijn_haar_student}} begeleidingstraject?',
    labels: ['niet belangrijk', 'heel belangrijk']
  }, {
    id: :v3_51,
    type: :checkbox,
    show_otherwise: false,
    title: 'Hoe tevreden ben je met de interactie tussen jou en {{deze_student}}?',
    options: [
      { title: 'Niet van toepassing', hides_questions: %i[v3_5] }
    ]
  }, {
    id: :v3_5,
    hidden: false,
    type: :range,
    title: '',
    labels: ['ontevreden', 'heel tevreden'],
    section_end: true
  }]
}, {
  id: :v4,
  hidden: true,
  type: :time,
  hours_from: 0,
  hours_to: 11,
  hours_step: 1,
  title: 'Hoeveel tijd heb je deze week besteed aan de begeleiding van {{deze_student}}?',
  section_start: 'Overige vragen'
}, {
  id: :v5,
  hidden: true,
  type: :range,
  title: 'Waren jouw acties in de begeleiding van {{deze_student}} deze week vooral gepland of vooral intuïtief?',
  labels: ['helemaal intuïtief ', 'helemaal gepland']
}, {
  id: :v6,
  hidden: true,
  type: :range,
  title: 'In hoeverre heb jij deze week geprobeerd {{deze_student}} te ondersteunen in het maken van {{zijn_haar_student}} eigen beslissingen?',
  labels: ['niet', 'heel sterk']
}, {
  id: :v7,
  hidden: true,
  type: :range,
  title: 'In hoeverre heb jij deze week geprobeerd {{deze_student}} het gevoel te geven dat {{hij_zij_student}} dingen goed kan?',
  labels: ['niet', 'heel sterk']
}, {
  id: :v8,
  hidden: true,
  type: :range,
  title: 'In hoeverre heb jij deze week geprobeerd {{deze_student}} het gevoel te geven dat je er voor {{hem_haar_student}} bent?',
  labels: ['niet', 'heel sterk'],
  section_end: true
}, {
  id: :v9, # 3.2
  hidden: true,
  type: :radio,
  show_otherwise: false,
  title: 'Heb je de begeleiding van {{deze_student}} deze week grotendeels overgedragen aan een andere persoon?',
  tooltip: 'Met grotendeels bedoelen wij voor meer dan de helft',
  options: [
    { title: 'Ja', shows_questions: %i[v10 v11 v12] },
    { title: 'Nee' }
  ]
}, {
  id: :v10, # 3.2.2
  hidden: true,
  type: :textarea,
  title: 'Waarom heb jij de begeleiding (grotendeels) overgedragen?'
}, {
  id: :v11, # 3.2.3
  hidden: true,
  type: :textarea,
  title: 'Aan wie heb jij de begeleiding (grotendeels) overgedragen?'
}, {
  id: :v12, # 3.2.4
  hidden: true,
  type: :textarea,
  title: 'Wat denk jij dat diegene deze week heeft gedaan in de begeleiding van {{deze_student}}?'
}, {
  id: :v13,
  hidden: true,
  type: :raw,
  content: '<p class="flow-text section-explanation">Is de overdracht van begeleiding van permanente aard? Mail dan de telefoonnummers van jou, {{deze_student}} en de nieuwe begeleider naar <a href="mailto:n.r.snell@rug.nl">n.r.snell@rug.nl</a>.</p>'
}, {
  id: :v14,
  hidden: true,
  type: :textarea,
  title: 'Waarom ben je gestopt met de begeleiding van {{deze_student}}?'
}, {
  id: :v15,
  hidden: true,
  type: :radio,
  title: 'Denk jij dat {{deze_student}} nog steeds risico loopt om voortijdig te stoppen met {{zijn_haar_student}} opleiding?',
  options: %w[Ja Nee]
}, {
  id: :v16,
  hidden: true,
  type: :textarea,
  title: 'Waarom is {{deze_student}} gestopt met {{zijn_haar_student}} opleiding?'
}, {
  id: :v17,
  hidden: true,
  type: :radio,
  title: 'Wat gaat {{deze_student}} doen nu {{hij_zij_student}} gestopt is met {{zijn_haar_student}} opleiding?',
  options: [
    'Werken',
    'Een andere opleiding volgen',
    'Weet ik niet'
  ]
}, {
  id: :v18,
  hidden: true,
  type: :radio,
  title: 'Stopt jouw begeleiding van {{deze_student}} nu {{hij_zij_student}} met de opleiding is gestopt?',
  options: [
    { title: 'Ja',
      stop_subscription: true,
      tooltip: 'Let op: als je deze optie selecteert word je hierna niet meer gevraagd om vragenlijsten in te vullen over {{deze_student}}.' },
    'Nee'
  ]
}]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
