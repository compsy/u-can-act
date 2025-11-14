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
    id: :q1_table,
    title: '1. Heart failure affects different people in different ways. Some feel shortness of breath while others feel fatigue. Please indicate how much you are limited by heart failure (shortness of breath or fatigue) in your ability to do the following activities over the past 2 weeks.',
    type: :table,
    required: true,
    options: [
      'Extremely Limited',
      'Quite a bit Limited',
      'Moderately Limited',
      'Slightly Limited',
      'Not at all Limited',
      'Limited for other reasons or did not do the activity'
    ],
    show_otherwise: false,
    rows: [
      {
        id: :q1a,
        title: 'a. Showering/Bathing'
      },
      {
        id: :q1b,
        title: 'b. Walking 1 block on level ground'
      },
      {
        id: :q1c,
        title: 'c. Hurrying or jogging (as if to catch a bus)'
      }
    ]
  },
  {
    id: :q2,
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
    id: :q3,
    title: '3. Over the past 2 weeks, on average, how many times has fatigue limited your ability to do what you wanted?',
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
    id: :q4,
    title: '4. Over the past 2 weeks, on average, how many times has shortness of breath limited your ability to do what you wanted?',
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
    id: :q5,
    title: '5. Over the past 2 weeks, on average, how many times have you been forced to sleep sitting up in a chair or with at least 3 pillows to prop you up because of shortness of breath?',
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
    id: :q6,
    title: '6. Over the past 2 weeks, how much has your heart failure limited your enjoyment of life?',
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
    id: :q7,
    title: '7. If you had to spend the rest of your life with your heart failure the way it is right now, how would you feel about this?',
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
    id: :q8_table,
    title: '8. How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in the following activities over the past 2 weeks.',
    type: :likert,
    required: true,
    options: [
      'Severely Limited',
      'Limited quite a bit',
      'Moderately limited',
      'Slightly limited',
      'Did not limit at all',
      'Does not apply or did not do for other reasons'
    ],
    show_otherwise: false,
    rows: [
      {
        id: :q8a,
        title: 'a. Hobbies, recreational activities'
      },
      {
        id: :q8b,
        title: 'b. Working or doing household chores'
      },
      {
        id: :q8c,
        title: 'c. Visiting family or friends out of your home'
      }
    ]
  }
]

questionnaire.content = {
  questions: dagboek_content,
  scores: []
}
questionnaire.title = db_title
questionnaire.save!