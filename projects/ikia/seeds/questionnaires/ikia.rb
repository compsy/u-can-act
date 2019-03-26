# frozen_string_literal: true

db_title = '' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'demo'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [
  {
    section_start: '<strong>De volgende vragen gaan over hoe je je op dit moment voelt.</strong>',
    id: :v1,
    type: :textfield,
    title: 'Ik voel me op dit moment...'
  }, {
    id: :v2,
    type: :radio,
    show_otherwise: false,
    title: 'Merk je dit gevoel ook in je lichaam?',
    options: [
      { title: 'Ja', shows_questions: %i[v3 v4] },
      { title: 'Nee' }
    ]
  }, {
    type: :raw,
    content: <<ENDL
<div class="v3_toggle hidden">
  <p class="flow-text">Kleur de plekken in je lichaam waar je merkt dat het sterker wordt</p>
  <div class="row">
    <div class="col s12 m6">
      <div id="sketch-container" class="sketch-container"></div>
    </div>
    <div class="col s12 m6 hideme">
      <div id="log" class="log"></div>
    </div>
  </div>
  <div class="row section">
    <div class="col s12">
      <button class="btn waves-effect waves-light" id="clear">Wissen</button>
      <button class="btn" id="ok">Ok</button>
    </div>
  </div>
</div>
ENDL
  }, {
    type: :raw,
    content: <<ENDL
<div class="v4_toggle hidden">
  <p class="flow-text">Kleur de plekken in je lichaam waar je merkt dat het slapper wordt</p>
  <div class="row">
    <div class="col s12 m6">
      <div id="sketch-container1" class="sketch-container"></div>
    </div>
    <div class="col s12 m6 hideme">
      <div id="log1" class="log"></div>
    </div>
  </div>
  <div class="row">
    <div class="col s12">
      <button class="btn waves-effect waves-light" id="clear1">Wissen</button>
      <button class="btn" id="ok1">Ok</button>
    </div>
  </div>
</div>
ENDL
  }, {
    type: :raw,
    content: '<p class="flow-text">Geef bij elk gevoel aan hoe sterk je dit nu voelt:</p>'
  }, {
    id: :v5,
    type: :range,
    title: 'Boos',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v6,
    type: :range,
    title: 'Tevreden',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v7,
    type: :range,
    title: 'Schuldig',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v8,
    type: :range,
    title: 'Energiek',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v9,
    type: :range,
    title: 'Vrolijk',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v10,
    type: :range,
    title: 'Verdrietig',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v11,
    type: :range,
    title: 'Bang',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v12,
    type: :range,
    title: 'Overstuur',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v13,
    type: :range,
    title: 'Eenzaam',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v14,
    type: :range,
    title: 'Nerveus',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v15,
    type: :range,
    title: 'Gelukkig',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v16,
    type: :range,
    title: 'Dankbaar',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v17,
    type: :range,
    title: 'Ik weet precies wat ik op dit moment voel',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v18,
    type: :range,
    title: 'Ik ben in de war over hoe ik me voel',
    labels: ['Helemaal niet', 'Heel erg'],
    section_end: true
  }, {
    section_start: '<strong>De volgende vragen gaan over hoe je dag was</strong>',
    id: :v19,
    type: :radio,
    show_otherwise: false,
    title: 'Is er vandaag iets leuks of plezierigs gebeurd?',
    options: [
      { title: 'Ja', shows_questions: %i[v20 v21 v22] },
      { title: 'Nee' }
    ]
  }, {
    id: :v20,
    hidden: true,
    type: :range,
    title: 'Hoe leuk of plezierig was deze gebeurenis?',
    labels: ['Een klein beetje leuk', 'Heel erg leuk']
  }, {
    id: :v21,
    hidden: true,
    type: :checkbox,
    required: true,
    title: 'Waar had deze gebeurtenis mee te maken?',
    options: [
      'Met mijzelf',
      'Met mijn ouders/familie/thuis',
      'Met mijn vrienden',
      'Met mijn klasgenoten',
      'Met school',
      'Met onbekenden',
      'Met iets wat ik op het nieuws/ internet/ de krant las of zag'
    ],
    show_otherwise: true,
    otherwise_label: 'Met iets anders, namelijk'
  }, {
    id: :v22,
    hidden: true,
    type: :checkbox,
    required: true,
    title: 'Heb je hier met iemand over gepraat?',
    options: [
      'Nee, met niemand',
      'Ja, met mijn vader/moeder',
      'Ja, met een vriend(in)'
    ],
    show_otherwise: true,
    otherwise_label: 'Ja, met iemand anders, namelijk'
  }, {
    id: :v23,
    type: :radio,
    show_otherwise: false,
    title: 'Is er vandaag iets vervelends of naars gebeurd?',
    options: [
      { title: 'Ja', shows_questions: %i[v24 v25 v26 v27 v28] },
      { title: 'Nee' }
    ]
  }, {
    id: :v24,
    hidden: true,
    type: :range,
    title: 'Hoe vervelend of naar was deze gebeurtenis?',
    labels: ['Een klein beetje vervelend', 'Heel erg vervelend']
  }, {
    id: :v25,
    hidden: true,
    type: :checkbox,
    required: true,
    title: 'Waar had deze gebeurtenis mee te maken?',
    options: [
      'Met mijzelf',
      'Met mijn ouders/familie/thuis',
      'Met mijn vrienden',
      'Met mijn klasgenoten',
      'Met school',
      'Met onbekenden',
      'Met iets wat ik op het nieuws/ internet/ de krant las of zag'
    ],
    show_otherwise: true,
    otherwise_label: 'Met iets anders, namelijk'
  }, {
    id: :v26,
    hidden: true,
    type: :range,
    title: 'Heb je over deze gebeurtenis lopen piekeren?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v27,
    hidden: true,
    type: :range,
    title: 'Heb je geprobeerd niet aan deze gebeurtenis te denken?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v28,
    hidden: true,
    type: :checkbox,
    required: true,
    title: 'Heb je hier met iemand over gepraat?',
    options: [
      'Nee, met niemand',
      'Ja, met mijn vader/moeder',
      'Ja, met een vriend(in)'
    ],
    show_otherwise: true,
    otherwise_label: 'Ja, met iemand anders, namelijk'
  }, {
    id: :v29,
    type: :range,
    title: 'Heb je vandaag gelachen?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v30,
    type: :range,
    title: 'Ben je vandaag buiten geweest?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v31,
    type: :range,
    title: 'Ben je vandaag actief geweest?',
    tooltip: 'Sporten, wandelen, fietsen',
    labels: ['Helemaal niet', 'Heel erg'],
    section_end: true
  }, {
    section_start: '<strong>De volgende vragen gaan over hoe het vandaag tussen jou en je moeder/ vader was.</strong>',
    id: :v32,
    type: :range,
    title: 'Heb je vandaag plezier gehad met je vader/moeder?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v33,
    type: :range,
    title: 'Heb je vandaag ruzie gemaakt met je vader/moeder?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v34,
    type: :range,
    title: 'Heb je vandaag geknuffeld met je vader/moeder?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v35,
    type: :range,
    title: 'Was je vader/moeder vandaag boos op jou?',
    labels: ['Helemaal niet', 'Heel erg']
  }, {
    id: :v36,
    type: :range,
    title: 'Hoe leuk of fijn vond je het om bij je vader/moeder te zijn?',
    labels: ['Helemaal niet', 'Heel erg'],
    section_end: true
  },
]

dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
