# frozen_string_literal: true

db_title = 'Baseline questionnaire'

db_name1 = 'baseline'
dagboek1 = Questionnaire.find_by(name: db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]

# This questionnaire is the first one that participants will fill out when taking part in the study. It assesses
# demographic characteristics as well as variables that may influence how socially active participants are during
# their daily life. Variables that we consider are gender, age, education, marital status, living situation and
# physical living distance from close individuals. Additionally, we ask participants for a subjective rating of their
# social contact frequency in-person, via calls and via text. The information from this questionnaire will be used to
# create the two matched groups for the further study procedure.

living_options = [
  'Living together',
  'Living in the same street',
  'Living in the same area of the city',
  'Living in the same city',
  'Living in the same province',
  'Living in the same country',
  'Living abroad (Less than 4 hours travel)',
  'Living abroad (More than 4 hours travel)'
]
frequency_options = [
  'Almost constantly',
  'A couple of times times per day',
  'Once per day',
  'A couple of times per week',
  'A couple of times per month',
  'About once a month',
  'Less than once a month',
  'Never'
]
often_options = [
  'Often',
  'Some of the time',
  'Hardly ever'
]
time_options = [
  'All of the time',
  'Most of the time',
  'A good bit of the time',
  'Some of the time',
  'A little of the time',
  'None of the time'
]

dagboek_content = [
  {
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'What gender do you identify as?',
    options: %w[Male Female Other]
  }, {
    id: :v2,
    type: :number,
    title: 'What is your age?',
    maxlength: 3,
    placeholder: 'Enter something',
    min: 0,
    max: 120,
    required: true
  }, {
    id: :v3,
    type: :radio,
    show_otherwise: false,
    title: 'What is your current level of education?',
    options: [
      'Less than a highschool diploma',
      'Highschool diploma (or a similar diploma)',
      'Secondary vocational education (or a similar diploma)',
      'Higher vocational education (or a similar diploma)',
      'University degree or higher (or a similar diploma)'
    ]
  }, {
    id: :v4,
    type: :radio,
    show_otherwise: false,
    title: 'What is your current marital status?',
    options: [
      'Single',
      'In a relationship or married (living apart)',
      'In a relationship or married (living together)',
      'Widowed, divorced or separated'
    ]
  }, {
    id: :v5,
    type: :radio,
    title: 'What is your current living situation?',
    options: [
      'Alone',
      'Shared living with parents and /or other family members',
      'Shared living with roommates/ flatmates',
      'Shared living with partner',
      'Shared living with partner and children',
      'Shared living without partner and children',
      'Shared living with three or more generations'
    ],
    otherwise_label: 'Other:'
  }, {
    id: :v6,
    type: :radio,
    show_otherwise: false,
    title: 'How far do you live from family members that are important social contacts for you?',
    tooltip: 'Please consider the family member that you are emotionally closest with, but not your partner.',
    options: living_options
  }, {
    id: :v7,
    type: :radio,
    show_otherwise: false,
    title: 'How far do you live from your best friend?',
    tooltip: 'Please do not consider your partner.',
    options: living_options
  }, {
    id: :v8,
    type: :radio,
    show_otherwise: false,
    title: 'How frequently do you have interactions (lasting more than 5 minutes) with people face-to-face?',
    options: frequency_options - ['Never']
  }, {
    id: :v9,
    type: :radio,
    show_otherwise: false,
    title: 'How frequently do you call or video call with social contacts (e.g., friends, family, colleagues)?',
    options: frequency_options
  }, {
    id: :v10,
    type: :radio,
    show_otherwise: false,
    title: 'How frequently do you have written online contact (e.g. Whatsapp, Email) with social contacts?',
    options: frequency_options
  }, {
    # v11-v13 = UCLA 3 items loneliness scale
    id: :v11,
    type: :radio,
    show_otherwise: false,
    title: 'How often do you feel that you lack companionship?',
    options: often_options
  }, {
    id: :v12,
    type: :radio,
    show_otherwise: false,
    title: 'How often do you feel left out?',
    options: often_options
  }, {
    id: :v13,
    type: :radio,
    show_otherwise: false,
    title: 'How often do you feel isolated from others?',
    options: often_options
  }, {
    # v14-v18 = MHI 5 questionnaire (SF-36, emotional wellbeing scale), similar to the general health questionnaire
    id: :v14,
    type: :radio,
    show_otherwise: false,
    title: 'How much of the time during the past 4 weeks have you been a very nervous person?',
    options: time_options
  }, {
    id: :v15,
    type: :radio,
    show_otherwise: false,
    title: 'How much of the time during the past 4 weeks have you felt so down in the dumps that nothing could cheer you up?',
    options: time_options
  }, {
    id: :v16,
    type: :radio,
    show_otherwise: false,
    title: 'How much of the time during the past 4 weeks have you felt calm and peaceful?',
    options: time_options
  }, {
    id: :v17,
    type: :radio,
    show_otherwise: false,
    title: 'How much of the time during the past 4 weeks have you felt downhearted and blue?',
    options: time_options
  }, {
    id: :v18,
    type: :radio,
    show_otherwise: false,
    title: 'How much of the time during the past 4 weeks have you been a happy person?',
    options: time_options,
    section_end: true
  }, {
    id: :v19,
    type: :radio,
    show_otherwise: false,
    title: 'During the <strong>past 4 weeks</strong>, how much of the time has <strong>your physical health or emotional problems</strong> interfered with your social activities (like visiting with friends, relatives, etc.)?',
    options: [
      'All of the time',
      'Most of the time',
      'Some of the time',
      'A little of the time',
      'None of the time'
    ],
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
