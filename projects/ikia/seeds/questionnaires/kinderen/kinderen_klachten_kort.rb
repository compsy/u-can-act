# frozen_string_literal: true

db_title = 'Binnenwereld en buitenwereld'
db_name1 = 'Klachten_Kort_Kinderen_11plus'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">De volgende vragenlijst gaat over moeilijkheden die kinderen kunnen hebben. Het invullen duurt ongeveer 10 minuten.</p>'
  }, {
    section_start: 'Bedenk bij elke zin of dit de <i>afgelopen zes maanden</i> zo bij jou is geweest. Verplaats het bolletje naar het antwoord wat het beste bij jou past:',
    id: :v1,
    type: :range,
    title: 'Ik probeer aardig te zijn tegen anderen. Ik houd rekening met hun gevoelens.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true,
    section_end: false
  }, {
    id: :v2,
    type: :range,
    title: 'Ik ben rusteloos, ik kan niet lang stilzitten.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v3,
    type: :range,
    title: 'Ik heb vaak hoofdpijn, buikpijn, of ik ben misselijk.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v4,
    type: :range,
    title: 'Ik deel gemakkelijk met anderen (snoep, speelgoed, potloden, enz.).',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v5,
    type: :range,
    title: 'Ik word erg boos en ben vaak driftig.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v6,
    type: :range,
    title: 'Ik ben nogal op mijzelf. Ik speel meestal alleen of bemoei mij niet met anderen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Ik doe meestal wat me wordt opgedragen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'Ik pieker veel.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v9,
    type: :range,
    title: 'Ik help iemand die zich heeft bezeerd, van streek is of zich ziek voelt.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v10,
    type: :range,
    title: 'Ik zit constant te wiebelen of te friemelen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v11,
    type: :range,
    title: 'Ik heb minstens één goede vriend of vriendin.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Ik vecht vaak. Het lukt mij andere mensen te laten doen wat ik wil.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Ik ben vaak ongelukkig, in de put of in tranen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Andere jongeren van mijn leeftijd vinden mij over het algemeen aardig.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v15,
    type: :range,
    title: 'Ik ben snel afgeleid, ik vind het moeilijk om me te concentreren.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v16,
    type: :range,
    title: 'Ik ben zenuwachtig in nieuwe situaties. Ik verlies makkelijk mijn zelfvertrouwen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v17,
    type: :range,
    title: 'Ik ben aardig tegen jongere kinderen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v18,
    type: :range,
    title: 'Ik word er vaak van beschuldigd dat ik lieg of bedrieg.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v19,
    type: :range,
    title: 'Andere kinderen of jongeren pesten of treiteren mij.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar']
  }, {
    id: :v20,
    type: :range,
    title: 'Ik bied vaak anderen aan hun te helpen (ouders, leerkrachten, kinderen).',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v21,
    type: :range,
    title: 'Ik denk na voor ik iets doe.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v22,
    type: :range,
    title: 'Ik steel of jat dingen die niet van mij zijn (thuis, op school of op andere plaatsen).',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v23,
    type: :range,
    title: 'Ik kan beter met volwassenen opschieten dan met jongeren van mijn leeftijd.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v24,
    type: :range,
    title: 'Ik ben voor heel veel dingen bang, ik ben snel angstig.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v25,
    type: :range,
    title: 'Ik maak af waar ik mee bezig ben. Ik kan mijn aandacht er goed bij houden.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over of jij denkt dat je problemen hebt met gevoelens, concentratie, gedrag en opschieten met andere mensen.',
    id: :v26,
    title: 'Denk je dat je problemen hebt met gevoelens?',
    type: :likert,
    options: [
      { title: 'Nee' },
      { title: 'Ja, kleine problemen', shows_questions: %i[v26_a, v26_b, v26_c, v26_d, v26_e, v26_f, v26_g] },
      { title: 'Ja, duidelijke problemen', shows_questions: %i[v26_a, v26_b, v26_c, v26_d, v26_e, v26_f, v26_g] },
      { title: 'Ja, ernstige problemen', shows_questions: %i[v26_a, v26_b, v26_c, v26_d, v26_e, v26_f, v26_g] }
    ],
    section_end: false
  }, {
    id: :v26_a,
    hidden: true,
    type: :likert,
    title: 'Hoe lang bestaan deze problemen met gevoelens?',
    options: [
      { title: 'Korter dan een maand' },
      { title: '1-5 maanden' },
      { title: '6-12 maanden' },
      { title: 'Meer dan een jaar' }
    ]
  }, {
    id: :v26_b,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen met gevoelens je overstuur of van slag?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v26_c,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen met gevoelens jouw leven lastiger op de volgende gebieden?<br><br>Thuis:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v26_d,
    hidden: true,
    type: :likert,
    title: 'Vriendschappen:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v26_e,
    hidden: true,
    type: :likert,
    title: 'Leren in de klas:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v26_f,
    hidden: true,
    type: :likert,
    title: 'Wat je doet in je vrije tijd:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v26_g,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen met gevoelens het lastiger voor de mensen in jouw omgeving (je gezin, vrienden, leerkrachten, enz.)?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v27,
    type: :likert,
    title: 'Denk je dat je problemen hebt met concentreren?',
    options: [
      { title: 'Nee' },
      { title: 'Ja, kleine problemen', shows_questions: %i[v27_a, v27_b, v27_c, v27_d, v27_e, v27_f, v27_g] },
      { title: 'Ja, duidelijke problemen', shows_questions: %i[v27_a, v27_b, v27_c, v27_d, v27_e, v27_f, v27_g] },
      { title: 'Ja, ernstige problemen', shows_questions: %i[v27_a, v27_b, v27_c, v27_d, v27_e, v27_f, v27_g] }
    ],
    tooltip: 'Concentreren betekent dat je je aandacht ergens bij kunt houden'
  }, {
    id: :v27_a,
    hidden: true,
    type: :likert,
    title: 'Hoe lang bestaan deze problemen met concentreren?',
    options: [
      { title: 'Korter dan een maand' },
      { title: '1-5 maanden' },
      { title: '6-12 maanden' },
      { title: 'Meer dan een jaar' }
    ]
  }, {
    id: :v27_b,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen met concentreren je overstuur of van slag?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v27_c,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen met concentratie jouw leven lastiger op de volgende gebieden?<br><br>Thuis:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v27_d,
    hidden: true,
    type: :likert,
    title: 'Vriendschappen:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v27_e,
    hidden: true,
    type: :likert,
    title: 'Leren in de klas:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v27_f,
    hidden: true,
    type: :likert,
    title: 'Wat je doet in je vrije tijd:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v27_g,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen met concentreren het lastiger voor de mensen in jouw omgeving (je gezin, vrienden, leerkrachten, enz.)?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v28,
    type: :likert,
    title: 'Denk je dat je problemen hebt met je gedrag?',
    options: [
      { title: 'Nee' },
      { title: 'Ja, kleine moeilijkheden', shows_questions: %i[v28_a, v28_b, v28_c, v28_d, v28_e, v28_f, v28_g] },
      { title: 'Ja, duidelijke moeilijkheden', shows_questions: %i[v28_a, v28_b, v28_c, v28_d, v28_e, v28_f, v28_g] },
      { title: 'Ja, ernstige moeilijkheden', shows_questions: %i[v28_a, v28_b, v28_c, v28_d, v28_e, v28_f, v28_g] }
    ]
  }, {
    id: :v28_a,
    hidden: true,
    type: :likert,
    title: 'Hoe lang bestaan deze problemen met je gedrag?',
    options: [
      { title: 'Korter dan een maand' },
      { title: '1-5 maanden' },
      { title: '6-12 maanden' },
      { title: 'Meer dan een jaar' }
    ]
  }, {
    id: :v28_b,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen met je gedrag je overstuur of van slag?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v28_c,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen met je gedrag jouw leven lastiger op de volgende gebieden?<br><br>Thuis:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v28_d,
    hidden: true,
    type: :likert,
    title: 'Vriendschappen:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v28_e,
    hidden: true,
    type: :likert,
    title: 'Leren in de klas:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v28_f,
    hidden: true,
    type: :likert,
    title: 'Wat je doet in je vrije tijd:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v28_g,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen met je gedrag het lastiger voor de mensen in jouw omgeving (je gezin, vrienden, leerkrachten, enz.)?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v29,
    type: :likert,
    title: 'Denk je dat je problemen hebt om met andere mensen op te schieten?',
    options: [
      { title: 'Nee' },
      { title: 'Ja, kleine moeilijkheden', shows_questions: %i[v29_a, v29_b, v29_c, v29_d, v29_e, v29_f, v29_g] },
      { title: 'Ja, duidelijke moeilijkheden', shows_questions: %i[v29_a, v29_b, v29_c, v29_d, v29_e, v29_f, v29_g] },
      { title: 'Ja, ernstige moeilijkheden', shows_questions: %i[v29_a, v29_b, v29_c, v29_d, v29_e, v29_f, v29_g] }
    ]
  }, {
    id: :v29_a,
    hidden: true,
    type: :likert,
    title: 'Hoe lang bestaan deze problemen om met andere mensen op te schieten?',
    options: [
      { title: 'Korter dan een maand' },
      { title: '1-5 maanden' },
      { title: '6-12 maanden' },
      { title: 'Meer dan een jaar' }
    ]
  }, {
    id: :v29_b,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen om met andere mensen op te schieten je overstuur of van slag?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v29_c,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen om met andere mensen op te schieten jouw leven lastiger op de volgende gebieden?<br><br>Thuis:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v29_d,
    hidden: true,
    type: :likert,
    title: 'Vriendschappen:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v29_e,
    hidden: true,
    type: :likert,
    title: 'Leren in de klas:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v29_f,
    hidden: true,
    type: :likert,
    title: 'Wat je doet in je vrije tijd:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v29_g,
    hidden: true,
    type: :likert,
    title: 'Maken de problemen om met andere mensen op te schieten het lastiger voor de mensen in jouw omgeving (je gezin, vrienden, leerkrachten, enz.)?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg'],
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over wat je denkt, voelt en doet. Lees elke zin goed en bedenk hoe waar deze uitspraak voor jou is. Verplaats het bolletje naar het antwoord dat het beste bij jou past:',
    id: :v30,
    type: :range,
    title: 'Mijn leven zal pas goed zijn als ik me gelukkig voel.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true,
    section_end: false
  }, {
    id: :v31,
    type: :range,
    title: 'Mijn gedachten en gevoelens verpesten mijn leven.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v32,
    type: :range,
    title: 'Als ik mij verdrietig of angstig voel, dan moet er iets mis zijn met mij.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v33,
    type: :range,
    title: 'De slechte dingen die ik over mezelf denk, moeten wel waar zijn.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v34,
    type: :range,
    title: 'Ik probeer geen nieuwe dingen uit, als ik bang ben dat ik het niet kan of goed doe.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v35,
    type: :range,
    title: 'Ik moet van mijn zorgen en angsten afkomen, zodat ik een goed leven kan hebben.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v36,
    type: :range,
    title: 'Als ik bij andere mensen ben, doe ik erg mijn best om niet dom over te komen.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v37,
    type: :range,
    title: 'Ik doe erg mijn best om pijnlijke herinneringen te vergeten.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v38,
    type: :range,
    title: 'Ik kan er niet tegen om pijn te voelen in mijn lichaam. ',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v39,
    type: :range,
    title: 'Als mijn hart snel klopt, dan moet er iets mis zijn met mij.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v40,
    type: :range,
    title: 'Gedachten en gevoelens die ik niet fijn vind, duw ik weg.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v41,
    type: :range,
    title: 'Als ik me slecht voel, stop ik met het doen van dingen die belangrijk voor me zijn. ',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v42,
    type: :range,
    title: 'Ik presteer slechter op school als ik gedachten heb die me verdrietig maken.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v43,
    type: :range,
    title: 'Ik zeg dingen zodat ik overkom als een ‘cool’ persoon.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v44,
    type: :range,
    title: 'Ik zou willen dat ik met een toverstok kon zwaaien om al mijn verdriet te laten verdwijnen.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v45,
    type: :range,
    title: 'Ik ben bang voor mijn gevoelens.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v46,
    type: :range,
    title: 'Ik kan geen goede vriend(in) zijn als ik van streek ben.',
    labels: ['Helemaal niet waar', 'Best wel waar', 'Heel erg waar'],
    required: true,
    section_end: true
  }
]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Binnenwereld',
      ids: %i[v3 v8 v13 v16 v24 v6 v11 v14 v19 v23],
      preprocessing: {
        v11: invert,
        v14: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Buitenwereld',
      ids: %i[v5 v7 v12 v18 v22 v2 v10 v15 v21 v25],
      preprocessing: {
        v7: invert,
        v21: invert,
        v25: invert
      },
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
