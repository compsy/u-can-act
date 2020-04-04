# frozen_string_literal: true
db_title = 'Eetgedrag'
db_name1 = 'Eetgedrag_Kinderen_Ouderrapportage_4tot11'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

likert_options = [
  { title: '1-10', numeric_value: 0.0 },
  { title: '11-20', numeric_value: 16.67 },
  { title: '21-30', numeric_value: 33.33 },
  { title: '31-40', numeric_value: 50.0 },
  { title: '41-50', numeric_value: 66.67 },
  { title: '51-60', numeric_value: 83.33 },
  { title: '>60 min', numeric_value: 100.0 }
]
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> Welkom! Deze vragenlijst gaat over het eetgedrag van uw kind. Het invullen duurt ongeveer 5 minuten. Let erop dat de antwoordopties steeds verschillend zijn. Lees daarom elke vraag zorgvuldig.</p>'
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
    type: :range,
    title: 'Hoe lang duurt een maaltijd van uw kind (in minuten)?',
    labels: ['0 minuten', '60 minuten of meer'],
    required: true
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
  },{
 id: :v2_1,
    type: :radio,
    title: 'Volgt uw kind een dieet of aangepast voedingspatroon?',
    options: [
      {title: 'Ja', shows_questions: %i[v2_2]},
      {title: 'Nee'}],
    show_otherwise: false
    },{
      id: :v2_2,
      hidden: true,
      type: :checkbox,
      title: 'Om welk dieet of aangepast voedingspatroon gaat het?',
      options: [
        'Vegetarisch', 
        'Veganistisch', 
        'Lactose- of koemelkvrij',
        'Glutenvrij',
        'Pinda- of notenvrij']
      show_otherwise: true,
      tooltip: 'Meerdere antwoorden mogelijk'
      },       
]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Eetgedrag',
      ids: %i[v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14],
      preprocessing: {
        v1: invert,
        v3: invert,
        v4: invert,
        v8: invert,
        v10: invert,
        v12: invert,
        v13: invert
      },
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
