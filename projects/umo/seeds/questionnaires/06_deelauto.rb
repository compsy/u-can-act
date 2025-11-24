# frozen_string_literal: true

db_title = ''
db_name1 = 'deelauto'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

DEELAUTO_QUESTIONS = %i[v31 v32]
DEELFIETS_QUESTIONS = %i[v34]
DEELSCOOTER_QUESTIONS = %i[v36]

dagboek_content = [
  {
    id: :v30,
    type: :radio,
    title: {
      nl: 'Hoe vaak maakt u gemiddeld gebruik van een auto via een deelautoaanbieder?',
      en: 'On average, how often do you use a car from a car-sharing platform?'
    },
    options: [
      {
        nl: 'Nooit',
        en: 'Never'
      },
      {
        title: {
          nl: 'Minder dan een keer per jaar',
          en: 'Less than once per year'
        },
        shows_questions: DEELAUTO_QUESTIONS
      },
      {
        title: {
          nl: 'Enkele keren per jaar',
          en: 'Multiple times per year'
        },
        shows_questions: DEELAUTO_QUESTIONS
      },
      {
        title: {
          nl: 'Eens per maand',
          en: 'Once per month'
        },
        shows_questions: DEELAUTO_QUESTIONS
      },
      {
        title: {
          nl: 'Een paar keer per maand',
          en: 'Multiple times per month'
        },
        shows_questions: DEELAUTO_QUESTIONS
      },
      {
        title: {
          nl: 'Iedere week',
          en: 'Every week'
        },
        shows_questions: DEELAUTO_QUESTIONS
      }
    ],
    required: true,
    show_otherwise: false,
    section_start: {
      nl: 'Deelauto',
      en: 'Car-sharing'
    }
  }, {
    id: :v31,
    hidden: true,
    type: :checkbox,
    title: {
      nl: 'Bij welke aanbieder maakt u wel eens gebruik van een deelauto?',
      en: 'Which car-sharing platforms do you use?'
    },
    options: [
      'MyWheels',
      'SnappCar',
      'Greenwheels',
      'Hely',
      'Sixt',
      'Disk',
      'Free2Move',
      'Green Mobility',
      'Check',
      'Ready2Share/Mr. Green',
      'Vloto Cars',
      'Just Go',
      'Onze Auto'
    ],
    required: true,
    show_otherwise: true,
    otherwise_label: {
      nl: 'Anders, namelijk:',
      en: 'Other (please specify):'
    },
    otherwise_placeholder: {
      nl: 'Vul iets in',
      en: 'Enter something'
    }
  }, {
    id: :v32,
    hidden: true,
    type: :radio,
    title: {
      nl: 'Wat is de afstand van uw huis tot de deelauto ongeveer?',
      en: 'Approximately, what is the distance between your home and the shared car?'
    },
    options: [
      {
        nl: '1 - 25 meter',
        en: '1 - 25 meters'
      },
      {
        nl: '25 - 100 meter',
        en: '25 - 100 meters'
      },
      {
        nl: '100 - 200 meter',
        en: '100 - 200 meters'
      },
      {
        nl: '200 - 500 meter',
        en: '200 - 500 meters'
      },
      {
        nl: '500 - 1000 meter',
        en: '500 - 1000 meters'
      },
      {
        nl: 'Meer dan 1000 meter',
        en: 'More than 1000 meters'
      }
    ],
    required: true,
    show_otherwise: false
  }, {
    type: :raw,
    content: '<div></div>',
    section_end: true
  }, {
    id: :v33,
    type: :radio,
    title: {
      nl: 'Hoe vaak maakt u gemiddeld gebruik van een fiets via een deelfietsaanbieder (ook OV-fiets)?',
      en: 'On average, how often do you use a shared bicycle through a bicycle-sharing platform (including OV-Fiets)?'
    },
    options: [
      {
        nl: 'Nooit',
        en: 'Never'
      },
      {
        title: {
          nl: 'Minder dan een keer per jaar',
          en: 'Less than once per year'
        },
        shows_questions: DEELFIETS_QUESTIONS
      },
      {
        title: {
          nl: 'Enkele keren per jaar',
          en: 'Multiple times per year'
        },
        shows_questions: DEELFIETS_QUESTIONS
      },
      {
        title: {
          nl: 'Eens per maand',
          en: 'Once per month'
        },
        shows_questions: DEELFIETS_QUESTIONS
      },
      {
        title: {
          nl: 'Een paar keer per maand',
          en: 'Multiple times per month'
        },
        shows_questions: DEELFIETS_QUESTIONS
      },
      {
        title: {
          nl: 'Iedere week',
          en: 'Every week'
        },
        shows_questions: DEELFIETS_QUESTIONS
      }
    ],
    required: true,
    show_otherwise: false,
    section_start: {
      nl: 'Deelfiets',
      en: 'Bike-sharing'
    }
  }, {
    id: :v34,
    hidden: true,
    type: :checkbox,
    title: {
      nl: 'Bij welke aanbieder maakt u wel eens gebruik van een deelfiets?',
      en: 'Which bicycle-sharing platforms do you use?'
    },
    options: [
      'OV-fiets',
      'Donkey Republic',
      'Dott',
      'Hely',
      'Felyx',
      'Bolt'
    ],
    required: true,
    show_otherwise: true,
    otherwise_label: {
      nl: 'Anders, namelijk:',
      en: 'Other (please specify):'
    },
    otherwise_placeholder: {
      nl: 'Vul iets in',
      en: 'Enter something'
    }
  }, {
    type: :raw,
    content: '<div></div>',
    section_end: true
  }, {
    id: :v35,
    type: :radio,
    title: {
      nl: 'Hoe vaak maakt u gemiddeld gebruik van een scooter via een deelscooteraanbieder?',
      en: 'On average, how often do you use a shared scooter?'
    },
    options: [
      {
        nl: 'Nooit',
        en: 'Never'
      },
      {
        title: {
          nl: 'Minder dan een keer per jaar',
          en: 'Less than once per year'
        },
        shows_questions: DEELSCOOTER_QUESTIONS
      },
      {
        title: {
          nl: 'Enkele keren per jaar',
          en: 'Multiple times per year'
        },
        shows_questions: DEELSCOOTER_QUESTIONS
      },
      {
        title: {
          nl: 'Eens per maand',
          en: 'Once per month'
        },
        shows_questions: DEELSCOOTER_QUESTIONS
      },
      {
        title: {
          nl: 'Een paar keer per maand',
          en: 'Multiple times per month'
        },
        shows_questions: DEELSCOOTER_QUESTIONS
      },
      {
        title: {
          nl: 'Iedere week',
          en: 'Every week'
        },
        shows_questions: DEELSCOOTER_QUESTIONS
      }
    ],
    required: true,
    show_otherwise: false,
    section_start: {
      nl: 'Deelscooter',
      en: 'Scooter-sharing'
    }
  }, {
    id: :v36,
    hidden: true,
    type: :checkbox,
    title: {
      nl: 'Bij welke aanbieder maakt u wel eens gebruik van een deelscooter?',
      en: 'Which platforms do you use to access a shared moped?'
    },
    options: [
      'Check',
      'Felyx'
    ],
    required: true,
    show_otherwise: true,
    otherwise_label: {
      nl: 'Anders, namelijk:',
      en: 'Other (please specify):'
    },
    otherwise_placeholder: {
      nl: 'Vul iets in',
      en: 'Enter something'
    }
  }, {
    type: :raw,
    content: '<div></div>',
    section_end: true
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
