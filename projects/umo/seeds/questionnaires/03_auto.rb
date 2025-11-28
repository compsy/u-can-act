# frozen_string_literal: true

db_title = ''
db_name1 = 'auto'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

RIJBEWIJS_QUESTIONS = %i[v14]
PARKING_QUESTIONS = %i[v19]
CHARGING_QUESTIONS = %i[v20]

class AutoMethods

  class << self
    def car_x_questions(idx)
      [
        "v16_#{idx}".to_sym,
        "v17_#{idx}".to_sym,
        "v18_#{idx}".to_sym
      ]
    end

    def car_up_to_x_questions(idx)
      result = PARKING_QUESTIONS.dup
      idx.times do |index|
        result += car_x_questions(index + 1)
      end
      result
    end

    def generate_car_questions(idx)
      [
        {
          id: "v16_#{idx}".to_sym,
          hidden: true,
          type: :radio,
          title: {
            nl: "Voor auto #{idx}: Van wie is die auto?",
            en: "For car #{idx}: who owns this car?"
          },
          options: [
            {
              nl: 'Van een lid van mijn huishouden',
              en: 'My household'
            },
            {
              nl: 'Leaseauto via de werkgever',
              en: 'Leased car via employer'
            },
            {
              nl: 'Private lease',
              en: 'Private lease'
            },
            {
              nl: 'Bedrijfsauto',
              en: 'Company car'
            },
            {
              nl: 'Van mij samen met 1 of meerdere personen buiten mijn huishouden',
              en: 'Myself, together with one or more people from outside of my household'
            },
            {
              nl: 'Van iemand buiten mijn huishouden',
              en: 'Someone outside of my household'
            },
            {
              nl: 'Anders',
              en: 'Other'
            }
          ],
          required: true,
          show_otherwise: false,
          section_start: {
            nl: "Voor auto #{idx}",
            en: "For car #{idx}"
          }
        }, {
          id: "v17_#{idx}".to_sym,
          hidden: true,
          type: :radio,
          title: {
            nl: "Voor auto #{idx}: Welke brandstof gebruikt deze auto?",
            en: "For car #{idx}: which fuel type does this car use?"
          },
          options: [
            {
              nl: 'Benzine',
              en: 'Petrol/gasoline'
            },
            {
              nl: 'Diesel',
              en: 'Diesel'
            },
            {
              title: {
                nl: 'Elektriciteit',
                en: 'Electric'
              },
              shows_questions: CHARGING_QUESTIONS
            },
            {
              title: {
                nl: 'Hybride benzine',
                en: 'Hybrid petrol/gasoline'
              },
              shows_questions: CHARGING_QUESTIONS
            },
            {
              title: {
                nl: 'Hybride diesel',
                en: 'Hybrid diesel'
              },
              shows_questions: CHARGING_QUESTIONS
            },
            {
              nl: 'Waterstof',
              en: 'Hydrogen'
            },
            {
              nl: 'Anders',
              en: 'Other'
            }
          ],
          required: true,
          show_otherwise: false
        }, {
          id: "v18_#{idx}".to_sym,
          hidden: true,
          type: :radio,
          title: {
            nl: "Voor auto #{idx}: Wat is het bouwjaar van deze auto?",
            en: "For car #{idx}: what is the build year of this car?"
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
            nl: 'Jaar',
            en: 'Year'
          },
          otherwise_placeholder: {
            nl: 'Vul een jaar in',
            en: 'Enter a year'
          },
          section_end: true
        }
      ]
    end

    def generate_car_up_to_questions(idx)
      result = []
      idx.times do |index|
        result += generate_car_questions(index + 1)
      end
      result
    end
  end
end

dagboek_content = [
  {
    id: :v13,
    type: :radio,
    title: {
      nl: 'Beschikt u over een geldig rijbewijs?',
      en: 'Do you possess a valid driver\'s license?'
    },
    options: [
      {
        title: {
          nl: 'Ja',
          en: 'Yes'
        },
        shows_questions: RIJBEWIJS_QUESTIONS
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
    id: :v14,
    hidden: true,
    type: :checkbox,
    title: {
      nl: 'Over welk rijbewijs beschikt u? (meerdere keuzes mogelijk).',
      en: 'Which driver\'s license do you possess? (Multiple answers possible)'
    },
    options: [
      {
        nl: 'AM: Bromfiets, scooter, speed-pedelec, snorfiets en brommobiel',
        en: 'AM: Moped, speed-pedelec'
      },
      {
        nl: 'A, A1, A2: Motor',
        en: 'A, A1, A2: Motorcycle'
      },
      {
        nl: 'B, BE, B+: Autorijbewijs',
        en: 'B, BE, B+: car driver\'s license'
      },
      {
        nl: 'Andere rijbewijzen',
        en: 'Other licenses'
      }
    ],
    required: true,
    show_otherwise: false
  }, {
    id: :v15,
    type: :radio,
    title: {
      nl: 'Hoeveel auto’s heeft uw huishouden ter beschikking?',
      en: 'How many cars does your household have at its disposal?'
    },
    tooltip: {
      nl: 'We bedoelen hiermee de auto’s die u of een ander lid van het huishouden zou kunnen gebruiken',
      en: 'By this we mean the cars that you or another member of the household could use.'
    },
    options: [
      '0',
      { title: '1', shows_questions: AutoMethods::car_up_to_x_questions(1) },
      { title: '2', shows_questions: AutoMethods::car_up_to_x_questions(2) },
      { title: '3', shows_questions: AutoMethods::car_up_to_x_questions(3) },
      { title: '4', shows_questions: AutoMethods::car_up_to_x_questions(4) },
      { title: '5', shows_questions: AutoMethods::car_up_to_x_questions(5) },
      { title: '6', shows_questions: AutoMethods::car_up_to_x_questions(6) },
      { title: '7', shows_questions: AutoMethods::car_up_to_x_questions(7) },
      { title: '8 of meer', shows_questions: AutoMethods::car_up_to_x_questions(8) }
    ],
    required: true,
    show_otherwise: false
  },
  *AutoMethods::generate_car_up_to_questions(8),
  {
    id: :v19,
    hidden: true,
    type: :radio,
    title: {
      nl: 'Waar parkeert u uw meest gebruikte auto? (in geval van meerdere auto’s: de auto die u het meest gebruikt).',
      en: 'Where do you park the car you use most? (If there are multiple cars: the car you use the most).'
    },
    options: [
      {
        nl: 'Op eigen terrein/in eigen garage/op eigen plek in parkeergarage',
        en: 'Own parking space/garage/own space in shared parking garage'
      },
      {
        nl: 'Vrij parkeren op straat',
        en: 'Free parking on the street'
      },
      {
        nl: 'Met een parkeervergunning op straat of in een garage',
        en: 'With a permit on the street or in a shared garage'
      }
    ],
    required: true,
    show_otherwise: true
  }, {
    id: :v20,
    hidden: true,
    type: :radio,
    title: {
      nl: 'Waar laadt u uw elektrische/hybride auto doorgaans op?',
      en: 'Where do you charge your electric or hybrid vehicle?'
    },
    options: [
      {
        nl: 'Laadpaal thuis',
        en: 'Charging station at home'
      },
      {
        nl: 'Openbare laadpaal in de buurt bij de woning',
        en: 'A public charging station near my home'
      },
      {
        nl: 'Laadpaal op het werk',
        en: 'A charging station at work'
      },
      {
        nl: 'Laadpaal elders',
        en: 'A charging station elsewhere'
      }
    ],
    required: true,
    show_otherwise: false
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
