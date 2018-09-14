# frozen_string_literal: true

title = 'Q-RES-KCT'

name = 'KCT Q-RES'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]
default_options = [
  'Nooit',
  'Bijna nooit',
  'Soms',
  'Vaak',
  'Altijd'
]

content = [
  {
    id: :v1,
    type: :radio,
    title: 'Na een tegenslag herstel ik me snel.',
    options: default_options
  }, {
    id: :v2,
    type: :radio,
    title: 'Ik vind het moeilijk om me na een stressvolle gebeurtenis te herpakken.',
    options: default_options
  }, {
    id: :v3,
    type: :radio,
    title: 'Ik krabbel snel op na een negatieve gebeurtenis.',
    options: default_options
  }, {
    id: :v4,
    type: :radio,
    title: 'Het is voor mij moeilijk om te herstellen nadat er iets vervelends is gebeurd.',
    options: default_options
  }, {
    id: :v5,
    type: :radio,
    title: 'Ik herstel normaal gesproken snel als ik een lastige tijd heb gehad.',
    options: default_options
  }, {
    id: :v6,
    type: :radio,
    title: 'Ik heb lang nodig om over een tegenslag heen te komen.',
    options: default_options,
    section_end: false
  }
]
questionnaire.content = content
questionnaire.title = title
questionnaire.save!
