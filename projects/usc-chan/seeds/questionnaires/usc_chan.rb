# frozen_string_literal: true

db_title = '' # Shown to users as a big text, but cannot be localized, so often left empty.

time_options = { hidden: true,
                 required: true,
                 type: :time,
                 title: '',
                 hours_from: 0,
                 hours_to: 24,
                 hours_step: 1,
                 hours_label: 'Hours',
                 minutes_label: 'Minutes' }

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
      { title: 'Yes', shows_questions: %i[v2 v3 v4 v5 v6] },
      { title: 'No', shows_questions: %i[v7] }
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
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: 'What activities do you plan to do today? <em>(select all that apply)</em>',
    options: [
      { title: 'Work/school', tooltip: 'Activities such as paid work, volunteering, attending class, or studying.' },
      { title: 'Driving a car', tooltip: 'Operating a vehicle to get to another location.' },
      { title: 'Riding in a vehicle', tooltip: 'Taking a car/bus/train to get to another location.' },
      { title: 'Active transportation', tooltip: 'Using a bike, scooter or walking to get to another location.' },
      { title: 'Napping', tooltip: 'Sleeping during the day in between other activities.' },
      { title: 'Rest/relax', tooltip: 'Activities that help you take a break or recover, such as meditation or yoga.' },
      { title: 'Socialize', tooltip: 'Activities where the main focus is spending time with others, such as parties or hanging out with friends and family.' },
      { title: 'Dining/eating', tooltip: 'Times when your main activity is eating, rather than eating while doing another task.' },
      { title: 'Exercise', tooltip: 'Physical activities you do primarily for health rather than for fun, such as strength training, stretching, or cardiovascular exercise.' },
      { title: 'Care for myself', tooltip: 'Activities such as brushing your teeth, showering, shaving, or combing your hair.' },
      { title: 'Care for others', tooltip: 'Activities such as taking care of a child or dependent adult, or caring for pets.' },
      { title: 'Household tasks - active', tooltip: 'Household activities that require movement and energy, such as cooking and cleaning.' },
      { title: 'Household tasks - sedentary', tooltip: 'Household activities that don\'t require movement or energy, such as paying bills and online shopping.' },
      { title: 'Running errands', tooltip: 'Activities done outside the home such as shopping at a store or going to the post office.' },
      { title: '"Zoning out"', tooltip: 'Times when you are distracted or not fully present and aware of what you are doing.' },
      { title: 'Play/leisure - sedentary', tooltip: 'Activities you do for fun that don\'t require movement or energy, such as social media, watching TV, or reading.' },
      { title: 'Play/leisure - active', tooltip: 'Activities you do for fun that require movement and energy, such as hobbies and sports.' },
      { title: 'Manage my health', tooltip: 'Activities such as attending health appointments, managing medications or supplies, and navigating the healthcare system.' },
    ],
  }, {
    id: :v7,
    hidden: true,
    required: true,
    type: :radio,
    show_otherwise: false,
    title: 'Is this your last questionnaire of the day?',
    options: [
      { title: 'Yes', shows_questions: %i[v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 v29 v30 v31 v32 v33 v34 v35 v36 v37] },
      { title: 'No' }
    ],
  }, {
    id: :v18,
    type: :raw,
    hidden: true,
    content: '<p class="flow-text">How much time did you spend on the following activities today?</p>'
  }, {
    id: :v19,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Work/school', shows_questions: %i[v19a], tooltip: 'Activities such as paid work, volunteering, attending class, or studying.' }],
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
    options: [{ title: 'Driving a car', shows_questions: %i[v20a], tooltip: 'Operating a vehicle to get to another location.' }],
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
    options: [{ title: 'Riding in a vehicle', shows_questions: %i[v21a], tooltip: 'Taking a car/bus/train to get to another location.' }],
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
    options: [{ title: 'Active transportation', shows_questions: %i[v22a], tooltip: 'Using a bike, scooter or walking to get to another location.' }],
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
    options: [{ title: 'Napping', shows_questions: %i[v23a], tooltip: 'Sleeping during the day in between other activities.' }],
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
    options: [{ title: 'Rest/relax', shows_questions: %i[v24a], tooltip: 'Activities that help you take a break or recover, such as meditation or yoga.' }],
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
    options: [{ title: 'Socialize', shows_questions: %i[v25a], tooltip: 'Activities where the main focus is spending time with others, such as parties or hanging out with friends and family.' }],
  }, {
    id: :v25a,
    **time_options,
  }, {
    id: :v26,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Dining/eating', shows_questions: %i[v26a], tooltip: 'Times when your main activity is eating, rather than eating while doing another task.' }],
  }, {
    id: :v26a,
    **time_options,
  }, {
    id: :v27,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Exercise', shows_questions: %i[v27a], tooltip: 'Physical activities you do primarily for health rather than for fun, such as strength training, stretching, or cardiovascular exercise.' }],
  }, {
    id: :v27a,
    **time_options,
  }, {
    id: :v28,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Care for myself', shows_questions: %i[v28a], tooltip: 'Activities such as brushing your teeth, showering, shaving, or combing your hair.' }],
  }, {
    id: :v28a,
    **time_options,
  }, {
    id: :v29,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Care for others', shows_questions: %i[v29a], tooltip: 'Activities such as taking care of a child or dependent adult, or caring for pets.' }],
  }, {
    id: :v29a,
    **time_options,
  }, {
    id: :v30,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Household tasks - active', shows_questions: %i[v30a], tooltip: 'Household activities that require movement and energy, such as cooking and cleaning.' }],
  }, {
    id: :v30a,
    **time_options,
  }, {
    id: :v31,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Household tasks - sedentary', shows_questions: %i[v31a], tooltip: 'Household activities that don\'t require movement or energy, such as paying bills and online shopping.' }],
  }, {
    id: :v31a,
    **time_options,
  }, {
    id: :v32,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Running errands', shows_questions: %i[v32a], tooltip: 'Activities done outside the home such as shopping at a store or going to the post office.' }],
  }, {
    id: :v32a,
    **time_options,
  }, {
    id: :v33,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: '"Zoning out"', shows_questions: %i[v33a], tooltip: 'Times when you are distracted or not fully present and aware of what you are doing.' }],
  }, {
    id: :v33a,
    **time_options,
  }, {
    id: :v34,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Play/leisure - sedentary', shows_questions: %i[v34a], tooltip: 'Activities you do for fun that don\'t require movement or energy, such as social media, watching TV, or reading.' }],
  }, {
    id: :v34a,
    **time_options,
  }, {
    id: :v35,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Play/leisure - active', shows_questions: %i[v35a], tooltip: 'Activities you do for fun that require movement and energy, such as hobbies and sports.' }],
  }, {
    id: :v35a,
    **time_options,
  }, {
    id: :v36,
    hidden: true,
    required: false,
    type: :checkbox,
    show_otherwise: false,
    title: '',
    options: [{ title: 'Manage my health', shows_questions: %i[v36a], tooltip: 'Activities such as attending health appointments, managing medications or supplies, and navigating the healthcare system.' }],
  }, {
    id: :v36a,
    **time_options,
  }, {
    id: :v37,
    hidden: true,
    required: true,
    type: :radio,
    show_otherwise: true,
    title: 'Did diabetes get in the way of doing any of these activities today?',
    options: [
      'No',
      'Yes, I was feeling unwell',
      'Yes, self-management tasks interfered',
    ],
    otherwise_label: 'Yes, for another reason',
    otherwise_placeholder: 'Please specify',
  }, {
    id: :v38, # TODO: maybe add a separator here
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how do you feel <strong>physically</strong>?',
    labels: ['Extremely bad', 'Extremely good'],
  }, {
    id: :v39,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how do you feel <strong>mentally and emotionally</strong>?',
    labels: ['Extremely bad', 'Extremely good'],
  }, {
    id: :v40,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how <strong>confident</strong> do you feel about tackling your day?',
    labels: ['Not at all confident', 'Very confident'],
  }, {
    id: :v41,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how <strong>stressed</strong> are you?',
    labels: ['Not at all stressed', 'Extremely stressed'],
  }, {
    id: :v42,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how <strong>bothered</strong> are you by your diabetes or its management?',
    labels: ['Not at all bothered', 'Extremely bothered'],
  }, {
    id: :v43,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how <strong>tired</strong> do you feel?',
    labels: ['Not at all tired', 'Extremely tired'],
  }, {
    id: :v44,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, how <strong>aware</strong> are you of your glucose or other physical symptoms?',
    labels: ['Completely unaware', 'Completely aware'],
  }, {
    id: :v45,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Right now, is your <strong>eating pattern</strong> affecting how you feel?',
    labels: ['Yes, very negatively', 'Neutral', 'Yes, very positively'],
    min: -50,
    max: 50,
    value: 0,
  }, {
    id: :v46,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Since the last survey, have you been following your usual <strong>routine</strong>?',
    labels: ['Not at all', 'Completely'],
  }, {
    id: :v47,
    required: true,
    type: :range,
    no_initial_thumb: true,
    title: 'Since the last survey, how well have you been able to <strong>perform your activities</strong>?',
    labels: ['Unable to do at all', 'Extremely well'],
  }, {
    id: :v48,
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
