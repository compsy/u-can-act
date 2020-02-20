# frozen_string_literal: true

db_title = 'Krachten'
db_name1 = 'Krachten_Kinderen_8en9jaar'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! Deze vragenlijst gaat over krachten. Er volgen X vragen. Hier ben je ongeveer X minuten mee bezig.</p>'
  }, {
    id: :v1_1,
    type: :range,
    title: 'In vergelijking met anderen van jouw leeftijd, hoe creatief ben jij?',
    labels: ['Helemaal niet creatief', 'Net zo creatief', 'Heel erg creatief'],
    required: true
  }, {
    section_start: 'In hoeverre passen de volgende uitspraken bij jou? Verplaats het bolletje naar het antwoord dat het beste bij je past.',
    id: :v1_2,
    type: :range,
    title: 'Ik bedenk verschillende manieren om opdrachten uit te werken',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: false
  }, {
    id: :v1_3,
    type: :range,
    title: 'Ik bedenk nieuwe dingen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v1_4,
    type: :range,
    title: 'Ik heb altijd veel ideeën als ik een opdracht krijg',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v1_5,
    type: :range,
    title: 'Ik maak nieuwe dingen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v1_6,
    type: :range,
    title: 'Ik probeer meer manieren uit',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v1_7,
    type: :range,
    title: 'Ik maak dingen die voor mij nieuw zijn',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v1_8,
    type: :range,
    title: 'Ik kom zomaar op ideeën',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende zinnen gaan over gevoelens die je kan hebben, en hoe je met de gevoelens van anderen om kan gaan. Geef bij elke zin aan hoe waar deze voor jou is. Verschuif het bolletje naar het antwoord dat het beste bij jou past.',
    id: :v3_1,
    type: :range,
    required: true,
    title: 'Als mijn moeder blij is, word ik daar blij van.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar'],
    section_end: false
  }, {
    id: :v3_2,
    type: :range,
    required: true,
    title: 'Ik begrijp dat een klasgenoot zich schaamt als hij iets verkeerds heeft gedaan.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_3,
    type: :range,
    required: true,
    title: 'Als een vriend(in) verdrietig is, wil ik graag troosten.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_4,
    type: :range,
    required: true,
    title: 'Ik voel me vervelend als twee mensen ruzie maken.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_5,
    type: :range,
    required: true,
    title: 'Als een vriend(in) boos is, weet ik meestal wel waarom.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_6,
    type: :range,
    required: true,
    title: 'Ik wil graag helpen als een klasgenootje boos is.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_7,
    type: :range,
    required: true,
    title: 'Als een vriend(in) verdrietig is, word ik ook verdrietig.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_8,
    type: :range,
    required: true,
    title: 'Ik begrijp dat een klasgenoot trots is als hij iets goeds heeft gedaan.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_9,
    type: :range,
    required: true,
    title: 'Als een vriend(in) ruzie heeft, probeer ik te helpen.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_10,
    type: :range,
    required: true,
    title: 'Als een vriend(in) plezier heeft, moet ik ook lachen. ',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_11,
    type: :range,
    required: true,
    title: 'Als een vriend(in) verdrietig is, begrijp ik vaak waarom.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_12,
    type: :range,
    required: true,
    title: 'Ik wil graag dat iedereen zich goed voelt.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_13,
    type: :range,
    required: true,
    title: 'Als een vriend(in) huilt, moet ik zelf ook huilen.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_14,
    type: :range,
    required: true,
    title: 'Als een klasgenootje moet huilen, begrijp ik vaak wat er is gebeurd.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_15,
    type: :range,
    required: true,
    title: 'Als een klasgenootje verdrietig is, wil ik graag iets doen om het beter te maken.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_16,
    type: :range,
    required: true,
    title: 'Als iemand in mijn familie verdrietig is, voel ik me erg naar.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_17,
    type: :range,
    required: true,
    title: 'Ik vind het leuk een vriend(in) een cadeautje te geven.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar']
  }, {
    id: :v3_18,
    type: :range,
    required: true,
    title: 'Als een vriend(in) kwaad is, word ik ook naar.',
    labels: ['Helemaal niet waar', 'Beetje waar', 'Waar'],
    section_end: true
  }, {
    section_start: 'Tot slot...',
    id: :v5,
    type: :expandable,
    title: 'Schrijf alle dingen op die kunt doen met een melkpak',
    default_expansions: 1,
    max_expansions: 30,
    content: [{
                id: :v5_1,
                type: :textarea,
                title: 'Wat kun je doen met een melkpak?',
                tooltip: 'Bijvoorbeeld: een pennenhouder van maken'}],
    section_end: true
  }]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
