# frozen_string_literal: true

db_title = '' # Shown to users as a big text, but cannot be localized, so often left empty.

db_name1 = 'usc_chan' # Internal name to identify this questionnaire by. Should be unique.
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">A demo questionnaire is ready for you. This is in a RAW tag</p>'
  }, {
    id: :v1, # 1
    type: :radio,
    show_otherwise: false,
    title: 'Example of a radio button',
    options: [
      { title: 'Yes', shows_questions: %i[v2] },
      { title: 'No', shows_questions: %i[v2] }
    ]
  }, {
    id: :v2,
    hidden: true,
    type: :range,
    title: 'Example with a range',
    labels: ['very little', 'very much']
  }, {
    id: :v3,
    type: :time,
    hours_from: 0,
    hours_to: 11,
    hours_step: 1,
    title: 'Example of a time question',
    section_start: 'Other questions'
  }, {
    id: :v4,
    type: :date,
    title: 'Example of a date question',
    labels: ['completely intuitive', 'completely planned']
  }, {
    id: :v5,
    type: :textarea,
    placeholder: 'This is default text',
    title: 'Example of a textarea'
  }, {
    id: :v6,
    type: :textfield,
    placeholder: 'This is default text',
    title: 'Example of a textfield'
  }, {
    id: :v7,
    type: :checkbox,
    required: true,
    title: 'Example of a checkbox question',
    options: [
      { title: 'Answer 1', tooltip: 'Tooltip 1' },
      { title: 'Answer 2', tooltip: 'Tooltip 2' },
      { title: 'Answer 3', tooltip: 'Tooltip 3' }
    ]
  }, {
    id: :v8,
    type: :likert,
    title: 'Example of a Likert scale',
    tooltip: 'some tooltip',
    options: ['strongly disagree', 'disagree', 'neutral', 'agree', 'strongly agree']
  }, {
    id: :v9,
    type: :number,
    title: 'Example of a numeric field',
    tooltip: 'some tooltip',
    maxlength: 4,
    placeholder: '1234',
    min: 0,
    max: 9999,
    required: true
  }, {
    id: :v10,
    type: :textfield,
    placeholder: 'This is default text',
    title: 'Example of a small free text field'
  }, {
    id: :v11,
    title: 'Example of an expandable',
    remove_button_label: 'Remove',
    add_button_label: 'Add',
    type: :expandable,
    default_expansions: 1,
    max_expansions: 10,
    content: [
      {
        id: :v11_1,
        type: :checkbox,
        title: 'With a checkbox question',
        options: [
          'Answer A',
          'Answer B',
          'Answer C',
          'Answer D',
          'Answer E',
          'Answer F'
        ]
      }
    ]
  }, {
    id: :v12,
    type: :dropdown,
    title: 'What were the main events related to?',
    options: ['hobby/sport', 'work', 'friendship', 'romantic relationship', 'home']
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
