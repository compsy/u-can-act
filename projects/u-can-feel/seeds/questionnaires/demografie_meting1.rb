# frozen_string_literal: true
db_title = 'Start'
db_name1 = 'demografie'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! We beginnen ons onderzoek met een paar vragen over wie je bent en over jouw thuis.
</p>'
  }, {
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'Ben je een jongen of een meisje?',
    options: %w[Jongen Meisje Anders]
  }, {
    id: :v2,
    type: :dropdown,
    show_otherwise: false,
    title: 'Hoe oud ben je?',
    options: (8..21).to_a.map(&:to_s)
  }, {
    id: :v3,
    type: :radio,
    show_otherwise: false,
    title: 'In welk schooljaar zit je?',
    options: [
      { title: 'Eerste klas' },
      { title: 'Tweede klas', shows_questions: %i[v4_b] },
      { title: 'Derde klas', shows_questions: %i[v4_b] },
      { title: 'Vierde klas', shows_questions: %i[v4_b] },
      { title: 'Vijfde klas', shows_questions: %i[v4_b] },
      { title: 'Zesde klas', shows_questions: %i[v4_b] }
    ]
  }, {
    id: :v4_a,
    type: :checkbox,
    required: true,
    show_otherwise: false,
    title: 'Op welk schoolniveau zit je? Als je in een combinatieklas zit, kun je meerdere niveaus aanklikken.',
    options: ['VMBO basis', 'VMBO kader', 'VMBO gemengd', 'VMBO-TL', 'Havo', 'Vwo, atheneum of gymnasium']
  }, {
    id: :v4_b,
    type: :checkbox,
    hidden: true,
    required: true,
    show_otherwise: false,
    title: 'Op welk schoolniveau ben je in de eerste klas begonnen? Je kunt weer meerdere niveaus aanklikken.',
    options: ['VMBO basis', 'VMBO kader', 'VMBO gemengd', 'VMBO-TL', 'Havo', 'Vwo, atheneum of gymnasium']
  }, {
    id: :v4_c,
    type: :checkbox,
    required: true,
    show_otherwise: false,
    title: 'Welk advies had je op de basisschool gekregen voor je schoolniveau? Je kunt weer meerdere niveaus aanklikken.',
    options: ['VMBO basis', 'VMBO kader', 'VMBO gemengd', 'VMBO-TL', 'Havo', 'Vwo, atheneum of gymnasium', 'Anders', 'Geen advies', 'Ik weet het niet meer']
  },{
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over je thuis. Hiermee bedoelen we het huis waarin je woont. In dit huis woont ook een volwassene die voor je zorgt. Sommige jongeren hebben meer dan 1 thuis.
</p>'
  }, {
    id: :v5,
    type: :radio,
    show_otherwise: false,
    title: 'In hoeveel verschillende huizen woon je?',
    options: [
      { title: '1 huis', shows_questions: %i[v6_a v6_b] },
      { title: '2 of meer huizen', shows_questions: %i[v7_a v7_b v7_c v7_d] }
    ]
  }, {
    id: :v6_a,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Woon je in dit huis met je ouders? We bedoelen hiermee je vader of moeder, geen pleegouders of stiefouders',
    options: ['Ja, beide ouders', 'Ja, een van beide ouders', 'Nee, <u>geen</u> van beide ouders']
  }, {
    id: :v6_b,
    type: :checkbox,
    hidden: true,
    required: true,
    show_otherwise: false,
    title: 'Wie wonen er nog meer bij je in dit huis? Je kunt meerdere opties aanvinken.',
    options: ['Niemand anders', 'Een stiefouder of vriend/vriendin van je ouder', '(Half)broer(tjes) of zus(jes)', 'Stiefbroer(tjes) of stiefzus(jes)', 'Opa of oma', 'Pleegouder(s)', 'Andere volwassenen', 'Andere kinderen']
  }, {
    id: :v7_a,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'De volgende vragen gaan over het huis waar je het grootste deel van de tijd woont. Als je ongeveer even vaak in twee verschillende huizen slaapt (bijvoorbeeld de helft van de week bij je moeder en de andere helft bij je vader), kies dan gewoon één van de huizen waar je woont. Hoeveel nachten per week slaap je ongeveer in dit huis?',
    options: ['Minder dan 1 nacht per week', '1 nacht per week', '2 nachten per week', '3 nachten per week', '4 nachten per week', '5 nachten per week', '6 nachten per week', '7 nachten per week']
  }, {
    id: :v7_b,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Woon je in dit huis met je ouders? We bedoelen hiermee je vader of moeder, geen pleegouders of stiefouders',
    options: ['Ja, beide ouders', 'Ja, een van beide ouders', 'Nee, <u>geen</u> van beide ouders']
  }, {
    id: :v7_c,
    type: :checkbox,
    hidden: true,
    required: true,
    show_otherwise: false,
    title: 'Wie wonen er nog meer bij je in dit huis? Je kunt meerdere opties aanvinken.',
    options: ['Niemand anders', 'Een stiefouder of vriend/vriendin van je ouder', '(Half)broer(tjes) of zus(jes)', 'Stiefbroer(tjes) of stiefzus(jes)', 'Opa of oma', 'Pleegouder(s)', 'Andere volwassenen', 'Andere kinderen']
  }, {
    id: :v7_d,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Woon je hiernaast nog in een ander huis?',
    options: [
      { title: 'Ja', shows_questions: %i[v8_a v8_b v8_c v8_d] },
      { title: 'Nee' }
    ]
  }, {
    id: :v8_a,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Hoeveel nachten per week slaap je in dit andere huis?',
    options: ['Minder dan 1 nacht per week', '1 nacht per week', '2 nachten per week', '3 nachten per week', '4 nachten per week', '5 nachten per week', '6 nachten per week', '7 nachten per week']
  }, {
    id: :v8_b,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Woon je in dit huis met je ouders? We bedoelen hiermee je vader of moeder, geen pleegouders of stiefouders',
    options: ['Ja, beide ouders', 'Ja, een van beide ouders', 'Nee, <u>geen</u> van beide ouders']
  }, {
    id: :v8_c,
    type: :checkbox,
    hidden: true,
    required: true,
    show_otherwise: false,
    title: 'Wie wonen er nog meer bij je in dit huis? Je kunt meerdere opties aanvinken.',
    options: ['Niemand anders', 'Een stiefouder of vriend/vriendin van je ouder', '(Half)broer(tjes) of zus(jes)', 'Stiefbroer(tjes) of stiefzus(jes)', 'Opa of oma', 'Pleegouder(s)', 'Andere volwassenen', 'Andere kinderen']
  }, {
    id: :v8_d,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Woon je hiernaast nog in een ander huis?',
    options: [
      { title: 'Ja', shows_questions: %i[v9_a v9_b v9_c] },
      { title: 'Nee' }
    ]
  }, {
    id: :v9_a,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Hoeveel nachten per week slaap je in dit andere huis?',
    options: ['Minder dan 1 nacht per week', '1 nacht per week', '2 nachten per week', '3 nachten per week', '4 nachten per week', '5 nachten per week', '6 nachten per week', '7 nachten per week']
  }, {
    id: :v9_b,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Woon je in dit huis met je ouders? We bedoelen hiermee je vader of moeder, geen pleegouders of stiefouders',
    options: ['Ja, beide ouders', 'Ja, een van beide ouders', 'Nee, <u>geen</u> van beide ouders']
  }, {
    id: :v9_c,
    type: :checkbox,
    hidden: true,
    required: true,
    show_otherwise: false,
    title: 'Wie wonen er nog meer bij je in dit huis? Je kunt meerdere opties aanvinken.',
    options: ['Niemand anders', 'Een stiefouder of vriend/vriendin van je ouder', '(Half)broer(tjes) of zus(jes)', 'Stiefbroer(tjes) of stiefzus(jes)', 'Opa of oma', 'Pleegouder(s)', 'Andere volwassenen', 'Andere kinderen']
  } 
]




dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!