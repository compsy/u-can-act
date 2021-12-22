# frozen_string_literal: true

db_title = ''
db_name1 = 'eq5d5l_rheumatism'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Zet bij iedere groep in de lijst hieronder een kruisje in het hokje dat het best past bij uw gezondheid VANDAAG.</p>',
  }, {
    id: :v1,
    type: :radio,
    title: 'MOBILITEIT',
    options: [
      'Ik heb geen problemen met lopen',
      'Ik heb een beetje problemen met lopen',
      'Ik heb matige problemen met lopen',
      'Ik heb ernstige problemen met lopen',
      'Ik ben niet in staat om te lopen'
    ],
    show_otherwise: false
  }, {
    id: :v2,
    type: :radio,
    title: 'ZELFZORG',
    options: [
      'Ik heb geen problemen met mijzelf wassen of aankleden',
      'Ik heb een beetje problemen met mijzelf wassen of aankleden',
      'Ik heb matige problemen met mijzelf wassen of aankleden',
      'Ik heb ernstige problemen met mijzelf wassen of aankleden',
      'Ik ben niet in staat mijzelf te wassen of aan te kleden'
    ],
    show_otherwise: false
  }, {
    id: :v3,
    type: :radio,
    title: 'DAGELIJKSE ACTIVITEITEN (bijv. werk, studie, huishouden, gezins- en vrijetijdsactiviteiten)',
    options: [
      'Ik heb geen problemen met mijn dagelijkse activiteiten',
      'Ik heb een beetje problemen met mijn dagelijkse activiteiten',
      'Ik heb matige problemen met mijn dagelijkse activiteiten',
      'Ik heb ernstige problemen met mijn dagelijkse activiteiten',
      'Ik ben niet in staat mijn dagelijkse activiteiten uit te voeren'
    ],
    show_otherwise: false
  }, {
    id: :v4,
    type: :radio,
    title: 'PIJN/ONGEMAK',
    options: [
      'Ik heb geen pijn of ongemak',
      'Ik heb een beetje pijn of ongemak',
      'Ik heb matige pijn of ongemak',
      'Ik heb ernstige pijn of ongemak',
      'Ik heb extreme pijn of ongemak'
    ],
    show_otherwise: false
  }, {
    id: :v5,
    type: :radio,
    title: 'ANGST/SOMBERHEID',
    options: [
      'Ik ben niet angstig of somber',
      'Ik ben een beetje angstig of somber',
      'Ik ben matig angstig of somber',
      'Ik ben erg angstig of somber',
      'Ik ben extreem angstig of somber'
    ],
    show_otherwise: false
  }, {
    id: :v6,
    type: :range,
    title: 'We willen weten hoe goed of slecht uw gezondheid VANDAAG is. De onderstaande meetschaal loopt van 0 tot 100. 100 staat voor de <strong>beste</strong> gezondheid die u zich kunt voorstellen. 0 staat voor de <strong>slechtste</strong> gezondheid die u zich kunt voorstellen. Klik hieronder op de meetschaal om aan te geven hoe uw gezondheid VANDAAG is.',
    labels: ['De slechtste gezondheid die u zich kunt voorstellen', 'De beste gezondheid die u zich kunt voorstellen'],
    no_initial_thumb: true,
    required: true
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
