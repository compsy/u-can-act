# frozen_string_literal: true

title = 'Start van de week'

name = 'KCT Start van de week'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_ponder_question(id, title, negative, positive)
  {
    id: id,
    type: :likert,
    required: true,
    title: title,
    options: [
      sprintf('1 (%s)', negative),
      '2',
      '3',
      '4',
      '5',
      '6',
      sprintf('7 (%s)', positive)
    ],
    show_otherwise: false
  }
end

def create_srss_question(title, examples)
  res = {
    id: title.gsub(/\s+/, "_").downcase.to_sym,
    type: :likert,
    required: true,
    title: sprintf('<b>%s</b>, bijvoorbeeld: %s.', title, examples),
    options: [
      '0 (helemaal niet van toepassing)',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6 (helemaal van toepassing)'
    ],
    show_otherwise: false
  }
  res
end

content = [
  {
    id: :gewicht,
    type: :textfield,
    required: true,
    title: 'Gewicht',
    placeholder: '... kilogram'
  }, {
    id: :herstel,
    type: :radio,
    required: true,
    title: 'Hoe goed ben je hersteld?',
    options: [
      '6',
      '7 (heel, heel slecht hersteld)',
      '8',
      '9 (heel slecht hersteld)',
      '10',
      '11 (slecht hersteld)',
      '12',
      '13 (redelijk hersteld)',
      '14',
      '15 (goed hersteld)',
      '16',
      '17 (heel goed hersteld)',
      '18',
      '19 (heel, heel goed hersteld)',
      '20'
    ],
    show_otherwise: false,
  },
  create_ponder_question(
    :vertrouwen,
    'Hoe zeker ben je ervan dat je het einde van de week kan halen?',
    'helemaal niet zeker',
    'heel erg zeker'
  ),
  create_ponder_question(
    :motivatie,
    'Hoe gemotiveerd ben je om het einde van de week te halen?',
    'helemaal niet gemotiveerd',
    'heel erg gemotiveerd'
  ),
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
      Hieronder vind je een lijst met uitdrukkingen, die verschillende aspecten van jouw hersteltoestand beschrijven.
      Geef aan hoe jij je <b>op dit moment</b> voelt, in vergelijking met je beste hersteltoestand ooit.
    </p>
    '
  },
  create_srss_question('Fysiek prestatievermogen', 'sterk; fysiek fit; energiek; vol energie'),
  create_srss_question('Mentaal prestatievermogen', 'alert; ontvankelijk; mentaal scherp; geconcentreerd'),
  create_srss_question('Emotionele balans', 'tevreden; stabiel; in een goede bui; alles onder controle hebben'),
  create_srss_question('Algeheel herstel', 'hersteld; uitgerust; ontspannen spieren; fysiek ontspannen'),
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
      Hieronder vind je een lijst met uitdrukkingen, die verschillende aspecten van jouw stresstoestand beschrijven.
      Geef aan hoe jij je <b>op dit moment</b> voelt, in vergelijking met je hoogste hersteltoestand ooit.
    </p>
    '
  },
  create_srss_question('Stress op spieren', 'uitgeputte spieren; vermoeide spieren; spierpijn; stijve spieren'),
  create_srss_question('Gebrek aan bezieling', 'ongemotiveerd; sloom; niet enthousiast; gebrek aan energie'),
  create_srss_question('Negatieve emotionele toestand', 'neerslachtig; gestressed; geïrriteerd; opvliegend'),
  create_srss_question('Algehele stress', 'moe; versleten; overbelast; fysiek uitgeput'),
  {
    id: :plaats_expandable,
    type: :expandable,
    title: 'Geef, met behulp van onderstaande afbeelding, zo nauwkeurig mogelijk de plaats(en) op het lichaam aan waar je de afgelopen week klachten had en hoeveel last je had.',
    add_button_label: 'Voeg plaats toe',
    remove_button_label: 'Verwijder plaats',
    content: [
      {
        id: :plaats,
        type: :dropdown,
        title: 'Waar had je last?',
        placeholder: 'Selecteer je antwoord...',
        required: true,
        options: ['Hoofd', 'Hals/nek', 'Borst', 'Pols/hand', 'Buik', 'Schouder',
          'Rug thoracaal (ter hoogte borst)', 'Lage rug', 'Bekken', 'Bovenbeen',
          'Knie', 'Onderbeen', 'Enkel']
      }, {
        id: :pijn,
        type: :likert,
        required: true,
        title: 'Hoeveel last had je?',
        # https://behandelaar.pijnbijkanker.nl/chronische-pijn/onderzoek/meet-methodes/vas
        options: [
          '1 (geen pijn)',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10 (ergst denkbare pijn)'
        ],
      }
    ]
  },
  {
    type: :raw,
    content: '
    <img src="/images/questionnaires/kct/blessures.jpg" style="width: 80%; margin-left: 3rem;" />
    '
  }
]

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
