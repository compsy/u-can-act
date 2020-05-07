# frozen_string_literal: true

db_title = 'Dagboekvragenlijst'
db_name1 = 'Dagboek_Kinderen_8+'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

dagboek_content = [
  {
    section_start: '<strong>De volgende vragen gaan over hoe je je op dit moment voelt.</strong>',
    id: :v1,
    type: :textfield,
    title: 'Ik voel me op dit moment...',
    section_end: false
  }, {
    id: :v1b,
    type: :range,
    title: 'Hoe sterk voel je dit?',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  },{   
    id: :v2,
    type: :radio,
    show_otherwise: false,
    title: 'Merk je dit gevoel ook in je lichaam?',
    options: [
      { title: 'Ja', shows_questions: %i[v3] },
      { title: 'Nee' }
    ]
  }, {
    id: :v3,
    hidden: true,
    type: :drawing,
    title: 'Waar in je lichaam merk je dit?',
    width: 240,
    height: 536,
    image: 'bodymap.png',
    color: '#e57373'
  }, {
    id: :v4,
    type: :range,
    title: 'Ik ben in de war over wat ik nu voel',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    type: :raw,
    content: '<p class="flow-text">Geef bij elk gevoel aan hoe sterk je dit nu voelt:</p>'
  }, {
    id: :v5,
    type: :range,
    title: 'Trots',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v6,
    type: :range,
    title: 'Boos',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Tevreden',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'Beschaamd',
    labels: ['Helemaal niet', 'Heel erg'],
    tooltip: 'Dit is het gevoel dat je je ergens voor schaamt, dat je het anders had willen doen',
    required: true
  }, {
    id: :v9,
    type: :range,
    title: 'Vol energie',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v10,
    type: :range,
    title: 'Vrolijk',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v11,
    type: :range,
    title: 'Verdrietig',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Bang',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Gelukkig',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Eenzaam',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v15,
    type: :range,
    title: 'Zenuwachtig',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v16,
    type: :range,
    title: 'Geliefd',
    labels: ['Helemaal niet', 'Heel erg'],
    tooltip: 'Dit is het gevoel dat andere mensen van je houden',
    required: true
  }, {
    id: :v17,
    type: :range,
    title: 'Gestrest',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v18,
    type: :range,
    title: 'Ontspannen',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v19,
    type: :range,
    title: 'Geïrriteerd',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: true
  }, {
    section_start: '<strong>De volgende vragen gaan over hoe je dag was.</strong> <br> <br>
    Denk aan de <i> voor jou belangrijkste gebeurtenis</i> van vandaag. ',
    id: :v20,
    type: :radio,
    title: 'Hoe leuk was deze gebeurtenis?',
    options: [
      { title: 'Helemaal niet leuk' },
      { title: 'Niet leuk' },
      { title: 'Een beetje leuk', shows_questions: %i[v20a v20b] },
      { title: 'Leuk', shows_questions: %i[v20a v20b] },
      { title: 'Heel erg leuk', shows_questions: %i[v20a v20b] }],
    section_end: false
  }, {
    id: :v20a,
    type: :range,
    hidden: true,
    title: 'Ik heb geprobeerd om het positieve gevoel vast te houden.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v20b,
    type: :range,
    hidden: true,
    title: 'Ik heb teruggedacht aan deze gebeurtenis.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v21,
    type: :radio,
    title: 'Hoe vervelend was deze gebeurtenis?',
    options: [
      { title: 'Helemaal niet vervelend' },
      { title: 'Niet vervelend' },
      { title: 'Een beetje vervelend', shows_questions: %i[v21a v21b] },
      { title: 'Vervelend', shows_questions: %i[v21a v21b] },
      { title: 'Heel erg vervelend', shows_questions: %i[v21a v21b] }],
  }, {
    id: :v21a,
    type: :range,
    hidden: true,
    title: 'Ik heb gepiekerd over deze gebeurtenis.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v21b,
    type: :range,
    hidden: true,
    title: 'Ik heb geprobeerd om niet over deze gebeurtenis na te denken.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v22,
    type: :checkbox,
    title: 'Waar had deze gebeurtenis mee te maken?',
    options: ['Met mijzelf', 'Met mijn ouders of familie', 'Met mijn vrienden', 'Mijn mijn klasgenoten', 'Met iets op social media', 'Met school', 'Met het coronavirus', 'Met onbekenden', 'Met iets wat niet direct met mijzelf te maken had, bijvoorbeeld iets op het nieuws'],
    show_otherwise: true,
    otherwise_label: 'Met iets anders, namelijk:',
    required: true
    },{
    id: :v23,
    type: :radio,
    title: 'Heb je met iemand over deze gebeurtenis gepraat?',
    options: [
      { title: 'Nee, met niemand', shows_questions: %i[v23b] },
      { title: 'Ja, met mijn ouder(s)', shows_questions: %i[v23a] },
      { title: 'Ja, met een vriend(in)', shows_questions: %i[v23a] },
      { title: 'Ja, met een leraar/lerares', shows_questions: %i[v23a] },
      { title: 'Ja, met iemand anders', shows_questions: %i[v23a] }],
    show_otherwise: false
  }, {
    id: :v23a,
    hidden: true,
    type: :checkbox,
    title: 'Hoe reageerde deze persoon toen je over de gebeurtenis vertelde?',
    options: [
      { title: 'Hij/zij werd boos' },
      { title: 'Hij/zij vond het niet belangrijk' },
      { title: 'Hij/zij nam de tijd om naar mij te luisteren' },
      { title: 'Hij/zij troostte me' },
      { title: 'Hij/zij moest lachen' },
      { title: 'Hij/zij knuffelde me' }],
    show_otherwise: true,
    otherwise_label: 'Anders, namelijk:',
    tooltip: 'Je mag meerdere antwoorden kiezen'
  }, {
    id: :v23b,
    type: :range,
    hidden: true,
    title: 'Had je wel met iemand over deze gebeurtenis willen praten?',
    labels: ['Helemaal niet', 'Heel graag'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over hoe het vandaag tussen jou en je ouder (of opvoeder) was. Hiermee bedoelen we één van je ouders of beide ouders.
Dit mag per antwoord verschillend zijn.',
    id: :v24,
    type: :range,
    title: 'We hebben vandaag samen iets leuks gedaan.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: false
  }, {
    id: :v25,
    type: :range,
    title: 'We hebben vandaag ruzie gemaakt.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v26,
    type: :range,
    title: 'We hebben elkaar vandaag een knuffel gegeven.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v27,
    type: :range,
    title: 'Mijn ouder was vandaag boos op mij.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v28,
    type: :range,
    title: 'Vandaag was het leuk of fijn om bij mijn ouder te zijn.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v29,
    type: :range,
    title: 'Ik had het gevoel dat mijn ouder blij was dat ik er was.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over hoe het tussen jou en je vriend(in) was.',
    id: :v30,
    type: :radio,
    title: 'Heb je vandaag een vriend(in) gezien of gesproken?',
    options: [
      { title: 'Ja', shows_questions: %i[v30a v30b v30c v30d] },
      { title: 'Nee', shows_questions: %i[v30e] }],
    show_otherwise: false,
    section_end: false
  }, {
    id: :v30a,
    type: :checkbox,
    title: 'Was dit in het echt of online (bijvoorbeeld via Whatsapp of Zoom)?',
    options: ['In het echt', 'Online'],
    show_otherwise: false
    },{
    id: :v30b,
    type: :range,
    hidden: true,
    title: 'Ik had het gevoel dat ik mezelf kon zijn bij mijn vriend(in).',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v30c,
    type: :range,
    hidden: true,
    title: 'Ik had het gevoel dat mijn vriend(in) blij was om mij te zien/spreken.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v30d,
    type: :range,
    hidden: true,
    title: 'Ik was liever alleen geweest.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v30e,
    type: :range,
    hidden: true,
    title: 'Ik had liever een vriend(in) willen zien of spreken.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: true
  }, {
    section_start: 'De laatste vragen:',
    id: :v31,
    type: :radio,
    title: 'Ik ben vandaag naar school geweest.',
    options: ['Ja', 'Nee'],
    show_otherwise: false,
    section_end: false
    },{
      id: :v32,
    type: :range,
    title: 'Vandaag was een leuke dag.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v33,
    type: :range,
    title: 'Ik ben vandaag buiten geweest.',
    labels: ['Helemaal niet', 'Heel veel'],
    required: true
  }, {
    id: :v34,
    type: :range,
    title: 'Ik heb het vandaag druk gehad.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v35,
    type: :range,
    title: 'Ik heb me vandaag zorgen gemaakt.',
    labels: ['Helemaal niet', 'Heel veel'],
    required: true
  }, {
    id: :v36,
    type: :range,
    title: 'Ik kijk uit naar morgen.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: true
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
