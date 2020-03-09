# frozen_string_literal: true

db_title = 'Krachten'

db_name1 = 'Creativiteit_Kinderen4tm11_Ouderrapportage'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! De vragenlijst gaat over de krachten van uw kind. Er volgen X vragen. Hier bent u ongeveer X minuten mee bezig.</p>'
  }, {
    section_start: 'De volgende vragen gaan over creativiteit. Verplaats het bolletje naar het antwoord dat het beste bij uw kind past.',
    id: :v1,
    type: :range,
    required: true,
    title: 'Mijn kind heeft een fantasierijk denkvermogen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    section_end: false
  }, {
    id: :v2,
    type: :range,
    required: true,
    title: 'Mijn kind heeft gevoel voor humor',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v3,
    type: :range,
    required: true,
    title: 'Mijn kind bedenkt ongebruikelijke, unieke of slimme oplossingen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v4,
    type: :range,
    required: true,
    title: 'Mijn kind heeft een avontuurlijk karakter of is niet bang om risicos te nemen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v5,
    type: :range,
    required: true,
    title: 'Mijn kind komt met veel ideeën of oplossingen voor vragen of problemen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v6,
    type: :range,
    required: true,
    title: 'Mijn kind ziet humor in situaties waar anderen dat niet zien',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v7,
    type: :range,
    required: true,
    title: 'Mijn kind kan dingen of ideeën aanpassen of verbeteren',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v8,
    type: :range,
    required: true,
    title: 'Mijn kind is bereid om te fantaseren en met ideeën te spelen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v9,
    type: :range,
    required: true,
    title: 'Mijn kind is niet bang om anders te zijn of om het niet eens te zijn met de gangbare opinie',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg']
  }, {
    id: :v10,
    type: :range,
    required: true,
    title: 'In vergelijking met leeftijdsgenoten, hoe creatief is uw kind?',
    labels: ['Helemaal niet', 'Niet meer of minder', 'Heel erg'],
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over gevoelens die uw kind kan hebben, en hoe hij/zij met de gevoelens van anderen omgaat. Verplaats het bolletje naar het antwoord dat het beste bij uw kind past.',
    id: :v2_1,
    type: :range,
    required: true,
    title: 'Als ik blij ben, wordt mijn kind daar blij van.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar'],
    section_end: false
  }, {
    id: :v2_2,
    type: :range,
    required: true,
    title: 'Mijn kind begrijpt dat een klasgenoot zich schaamt als diegene iets verkeerd heeft gedaan.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_3,
    type: :range,
    required: true,
    title: 'Als een vriend(in) van mijn kind verdrietig is, wil mijn kind diegene graag troosten.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_4,
    type: :range,
    required: true,
    title: 'Mijn kind voelt zich vervelend als twee mensen ruzie maken.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_5,
    type: :range,
    required: true,
    title: 'Als een vriend(in) van mijn kind boos is, begrijpt mijn kind meestal wel waarom.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_6,
    type: :range,
    required: true,
    title: 'Mijn kind wil graag helpen als een familielid boos is.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_7,
    type: :range,
    required: true,
    title: 'Als een vriend(in) van mijn kind verdrietig is, wordt mijn kind ook verdrietig.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_8,
    type: :range,
    required: true,
    title: 'Mijn kind begrijpt dat een klasgenoot trots is als diegene iets goed gedaan heeft.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_9,
    type: :range,
    required: true,
    title: 'Als een vriend(in) van mijn kind ruzie heeft, probeert mijn kind te helpen.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_10,
    type: :range,
    required: true,
    title: 'Als een familielid plezier heeft, moet mijn kind ook lachen.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_11,
    type: :range,
    required: true,
    title: 'Als een vriend(in) van mijn kind verdrietig is, begrijpt mijn kind vaak waarom.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_12,
    type: :range,
    required: true,
    title: 'Mijn kind wil graag dat iedereen zich goed voelt.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_13,
    type: :range,
    required: true,
    title: 'Als een familielid huilt, moet mijn kind zelf ook huilen.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_14,
    type: :range,
    required: true,
    title: 'Als een klasgenootje moet huilen, begrijpt mijn kind vaak wat er is gebeurd.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_15,
    type: :range,
    required: true,
    title: 'Als een klasgenootje verdrietig is, wil mijn kind graag iets doen om het beter te maken.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_16,
    type: :range,
    required: true,
    title: 'Mijn kind voelt zich naar als iemand in zijn/haar familie verdrietig is.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_17,
    type: :range,
    required: true,
    title: 'Mijn kind vindt het leuk om een vriend(in) een cadeautje te geven.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar']
  }, {
    id: :v2_18,
    type: :range,
    required: true,
    title: 'Als een vriend(in) van mijn kind kwaad is, wordt mijn kind ook naar.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Waar'],
    section_end: true
  }
]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Creativiteit',
      ids: %i[v1 v2 v3 v4 v5 v6 v7 v8 v9],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Empathie',
      ids: %i[v2_1 v2_2 v2_3 v2_4 v2_5 v2_6 v2_7 v2_8 v2_9 v2_10 v2_11 v2_12 v2_13 v2_14 v2_15 v2_16 v2_17 v2_18],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
