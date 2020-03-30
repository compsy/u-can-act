# frozen_string_literal: true
db_title = 'Klachten (deel 1)'
db_name1 = 'Klachten_Kind_Kort_Ouderrapportage'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> De volgende vragenlijst gaat over klachten die kinderen kunnen hebben. Geef bij elke zin aan in hoeverre deze waar is voor uw kind door het bolletje te verplaatsen. Baseer uw antwoorden op het gedrag van uw kind gedurende <i>de laatste zes maanden</i>. Het invullen kost u ongeveer 10 minuten.</p>'
  }, {
    section_start: 'Mijn kind…',
    id: :v1,
    type: :range,
    title: 'Houdt rekening met gevoelens van anderen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true,
    section_end: false
  }, {
    id: :v2,
    type: :range,
    title: 'Is rusteloos, overactief, kan niet lang stilzitten.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v3,
    type: :range,
    title: 'Klaagt vaak over hoofdpijn, buikpijn, of misselijkheid.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v4,
    type: :range,
    title: 'Deelt gemakkelijk met andere kinderen (bijvoorbeeld speelgoed, snoep, potloden).',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v5,
    type: :range,
    title: 'Heeft vaak driftbuien of woede-uitbarstingen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v6,
    type: :range,
    title: 'Is nogal op zichzelf, neigt er toe alleen te spelen of te zijn.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Is doorgaans gehoorzaam, doet gewoonlijk wat volwassenen vragen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'Heeft veel zorgen, lijkt vaak over dingen in te zitten.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v9,
    type: :range,
    title: 'Is behulpzaam als iemand zich heeft bezeerd, van streek is of zich ziek voelt.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v10,
    type: :range,
    title: 'Is constant aan het wiebelen of friemelen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v11,
    type: :range,
    title: 'Heeft minstens één goede vriend of vriendin.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Vecht vaak met andere kinderen of pest ze.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Is vaak ongelukkig, in de put of in tranen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Wordt over het algemeen aardig gevonden door andere kinderen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v15,
    type: :range,
    title: 'Is gemakkelijk afgeleid, heeft moeite om zich te concentreren.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v16,
    type: :range,
    title: 'Is zenuwachtig of zich vastklampend in nieuwe situaties, verliest makkelijk zelfvertrouwen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v17,
    type: :range,
    title: 'Is aardig tegen jongere kinderen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v18,
    type: :range,
    title: 'Liegt of bedriegt vaak.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v19,
    type: :range,
    title: 'Wordt getreiterd of gepest door andere kinderen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v20,
    type: :range,
    title: 'Biedt vaak vrijwillig hulp aan anderen (ouders, leerkrachten, andere kinderen).',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v21,
    type: :range,
    title: 'Denkt na voor iets te doen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v22,
    type: :range,
    title: 'Steelt dingen thuis, op school of op andere plaatsen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v23,
    type: :range,
    title: 'Kan beter opschieten met volwassenen dan met andere kinderen.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v24,
    type: :range,
    title: 'Is voor heel veel bang, is snel angstig.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true
  }, {
    id: :v25,
    type: :range,
    title: 'Maakt opdrachten af, kan de aandacht goed vasthouden.',
    labels: ['Niet waar', 'Een beetje waar', 'Zeker waar'],
    required: true,
    section_end: true
  }, {
    id: :v26,
    title: 'Denkt u dat uw kind moeilijkheden heeft met emoties?',
    type: :likert,
    options: [
      {title: 'Nee'},
      {title: 'Ja, kleine moeilijkheden', shows_questions: %i[v26_a, v26_b, v26_c, v26_d, v26_e, v26_f, v26_g]},
      {title: 'Ja, duidelijke moeilijkheden', shows_questions: %i[v26_a, v26_b, v26_c, v26_d, v26_e, v26_f, v26_g]},
      {title: 'Ja, ernstige moeilijkheden', shows_questions: %i[v26_a, v26_b, v26_c, v26_d, v26_e, v26_f, v26_g]}
    ]
  }, {
    id: :v26_a,
    hidden: true,
    type: :likert,
    title: 'Hoe lang bestaan deze moeilijkheden met emoties?',
    options: [
      {title: 'Korter dan een maand'},
      {title: '1-5 maanden'},
      {title: '6-12 maanden'},
      {title: 'Meer dan een jaar'}
    ]
  }, {
    id: :v26_b,
    hidden: true,
    type: :likert,
    title: 'Maken deze moeilijkheden met emoties uw kind overstuur of van slag?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v26_c,
    hidden: true,
    type: :likert,
    title: 'Belemmeren deze moeilijkheden met emoties het dagelijkse leven van uw kind op de volgende gebieden?<br><br>Thuis:',
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
    title: 'Activiteiten in de vrije tijd:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v26_g,
    hidden: true,
    type: :likert,
    title: 'Belasten deze moeilijkheden met emoties u of het gezin als geheel?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v27,
    type: :likert,
    title: 'Denkt u dat uw kind moeilijkheden heeft met concentratie?',
    options: [
      {title: 'Nee'},
      {title: 'Ja, kleine moeilijkheden', shows_questions: %i[v27_a, v27_b, v27_c, v27_d, v27_e, v27_f, v27_g]},
      {title: 'Ja, duidelijke moeilijkheden', shows_questions: %i[v27_a, v27_b, v27_c, v27_d, v27_e, v27_f, v27_g]},
      {title: 'Ja, ernstige moeilijkheden', shows_questions: %i[v27_a, v27_b, v27_c, v27_d, v27_e, v27_f, v27_g]}
    ]
  }, {
    id: :v27_a,
    hidden: true,
    type: :likert,
    title: 'Hoe lang bestaan deze moeilijkheden met concentratie?',
    options: [
      {title: 'Korter dan een maand'},
      {title: '1-5 maanden'},
      {title: '6-12 maanden'},
      {title: 'Meer dan een jaar'}
    ]
  }, {
    id: :v27_b,
    hidden: true,
    type: :likert,
    title: 'Maken deze moeilijkheden met concentratie uw kind overstuur of van slag?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v27_c,
    hidden: true,
    type: :likert,
    title: 'Belemmeren deze moeilijkheden met concentratie het dagelijkse leven van uw kind op de volgende gebieden?<br><br>Thuis:',
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
    title: 'Activiteiten in de vrije tijd:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v27_g,
    hidden: true,
    type: :likert,
    title: 'Belasten deze moeilijkheden met concentratie u of het gezin als geheel?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v28,
    type: :likert,
    title: 'Denkt u dat uw kind moeilijkheden heeft met gedrag?',
    options: [
      {title: 'Nee'},
      {title: 'Ja, kleine moeilijkheden', shows_questions: %i[v28_a, v28_b, v28_c, v28_d, v28_e, v28_f, v28_g]},
      {title: 'Ja, duidelijke moeilijkheden', shows_questions: %i[v28_a, v28_b, v28_c, v28_d, v28_e, v28_f, v28_g]},
      {title: 'Ja, ernstige moeilijkheden', shows_questions: %i[v28_a, v28_b, v28_c, v28_d, v28_e, v28_f, v28_g]}
    ]
  }, {
    id: :v28_a,
    hidden: true,
    type: :likert,
    title: 'Hoe lang bestaan deze moeilijkheden met gedrag?',
    options: [
      {title: 'Korter dan een maand'},
      {title: '1-5 maanden'},
      {title: '6-12 maanden'},
      {title: 'Meer dan een jaar'}
    ]
  }, {
    id: :v28_b,
    hidden: true,
    type: :likert,
    title: 'Maken deze moeilijkheden met gedrag uw kind overstuur of van slag?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v28_c,
    hidden: true,
    type: :likert,
    title: 'Belemmeren deze moeilijkheden met gedrag het dagelijkse leven van uw kind op de volgende gebieden?<br><br>Thuis:',
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
    title: 'Activiteiten in de vrije tijd:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v28_g,
    hidden: true,
    type: :likert,
    title: 'Belasten deze moeilijkheden met gedrag u of het gezin als geheel?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v29,
    type: :likert,
    title: 'Denkt u dat uw kind moeilijkheden heeft met sociaal contact?',
    options: [
      {title: 'Nee'},
      {title: 'Ja, kleine moeilijkheden', shows_questions: %i[v29_a, v29_b, v29_c, v29_d, v29_e, v29_f, v29_g]},
      {title: 'Ja, duidelijke moeilijkheden', shows_questions: %i[v29_a, v29_b, v29_c, v29_d, v29_e, v29_f, v29_g]},
      {title: 'Ja, ernstige moeilijkheden', shows_questions: %i[v29_a, v29_b, v29_c, v29_d, v29_e, v29_f, v29_g]}
    ]
  }, {
    id: :v29_a,
    hidden: true,
    type: :likert,
    title: 'Hoe lang bestaan deze moeilijkheden met sociaal contact?',
    options: [
      {title: 'Korter dan een maand'},
      {title: '1-5 maanden'},
      {title: '6-12 maanden'},
      {title: 'Meer dan een jaar'}
    ]
  }, {
    id: :v29_b,
    hidden: true,
    type: :likert,
    title: 'Maken deze moeilijkheden met sociaal contact uw kind overstuur of van slag?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v29_c,
    hidden: true,
    type: :likert,
    title: 'Belemmeren deze moeilijkheden met sociaal contact het dagelijkse leven van uw kind op de volgende gebieden?<br><br>Thuis:',
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
    title: 'Activiteiten in de vrije tijd:',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
  }, {
    id: :v29_g,
    hidden: true,
    type: :likert,
    title: 'Belasten deze moeilijkheden met sociaal contact u of het gezin als geheel?',
    options: ['Helemaal niet', 'Een beetje maar', 'Behoorlijk', 'Heel erg']
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
