# frozen_string_literal: true
db_title = 'Geloof, gebeurtenissen en sociale media'
db_name1 = 'other_factors'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
social_media_options = ['Nooit of bijna nooit', 'Zo nu en dan', 'Soms', 'Vaak', 'Heel vaak']
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Je bent er bijna! <br><br>
        De laatste vragen gaan over een aantal dingen die invloed kunnen hebben op hoe het met je gaat.<br><br>
        De eerste vragen gaan over je geloof. Sommige kinderen geloven in God, Allah of een andere hogere macht. Andere kinderen geloven daar niet in.
    </p>'
  }, {
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'Ben jij gelovig?',
    options: [
      { title: 'Ja', shows_questions: %i[v5_a v5_b v5_c v5_d v5_e] },
      { title: 'Nee' },
      { title: 'Weet ik niet', shows_questions: %i[v5_a v5_b v5_c v5_d v5_e] }
    ]
  }, {
    id: :v2,
    type: :radio,
    show_otherwise: false,
    title: 'Kom je uit een gelovig gezin?',
    options: %w[Ja Nee]
  }, {
    id: :v3,
    type: :radio,
    show_otherwise: false,
    title: 'Ben je in het afgelopen half jaar naar de kerk, de moskee of een andere religieuze dienst geweest?',
    options: ['Ja, ongeveer wekelijks of vaker', 'Ja, één of twee keer per maand', 'Ja, een paar keer', 'Nooit of bijna nooit']
  }, {
    type: :raw,
    content: '<p class="flow-text">Verschuif de slider om aan te geven hoeveel je het eens of oneens bent met de volgende zin(nen).
    </p>'
  }, {
    id: :v4,
    type: :range,
    required: true,
    title: 'Op mijn school speelt geloof een belangrijke rol',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v5_a,
    type: :range,
    hidden: true,
    required: true,
    title: 'Ik geloof dat God, Allah of een andere hogere macht van mij houdt en om mij geeft',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v5_b,
    type: :range,
    hidden: true,
    required: true,
    title: 'Mijn relatie met God, Allah of een andere hogere macht betekent veel voor mij',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v5_c,
    type: :range,
    hidden: true,
    required: true,
    title: 'Ik ervaar niet veel kracht of steun van God, Allah of een andere hogere macht',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v5_d,
    type: :range,
    hidden: true,
    required: true,
    title: 'Ik geloof dat God, Allah of een andere hogere macht geeft om mijn problemen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v5_e,
    type: :range,
    hidden: true,
    required: true,
    title: 'Mijn relatie met God, Allah of een andere hogere macht draagt bij aan mijn geluk',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over dingen die kunnen gebeuren in je leven. Geef voor elke gebeurtenis aan of dit <u><b>het afgelopen half jaar</b></u> in jouw leven gebeurd is.<br><br>
    In het afgelopen half jaar ...
    </p>'
  }, {
    id: :v6,
    type: :radio,
    show_otherwise: false,
    title: 'Ik ben verhuisd',
    options: %w[Ja Nee]
  }, {
    id: :v7,
    type: :radio,
    show_otherwise: false,
    title: 'Iemand in mijn gezin had een ernstig ongeluk of ziekte',
    options: %w[Ja Nee]
  }, {
    id: :v8,
    type: :radio,
    show_otherwise: false,
    title: 'Mijn ouders zijn dit jaar gescheiden',
    options: %w[Ja Nee]
  }, {
    id: :v9,
    type: :radio,
    show_otherwise: false,
    title: 'Ik ben op school geschorst',
    options: %w[Ja Nee]
  }, {
    id: :v10,
    type: :radio,
    show_otherwise: false,
    title: 'Mijn ouders hadden vaak ruzie met elkaar',
    options: %w[Ja Nee]
  }, {
    id: :v11,
    type: :radio,
    show_otherwise: false,
    title: 'Ik had vaak ruzie met mijn ouders',
    options: %w[Ja Nee]
  }, {
    id: :v12,
    type: :radio,
    show_otherwise: false,
    title: 'Mijn vader of moeder is zijn of haar baan kwijtgeraakt',
    options: %w[Ja Nee]
  }, {
    id: :v13,
    type: :radio,
    show_otherwise: false,
    title: 'Ik heb een ernstig ongeluk of ziekte gehad',
    options: %w[Ja Nee]
  }, {
    id: :v14,
    type: :radio,
    show_otherwise: false,
    title: 'De relatie met mijn vriend/vriendin is uitgegaan',
    options: %w[Ja Nee]
  }, {
    id: :v15,
    type: :radio,
    show_otherwise: false,
    title: 'Ik heb slechte cijfers gehaald op school',
    options: %w[Ja Nee]
  }, {
    id: :v16,
    type: :radio,
    show_otherwise: false,
    title: 'Ik heb problemen met de politie gehad',
    options: %w[Ja Nee]
  }, {
    id: :v17,
    type: :radio,
    show_otherwise: false,
    title: 'Mijn ouders hadden geldproblemen',
    options: %w[Ja Nee]
  }, {
    id: :v18,
    type: :radio,
    show_otherwise: false,
    title: 'Ik ben niet toegelaten tot een groep vrienden of een team waar ik graag bij wilde',
    options: %w[Ja Nee]
  }, {
    id: :v19,
    type: :radio,
    show_otherwise: false,
    title: 'Iemand in mijn gezin is gearresteerd',
    options: %w[Ja Nee]
  }, {
    id: :v20,
    type: :radio,
    show_otherwise: false,
    title: 'Er is een nieuwe huisgenoot bij ons gezin komen wonen (bijvoorbeeld een stiefouder, een nieuw broertje of zusje, een stiefbroer of stiefzus, of iemand anders)',
    options: %w[Ja Nee]
  }, {
    id: :v21,
    type: :radio,
    show_otherwise: false,
    title: 'Mensen waar ik vrienden mee was, besteden geen aandacht meer aan mij',
    options: %w[Ja Nee]
  }, {
    id: :v22,
    type: :radio,
    show_otherwise: false,
    title: 'Mijn vader of moeder had psychische problemen',
    options: %w[Ja Nee]
  }, {
    id: :v23,
    type: :radio,
    show_otherwise: false,
    title: 'Mijn vader of moeder had problemen met drugs of alcohol',
    options: %w[Ja Nee]
  }, {
    id: :v24,
    type: :radio,
    show_otherwise: false,
    title: 'Iemand anders in mijn gezin had psychische problemen',
    options: %w[Ja Nee]
  }, {
    id: :v25,
    type: :radio,
    show_otherwise: false,
    title: 'Iemand anders in mijn gezin had problemen met drugs of alcohol',
    options: %w[Ja Nee]
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over of je wel eens rookt, alcohol drinkt of drugs gebruikt. We vertellen je antwoorden nooit aan je ouders, je school of anderen. Denk even terug aan <u>de afgelopen maand</u>. In de afgelopen maand ...
    </p>'
  }, {
    id: :v25_substance1,
    type: :dropdown,
    show_otherwise: false,
    title: 'Hoeveel dagen dronk je <u>geen</u> alcohol?',
    options: (0..30).to_a.map(&:to_s)
  }, {
    id: :v25_substance2,
    type: :dropdown,
    show_otherwise: false,
    title: 'Hoeveel dagen dronk je 1 of 2 glazen alcohol?',
    options: (0..30).to_a.map(&:to_s)
  }, {
    id: :v25_substance3,
    type: :dropdown,
    show_otherwise: false,
    title: 'Hoeveel dagen dronk je 3 of 4 glazen alcohol?',
    options: (0..30).to_a.map(&:to_s)
  }, {
    id: :v25_substance4,
    type: :dropdown,
    show_otherwise: false,
    title: 'Hoeveel dagen dronk je 5 of meer glazen alcohol?',
    options: (0..30).to_a.map(&:to_s)
  }, {
    id: :v25_substance5,
    type: :dropdown,
    show_otherwise: false,
    title: 'Hoeveel dagen rookte je (sigaretten, shag)?',
    options: (0..30).to_a.map(&:to_s)
  }, {
    id: :v25_substance6,
    type: :dropdown,
    show_otherwise: false,
    title: 'Hoeveel dagen gebruikte je cannabis (hasj, wiet)?',
    options: (0..30).to_a.map(&:to_s)
  }, {
    id: :v25_substance7,
    type: :dropdown,
    show_otherwise: false,
    title: "Hoeveel dagen gebruikte je een andere drug? Bijvoorbeeld cocaïne, speed, XTC, GHB of paddo's.",
    options: (0..30).to_a.map(&:to_s)
  }, {
    id: :v25_substance8a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Heb je ooit in een auto of op een brommer of scooter gezeten die bestuurd werd door iemand (inclusief jijzelf) die onder invloed was, of alcohol of drugs had gebruikt?',
    options: ['Ja', 'Nee']
  }, {
    id: :v25_substance8b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Gebruik je wel eens alcohol of drugs om je te ontspannen, om je beter over jezelf te voelen, of om erbij te horen?',
    options: ['Ja', 'Nee']
  }, {
    id: :v25_substance8c,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Gebruik je wel eens alcohol of drugs als er geen anderen bij zijn, als je alleen bent?',
    options: ['Ja', 'Nee']
  }, {
    id: :v25_substance8d,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Vergeet je wel eens dingen die je hebt gedaan terwijl je alcohol of drugs gebruikte?',
    options: ['Ja', 'Nee']
  }, {
    id: :v25_substance8e,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Zeggen je familie of vrienden wel eens tegen je dat je je alcohol- of drugsgebruik zou moeten verminderen?',
    options: ['Ja', 'Nee']
  }, {
    id: :v25_substance8f,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Ben je ooit in de problemen gekomen terwijl je alcohol of drugs gebruikte?',
    options: ['Ja', 'Nee']
  }, {
    type: :raw,
    content: '<p class="flow-text">De laatste vragen gaan over hoe jij sociale media gebruikt.
    </p>'
  }, {
    id: :v25_a,
    type: :checkbox,
    show_otherwise: false,
    required: true,
    title: 'Welke sociale media gebruik jij weleens?',
    options: [
      { title: 'WhatsApp', shows_questions: %i[v25_b v26_a v26_b v27_a v27_b v28_a v28_b v28_c] },
      { title: 'Instagram', shows_questions: %i[v25_b v26_a v26_b v27_a v27_b v28_a v28_b v28_c] },
      { title: 'YouTube', shows_questions: %i[v25_b v26_a v26_b v27_a v27_b v28_a v28_b v28_c] },
      { title: 'Snapchat', shows_questions: %i[v25_b v26_a v26_b v27_a v27_b v28_a v28_b v28_c] },
      { title: 'Facebook', shows_questions: %i[v25_b v26_a v26_b v27_a v27_b v28_a v28_b v28_c] },
      { title: 'Pinterest', shows_questions: %i[v25_b v26_a v26_b v27_a v27_b v28_a v28_b v28_c] },
      { title: 'Twitter', shows_questions: %i[v25_b v26_a v26_b v27_a v27_b v28_a v28_b v28_c] },
      { title: 'TikTok', shows_questions: %i[v25_b v26_a v26_b v27_a v27_b v28_a v28_b v28_c] },
      { title: 'Twitch', shows_questions: %i[v25_b v26_a v26_b v27_a v27_b v28_a v28_b v28_c] },
      { title: 'Iets anders', shows_questions: %i[v25_b v26_a v26_b v27_a v27_b v28_a v28_b v28_c] },
      { title: 'Ik gebruik helemaal geen sociale media' }
    ]
  }, {
    id: :v25_b,
    type: :checkbox,
    show_otherwise: false,
    required: true,
    hidden: true,
    title: 'Welke sociale media gebruik jij <b>dagelijks of bijna dagelijks</b>?',
    options: [
      { title: 'WhatsApp' },
      { title: 'Instagram' },
      { title: 'YouTube' },
      { title: 'Snapchat' },
      { title: 'Facebook' },
      { title: 'Pinterest' },
      { title: 'Twitter' },
      { title: 'TikTok' },
      { title: 'Twitch' },
      { title: 'Iets anders' },
      { title: 'Ik gebruik geen van deze sociale media dagelijks of bijna dagelijks' }
    ]
  }, {
    id: :v26_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Hoe vaak ben je in de afgelopen maand bezig geweest met sociale media?',
    options: ['Bijna de hele dag door', 'Een paar keer per dag', 'Dagelijks', 'Een paar keer per week', 'Wekelijks', 'Nooit of bijna nooit']
  }, {
    id: :v26_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Hoeveel tijd heb je in de afgelopen maand ongeveer per dag aan sociale media besteed?',
    options: ['Meer dan 6 uur', '3 à 6 uur', '1 à 3 uur', 'Minder dan een uur']
  }, {
    id: :v27_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Hoe vaak heb je in de afgelopen maand op sociale media gezeten terwijl je eigenlijk iets anders moest doen?',
    options: social_media_options
  }, {
    id: :v27_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Hoe vaak heb je in de afgelopen maand langer op sociale media gezeten dan je eigenlijk wou?',
    options: social_media_options
  }, {
    id: :v28_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Heb je in de afgelopen maand je ontevreden gevoeld omdat je <b>meer</b> tijd aan sociale media had willen besteden?',
    options: social_media_options
  }, {
    id: :v28_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: "Heb je in de afgelopen maand geen interesse gehad in hobby's of andere bezigheden omdat je liever met sociale media bezig was?",
    options: social_media_options
  }, {
    id: :v28_c,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Heb je in de afgelopen maand sociale media gebruikt om niet aan vervelende dingen te hoeven denken?',
    options: social_media_options
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!