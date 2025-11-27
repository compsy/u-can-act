# frozen_string_literal: true

db_title = ''
db_name1 = 'scooter'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

SCOOTER_QUESTIONS = %i[v26]

dagboek_content = [
  {
    id: :v25,
    type: :radio,
    title: {
      nl: 'Heeft u een scooter/bromfiets/snorfiets?',
      en: 'Do you own a moped?'
    },
    options: [
      {
        title: {
          nl: 'Ja',
          en: 'Yes'
        },
        shows_questions: SCOOTER_QUESTIONS
      },
      {
        title: {
          nl: 'Nee',
          en: 'No'
        }
      }
    ],
    required: true,
    show_otherwise: false
  }, {
    id: :v26,
    hidden: true,
    type: :radio,
    title: {
      nl: 'Welke brandstof gebruikt uw scooter/bromfiets/snorfiets?',
      en: 'Which type of fuel does this moped use?'
    },
    options: [
      {
        nl: 'Elektrisch',
        en: 'Electric'
      },
      {
        nl: 'Benzine',
        en: 'Petrol/gasoline'
      }
    ],
    required: true,
    show_otherwise: true,
  }, {
    id: :v27,
    type: :radio,
    title: {
      nl: 'Heeft u een motor?',
      en: 'Do you own a motorcycle?'
    },
    options: [
      {
        nl: 'Ja',
        en: 'Yes'
      },
      {
        nl: 'Nee',
        en: 'No'
      }
    ],
    required: true,
    show_otherwise: false
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
