# frozen_string_literal: true

db_title = 'Creativiteit van mijn kind'

db_name1 = 'Creativiteit_Kinderen_Ouderrapportage'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! De vragenlijst gaat over de krachten van uw kind. Er volgen X vragen. Hier bent u ongeveer X minuten mee bezig.</p>'
  }, {
    section_start: 'De volgende vragen gaan over creativiteit. Verplaats het bolletje naar het antwoord dat het paste bij uw kind past.',
    id: :v1,
    type: :range,
    required: true,
    title: 'Heeft een fantasierijk denkvermogen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    section_end: false
  }, {
    id: :v2,
    type: :range,
    required: true,
    title: 'Heeft gevoel voor humor',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v3,
    type: :range,
    required: true,
    title: 'Bedenkt ongebruikelijke, unieke of slimme oplossingen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v4,
    type: :range,
    required: true,
    title: 'Heeft een avontuurlijk karakter of is niet bang om risicos te nemen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v5,
    type: :range,
    required: true,
    title: 'Komt met veel ideeën of oplossingen voor vragen of problemen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v6,
    type: :range,
    required: true,
    title: 'Ziet humor in situaties waar anderen dat niet zien',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v7,
    type: :range,
    required: true,
    title: 'Kan dingen of ideeën aanpassen of verbeteren',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v8,
    type: :range,
    required: true,
    title: 'Bereid om te fantaseren en met ideeën te spelen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v9,
    type: :range,
    required: true,
    title: 'Niet bang om anders te zijn of om het niet eens te zijn met de gangbare opinie',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v10,
    type: :range,
    required: true,
    title: 'In vergelijking met leeftijdsgenoten, hoe creatief is uw kind?',
    labels: ['Helemaal niet', 'Niet meer of minder', 'Heel erg'],
    section_end: true
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
