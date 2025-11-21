# frozen_string_literal: true

db_title = ''
db_name1 = 'ov'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

OV_ABONNEMENT_QUESTIONS = %i[v39]

dagboek_content = [
  {
    id: :v37,
    type: :radio,
    title: {
      nl: 'Heeft u een OV-chipcard?',
      en: 'Do you possess an OV-chipkaart?'
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
  }, {
    id: :v38,
    type: :radio,
    title: {
      nl: 'Heeft u een OV abonnement? (NS Flex/basis telt ook als is hier ook een abonnement)',
      en: 'Do you have a public transit subscription? (Including NS Flex/NS Flex Basis)'
    },
    options: [
      { 
        title: {
          nl: 'Ja',
          en: 'Yes'
        }, 
        shows_questions: OV_ABONNEMENT_QUESTIONS 
      },
      {
        nl: 'Nee',
        en: 'No'
      }
    ],
    required: true,
    show_otherwise: false
  }, {
    id: :v39,
    hidden: true,
    type: :checkbox,
    title: {
      nl: 'Welke OV abonnement(en) heeft u?',
      en: 'Which public transport subscriptions do you have?'
    },
    options: [
      {
        nl: 'NS Basis (NS Flex)',
        en: 'NS Basis (NS Flex)'
      },
      {
        nl: 'NS Weekend Voordeel',
        en: 'NS Weekend Voordeel (Weekend discounted)'
      },
      {
        nl: 'NS Dal Voordeel',
        en: 'NS Dal Voordeel (Low hours discounted)'
      },
      {
        nl: 'NS Altijd Voordeel',
        en: 'NS Altijd Voordeel (Always discounted)'
      },
      {
        nl: 'NS Weekend Vrij',
        en: 'NS Weekend Vrij (Free travel in weekends)'
      },
      {
        nl: 'NS Dal Vrij',
        en: 'NS Dal Vrij (Free travel in low hours)'
      },
      {
        nl: 'NS Altijd Vrij',
        en: 'NS Altijd Vrij (Always free travel)'
      },
      {
        nl: 'NS Traject Vrij',
        en: 'NS Traject Vrij (Free travel on a specific segment)'
      },
      {
        nl: 'Bus/tram/metro korting (beperkt gebied)',
        en: 'Bus/tram/metro discount (Limited area)'
      },
      {
        nl: 'Bus/tram/metro vrij (beperkt gebied)',
        en: 'Bus/tram/metro free travel (Limited area)'
      },
      {
        nl: 'Bus/tram/metro korting (Heel Nederland)',
        en: 'Bus/tram/metro discount (Countrywide)'
      },
      {
        nl: 'Bus/tram/metro vrij (Heel Nederland)',
        en: 'Bus/tram/metro free (Countrywide)'
      }
    ],
    required: true,
    show_otherwise: true,
    section_end: true
  }, {
    type: :raw,
    section_start: {
      nl: 'U bent klaar met de vragenlijst. U verzendt door op volgende te klikken.',
      en: 'You have completed the questionnaire. Submit by clicking next.'
    },
    content: '<div></div>'
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
