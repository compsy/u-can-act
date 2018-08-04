# frozen_string_literal: true

title = 'Q-COM-KCT' 

name = 'KCT Q-COM'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]
default_options = [
      'Helemaal mee oneens',
      'Gedeeltelijk mee oneens',
      'Niet oneens, niet eens',
      'Gedeeltelijk mee eens',
      'Helemaal mee eens'
    ]

content = [
  {
    id: :v1,
    type: :radio,
    title: 'Het is moeilijk voor mij om het behalen van de ECO serieus te nemen.',
    options: default_options
  }, {
    id: :v2,
    type: :radio,
    title: 'Eerlijk gezegd, kan het me niet schelen of ik de ECO wel of niet haal.',
    options: default_options
  }, {
    id: :v3,
    type: :radio,
    title: 'Voor mij is het heel belangrijk om het behalen van de ECO na te streven.',
    options: default_options
  }, {
    id: :v4,
    type: :radio,
    title: 'Er hoeft niet veel te gebeuren om het behalen van de ECO te laten vallen.',
    options: default_options
  }, {
    id: :v5,
    type: :radio,
    title: 'Ik vind het behalen van de ECO een goed doel om voor te gaan.',
    options: default_options,
    section_end: true
  }
]
questionnaire.content = content
questionnaire.title = title
questionnaire.save!
