# frozen_string_literal: true
db_title = 'De afgelopen week'
db_name1 = 'weekly_diary'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over wat je de afgelopen week allemaal hebt meegemaakt. Er zijn geen "goede" of "foute" antwoorden, het gaat erom hoe je je echt voelt.
    </p>'
  }, {
    id: :v1,
    type: :range,
    required: true,
    title: 'Hoe ging het afgelopen week met je?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    type: :raw,
    content: '<p class="flow-text">Ongeveer hoe vaak voelde je je in de afgelopen week ...
  </p>'
  }, {
    id: :v2,
    type: :range,
    required: true,
    title: 'Zenuwachtig?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    id: :v3,
    type: :range,
    required: true,
    title: 'Hopeloos?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    id: :v4,
    type: :range,
    required: true,
    title: 'Rusteloos of ongedurig?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    id: :v5,
    type: :range,
    required: true,
    title: 'Zo somber dat niets je kon opvrolijken?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    id: :v6,
    type: :range,
    required: true,
    title: 'Dat alles veel moeite kostte?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    id: :v7,
    type: :range,
    required: true,
    title: 'Waardeloos?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    type: :raw,
    content: '<p class="flow-text"><br><br>
  </p>'
  }, {
    id: :v8,
    type: :range,
    required: true,
    title: 'Hoe goed heb je in de afgelopen week geslapen?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v9,
    type: :radio,
    show_otherwise: false,
    title: 'Ben je afgelopen week naar school geweest?',
    options: [
      {title: 'Ja, alleen in het echt', shows_questions: %i[v10_a v11 v12 v13 v24] },
      {title: 'Ja, alleen online', shows_questions: %i[v10_a v11 v12 v13 v24] },
      {title: 'Ja, zowel in het echt als online', shows_questions: %i[v10_a v11 v12 v13 v24] },
      {title: 'Nee, helemaal niet', shows_questions: %i[v9_b] }
    ]
  }, {
    id: :v9_b,
    type: :checkbox,
    show_otherwise: false,
    required: true,
    hidden: true,
    title: 'Waarom ben je niet naar school geweest?',
    options: [
      { title: 'Het was vakantie' },
      { title: 'Ik was ziek' },
      { title: 'Ik moest thuisblijven wegens corona (bijvoorbeeld quarantaine)' },
      { title: 'Ik vond het te moeilijk om naar school te gaan' },
      { title: 'Ik had een andere reden' }
    ]
  }, {
    id: :v10_a,
    type: :days,
    hidden: true,
    title: 'Zijn er in de afgelopen week wel dagdelen geweest waarop je niet naar school bent geweest of online lessen hebt gemist? Vink de dagdelen aan waarop je <u>niet</u> naar school bent geweest of waarop je minstens 1 lesuur hebt gemist.',
    tooltip: 'Het maakt niet uit wat de reden was. Als je alleen een paar minuten te laat was, hoef je het niet mee te tellen.',
    shows_questions: %i[v10_b],
    required: false,
    from_days_ago: 7,
    exclude_weekends: true,
    include_today: false,
    morning_and_afternoon: true,
  }, {
    id: :v10_b,
    type: :checkbox,
    show_otherwise: false,
    hidden: true,
    required: true,
    title: 'Waarom was je niet naar school of heb je lessen gemist? Je kunt meerdere redenen aanvinken.',
    options: [
    { title: 'Ik had een afspraak (bijvoorbeeld met de huisarts of een specialist)' }, 
    { title: 'Ik was ziek (bijvoorbeeld grieperig) of lag in het ziekenhuis' },
    { title: 'Ik moest thuisblijven wegens corona (bijvoorbeeld quarantaine)' },
    { title: 'Ik vond het moeilijk om naar school te gaan of daar te blijven (bijvoorbeeld omdat je bang was)' },
    { title: 'Ik was aan het spijbelen' },
    { title: 'De school was gesloten (bijvoorbeeld vanwege een studiedag of feestdag' },
    { title: 'Ik had vrij gekregen van mijn ouders (bijvoorbeeld om rust te krijgen of op vakantie te gaan' },    
    { title: 'Ons gezin had iets dringends (bijvoorbeeld een begrafenis of een kapotte auto)' },  
    { title: 'Ik was naar huis gestuurd vanwege mijn gedrag (bijvoorbeeld een schorsing)' },
    { title: 'Er was zwaar weer (bijvoorbeeld een storm)' },
    { title: 'Ik had een andere reden' }
  ]
  }, {
    id: :v11,
    type: :range,
    hidden: true,
    required: true,
    title: 'Hoe ging het afgelopen week in het algemeen op school?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v12,
    type: :range,
    hidden: true,
    required: true,
    title: 'Hoeveel moeite had je afgelopen week met je schoolwerk of met toetsen?',
    labels: ['Geen moeite', 'Heel veel moeite']
  }, {
    id: :v13,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Had je afgelopen week toetsen?',
    options: ['Nee', "Ja, tijdens een gewone schoolweek", "Ja, tijdens een toetsweek"]
  }, {
    id: :v14,
    type: :range,
    required: true,
    title: 'Heb je afgelopen week druk gevoeld om goed te presteren vanuit je leraren?',
    labels: ['Helemaal niet', 'Heel veel']
  }, {
    id: :v15,
    type: :range,
    required: true,
    title: 'Heb je afgelopen week druk gevoeld om goed te presteren vanuit je ouders?',
    labels: ['Helemaal niet', 'Heel veel']
  }, {
    id: :v16,
    type: :range,
    required: true,
    title: 'Heb je afgelopen week druk gevoeld om goed te presteren vanuit jezelf?',
    labels: ['Helemaal niet', 'Heel veel']
  }, {
    id: :v17,
    type: :range,
    required: true,
    title: 'Hoe zeker ben je dat je dit jaar over zal gaan?',
    labels: ['Helemaal niet zeker', 'Heel zeker']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over de mensen om je heen.
  </p>'
  }, {
    id: :v18,
    type: :radio,
    show_otherwise: false,
    title: ' Had je afgelopen week verkering met iemand?',
    options: [
      { title: 'Ja', shows_questions: %i[v23] }, 
      { title: 'Nee' } 
    ]
  }, {
    type: :raw,
    content: '<p class="flow-text">Hoe goed kon je de afgelopen week opschieten met ...
  </p>'
  }, {
    id: :v19,
    type: :range,
    required: true,
    title: 'Je leraren?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v20,
    type: :range,
    required: true,
    title: 'Je klasgenoten?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v21,
    type: :range,
    required: true,
    title: 'Je vrienden?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v22,
    type: :range,
    required: true,
    title: 'Je ouders?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v23,
    type: :range,
    hidden: true,
    required: true,
    title: 'Degene met wie je verkering hebt?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    type: :raw,
    content: '<p class="flow-text"><br><br>
  </p>'
  }, {
    id: :v24,
    type: :checkbox,
    hidden: true,
    show_otherwise: false,
    required: true,
    title: 'Is er de afgelopen week iets bijzonders gebeurd op school? Je kunt meerdere opties aankruisen.',
    options: [
      { title: 'Nee, niets' },
      { title: 'Ja, iets leuks' },
      { title: 'Ja, iets neutraals' },
      { title: 'Ja, iets vervelends' }
    ]
  }, {
    id: :v25,
    type: :checkbox,
    show_otherwise: false,
    required: true,
    title: 'Is er de afgelopen week iets bijzonders gebeurd buiten school, bijvoorbeeld thuis? Je kunt meerdere opties aankruisen.',
    options: [
      { title: 'Nee, niets' },
      { title: 'Ja, iets leuks' },
      { title: 'Ja, iets neutraals' },
      { title: 'Ja, iets vervelends' }
    ]
  }
]


dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
