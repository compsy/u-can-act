# frozen_string_literal: true

title = 'Start van de week'

name = 'KCT Start van de week'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_injury_question(id, title)
  res = {
    id: id,
    type: :likert,
    required: true,
    title: title,
    show_otherwise: false,
    options: %w[1 2 3]
  }
  res
end

content = [
  {
    id: :v1,
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
    </p>

    <p>
      De vragen lopen van <b>0 (helemaal niet van toepassing)</b> tot <b>6 (volledig van toepassing)</b>.
    </p>
    '
  }, {
    section_start: 'Deel 1: Beoordeel hoe jij je <b>nu voelt</b> in relatie tot je beste herstel-status ooit.',
    id: :v2,
    type: :likert,
    required: true,
    title: '<b>Physical Performance Capability</b>, bijv. fysiek sterk; fit; energiek; vol kracht.',
    options: %w[0 1 2 3 4 5 6],
    show_otherwise: false,
  }, {
    id: :v3,
    type: :likert,
    title: '<b>Mental Performance Capability</b>, bijv. attent/oplettend; ontvankelijk, gevoelig; geconcentreerd; alert.',
    options: %w[0 1 2 3 4 5 6],
    show_otherwise: false,
  }, {
    id: :v4,
    type: :likert,
    title: '<b>Emotional Balance</b>, bijv. tevreden; evenwichtig; in een goede bui; alles onder controle hebben; stabiel; verheugd.',
    options: %w[0 1 2 3 4 5 6],
    show_otherwise: false,
  }, {
    id: :v5,
    type: :likert,
    title: '<b>Overall Recovery (herstel)</b>, bijv. teruggewonnen; uitgerust; spierontspanning; fysiek ontspannen.',
    options: %w[0 1 2 3 4 5 6],
    show_otherwise: false,
    section_end: true
  }, {
    section_start: 'Deel 2: Geef onderstaand per item aan hoe jij je <b>nu voelt</b> in relatie tot je hoogste <b>stress-toestand</b> ooit.',
    id: :v6,
    type: :likert,
    title: '<b>Muscular Stress</b>, bijv. stijve spieren; spierpijn; vermoeide spieren.',
    options: %w[0 1 2 3 4 5 6],
    show_otherwise: false,
  }, {
    id: :v7,
    type: :likert,
    title: '<b>Lack of Activation</b>, bijv. ongemotiveerd; ongeïnteresseerd; geen fut; loom / weinig energie.',
    options: %w[0 1 2 3 4 5 6],
    show_otherwise: false,
  }, {
    id: :v8,
    type: :likert,
    title: '<b>Negative Emotional State</b>, bijv. neerslachtig; gestressed; geërgerd; kort lontje; verdrietig.',
    options: %w[0 1 2 3 4 5 6],
    show_otherwise: false,
  }, {
    id: :v9,
    type: :likert,
    title: '<b>Overall Stress</b>, bijv. moe; uitgeput; overbelast; fysiek afgemat.',
    options: %w[0 1 2 3 4 5 6],
    show_otherwise: false,
    section_end: true,
  }, {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
      Geef, met behulp van onderstaande afbeelding, zo nauwkeurig mogelijk de plaats(en) op het lichaam aan waar je de afgelopen dagen klachten had en hoeveel last je had.
    </p>

    <img src="/images/questionnaires/kct/blessures.jpg" style="width: 80%; margin-left: 3rem;" />

    <p class="flow-text section-explanation">
      De betekenis van de cijfers 1 tot en met 5 is als volgt:

      <ul class="flow-text section-explanation">
        <li>
        1 = geen last
        </li>

        <li>
        2 = een beetje last
        </li>

        <li>
        3 = heel veel last
        </li>
      </ul>
    </p>
    '
  },
  create_injury_question(:v10, 'Hoofd'),
  create_injury_question(:v11, 'Hals/nek'),
  create_injury_question(:v12, 'Borst'),
  create_injury_question(:v13, 'Pols/hand'),
  create_injury_question(:v14, 'Buik'),
  create_injury_question(:v15, 'Schouder'),
  {
    type: :raw,
    content: '<img src="/images/questionnaires/kct/blessures.jpg" style="width: 80%; margin-left: 3rem;" />'
  },
  create_injury_question(:v16, 'Rug thoracaal'),
  create_injury_question(:v17, 'Lage rug'),
  create_injury_question(:v18, 'Bekken'),
  create_injury_question(:v19, 'Pols/hand'),
  create_injury_question(:v20, 'Bovenbeen'),
  create_injury_question(:v21, 'Knie'),
  create_injury_question(:v22, 'Onderbeen'),
  create_injury_question(:v23, 'Enkel'),
]

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
