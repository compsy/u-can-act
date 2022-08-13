# frozen_string_literal: true

db_title = ''

db_name1 = 'weekly_wellbeing'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: { nl: "<h4 class=\"header\">Wekelijkse welzijn</h4>",
               en: "<h4 class=\"header\">Weekly wellbeing</h4>" }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Selecteer de optie die het beste aansluit bij je welbevinden van <strong>de afgelopen 7 dagen</strong>. Wanneer je niet helemaal zeker bent van jouw antwoord, probeer dan zo goed als mogelijk een antwoord te geven.</p>',
               en: '<p class="flow-text">Select the option that best fits your well-being during <strong>the past 7 days</strong>. If you are not entirely sure of your answer, try to answer as best you can.</p>' }
  },
  {
    id: :v1,
    title: { nl: 'Wat was <strong>de afgelopen 7 dagen</strong> je gemiddelde slaapkwaliteit?',
             en: 'What was your average sleep quality during <strong>the past 7 days</strong>?' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    required: true,
    no_initial_thumb: true,
    ticks: true,
    labels: [{ nl: 'Slapeloosheid', en: 'Insomnia' },
             { nl: 'Onrustige slaap', en: 'Restless sleep' },
             { nl: 'Normaal', en: 'Normal' },
             { nl: 'Goed geslapen', en: 'Good' },
             { nl: 'Erg goed geslapen', en: 'Very rested' }]
  },
  {
    id: :v2,
    title: { nl: 'Wat was <strong>de afgelopen 7 dagen</strong> je gemiddelde slaapduur?',
             en: 'What was your average sleep duration during <strong>the past 7 days</strong>?' },
    type: :time,
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: { nl: 'Uren', en: 'Hours' },
    minutes_label: { nl: 'Minuten', en: 'Minutes' }
  },
  {
    id: :v3,
    title: { nl: 'Hoe vermoeid was je <strong>de afgelopen 7 dagen</strong>?',
             en: 'How tired were you in <strong>the past 7 days</strong>?' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    required: true,
    no_initial_thumb: true,
    ticks: true,
    labels: [{ nl: 'Heel vermoeid', en: 'Very tired' },
             { nl: 'Meer vermoeid dan normaal', en: 'More tired than usual' },
             { nl: 'Normaal', en: 'Normal' },
             { nl: 'Energiek', en: 'Fit' },
             { nl: 'Heel energiek', en: 'Very fit' }]
  },
  {
    id: :v4,
    title: { nl: 'Hoe gestrest was je <strong>de afgelopen 7 dagen</strong>?',
             en: 'How stressed were you in <strong>the past 7 days</strong>?' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    required: true,
    no_initial_thumb: true,
    ticks: true,
    labels: [{ nl: 'Erg gestresst', en: 'Very stressed' },
             { nl: 'Gestresst', en: 'Stressed' },
             { nl: 'Normaal', en: 'Normal' },
             { nl: 'Relaxed', en: 'Relaxed' },
             { nl: 'Erg relaxed', en: 'Very relaxed' }]
  },
  {
    id: :v5,
    title: { nl: 'Wat was je gemoedstoestand <strong>de afgelopen 7 dagen</strong>?',
             en: 'What was your mood in <strong>the past 7 days</strong>?' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    required: true,
    no_initial_thumb: true,
    ticks: true,
    labels: [{ nl: 'Erg prikkelbaar / down', en: 'Highly annoyed / irritable / down' },
             { nl: 'Kortaf tegen teamgenoten, familie en collega’s', en: 'Snappiness at teammates, family and co-workers' },
             { nl: 'Normaal', en: 'Normal' },
             { nl: 'Een overwegend goede gemoedstoestand', en: 'A generally good mood' },
             { nl: 'Een erg positieve gemoedstoestand', en: 'A very positive mood' }],
  },
  {
    id: :v6,
    title: { nl: 'Opmerking', en: 'Comment' },
    placeholder: { nl: 'Vul iets in (optioneel)', en: 'Enter some text (optional)' },
    type: :textarea
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
