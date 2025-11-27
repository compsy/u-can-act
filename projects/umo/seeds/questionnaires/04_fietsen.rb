# frozen_string_literal: true

db_title = ''
db_name1 = 'fietsen'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

BIKING_QUESTIONS = %i[v22 v23 v24]

dagboek_content = [
  {
    id: :v21,
    type: :radio,
    title: {
      nl: 'Gebruikt u een fiets als vervoermiddel?',
      en: 'Do you use a bicycle?'
    },
    options: [
      {
        title: {
          nl: 'Ja',
          en: 'Yes'
        },
        shows_questions: BIKING_QUESTIONS
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
    id: :v22,
    hidden: true,
    type: :radio,
    title: {
      nl: 'Van wie is die fiets?',
      en: 'Who owns this bicycle?'
    },
    options: [
      {
        nl: 'Van mezelf/huishouden',
        en: 'Myself/my household'
      },
      {
        nl: 'Geleased (bijv. Swapfiets)',
        en: 'Leased (e.g. Swapfiets)'
      },
      {
        nl: 'Geleend',
        en: 'Borrowed'
      }
    ],
    required: true,
    show_otherwise: true,
  }, {
    id: :v23,
    hidden: true,
    type: :radio,
    title: {
      nl: 'Welke type fiets is die fiets?',
      en: 'What type of bicycle is this?'
    },
    options: [
      {
        nl: 'Stadsfiets',
        en: 'City bike'
      },
      {
        nl: 'Bakfiets',
        en: 'Cargo bike'
      },
      {
        nl: 'Sport/Hobby fiets (racefiets, mountainbike)',
        en: 'Sport/hobby bike (racing bike, mountain bike)'
      },
      {
        nl: 'Elektrische fiets (maximale snelheid 25 km/u)',
        en: 'Electric bicycle (max. speed 25 km/h)'
      },
      {
        nl: 'Speed pedelec (maximale snelheid 45 km/u)',
        en: 'Fast electric bicycle/speed pedelec (max. speed 45 km/h)'
      },
      {
        nl: 'Elektrische bakfiets',
        en: 'Electric cargo bike'
      },
      {
        nl: 'Anders',
        en: 'Other'
      }
    ],
    required: true,
    show_otherwise: false
  }, {
    id: :v24,
    hidden: true,
    type: :radio,
    title: {
      nl: 'Hoeveel jaar oud is die fiets?',
      en: 'How old is this bicycle in years?'
    },
    options: [
      {
        nl: 'Weet ik niet',
        en: "Don't know"
      }
    ],
    required: true,
    show_otherwise: true,
    otherwise_label: {
      nl: 'Jaren',
      en: 'Years'
    },
    otherwise_placeholder: {
      nl: 'Vul een getal in',
      en: 'Enter a number'
    }
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
