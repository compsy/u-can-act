# frozen_string_literal: true

db_title = 'Gevoelens'
db_name1 = 'Emoties_Kind_Ouderrapportage'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Deze vragenlijst gaat over gevoelens van uw kind. In deze vragenlijst onderzoeken we hoe uw kind zich de afgelopen tijd gevoeld heeft.</p>'
  }, {
    section_start: 'Geef bij elk gevoel hieronder aan in welke mate u denkt dat uw kind zich <i>in de afgelopen twee weken</i>zo gevoeld heeft. Verplaats het bolletje naar het antwoord dat het beste past.',
    id: :v1,
    type: :range,
    title: 'Gelukkig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: false
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
    title: 'Beschaamd',
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
  }
]
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Positieve emoties',
      ids: %i[v1 v3 v5 v6 v8 v11 v13 v14 v15 v19],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Negatieve emoties',
      ids: %i[v2 v4 v7 v9 v10 v12 v16 v17 v18 v20],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
