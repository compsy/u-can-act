# frozen_string_literal: true

puts 'Generating questionnaires - Started'

dagboekvragenlijst = Questionnaire.find_by_name('Dagboekvragenlijst Studenten')
dagboekvragenlijst ||= Questionnaire.new(name: 'Dagboekvragenlijst Studenten')
dagboekvragenlijst.content = [{
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
dagboekvragenlijst.save!

voormeting = Questionnaire.find_by_name('Voormeting Studenten')
voormeting ||= Questionnaire.new(name: 'Voormeting Studenten')
voormeting.content = [{
               id: :v1,
               type: :radio,
               title: 'Wat vind je van deze voormeting?',
               options: %w[slecht goed]
             }]
voormeting.save!

puts 'Generating questionnaires - Finished'
