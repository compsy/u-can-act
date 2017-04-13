# frozen_string_literal: true

FactoryGirl.define do
  factory :questionnaire do
    name 'Vragenlijst Dagboekstudie Studenten'
    content [{
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
      labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens']
    }]
  end
end
