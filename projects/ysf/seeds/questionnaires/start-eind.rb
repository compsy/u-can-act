# frozen_string_literal: true

def create_number_question()
  {
    id: :number,
    type: :textfield,
    required: false,
    title: 'Wat is je cursist nummer?'
  }
end

def create_weight_question()
  {
    id: :gewicht,
    type: :textfield,
    required: true,
    title: 'Wat is je gewicht?',
    placeholder: '... kilogram'
    # pattern: '[0-9]{2,3}(,[0-9]{1,2})?',
    # hint: 'Moet een getal zijn met 2 of 3 nummers, bijvoorbeeld 86 of 104'
  }
end

def create_ponder_question(id, title, negative, positive)
  {
    id: id,
    type: :range,
    required: true,
    title: title,
    labels: [
      sprintf('0 = %s', negative),
      sprintf('100 = %s', positive)
    ],
    min: 0,
    max: 100,
    step: 1
  }
end

def create_monday_ponder_questions()
  [
    {
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
      show_otherwise: false
    },
    create_ponder_question(
      :vertrouwen,
      'Hoe zeker ben je ervan dat je de ECO kan halen?',
      'helemaal niet zeker',
      'heel erg zeker'
    ),
    create_ponder_question(
      :motivatie,
      'Hoe gemotiveerd ben je om de ECO te halen?',
      'helemaal niet gemotiveerd',
      'heel erg gemotiveerd'
    )
  ]
end

def create_friday_ponder_questions()
  [
    {
      id: :inspannend,
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
    create_ponder_question(
      :prestatie,
      'Hoe goed heb jij deze week gepresteerd?',
      'ver beneden je kunnen',
      'op de top van je kunnen'
    )
  ]
end

def create_medic_question()
  [
    {
      id: :plaats_expandable,
      type: :expandable,
      title: 'Geef, met behulp van onderstaande afbeelding, zo nauwkeurig mogelijk de plaats(en) op het lichaam aan waar je de afgelopen week klachten had en hoeveel last je had. Je kunt een plaats selecteren via de knop "Voeg plaats toe".',
      add_button_label: 'Voeg plaats toe',
      remove_button_label: 'Verwijder plaats',
      content: [
        {
          id: :plaats,
          type: :dropdown,
          title: 'Waar had je last?',
          placeholder: 'Selecteer je antwoord...',
          required: true,
          options: ['Hoofd', 'Hals/nek', 'Borst', 'Pols/hand', 'Buik', 'Lies', 'Scheenbeen', 'Schouder',
            'Rug thoracaal (ter hoogte borst)', 'Arm/elleboog', 'Lage rug', 'Bekken', 'Bovenbeen', 'Hamstring',
            'Knie', 'Kuit', 'Onderbeen', 'Enkel', 'Voet']
        },
        {
          id: :pijn,
          type: :range,
          required: true,
          title: 'Hoeveel last had je?',
          # https://behandelaar.pijnbijkanker.nl/chronische-pijn/onderzoek/meet-methodes/vas
          labels: ['0 = geen pijn', '10 = ergst denkbare pijn'],
          min: 0,
          max: 10,
          step: 1
        }
      ]
    },
    {
      type: :raw,
      content: '
      <center>
        <img src="/images/questionnaires/kct/blessures.jpg" style="width: 80%; margin-left: 3rem;" />
      </center>
      '
    }
  ]
end

def create_event_question()
  {
    id: :gebeurd_expandable,
    type: :expandable,
    title: 'Is er in de afgelopen week iets belangrijks gebeurd? Zo ja, kun je een gebeurtenis toevoegen via de knop "Voeg gebeurtenis toe".',
    add_button_label: 'Voeg gebeurtenis toe',
    remove_button_label: 'Verwijder gebeurtenis',
    content: [
      {
        id: :gebeurtenis,
        type: :dropdown,
        title: 'Waar was deze gebeurtenis aan gerelateerd?',
        placeholder: 'Selecteer je antwoord...',
        required: false,
        options: [
          'Mezelf',
          'Thuissituatie/hechte familie/dierbaren',
          'Vrienden/andere familie/kennissen',
          'Werk',
          'Maatschappij/nieuws',
          'De opleiding bij het KCT',
          'Anders'
        ]
      },
      {
        id: :gebeurtenis_valentie,
        type: :range,
        required: false,
        title: 'Hoe negatief of positief was deze gebeurtenis?',
        labels: ['0 = zeer negatief', '10 = zeer positief'],
        min: 0,
        max: 10,
        step: 1
      },
      {
        id: :gebeurtenis_tekst,
        type: :textfield,
        required: false,
        title: 'Als je wil, kun je hieronder een toelichting geven'
      }
    ]
  }
end

def create_srss_question(title, examples)
  {
    id: title.gsub(/\s+/, "_").downcase.to_sym,
    type: :range,
    required: true,
    title: sprintf('<b>%s</b>, bijvoorbeeld: %s.', title, examples),
    labels: ['0 = helemaal niet van toepassing', '6 = helemaal van toepassing'],
    min: 0,
    max: 6,
    step: 1
  }
end

def create_srss_questions()
  [
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
        Geef aan hoe jij je <b>op dit moment</b> voelt, in vergelijking met je hoogste stresstoestand ooit.
      </p>
      '
    },
    create_srss_question('Stress op spieren', 'uitgeputte spieren; vermoeide spieren; spierpijn; stijve spieren'),
    create_srss_question('Gebrek aan bezieling', 'ongemotiveerd; sloom; niet enthousiast; gebrek aan energie'),
    create_srss_question('Negatieve emotionele toestand', 'neerslachtig; gestressed; geïrriteerd; opvliegend'),
    create_srss_question('Algehele stress', 'moe; versleten; overbelast; fysiek uitgeput')
  ]
end

def create_sleep_question(id, title)
  {
    id: id,
    type: :range,
    required: true,
    title: title,
    labels: ['1 = helemaal niet van toepassing', '5 = helemaal van toepassing'],
    min: 1,
    max: 5,
    step: 1
  }
end

def create_sleep_questions()
  [
    {
      type: :raw,
      content: '
      <p class="flow-text section-explanation">
        Hieronder volgen enkele vragen over je slaap.
        Wil je voor elk van de uitspraken aangeven in hoeverre deze op jou van toepassing was <b>in de afgelopen week</b>?
      </p>
      '
    },
    create_sleep_question(:s_vermoeidheid, 'Ik heb overdag last van vermoeidheid.'),
    create_sleep_question(:s_wakker_worden, 'Ik val pas tegen de ochtend in slaap en heb dan grote moeite om \'s morgens bijtijds wakker te worden. In het weekeinde slaap ik lang uit.'),
    create_sleep_question(:s_kwaliteit, 'De kwaliteit van mijn slaap is slecht en ik voel me \'s morgens dan ook niet uitgerust.'),
    create_sleep_question(:s_wakker_liggen, 'Ik lig \'s nachts lang wakker.'),
    create_sleep_question(:s_moeilijk, 'Ik kan \'s avonds moeilijk in slaap komen.'),
    create_sleep_question(:s_gevolgen, 'Vooral na een slechte nacht heb ik overdag last van één of meer van deze gevolgen: vermoeidheid, slaperigheid, slecht humeur, zwakke concentratie, geheugenproblemen of gebrek aan energie.'),
    create_sleep_question(:s_onvoldoende, 'Ik krijg onvoldoende slaap.'),
    create_sleep_question(:s_nachtmerries, 'Ik heb last van nachtmerries of angstige dromen.'),
    create_sleep_question(:s_functioneren, 'Omdat ik te weinig slaap krijg, functioneer ik overdag minder goed.'),
    create_sleep_question(:s_schema, 'Ik slaap slecht omdat het me niet lukt om op een normale tijd in slaap te vallen en \'s morgens op een normale tijd wakker te worden.')
  ]
end

###
# Start van de week
###
title = 'Start van de week'
name = 'KCT Start van de week'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = 'start'

content = [
  create_number_question(),
  create_weight_question(),
  *create_monday_ponder_questions(),
  *create_srss_questions(),
  *create_medic_question(),
  create_event_question()
]

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!

###
# Eind van de week
###
title = 'Eind van de week'
name = 'KCT Eind van de week'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = 'eind'

content = [
  create_number_question(),
  create_weight_question(),
  *create_friday_ponder_questions(),
  *create_medic_question(),
  *create_sleep_questions()
]

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
