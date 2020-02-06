# frozen_string_literal: true

db_title = 'Mijn gevoelens'

db_name1 = 'Emoties_Ouders_Zelf'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! Deze vragenlijst gaat over uw eigen gevoelens. Er zijn 40 vragen. Hier bent u ongeveer X minuten mee bezig.</p>'
  }, {
    section_start: 'Denk terug aan hoe u zich de afgelopen twee weken voelde. Geef bij elk gevoel hieronder aan in hoeverre u zich zo gevoeld heeft. Verplaats het bolletje naar het antwoord dat het beste bij u past.',
    id: :v1,
    type: :range,
    title: 'Gelukkig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v2,
    type: :range,
    title: 'Zenuwachtig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v3,
    type: :range,
    title: 'Kalm',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v4,
    type: :range,
    title: 'Boos',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v5,
    type: :range,
    title: 'Vrolijk',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v6,
    type: :range,
    title: 'Geliefd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Eenzaam',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'Trots',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v9,
    type: :range,
    title: 'Verdrietig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v10,
    type: :range,
    title: 'Bang',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v11,
    type: :range,
    title: 'Vol energie',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Gestrest',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Geïnteresseerd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Sterk',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v15,
    type: :range,
    title: 'Ontspannen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v16,
    type: :range,
    title: 'Schaamte',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v17,
    type: :range,
    title: 'Moe',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v18,
    type: :range,
    title: 'Geïrriteerd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v19,
    type: :range,
    title: 'Tevreden',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v20,
    type: :range,
    title: 'Somber',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over hoe u zich zou <i>willen</i> voelen. Stelt u zich het allerbeste en fijnste leven voor dat u kunt hebben. Geef aan in hoeverre u de volgende gevoelens zou willen hebben in dit allerbeste leven. Verplaats het bolletje naar het antwoord dat het beste bij u past.',
    id: :v21,
    type: :range,
    title: 'Gelukkig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: false
  }, {
    id: :v22,
    type: :range,
    title: 'Zenuwachtig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v23,
    type: :range,
    title: 'Kalm',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v24,
    type: :range,
    title: 'Boos',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v25,
    type: :range,
    title: 'Vrolijk',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v26,
    type: :range,
    title: 'Geliefd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v27,
    type: :range,
    title: 'Eenzaam',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v28,
    type: :range,
    title: 'Trots',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v29,
    type: :range,
    title: 'Verdrietig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v30,
    type: :range,
    title: 'Bang',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v31,
    type: :range,
    title: 'Vol energie',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v32,
    type: :range,
    title: 'Gestrest',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v33,
    type: :range,
    title: 'Geïnteresseerd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v34,
    type: :range,
    title: 'Sterk',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v35,
    type: :range,
    title: 'Ontspannen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v36,
    type: :range,
    title: 'Schaamte',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v37,
    type: :range,
    title: 'Moe',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v38,
    type: :range,
    title: 'Geïrriteerd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v39,
    type: :range,
    title: 'Tevreden',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v40,
    type: :range,
    title: 'Somber',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: true
  }
]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
