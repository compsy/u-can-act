# frozen_string_literal: true

title = 'Vrijdag'

name = 'KCT Vrijdag'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

content = [
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
    Wil je hieronder zo eerlijk en nauwkeurig mogelijk aangeven hoe jij je op dit moment voelt?
    '
  },
  {
    id: :v1,
    type: :radio,
    required: true,
    title: 'Hoe inspannend was deze week voor jou?',
    options: [
      '6',
      '7 (heel, heel licht inspannend)',
      '8',
      '9 (heel licht inspannend)',
      '10',
      '11 (licht inspannend)',
      '12',
      '13 (redelijk inspannend)',
      '14',
      '15 (inspannend)',
      '16',
      '17 (heel inspannend)',
      '18',
      '19 (heel, heel inspannend)',
      '20'
    ],
    show_otherwise: false,
  },
  {
    id: :v2,
    type: :radio,
    title: 'Hoe vermoeid voel je je op dit moment?',
    options: [
      '1 (helemaal niet vermoeid)',
      '2',
      '3',
      '4 (neutraal)',
      '5',
      '6',
      '7 (heel erg vermoeid)'
    ],
    show_otherwise: false,
  },
  {
    id: :v3,
    type: :radio,
    title: 'Hoe heb je de afgelopen nachten geslapen?',
    options: [
      '1 (heel erg slecht)',
      '2',
      '3',
      '4 (niet slecht en niet goed)',
      '5',
      '6',
      '7 (heel erg goed)'
    ],
    show_otherwise: false,
  },
  {
    id: :v4,
    type: :radio,
    title: 'Hoeveel spierpijn heb je op dit moment?',
    options: [
      '1 (helemaal geen spierpijn)',
      '2',
      '3',
      '4 (neutraal)',
      '5',
      '6',
      '7 (heel veel spierpijn)'
    ],
    show_otherwise: false,
  },
  {
    id: :v5,
    type: :radio,
    title: 'Hoe gestrest voel je je op dit moment?',
    options: [
      '1 (helemaal niet gestrest)',
      '2',
      '3',
      '4 (neutraal)',
      '5',
      '6',
      '7 (heel erg gestrest)'
    ],
    show_otherwise: false,
  },
  {
    id: :v6,
    type: :radio,
    title: 'Hoe positief is je stemming op dit moment?',
    options: [
      '1 (helemaal niet positief)',
      '2',
      '3',
      '4 (neutraal)',
      '5',
      '6',
      '7 (heel erg positief)'
    ],
    show_otherwise: false,
  },
  {
    id: :v7,
    type: :radio,
    title: 'Hoe negatief is je stemming op dit moment?',
    options: [
      '1 (helemaal niet negatief)',
      '2',
      '3',
      '4 (neutraal)',
      '5',
      '6',
      '7 (heel erg negatief)'
    ],
    show_otherwise: false,
  },
]
questionnaire.content = { questionnaire: content, scores: [] }
questionnaire.title = title
questionnaire.save!
