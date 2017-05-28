# frozen_string_literal: true

FactoryGirl.define do
  sequence(:questionnaire_name) { |n| "vragenlijst-dagboekstudie-studenten-#{n}" }
  factory :questionnaire do
    name { generate(:questionnaire_name) }
    title 'vragenlijst-dagboekstudie-studenten'
    content [{
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
    }]
  end
end
