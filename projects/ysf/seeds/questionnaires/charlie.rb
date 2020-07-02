# frozen_string_literal: true

title = 'Charlie'

name = 'KCT Charlie'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title, section_end: false)
  default_options = [
    'Nooit',
    'Bijna nooit',
    'Soms',
    'Vaak',
    'Altijd'
  ]

  res = {
    id: id,
    type: :radio,
    title: title,
    show_otherwise: false,
    options: default_options
  }
  res[:section_end] = section_end
  res
end

content = [
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
      Vul onderstaande vragen eerlijk in.
    </p>'
  },
  create_question(:v1, 'Na een tegenslag herstel ik me snel.'),
  create_question(:v2, 'Ik vind het moeilijk om me na een stressvolle gebeurtenis te herpakken.'),
  create_question(:v3, 'Ik krabbel snel op na een negatieve gebeurtenis.'),
  create_question(:v4, 'Het is voor mij moeilijk om te herstellen nadat er iets vervelends is gebeurd.'),
  create_question(:v5, 'Ik herstel normaal gesproken snel als ik een lastige tijd heb gehad.'),
  create_question(:v6, 'Ik heb lang nodig om over een tegenslag heen te komen.')
]
questionnaire.content = content
questionnaire.title = title
questionnaire.save!
