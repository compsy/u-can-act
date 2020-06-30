# frozen_string_literal: true

vm_name1 = 'voormeting studenten'
voormeting1 = Questionnaire.find_by(name: vm_name1)
voormeting1 ||= Questionnaire.new(name: vm_name1)
voormeting1.key = File.basename(__FILE__)[0...-3]
voormeting1.content = { questions: [{
  id: :v1,
  type: :textfield,
  required: true,
  title: 'Wat is je geboortejaar?',
  placeholder: 'Vul het volledige jaartal in: bv. 2001'
}, {
  id: :v2,
  type: :textfield,
  required: true,
  title: 'Wat is je nationaliteit?'
}, {
  id: :v3,
  type: :radio,
  title: 'Heb je op dit moment een partner?',
  options: ['Nee, ik heb geen relatie',
            'Ja, ik heb een partner',
            'Het is ingewikkeld',
            'Zeg ik liever niet']
}, {
  id: :v4,
  type: :radio,
  title: 'Heb je op dit moment kinderen?',
  options: ['Nee'],
  otherwise_label: 'Ja, aantal:'
}, {
  id: :v5,
  type: :textfield,
  required: true,
  title: 'Wat is de naam van je school?'
}, {
  id: :v6,
  type: :textfield,
  required: true,
  title: 'Welke opleiding doe je daar?'
}, {
  id: :v7,
  type: :radio,
  title: 'Op welk niveau is deze opleiding?',
  options: ['MBO niveau 1', 'MBO niveau 2', 'MBO niveau 3', 'MBO niveau 4']
}, {
  id: :v8,
  type: :textfield,
  required: true,
  title: 'Hoeveel jaar ben je inmiddels bezig met deze opleiding?'
}, {
  id: :v9,
  type: :radio,
  title: 'Wat deed je voordat je aan deze opleiding begon?',
  options: ['Werken', 'Middelbare school', 'Een andere MBO opleiding']
}], scores: [] }
voormeting1.title = 'Voormeting'
voormeting1.save!
