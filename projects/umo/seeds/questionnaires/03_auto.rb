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
          title: "Voor auto #{idx}: Van wie is die auto?",
          options: [
            'Van een lid van mijn huishouden',
            'Leaseauto via de werkgever',
            'Private lease',
            'Bedrijfsauto',
            'Van mij samen met 1 of meerdere personen buiten mijn huishouden',
            'Van iemand buiten mijn huishouden',
            'Anders'
          ],
          required: true,
          show_otherwise: false,
          section_start: "Voor auto #{idx}"
        }, {
          id: "v17_#{idx}".to_sym,
          hidden: true,
          type: :radio,
          title: "Voor auto #{idx}: Welke brandstof gebruikt deze auto?",
          options: [
            'Benzine',
            'Diesel',
            { title: 'Elektriciteit', shows_questions: CHARGING_QUESTIONS },
            { title: 'Hybride benzine', shows_questions: CHARGING_QUESTIONS },
            { title: 'Hybride diesel', shows_questions: CHARGING_QUESTIONS },
            'Waterstof',
            'Anders'
          ],
          required: true,
          show_otherwise: false
        }, {
          id: "v18_#{idx}".to_sym,
          hidden: true,
          type: :radio,
          title: "Voor auto #{idx}: Wat is het bouwjaar van deze auto?",
          options: ['Weet ik niet'],
          required: true,
          show_otherwise: true,
          otherwise_label: 'Jaar',
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
    title: 'Beschikt u over een geldig rijbewijs?',
    options: [
      { title: 'Ja', shows_questions: RIJBEWIJS_QUESTIONS },
      { title: 'Nee' }
    ],
    required: true,
    show_otherwise: false
  }, {
    id: :v14,
    hidden: true,
    type: :checkbox,
    title: 'Over welk rijbewijs beschikt u? (meerdere keuzes mogelijk).',
    options: [
      'AM: Bromfiets, scooter, speed-pedelec, snorfiets en brommobiel',
      'A, A1, A2: Motor',
      'B, BE, B+: Autorijbewijs',
      'Andere rijbewijzen'
    ],
    required: true,
    show_otherwise: false
  }, {
    id: :v15,
    type: :dropdown,
    title: 'Hoeveel auto’s heeft uw huishouden ter beschikking?',
    tooltip: 'We bedoelen hiermee de auto’s die u of een ander lid van het huishouden zou kunnen gebruiken',
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
    title: 'Waar parkeert u uw meest gebruikte auto? (in geval van meerdere auto’s: de auto die u het meest gebruikt).',
    options: [
      'Op eigen terrein/in eigen garage/op eigen plek in parkeergarage',
      'Vrij parkeren op straat',
      'Met een parkeervergunning op straat of in een garage'
    ],
    required: true,
    show_otherwise: true
  }, {
    id: :v20,
    hidden: true,
    type: :radio,
    title: 'Waar laadt u uw elektrische/hybride auto doorgaans op?',
    options: [
      'Laadpaal thuis',
      'Openbare laadpaal in de buurt bij de woning',
      'Laadpaal op het werk',
      'Laadpaal elders'
    ],
    required: true,
    show_otherwise: false
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
