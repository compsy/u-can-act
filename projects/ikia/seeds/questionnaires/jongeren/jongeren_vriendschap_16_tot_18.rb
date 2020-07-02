# frozen_string_literal: true

db_title = 'Vriendschap'
db_name1 = 'Vriendschap_Jongeren_16tot18'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! De volgende vragen gaan over vriendschap, en hoe jij daarover denkt. </p>'
  }, {
    section_start: 'Bedenk bij elke zin hoe waar deze voor jou is. Verplaats het bolletje naar het antwoord dat het beste past.',
    id: :v1_1,
    type: :range,
    title: 'Ik heb één of meerdere vrienden of vriendinnen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true,
    section_end: false
  }, {
    id: :v1_2,
    type: :range,
    title: 'Ik vind dat ik minder vriend(inn)en heb dan anderen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_3,
    type: :range,
    title: 'Ik voel me geïsoleerd van anderen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_4,
    type: :range,
    title: 'Ik voel me uitgestoten door mijn klasgenoten.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_5,
    type: :range,
    title: 'Ik verlang meer opgenomen te worden door mijn klasgenoten.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_6,
    type: :range,
    title: 'Vriend(inn)en maken is moeilijk voor mij.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_7,
    type: :range,
    title: 'Ik ben bang dat anderen me niet laten meedoen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_8,
    type: :range,
    title: 'Op school voel ik me alleen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_9,
    type: :range,
    title: 'Ik denk: er is geen enkele vriend(in) aan wie ik alles kan vertellen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_10,
    type: :range,
    title: 'Ik voel me in de steek gelaten door mijn vriend(inn)en.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_11,
    type: :range,
    title: 'Ik voel me aan de kant gezet door mijn vriend(inn)en.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_12,
    type: :range,
    title: 'Ik ben verdrietig omdat niemand met me mee wil doen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_13,
    type: :range,
    title: 'Ik ben verdrietig omdat ik geen vriend(inn)en heb.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true,
    section_end: true
  }, {
    id: :v2_1,
    type: :radio,
    title: 'Ik heb een <b>beste</b> vriend(in).',
    show_otherwise: false,
    options: [
      { title: 'Ja', shows_questions: %i[v2_2 v2_3 v2_4 v2_5 v2_6 v2_7 v2_8 v2_9 v2_10
v2_11 v2_12 v2_13 v2_14 v2_15 v2_16 v2_17 v2_18 v2_19 v2_20
v2_21 v2_22 v2_23 v2_24] },
      { title: 'Nee', shows_questions: %i[v2_25] }]
  }, {
    section_start: 'De volgende vragen gaan over jou en je <b>beste vriend(in)</b>. Verplaats het bolletje naar het antwoord dat het beste past.',
    id: :v2_2,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) en ik brengen bijna al onze vrije tijd samen door.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true,
    section_end: false
  }, {
    id: :v2_3,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) en ik hebben weleens ruzie met elkaar.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_4,
    type: :range,
    hidden: true,
    title: 'Als ik mijn eten vergeet of wat geld nodig heb, dan zou mijn vriend(in) me dat lenen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_5,
    type: :range,
    hidden: true,
    title: 'Als ik problemen heb kan ik er met mijn vriend(in) over praten.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_6,
    type: :range,
    hidden: true,
    title: 'Als mijn vriend(in) zou verhuizen zou ik hem/haar missen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_7,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) bedenkt leuke dingen om samen te doen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_8,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) kan me irriteren of lastig vallen ook al vraag ik hem/haar om dit niet te doen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_9,
    type: :range,
    hidden: true,
    title: 'Als iemand me lastig valt, dan zou mijn vriend(in) me helpen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_10,
    type: :range,
    hidden: true,
    title: 'Als ik sorry zou zeggen na een ruzie, dan zou mijn vriend(in) nog steeds boos zijn.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_11,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) is blij voor me als ik iets goed gedaan heb.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_12,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) en ik komen vaak bij elkaar thuis na schooltijd en in het weekend.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_13,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) en ik zijn vaak boos op elkaar.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_14,
    type: :range,
    hidden: true,
    title: 'Als ik niet weet hoe iets moet, dan helpt mijn vriend(in) mij.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_15,
    type: :range,
    hidden: true,
    title: 'Ik kan het mijn vriend(in) vertellen als me iets dwars zit, zelfs als ik dit niet aan anderen kan vertellen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_16,
    type: :range,
    hidden: true,
    title: 'Ik voel me blij als ik bij mijn vriend(in) ben.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_17,
    type: :range,
    hidden: true,
    title: 'Soms zitten mijn vriend(in) en ik alleen maar te kletsen over van alles, zoals school, sport, of dingen die we leuk vinden.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_18,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) en ik zijn het over veel dingen niet eens.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_19,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) komt voor mij op als andere mensen gemeen tegen mij doen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_20,
    type: :range,
    hidden: true,
    title: 'Als één van ons iets doet wat de ander vervelend vindt, maken mijn vriend(in) en ik het snel goed.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_21,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) geeft me weleens het gevoel dat ik bijzonder ben.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_22,
    type: :range,
    hidden: true,
    title: 'Mijn vriend(in) helpt mij als ik dat nodig heb.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_23,
    type: :range,
    hidden: true,
    title: 'Als mijn vriend(in) en ‘sorry’ zeggen als we ruzie hebben, dan is het weer goed tussen ons.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_24,
    type: :range,
    hidden: true,
    title: 'Ik denk aan mijn vriend(in), ook als hij/zij er niet is.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v2_25,
    type: :range,
    hidden: true,
    title: 'Ik zou graag een beste vriend(in) willen hebben.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true,
    section_end: true
  }]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Samen zijn',
      ids: %i[v2_2 v2_7 v2_12 v2_17],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Hulp en bescherming',
      ids: %i[v2_4 v2_14 v2_22 v2_9 v2_19],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Emotionele band',
      ids: %i[v2_6 v2_16 v2_24 v2_11 v2_21],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s4,
      label: 'Ruzies en irritaties',
      ids: %i[v2_3 v2_8 v2_13 v2_18],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s5,
      label: 'Ruzies goedmaken',
      ids: %i[v2_10 v2_20 v2_23],
      preprocessing: {
        v2_10: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s6,
      label: 'Eenzaamheid',
      ids: %i[v1_2 v1_3 v1_4 v1_5 v1_6 v1_7 v1_8 v1_9 v1_10 v1_11 v1_12 v1_13],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
