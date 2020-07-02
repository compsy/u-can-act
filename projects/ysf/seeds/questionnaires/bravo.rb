# frozen_string_literal: true

title = 'Bravo'

name = 'KCT Bravo'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

content = [
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
    Onderstaande informatie is bedoeld als achtergrondkennis voor de
    onderzoekers. Het is van belang om informatie te hebben over het soort
    deelnemers van het onderzoek (hierbij blijven
    identificeerbare gegevens, zoals namen, volledig anoniem).
    </p>'
  }, {
    id: :v1,
    type: :textfield,
    required: true,
    title: 'Leeftijd',
    placeholder: '... jaar'
  }, {
    id: :v2,
    type: :radio,
    title: 'Geslacht',
    options: %w[Man
                Vrouw],
    show_otherwise: false
  }, {
    id: :v3,
    type: :textfield,
    required: true,
    title: 'Lengte',
    placeholder: '... meter'
  }, {
    id: :v4,
    type: :textfield,
    required: true,
    title: 'Gewicht',
    placeholder: '... kilogram'
  }, {
    id: :v5,
    type: :radio,
    title: 'Wat is de hoogst gevolgde opleiding die je hebt voltooid of momenteel volgt?',
    options: %w[WO HBO MBO VWO HAVO VMBO]
  }, {
    id: :v6,
    type: :textfield,
    required: true,
    title: 'Hoeveel uur per week besteed je gemiddeld aan sportbeoefening?',
    placeholder: '... uur'
  }, {
    id: :v7,
    type: :radio,
    title: 'Welke rang heb je momenteel?',
    options: [
      'Sld',
      'Kpl',
      'Kpl 1',
      'Sgt',
      'Sgt 1',
      'Sergeant majoor',
      'Adjudant',
      'Luitenant',
      'Kapitein',
      'Majoor',
      'Luitenant kolonel',
      'Kolonel'
    ]
  }, {
    id: :v8,
    type: :radio,
    title: 'Ik ben op dit moment in opleiding als:',
    options: [
      'VO / ECO',
      'VCO'
    ]
  }, {
    id: :v9,
    type: :radio,
    title: 'Ik ben werkzaam bij:',
    options: [
      'de staf',
      '102 COTRCIE',
      '103 COTRCIE',
      '104 COTRCIE',
      '105 COTRCIE',
      '108 COTRCIE',
      'OTCSO'
    ]
  }, {
    id: :v10,
    type: :textfield,
    required: true,
    title: 'Hoeveel jaar ben je in totaal werkzaam bij Defensie?',
    placeholder: '... jaar'
  }, {
    id: :v11,
    type: :textfield,
    required: true,
    title: 'Hoeveel jaar ben je werkzaam bij het KCT?',
    placeholder: '... jaar'
  }, {
    id: :v12,
    type: :textfield,
    required: true,
    title: 'Hoeveel uitzendingen heb je inmiddels gedaan?',
    placeholder: ''
  }
]
questionnaire.content = { questionnaire: content, scores: [] }
questionnaire.title = title
questionnaire.save!
