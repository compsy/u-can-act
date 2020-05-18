# frozen_string_literal: true

FactoryBot.define do
  sequence(:questionnaire_name) { |n| "vragenlijst-dagboekstudie-studenten-#{n}" }
  sequence(:questionnaire_key) { |n| "vragenlijst_dagboekstudie_studenten_key_#{n}" }
  factory :questionnaire do
    name { generate(:questionnaire_name) }
    key { generate(:questionnaire_key) }
    title { 'vragenlijst-dagboekstudie-studenten' }
    content do
      {
        questions: [
          {
            section_start: 'Algemeen',
            id: :v1,
            type: :radio,
            title: 'Hoe voelt u zich vandaag?',
            options: %w[slecht goed]
          }, {
            id: :v2,
            type: :checkbox,
            title: 'Wat heeft u vandaag gegeten?',
            options: [
              { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
              { title: 'kaas en ham' },
              { title: 'pizza' }
            ]
          }, {
            id: :v3,
            type: :range,
            title: 'Hoe gaat het met u?',
            labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens'],
            section_end: true
          }, {
            id: :v4,
            title: 'Doelen voor deze student',
            add_button_label: 'Voeg doel toe',
            remove_button_label: 'Verwijder doel',
            type: :expandable,
            default_expansions: 0,
            max_expansions: 10,
            content: [
              {
                id: :v4_1,
                type: :textarea,
                title: 'Beschrijf in een aantal steekwoorden wat voor doel je gedaan hebt.'
              }, {
                id: :v4_2,
                type: :checkbox,
                title: 'Wat voor acties hoorden hierbij?',
                options: ['Laagdrempelig contact gelegd',
                          'Praktische oefeningen uitgevoerd',
                          'Gespreks- interventies/technieken gebruikt',
                          'Het netwerk betrokken',
                          'Motiverende handelingen uitgevoerd',
                          'Observaties gedaan']
              }, {
                id: :v4_3,
                type: :checkbox,
                title: 'Welke hoofddoelen hoorden er bij deze acties?',
                options: [
                  'De relatie verbeteren en/of onderhouden',
                  'Inzicht krijgen in de belevingswereld',
                  'Inzicht krijgen in de omgeving',
                  'Zelfinzicht geven',
                  'Vaardigheden ontwikkelen',
                  'De omgeving vreanderen/afstemmen met de omgeving'
                ]
              }, {
                id: :v4_4,
                type: :range,
                title: 'Slider 1 (lorem!)',
                labels: ['zelf geen invloed', 'zelf veel invloed']
              }, {
                id: :v4_5,
                type: :range,
                title: 'Slider 2 (lorem!)',
                labels: ['zelf geen invloed', 'zelf veel invloed']
              }
            ]
          }
        ],
        scores: []
      }
    end

    trait :one_expansion do
      content do
        {
          questions: [
            {
              section_start: 'Algemeen',
              id: :v1,
              type: :radio,
              title: 'Hoe voelt u zich vandaag?',
              options: %w[slecht goed]
            }, {
              id: :v2,
              type: :checkbox,
              title: 'Wat heeft u vandaag gegeten?',
              options: ['brood', 'kaas en ham', 'pizza']
            }, {
              id: :v3,
              type: :range,
              title: 'Hoe gaat het met u?',
              labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens'],
              section_end: true
            }, {
              id: :v4,
              title: 'Doelen voor deze student',
              add_button_label: 'Voeg doel toe',
              remove_button_label: 'Verwijder doel',
              type: :expandable,
              default_expansions: 1,
              max_expansions: 10,
              content: [
                {
                  id: :v4_1,
                  type: :textarea,
                  title: 'Beschrijf in een aantal steekwoorden wat voor doel je gedaan hebt.'
                }, {
                  id: :v4_2,
                  type: :checkbox,
                  title: 'Wat voor acties hoorden hierbij?',
                  options: ['Laagdrempelig contact gelegd',
                            'Praktische oefeningen uitgevoerd',
                            'Gespreks- interventies/technieken gebruikt',
                            'Het netwerk betrokken',
                            'Motiverende handelingen uitgevoerd',
                            'Observaties gedaan']
                }, {
                  id: :v4_3,
                  type: :checkbox,
                  title: 'Welke hoofddoelen hoorden er bij deze acties?',
                  options: [
                    'De relatie verbeteren en/of onderhouden',
                    'Inzicht krijgen in de belevingswereld',
                    'Inzicht krijgen in de omgeving',
                    { title: 'Zelfinzicht geven', shows_questions: %i[v4_4] },
                    'Vaardigheden ontwikkelen',
                    'De omgeving vreanderen/afstemmen met de omgeving'
                  ]
                }, {
                  id: :v4_4,
                  hidden: true,
                  type: :range,
                  title: 'Slider 1 (lorem!)',
                  labels: ['zelf geen invloed', 'zelf veel invloed']
                }, {
                  id: :v4_5,
                  type: :range,
                  title: 'Slider 2 (lorem!)',
                  labels: ['zelf geen invloed', 'zelf veel invloed']
                }
              ]
            }
          ],
          scores: []
        }
      end
    end

    trait :minimal do
      content do
        {
          questions: [
            { type: :raw, content: '<p>Hoihoihoi</p>' },
            { type: :checkbox, id: :v1, title: 'Tick this box?', options: %w[Yes No] }
          ],
          scores: []
        }
      end
    end

    trait :with_scores do
      content do
        {
          questions: [
            {
              section_start: 'Algemeen',
              id: :v1,
              type: :radio,
              title: 'Hoe voelt u zich vandaag?',
              options: %w[slecht goed]
            }, {
              id: :v2,
              type: :checkbox,
              title: 'Wat heeft u vandaag gegeten?',
              options: [
                { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                { title: 'kaas en ham' },
                { title: 'pizza' }
              ]
            }, {
              id: :v3,
              type: :range,
              title: 'Hoe gaat het met u?',
              labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens'],
              section_end: true
            }, {
              id: :v4,
              title: 'Doelen voor deze student',
              add_button_label: 'Voeg doel toe',
              remove_button_label: 'Verwijder doel',
              type: :expandable,
              default_expansions: 0,
              max_expansions: 10,
              content: [
                {
                  id: :v4_1,
                  type: :textarea,
                  title: 'Beschrijf in een aantal steekwoorden wat voor doel je gedaan hebt.'
                }, {
                  id: :v4_2,
                  type: :checkbox,
                  title: 'Wat voor acties hoorden hierbij?',
                  options: ['Laagdrempelig contact gelegd',
                            'Praktische oefeningen uitgevoerd',
                            'Gespreks- interventies/technieken gebruikt',
                            'Het netwerk betrokken',
                            'Motiverende handelingen uitgevoerd',
                            'Observaties gedaan']
                }, {
                  id: :v4_3,
                  type: :checkbox,
                  title: 'Welke hoofddoelen hoorden er bij deze acties?',
                  options: [
                    'De relatie verbeteren en/of onderhouden',
                    'Inzicht krijgen in de belevingswereld',
                    'Inzicht krijgen in de omgeving',
                    'Zelfinzicht geven',
                    'Vaardigheden ontwikkelen',
                    'De omgeving vreanderen/afstemmen met de omgeving'
                  ]
                }, {
                  id: :v4_4,
                  type: :range,
                  title: 'Slider 1 (lorem!)',
                  labels: ['zelf geen invloed', 'zelf veel invloed']
                }, {
                  id: :v4_5,
                  type: :range,
                  title: 'Slider 2 (lorem!)',
                  labels: ['zelf geen invloed', 'zelf veel invloed']
                }
              ]
            }
          ],
          scores: [
            { id: :s1, label: 'average of v3', ids: %i[v3], operation: :average, require_all: true }
          ]
        }
      end
    end
  end
end
