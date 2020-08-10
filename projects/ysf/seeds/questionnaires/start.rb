# frozen_string_literal: true

title = 'Start'

name = 'KCT Start van de week'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_injury_question(id, title)
  res = {
    id: id,
    type: :radio,
    title: title,
    show_otherwise: false,
    options: [
      '1 (geen last)',
      '2',
      '3 (een beetje last)',
      '4',
      '5 (heel veel last)'
    ]
  }
  res
end

content = [
  {
    id: :v0,
    type: :textfield,
    required: true,
    title: 'Gewicht',
    placeholder: '... kilogram'
  }, {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
    Hieronder vind je een lijst met uitdrukkingen die verschillende aspecten van je huidige staat van herstel en stresstoestand beschrijven.
    Deze vragenlijst wordt gebruikt als hulpmiddel om jou en de gehele groep zo goed mogelijk te kunnen begeleiden tijdens de opleiding.
    '
  }, {
    section_start: 'Deel 1: Beoordeel hoe jij je <b>nu voelt</b> in relatie tot je beste herstel-status ooit.',
    id: :v1,
    type: :radio,
    required: true,
    title: '<b>Physical Performance Capability</b>, bijv. fysiek sterk; fit; energiek; vol kracht.',
    options: [
      '0 (helemaal niet van toepassing)',
      '1',
      '2',
      '3 (neutraal)',
      '4',
      '5',
      '6 (volledig van toepassing)',
    ],
    show_otherwise: false,
  }, {
    id: :v2,
    type: :radio,
    title: '<b>Mental Performance Capability</b>, bijv. attent/oplettend; ontvankelijk, gevoelig; geconcentreerd; alert.',
    options: [
      '0 (helemaal niet van toepassing)',
      '1',
      '2',
      '3 (neutraal)',
      '4',
      '5',
      '6 (volledig van toepassing)',
    ],
    show_otherwise: false,
  }, {
    id: :v3,
    type: :radio,
    title: '<b>Emotional Balance</b>, bijv. tevreden; evenwichtig; in een goede bui; alles onder controle hebben; stabiel; verheugd.',
    options: [
      '0 (helemaal niet van toepassing)',
      '1',
      '2',
      '3 (neutraal)',
      '4',
      '5',
      '6 (volledig van toepassing)',
    ],
    show_otherwise: false,
  }, {
    id: :v4,
    type: :radio,
    title: '<b>Overall Recovery (herstel)</b>, bijv. teruggewonnen; uitgerust; spierontspanning; fysiek ontspannen.',
    options: [
      '0 (helemaal niet van toepassing)',
      '1',
      '2',
      '3 (neutraal)',
      '4',
      '5',
      '6 (volledig van toepassing)',
    ],
    show_otherwise: false,
    section_end: true
  }, {
    section_start: 'Deel 2: Geef onderstaand per item aan hoe jij je <b>nu voelt</b> in relatie tot je hoogste <b>stress-toestand</b> ooit.',
    id: :v5,
    type: :radio,
    title: '<b>Muscular Stress</b>, bijv. stijve spieren; spierpijn; vermoeide spieren.',
    options: [
      '0 (helemaal niet van toepassing)',
      '1',
      '2',
      '3 (neutraal)',
      '4',
      '5',
      '6 (volledig van toepassing)',
    ],
    show_otherwise: false,
  }, {
    id: :v6,
    type: :radio,
    title: '<b>Lack of Activation</b>, bijv. ongemotiveerd; ongeïnteresseerd; geen fut; loom / weinig energie.',
    options: [
      '0 (helemaal niet van toepassing)',
      '1',
      '2',
      '3 (neutraal)',
      '4',
      '5',
      '6 (volledig van toepassing)',
    ],
    show_otherwise: false,
  }, {
    id: :v7,
    type: :radio,
    title: '<b>Negative Emotional State</b>, bijv. neerslachtig; gestressed; geërgerd; kort lontje; verdrietig.',
    options: [
      '0 (helemaal niet van toepassing)',
      '1',
      '2',
      '3 (neutraal)',
      '4',
      '5',
      '6 (volledig van toepassing)',
    ],
    show_otherwise: false,
  }, {
    id: :v8,
    type: :radio,
    title: '<b>Overall Stress</b>, bijv. moe; uitgeput; overbelast; fysiek afgemat.',
    options: [
      '0 (helemaal niet van toepassing)',
      '1',
      '2',
      '3 (neutraal)',
      '4',
      '5',
      '6 (volledig van toepassing)',
    ],
    show_otherwise: false,
    section_end: true,
  }, {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
    Geef, met behulp van onderstaande afbeelding, zo nauwkeurig mogelijk de plaats(en) op het lichaam aan waar je de afgelopen dagen klachten had en hoeveel last je had.

    <p class=\"flow-text\">#{title}</p><img src=\"/images/questionnaires/kct/blessures.jpg\" style=\"width: 80%; margin-left: 3rem;\" />
    </p>
    '
  },
  create_injury_question(:v9, 'Hoofd'),
  create_injury_question(:v10, 'Hals/nek'),
  create_injury_question(:v11, 'Borst'),
  create_injury_question(:v12, 'Pols/hand'),
  create_injury_question(:v13, 'Buik'),
  create_injury_question(:v14, 'Schouder'),
  create_injury_question(:v15, 'Rug thoracaal'),
  create_injury_question(:v16, 'Lage rug'),
  create_injury_question(:v17, 'Bekken'),
  create_injury_question(:v18, 'Pols/hand'),
  create_injury_question(:v19, 'Bovenbeen'),
  create_injury_question(:v20, 'Knie'),
  create_injury_question(:v21, 'Onderbeen'),
  create_injury_question(:v22, 'Enkel'),
]

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
