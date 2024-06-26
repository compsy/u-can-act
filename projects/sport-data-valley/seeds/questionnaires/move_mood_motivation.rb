# frozen_string_literal: true

MMM_QUESTIONNAIRE_NAME = 'move_mood_motivation'

db_name = MMM_QUESTIONNAIRE_NAME
questionnaire = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
questionnaire ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
questionnaire.name = db_name

frequency_options = [
  {
    title: {  nl: "Nooit",
            en: "Never" },
    value: "never",
    numeric_value: 1
  },
  {
    title: {  nl: "Zelden",
            en: "Rarely" },
    value: "rarely",
    numeric_value: 2
  },
  {
    title: {  nl: "Soms",
            en: "Sometimes" },
    value: "sometimes",
    numeric_value: 3
  },
  {
    title: {  nl: "Vaak",
            en: "Often" },
    value: "often",
    numeric_value: 4
  },
  {
    title: {  nl: "Altijd",
            en: "Always" },
    value: "always",
    numeric_value: 5
  },
]

agreement_options = [
  {
    title: {  nl: "Zeer oneens",
            en: "Strongly disagree" },
    value: "strongly-disagree",
    numeric_value: 1
  },
  {
    title: {  nl: "Oneens",
            en: "Disagree" },
    value: "disagree",
    numeric_value: 2
  },
  {
    title: {  nl: "Neutraal",
            en: "Neutral" },
    value: "neutral",
    numeric_value: 3
  },
  {
    title: {  nl: "Eens",
            en: "Agree" },
    value: "agree",
    numeric_value: 4
  },
  {
    title: {  nl: "Zeer eens",
            en: "Strongly agree" },
    value: "strongly-agree",
    numeric_value: 5
  },
]


question_content = [
  {
    type: :raw,
    content: { nl: "<h4 class=\"header\">Move, Mood & Motivation vragenlijst</h4>",
                en: "<h4 class=\"header\">Move, Mood & Motivation questionnaire</h4>" }
  },
  {
    id: 'v1_activity_tracker',
    type: :radio,
    required: true,
    section_start: {
      nl: "Check op gebruik eigen activity tracker",
      en: "Check whether you use your own activity tracker"
    },
    section_end: true,
    title: {  nl: "Gebruik je een eigen activity tracker (b.v. Garmin, Fitbit)?",
              en: "Do you use your own activity tracker (i.e. Garmin, Fitbit)?" },
    options: [
      {
        title: {  nl: "Nee, en ook niet eerder gedragen.",
                en: "No, and I haven’t used one before." },
        value: "never-used"
      },
      {
        title: {  nl: "Nee, maar wel eerder gedragen.",
                en: "No, but I have used one before." },
        value: "no-but-have-used-before"
      },
      {
        title: {  nl: "Ja, maar voor dit onderzoek heb ik mijn eigen activity tracker afgedaan.",
                en: "Yes, but for this study I will not use my own activity tracker." },
        value: "yes-but-not-for-this-study"
      },
      {
        title: {  nl: "Ja, ik blijf mijn eigen activity tracker gedurende het onderzoek dragen.",
                en: "Yes, and I will keep using my own activity tracker during this study." },
        value: "yes-and-will-use-throughout-the-study"
      }
    ],
    show_otherwise: false
  },
  {
    id: 'v2_lifestyle',
    type: :likert,
    required: true,
    section_start: {
      nl: "Algemene gezondheid/levensstijl",
      en: "General health/lifestyle"
    },
    section_end: true,
    title: {  nl: "Hoe zou jij je levensstijl over het algemeen beschrijven? (Neem hierbij in overweging: voeding, beweging, nachtrust, roken, alcohol, drugs)",
              en: "How would you generally describe your lifestyle? (take into account: nutrition, exercise, sleep, smoking, alcohol, drug use)" },
    options: [
      {
        title: {  nl: "Zeer ongezond",
                en: "Very unhealthy" },
        numeric_value: 1
      },
      {
        title: {  nl: "Ongezond",
                en: "Unhealthy" },
        numeric_value: 2
      },
      {
        title: {  nl: "Niet ongezond / niet gezond",
                en: "Not healthy / not unhealthy" },
        numeric_value: 3
      },
      {
        title: {  nl: "Gezond",
                en: "Healthy" },
        numeric_value: 4
      },
      {
        title: {  nl: "Zeer gezond",
                en: "Very healthy" },
        numeric_value: 5
      }
    ]
  },
  {
    id: 'v3_sleep_quality',
    type: :range,
    required: true,
    section_start: {
      nl: "Slaapkwaliteit",
      en: "Sleep quality"
    },
    section_end: true,
    title: {  nl: "Over de laatste 7 dagen, hoe zou je jouw slaapkwaliteit over het algemeen beoordelen op een schaal van 0 (vreselijk) tot 10 (uitstekend)?",
              en: "During the past 7 days, how would you rate your sleep quality overall on a scale from 0 (terrible) to 10 (excellent)?" },
    labels: [
      {
        nl: "vreselijk",
        en: "terrible"
      },
      {
        nl: "uitstekend",
        en: "excellent"
      },
    ],
    min: 0,
    max: 10,
    step: 1
  },
  {
    id: 'v4_vigorous_physical_activity',
    type: :likert,
    required: true,
    section_start: {
      nl: "Beweeggedrag",
      en: "Physical activity behaviour"
    },
    title: {  nl: "Hoeveel keer per week voer je gewoonlijk gedurende 20 minuten of meer een fysiek zware activiteit uit? (bv. hardlopen, spinnen, squash)",
              en: "How many times a week do you usually perform a vigorous physical activity for 20 minutes or more? (e.g. running, spinning, squash)" },
    options: [
      {
        title: {  nl: "Niet",
                en: "None" },
        value: "none"
      },
      {
        title: {  nl: "1 tot 2 keer per week",
                en: "1 or 2 times a week" },
        value: "1-or-2"
      },
      {
        title: {  nl: "3 keer per week of vaker",
                en: "3 times a week or more" },
        value: "3-or-more"
      }
    ],
    show_otherwise: false
  },
  {
    id: 'v5_moderate_physical_activity',
    type: :likert,
    required: true,
    section_end: true,
    title: {  nl: "Hoeveel keer per week voer je gewoonlijk gedurende 30 minuten of meer een matig-intense fysieke activiteit uit? (bv. wandelen, rustig fietsen, roeien)",
              en: "How many times a week do you usually perform moderate physical activity for 30 minutes or more? (e.g. walking, cycling, rowing)" },
    options: [
      {
        title: {  nl: "Niet",
                en: "None" },
        value: "none"
      },
      {
        title: {  nl: "1 tot 2 keer per week",
                en: "1 or 2 times a week" },
        value: "1-or-2"
      },
      {
        title: {  nl: "3 tot 4 keer per week",
                en: "3 or 4 times a week" },
        value: "3-or-4"
      },
      {
        title: {  nl: "5 keer per week of vaker",
                en: "5 times a week or more" },
        value: "5-or-more"
      },
    ],
    show_otherwise: false
  },
  {
    id: 'v6_study_motivation',
    type: :range,
    required: true,
    section_start: {
      nl: "Studiemotivatie",
      en: "Study motivation"
    },
    section_end: true,
    title: {  nl: "Op een schaal van 0 tot 10, waarbij 0 het laagst mogelijke en 10 het hoogst mogelijke is, geef aan hoe je jezelf scoort op je studiemotivatie:",
              en: "On a scale of 0 to 10, where 0 is the lowest possible, and 10 is the highest possible score, please indicate how you rank yourself on your study motivation:" },
    min: 0,
    max: 10,
    labels: [
      {
        nl: "laag",
        en: "low"
      },
      {
        nl: "hoog",
        en: "high"
      },
    ],
    step: 1
  },
  {
    id: 'v7_study_stress',
    type: :range,
    required: true,
    section_start: {
      nl: "Studiestress",
      en: "Study stress"
    },
    section_end: true,
    title: {  nl: "Op een schaal van 0 tot 10, waarbij 0 het laagst mogelijke en 10 het hoogst mogelijke is, geef aan hoe je jezelf scoort op de mate van ervaren stress door de studie:",
              en: "On a scale of 0 to 10, where 0 is the lowest possible, and 10 is the highest possible score, please indicate how you rank yourself on the level of study related stress:" },
    min: 0,
    max: 10,
    labels: [
      {
        nl: "laag",
        en: "low"
      },
      {
        nl: "hoog",
        en: "high"
      },
    ],
    step: 1
  },
  {
    id: 'v8_considered_discontinuing',
    section_start: {
      nl: "Intentie stoppen opleiding",
      en: "Intention to stop training"
    },
    section_end: true,
    type: :radio,
    required: true,
    title: {  nl: "Heb je in de afgelopen 7 dagen overwogen om te stoppen met je opleiding?",
              en: "Have you seriously considered discontinuing your study during the last 7 days?" },
    options: [
      {
        title: {  nl: "Ja",
                en: "Yes" },
        value: "yes"
      },
      {
        title: {  nl: "Nee",
                en: "No" },
        value: "no"
      },
    ],
    show_otherwise: false
  },
  {
    id: 'v9_general_life_satisfaction',
    type: :range,
    required: true,
    section_start: {
      nl: "Algemene levenstevredenheid",
      en: "General life satisfaction"
    },
    section_end: true,
    title: {  nl: "Neem aan dat de schaal hieronder een manier is om je leven voor te stellen. Links (nummer 0) staat voor het slechtst mogelijke leven voor jou. Rechts (nummer 10) staat voor het best mogelijke leven voor jou. Waar op de schaal sta je op dit moment?",
              en: "Assume that this scale is a way of picturing your life. The left (number 0) represents the worst possible life for you. The right (number 10) represents the best possible life for you. Indicate where on the scale you feel you personally stand right now:" },
    min: 0,
    max: 10,
    step: 1,
    ticks: true,
    labels: [
      {
        nl: "slechtst",
        en: "worst"
      },
      *(Array.new(9) { { nl: '', en: ''} }), # Necessary for the labels to show on the right place
      {
        nl: "best",
        en: "best"
      },
    ]
  },
  {
    type: :raw,
    section_start: {
      nl: "Emotionele uitputting",
      en: "Emotional exhaustion"
    },
    content: { nl: '<p class="flow-text">In hoeverre zijn deze uitspraken op jou van toepassing?</p>',
              en: '<p class="flow-text">Please indicate how often these statements are applicable to you:</p>' }
  },
  {
    id: 'v10_mental_drainage',
    type: :likert,
    required: true,
    title: {  nl: "Door mijn studie voel ik me geestelijk uitgeput.",
              en: "I feel mentally drained by my studies." },
    options: frequency_options,
    show_otherwise: false
  },
  {
    id: 'v11_energy_recovery',
    type: :likert,
    required: true,
    title: {  nl: "Ik raak maar niet uitgerust nadat ik een dag gestudeerd heb.",
              en: "After a day of school(work), I find it hard to recover my energy." },
    options: frequency_options,
    show_otherwise: false
  },
  {
    id: 'v12_physical_exhaustion',
    type: :likert,
    required: true,
    title: {  nl: "Na een dag op de hogeschool voel ik mij lichamelijk uitgeput.",
              en: "After a day of school(work), I feel physically exhausted." },
    options: frequency_options,
    show_otherwise: false
  },
  {
    id: 'v13_morning_energy',
    type: :likert,
    required: true,
    section_end: true,
    title: {  nl: "Als ik ‘s morgens opsta, mis ik de energie om aan de schooldag te beginnen.",
              en: "When I get up in the morning, I lack the energy to start a new day at school." },
    options: frequency_options,
    show_otherwise: false
  },
  {
    type: :raw,
    section_start: {
      nl: "Veerkracht",
      en: "Resilience"
    },
    content: { nl: '<p class="flow-text">Geef aan in hoeverre je het eens bent met de volgende stellingen:</p>',
              en: '<p class="flow-text">Please indicate to which extent you agree or disagree to the following statements:</p>' }
  },
  {
    id: 'v14_trouble_moving_past_stressful_experiences',
    type: :likert,
    required: true,
    title: {  nl: "Ik vind het moeilijk om me door stressvolle gebeurtenissen heen te slaan.",
              en: "I have trouble moving past stressful experiences." },
    options: agreement_options,
    show_otherwise: false
  },
  {
    id: 'v15_time_recovering_from_stressful_experiences',
    type: :likert,
    required: true,
    title: {  nl: "Het kost me veel tijd om te herstellen van een stressvolle gebeurtenis",
              en: "It takes a long time for me to recover from a stressful experience." },
    options: agreement_options,
    show_otherwise: false
  },
  {
    id: 'v16_getting_over_setbacks',
    type: :likert,
    required: true,
    section_end: true,
    title: {  nl: "Het kost me meestal veel tijd om over tegenslagen in mijn leven heen te komen",
              en: "It usually takes a long time for me to get over setbacks in my life." },
    options: agreement_options,
    show_otherwise: false
  },
  {
    id: 'v17_study_participation_experience',
    type: :textarea,
    required: true,
    section_start: {
      nl: "Open vragen",
      en: "Open questions"
    },
    title: {  nl: "Hoe ervaar je momenteel je deelname aan dit onderzoek?",
              en: "How do you currently experience your participation in this study?" }
  },
  {
    id: 'v18_does_questionnaire_affect',
    type: :radio,
    required: true,
    title: {  nl: "Heeft het invullen van de vragenlijsten invloed op wat je doet en/of hoe je je voelt?",
              en: "Does completing the questionnaires affect what you do and/or how you feel?" },
    options: [
      {
        title: {  nl: "Ja",
                en: "Yes" },
        value: "yes",
        shows_questions: ['v19_how_questionnaire_affects']
      },
      {
        title: {  nl: "Nee",
                en: "No" },
        value: "no"
      }
    ],
    show_otherwise: false
  },
  {
    id: 'v19_how_questionnaire_affects',
    type: :textarea,
    hidden: true,
    required: true,
    title: {  nl: "Zo ja, geef dan aan wat voor invloed het op jou heeft:",
              en: "If so, please indicate how it affects you:" },
  },
  {
    id: 'v20_does_tracker_affect',
    type: :radio,
    required: false,
    title: {  nl: "Heeft het dragen van de activity tracker invloed op wat je doet en/of hoe je je voelt?",
              en: "Does wearing the activity tracker affect what you do and/or how you feel?" },
    options: [
      {
        title: {  nl: "Ja",
                en: "Yes" },
        value: "yes",
        shows_questions: ['v21_how_tracker_affects']
      },
      {
        title: {  nl: "Nee",
                en: "No" },
        value: "no"
      }
    ],
    show_otherwise: false
  },
  {
    id: 'v21_how_tracker_affects',
    type: :textarea,
    required: true,
    hidden: true,
    title: {  nl: "Zo ja, geef dan aan wat voor invloed het op jou heeft:",
              en: "If so, please indicate how it affects you:" },
  },
  {
    id: 'v22_last_remarks',
    type: :textarea,
    section_end: true,
    title: {  nl: "Is er nog iets anders dat je kwijt wil? (Zo niet, dan kan je dit antwoordveld leeg laten)",
              en: "Is there anything else you would like to share? (If not, you can leave this answer field empty)" },
  }
]

questionnaire.content = { questions: question_content, scores: [] }
questionnaire.title = ''
questionnaire.save!
