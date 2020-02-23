# frozen_string_literal: true
db_title = 'Eetgedrag van mijn kind'
db_name1 = 'Eetgedrag_Kinderen_Ouderrapportage_4tot11'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> Welkom! Deze vragenlijst gaat over het eetgedrag van uw kind. Er zijn X vragen. Hier bent u ongeveer X minuten mee bezig. Let erop dat de antwoordopties steeds verschillend zijn. Lees daarom elke vraag zorgvuldig.</p>'
  }, {
    id: :v1,
    type: :range,
    title: 'Hoe vindt u dat de maaltijden met uw kind verlopen?',
    labels: ['Zeer moeilijk', 'Zeer makkelijk'],
    required: true
  }, {
    id: :v2,
    type: :range,
    title: 'Hoe bezorgd bent u over het eten van uw kind?',
    labels: ['Niet bezorgd', 'Zeer bezorgd'],
    required: true
  }, {
    id: :v3,
    type: :range,
    title: 'Hoeveel trek (honger) heeft uw kind?',
    labels: ['Nooit honger', 'Flinke trek'],
    required: true
  }, {
    id: :v4,
    type: :range,
    title: 'Wanneer begint uw kind te weigeren, tijdens de maaltijd?',
    labels: ['In het begin', 'Aan het eind'],
    required: true
  }, {
    id: :v5,
    type: :likert,
    title: 'Hoe lang duurt een maaltijd van uw kind (in minuten)?',
    options: ['1-10', '11-20', '21-30', '31-40', '41-50', '51-60', '>60 min']
  }, {
    id: :v6,
    type: :range,
    title: 'Hoe gedraagt uw kind zich tijdens de maaltijd?',
    labels: ['Gedraagt zich goed', 'Doet moeilijk, maakt problemen'],
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Kokhalst, spuugt of braakt uw kind bij bepaalde soorten voeding?',
    labels: ['Nooit', 'Meestal'],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'Houdt uw kind voeding in de mond, zonder het door te slikken?',
    labels: ['Meestal', 'Nooit'],
    required: true
  }, {
    id: :v9,
    type: :range,
    title: 'Moet u uw kind achterna lopen of afleiding gebruiken (zoals speelgoed of TV) om uw kind te laten eten?',
    labels: ['Nooit', 'Meestal'],
    required: true
  }, {
    id: :v10,
    type: :range,
    title: 'Moet u uw kind dwingen om te eten of te drinken?',
    labels: ['Meestal', 'Nooit'],
    required: true
  }, {
    id: :v11,
    type: :range,
    title: 'Hoe goed kan uw kind zuigen en kauwen?',
    labels: ['Zeer goed', 'Zeer slecht'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Hoe vindt u de groei van uw kind?',
    labels: ['Groeit slecht', 'Groeit goed'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Hoe zeer beïnvloedt het eten van uw kind, uw relatie met hem/haar?',
    labels: ['Erg negatief', 'Helemaal niet'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Hoe zeer beïnvloedt het eten van uw kind de gezinsrelaties?',
    labels: ['Helemaal niet', 'Erg negatief'],
    required: true
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
