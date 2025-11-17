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
          title: {
            nl: "Voor persoon #{idx} uit uw huishouden: Wat is het geboortejaar van deze persoon?",
            en: "For member #{idx} of your household: what is this person's year of birth?"
          },
          min: 1900,
          max: 2030,
          required: true,
          maxlength: 4,
          section_start: {
            nl: "Voor persoon #{idx} uit uw huishouden",
            en: "For member #{idx} of your household"
          }
        }, {
          id: "v11_#{idx}".to_sym,
          hidden: true,
          type: :dropdown,
          title: {
            nl: "Voor persoon #{idx} uit uw huishouden: Deze persoon is uw...",
            en: "For member #{idx} of your household: this person is your..."
          },
          options: [
            {
              nl: 'Echtgenoot/samenwonende',
              en: 'Spouse/significant other'
            },
            {
              nl: 'Kind',
              en: 'Child'
            },
            {
              nl: 'Kind van echtgenoot/samenwonende',
              en: 'Child of spouse/significant other'
            },
            {
              nl: 'Moeder/vader',
              en: 'Parent'
            },
            {
              nl: 'Ouders van echtgenoot/samenwonende',
              en: 'Parent of spouse/significant other'
            },
            {
              nl: 'Grootmoeder/-vader',
              en: 'Grandparent'
            },
            {
              nl: 'Kleindochter/-zoon',
              en: 'Grandchild'
            },
            {
              nl: 'Zus/broer',
              en: 'Sibling'
            },
            {
              nl: 'Nicht/neef',
              en: 'Cousin'
            },
            {
              nl: 'Schoonzoon/-dochter',
              en: 'Stepchild'
            },
            {
              nl: 'Schoonzus/zwager',
              en: 'Brother-in-law/sister-in-law'
            },
            {
              nl: 'Tante/oom',
              en: 'Aunt/uncle'
            },
            {
              nl: 'Ander familielid',
              en: 'Other family member'
            },
            {
              nl: 'Geen familie',
              en: 'Not family'
            }
          ],
          required: true
        }, {
          id: "v12_#{idx}".to_sym,
          hidden: true,
          type: :radio,
          title: {
            nl: "Voor persoon #{idx} uit uw huishouden: Is deze persoon in het bezit van een geldig autorijbewijs?",
            en: "For member #{idx} of your household: does this person have a valid driver's license?"
          },
          options: [
            {
              nl: 'Ja',
              en: 'Yes'
            },
            {
              nl: 'Nee',
              en: 'No'
            },
            {
              nl: 'Weet ik niet',
              en: "I don't know"
            }
          ],
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
    type: :radio, # Not a radio in the original questionnaire
    title: {
      nl: 'Uit hoeveel mensen bestaat uw huishouden (behalve u zelf)?',
      en: 'How many people are a part of your household? (Except for yourself)'
    },
    options: [
      '0',
      { title: '1', shows_questions: HuisHoudenMethods::person_up_to_x_questions(1) },
      { title: '2', shows_questions: HuisHoudenMethods::person_up_to_x_questions(2) },
      { title: '3', shows_questions: HuisHoudenMethods::person_up_to_x_questions(3) },
      { title: '4', shows_questions: HuisHoudenMethods::person_up_to_x_questions(4) },
      { title: '5', shows_questions: HuisHoudenMethods::person_up_to_x_questions(5) },
      { title: '6', shows_questions: HuisHoudenMethods::person_up_to_x_questions(6) },
      { title: '7', shows_questions: HuisHoudenMethods::person_up_to_x_questions(7) },
      { 
        title: {
          nl: '8 of meer',
          en: '8 or more'
        }, 
        shows_questions: HuisHoudenMethods::person_up_to_x_questions(8) 
      }
    ],
    required: true,
    show_otherwise: false
  },
  *HuisHoudenMethods::generate_person_up_to_questions(8)
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
