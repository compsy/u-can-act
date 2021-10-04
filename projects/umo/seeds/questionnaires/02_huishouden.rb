# frozen_string_literal: true

db_title = ''
db_name1 = 'huishouden'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

class HuisHoudenMethods
  class << self

    def person_x_questions(idx)
      [
        "v10_#{idx}".to_sym,
        "v11_#{idx}".to_sym,
        "v12_#{idx}".to_sym
      ]
    end

    def person_up_to_x_questions(idx)
      result = []
      idx.times do |index|
        result += person_x_questions(index + 1)
      end
      result
    end

    def generate_person_questions(idx)
      [
        {
          id: "v10_#{idx}".to_sym,
          hidden: true,
          type: :number,
          title: "Voor persoon #{idx} uit uw huishouden: Wat is het geboortejaar van deze persoon?",
          min: 1900,
          max: 2030,
          required: true,
          maxlength: 4,
          section_start: "Voor persoon #{idx} uit uw huishouden"
        }, {
          id: "v11_#{idx}".to_sym,
          hidden: true,
          type: :dropdown,
          title: "Voor persoon #{idx} uit uw huishouden: Deze persoon is uw...",
          options: [
            'Echtgenoot/samenwonende',
            'Kind',
            'Kind van echtgenoot/samenwonende',
            'Moeder/vader',
            'Ouders van echtgenoot/samenwonende',
            'Grootmoeder/-vader',
            'Kleindochter/-zoon',
            'Zus/broer',
            'Nicht/neef',
            'Schoonzoon/-dochter',
            'Schoonzus/zwager',
            'Tante/oom',
            'Ander familielid',
            'Geen familie',
          ],
          required: true
        }, {
          id: "v12_#{idx}".to_sym,
          hidden: true,
          type: :radio,
          title: "Voor persoon #{idx} uit uw huishouden: Is deze persoon in het bezit van een geldig autorijbewijs?",
          options: ['Ja', 'Nee', 'Weet ik niet'],
          required: true,
          show_otherwise: false,
          section_end: true
        }
      ]
    end

    def generate_person_up_to_questions(idx)
      result = []
      idx.times do |index|
        result += generate_person_questions(index + 1)
      end
      result
    end

  end
end

dagboek_content = [
  {
    id: :v9,
    type: :dropdown, # Not a radio in the original questionnaire
    title: 'Uit hoeveel mensen bestaat uw huishouden (behalve u zelf)?',
    options: [
      '0',
      { title: '1', shows_questions: HuisHoudenMethods::person_up_to_x_questions(1) },
      { title: '2', shows_questions: HuisHoudenMethods::person_up_to_x_questions(2) },
      { title: '3', shows_questions: HuisHoudenMethods::person_up_to_x_questions(3) },
      { title: '4', shows_questions: HuisHoudenMethods::person_up_to_x_questions(4) },
      { title: '5', shows_questions: HuisHoudenMethods::person_up_to_x_questions(5) },
      { title: '6', shows_questions: HuisHoudenMethods::person_up_to_x_questions(6) },
      { title: '7', shows_questions: HuisHoudenMethods::person_up_to_x_questions(7) },
      { title: '8 of meer', shows_questions: HuisHoudenMethods::person_up_to_x_questions(8) }
    ],
    required: true,
    show_otherwise: false
  },
  *HuisHoudenMethods::generate_person_up_to_questions(8)
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
