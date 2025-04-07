# frozen_string_literal: true
# This is the correct questionnaire document:
# https://docs.google.com/document/d/1ez5xmrzA30vV0uDdFQAqZ5BlOsrsIW6s/edit

db_title = '' # Shown to users as a big text, but cannot be localized, so often left empty.

time_options = {
  hidden: true,
  required: true,
  type: :time,
  title: '',
  hours_from: 0,
  hours_to: 24,
  hours_step: 1,
  hours_label: 'Hours',
  minutes_label: 'Minutes'
}

get_in_the_way_options = {
  hidden: true,
  required: true,
  type: :radio,
  show_otherwise: false,
  options: ['No', 'Yes, I was feeling unwell', 'Yes, self-management tasks interfered']
}

db_name1 = 'usc_chan' # Internal name to identify this questionnaire by. Should be unique.
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    section_start: '',
    type: :raw,
    content: '<p class="flow-text">EMA Questions</p>'
  }, {
    id: :v1,
    required: true,
    type: :radio,
    title: 'Is this your first questionnaire of the day?',
    show_otherwise: false,
    options: [
      { title: 'Yes', shows_questions: %i[v2 v3 v4 v5] },
      { title: 'No', shows_questions: %i[v6] }
    ],
  }, {
    id: :v2,
    hidden: true,
    required: true,
    type: :time,
    title: 'What time did you go to bed?',
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: 'Hours',
    minutes_label: 'Minutes',
    am_pm: true,
  }, {
    id: :v3,
    hidden: true,
    required: true,
    type: :time,
    title: 'What time did you wake up?',
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: 'Hours',
    minutes_label: 'Minutes',
    am_pm: true,
  }, {
    id: :v4,
    hidden: true,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how well rested do you feel?',
    labels: ['Not at all rested', 'Extremely rested'],
  }, {
    id: :v5,
    hidden: true,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'How disrupted was your sleep last night?',
    labels: ['Not at all disrupted', 'Extremely disrupted'],
  }, {
    id: :v6,
    hidden: true,
    required: true,
    type: :radio,
    show_otherwise: false,
    title: 'Is this your last questionnaire of the day?',
    options: [
      { title: 'Yes', shows_questions: %i[v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25] },
      { title: 'No' }
    ],
  }, {
    id: :v7,
    type: :raw,
    hidden: true,
    content: '<p class="flow-text">How much time did you spend on the following activities today?</p>'
  }, {
    id: :v8,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Work/school', shows_questions: %i[v8a v8b], tooltip: 'Activities such as paid work, volunteering, attending class, or studying.' }],
  }, {
    id: :v8a,
    **time_options,
  }, {
    id: :v9,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Driving a car', shows_questions: %i[v9a v9b], tooltip: 'Operating a vehicle to get to another location.' }],
  }, {
    id: :v9a,
    **time_options,
  }, {
    id: :v10,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Riding in a vehicle', shows_questions: %i[v10a v10b], tooltip: 'Taking a car/bus/train to get to another location.' }],
  }, {
    id: :v10a,
    **time_options,
  }, {
    id: :v11,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Active transportation', shows_questions: %i[v11a v11b], tooltip: 'Using a bike, scooter or walking to get to another location.' }],
  }, {
    id: :v11a,
    **time_options,
  }, {
    id: :v12,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Napping', shows_questions: %i[v12a v12b], tooltip: 'Sleeping during the day in between other activities.' }],
  }, {
    id: :v12a,
    **time_options,
  }, {
    id: :v13,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Rest/relax', shows_questions: %i[v13a v13b], tooltip: 'Activities that help you take a break or recover, such as meditation or yoga.' }],
  }, {
    id: :v13a,
    **time_options,
  }, {
    id: :v14,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Socialize', shows_questions: %i[v14a v14b], tooltip: 'Activities where the main focus is spending time with others, such as parties or hanging out with friends and family.' }],
  }, {
    id: :v14a,
    **time_options,
  }, {
    id: :v15,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Dining/eating', shows_questions: %i[v15a v15b], tooltip: 'Times when your main activity is eating, rather than eating while doing another task.' }],
  }, {
    id: :v15a,
    **time_options,
  }, {
    id: :v16,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Exercise', shows_questions: %i[v16a v16b], tooltip: 'Physical activities you do primarily for health rather than for fun, such as strength training, stretching, or cardiovascular exercise.' }],
  }, {
    id: :v16a,
    **time_options,
  }, {
    id: :v17,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Care for myself', shows_questions: %i[v17a v17b], tooltip: 'Activities such as brushing your teeth, showering, shaving, or combing your hair.' }],
  }, {
    id: :v17a,
    **time_options,
  }, {
    id: :v18,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Care for others', shows_questions: %i[v18a v18b], tooltip: 'Activities such as taking care of a child or dependent adult, or caring for pets.' }],
  }, {
    id: :v18a,
    **time_options,
  }, {
    id: :v19,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Household tasks - active', shows_questions: %i[v19a v19b], tooltip: 'Household activities that require movement and energy, such as cooking and cleaning.' }],
  }, {
    id: :v19a,
    **time_options,
  }, {
    id: :v20,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Household tasks - sedentary', shows_questions: %i[v20a v20b], tooltip: 'Household activities that don\'t require movement or energy, such as paying bills and online shopping.' }],
  }, {
    id: :v20a,
    **time_options,
  }, {
    id: :v21,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Running errands', shows_questions: %i[v21a v21b], tooltip: 'Activities done outside the home such as shopping at a store or going to the post office.' }],
  }, {
    id: :v21a,
    **time_options,
  }, {
    id: :v22,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: '"Zoning out"', shows_questions: %i[v22a v22b], tooltip: 'Times when you are distracted or not fully present and aware of what you are doing.' }],
  }, {
    id: :v22a,
    **time_options,
  }, {
    id: :v23,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Play/leisure - sedentary', shows_questions: %i[v23a v23b], tooltip: 'Activities you do for fun that don\'t require movement or energy, such as social media, watching TV, or reading.' }],
  }, {
    id: :v23a,
    **time_options,
  }, {
    id: :v24,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Play/leisure - active', shows_questions: %i[v24a v24b], tooltip: 'Activities you do for fun that require movement and energy, such as hobbies and sports.' }],
  }, {
    id: :v24a,
    **time_options,
  }, {
    id: :v25,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Manage my health', shows_questions: %i[v25a v25b], tooltip: 'Activities such as attending health appointments, managing medications or supplies, and navigating the healthcare system.' }],
  }, {
    id: :v25a,
    **time_options,
  }, {
    id: :v8b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from doing work/school?',
  }, {
    id: :v9b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from driving a car?',
  }, {
    id: :v10b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from riding in a vehicle?',
  }, {
    id: :v11b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from active transportation?',
  }, {
    id: :v12b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from napping?',
  }, {
    id: :v13b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from resting/relaxing?',
  }, {
    id: :v14b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from socializing?',
  }, {
    id: :v15b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from dining/eating?',
  }, {
    id: :v16b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from exercising?',
  }, {
    id: :v17b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from caring for yourself?',
  }, {
    id: :v18b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from caring for others?',
  }, {
    id: :v19b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from doing household tasks - active?',
  }, {
    id: :v20b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from doing household tasks - sedentary?',
  }, {
    id: :v21b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from running errands?',
  }, {
    id: :v22b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from "zoning out"?',
  }, {
    id: :v23b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from doing play/leisure - sedentary?',
  }, {
    id: :v24b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from doing play/leisure - active?',
  }, {
    id: :v25b,
    **get_in_the_way_options,
    title: 'Did your illness get in the way of or keep you from managing your health?',
  }, {
    id: :v26, # TODO: maybe add a separator here
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how do you feel <strong>physically</strong>?',
    labels: ['Extremely bad', 'Extremely good'],
  }, {
    id: :v27,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how do you feel <strong>mentally and emotionally</strong>?',
    labels: ['Extremely bad', 'Extremely good'],
  }, {
    id: :v28,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how <strong>confident</strong> do you feel about tackling your day?',
    labels: ['Not at all confident', 'Very confident'],
  }, {
    id: :v29,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how <strong>stressed</strong> are you?',
    labels: ['Not at all stressed', 'Extremely stressed'],
  }, {
    id: :v30,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how <strong>bothered</strong> are you by your diabetes or its management?',
    labels: ['Not at all bothered', 'Extremely bothered'],
  }, {
    id: :v31,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how <strong>tired</strong> do you feel?',
    labels: ['Not at all tired', 'Extremely tired'],
  }, {
    id: :v32,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how <strong>aware</strong> are you of your glucose or other physical symptoms?',
    labels: ['Completely unaware', 'Completely aware'],
  }, {
    id: :v33,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, is your <strong>eating pattern</strong> affecting how you feel?',
    labels: ['Yes, very negatively', 'Neutral', 'Yes, very positively'],
    min: -50,
    max: 50,
    value: 0,
  }, {
    id: :v34,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Since the last survey, have you been following your usual <strong>routine</strong>?',
    labels: ['Not at all', 'Completely'],
  }, {
    id: :v35,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Since the last survey, how well have you been able to <strong>perform your activities</strong>?',
    labels: ['Unable to do at all', 'Extremely well'],
  }, {
    id: :v36,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Since the last survey, how <strong>physically active</strong> have you been?',
    labels: ['Not at all active', 'Extremely active'],
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
