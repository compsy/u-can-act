# frozen_string_literal: true

db_title = 'Kansas City Cardiomyopathy Questionnaire (KCCQ-12)'

questionnaire_key = File.basename(__FILE__)[0...-3]
db_name1 = questionnaire_key
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = questionnaire_key if questionnaire.key.blank?

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">The following questions refer to your heart failure and how it may affect your life. Please read and complete the following questions. There are no right or wrong answers. Please mark the answer that best applies to you.</p>'
  },
  {
    type: :raw,
    content: '<p class="flow-text">1. Heart failure affects different people in different ways. Some feel shortness of breath while others feel fatigue. Please indicate how much you are limited by heart failure (shortness of breath or fatigue) in your ability to do the following activities over the past 2 weeks.</p>'
  },
  {
    id: :v1a,
    title: 'Showering/Bathing',
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      'Extremely Limited',
      'Quite a bit Limited',
      'Moderately Limited',
      'Slightly Limited',
      'Not at all Limited',
      'Limited for other reasons or did not do the activity'
    ]
  },
  {
    id: :v1b,
    title: 'Walking 1 block on level ground',
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      'Extremely Limited',
      'Quite a bit Limited',
      'Moderately Limited', 
      'Slightly Limited',
      'Not at all Limited',
      'Limited for other reasons or did not do the activity'
    ]
  },
  {
    id: :v1c,
    title: 'Hurrying or jogging (as if to catch a bus)',
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      'Extremely Limited',
      'Quite a bit Limited',
      'Moderately Limited',
      'Slightly Limited', 
      'Not at all Limited',
      'Limited for other reasons or did not do the activity'
    ]
  },
  {
    id: :v2,
    title: '2. Over the past 2 weeks, how many times did you have swelling in your feet, ankles or legs when you woke up in the morning?',
    type: :likert,
    options: [
      'Every morning',
      '3 or more times per week but not every day',
      '1-2 times per week',
      'Less than once a week',
      'Never over the past 2 weeks'
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v3,
    title: '<br>3. Over the past 2 weeks, on average, how many times has fatigue limited your ability to do what you wanted?',
    type: :likert,
    options: [
      'All of the time',
      'Several times per day',
      'At least once a day',
      '3 or more times per week but not every day',
      '1-2 times per week',
      'Less than once a week',
      'Never over the past 2 weeks'
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v4,
    title: '<br>4. Over the past 2 weeks, on average, how many times has shortness of breath limited your ability to do what you wanted?',
    type: :likert,
    options: [
      'All of the time',
      'Several times per day',
      'At least once a day',
      '3 or more times per week but not every day',
      '1-2 times per week',
      'Less than once a week',
      'Never over the past 2 weeks'
    ],
    required: true, 
    show_otherwise: false
  },
  {
    id: :v5,
    title: '<br>5. Over the past 2 weeks, on average, how many times have you been forced to sleep sitting up in a chair or with at least 3 pillows to prop you up because of shortness of breath?',
    type: :likert,
    options: [
      'Every night',
      '3 or more times per week but not every day',
      '1-2 times per week',
      'Less than once a week',
      'Never over the past 2 weeks'
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v6,
    title: '<br>6. Over the past 2 weeks, how much has your heart failure limited your enjoyment of life?',
    type: :likert,
    options: [
      'It has extremely limited my enjoyment of life',
      'It has limited my enjoyment of life quite a bit',
      'It has moderately limited my enjoyment of life',
      'It has slightly limited my enjoyment of life',
      'It has not limited my enjoyment of life at all'
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v7,
    title: '<br>7. If you had to spend the rest of your life with your heart failure the way it is right now, how would you feel about this?',
    type: :likert,
    options: [
      'Not at all satisfied',
      'Mostly dissatisfied',
      'Somewhat satisfied',
      'Mostly satisfied',
      'Completely satisfied'
    ],
    required: true,
    show_otherwise: false
  },
  {
    type: :raw,
    content: '<p class="flow-text">8. How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in the following activities over the past 2 weeks.</p>'
  },
  {
    id: :v8a,
    title: 'Hobbies, recreational activities',
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      'Severely Limited',
      'Limited quite a bit',
      'Moderately limited',
      'Slightly limited',
      'Did not limit at all',
      'Does not apply or did not do for other reasons'
    ]
  },
  {
    id: :v8b,
    title: 'Working or doing household chores',
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      'Severely Limited',
      'Limited quite a bit',
      'Moderately limited',
      'Slightly limited',
      'Did not limit at all',
      'Does not apply or did not do for other reasons'
    ]
  },
  {
    id: :v8c,
    title: 'Visiting family or friends out of your home',
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      'Severely Limited',
      'Limited quite a bit',
      'Moderately limited',
      'Slightly limited',
      'Did not limit at all',
      'Does not apply or did not do for other reasons'
    ]
  }
]

questionnaire.content = {
  questions: dagboek_content,
  scores: []
}
questionnaire.title = db_title
questionnaire.save!