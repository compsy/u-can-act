# frozen_string_literal: true

db_title = '' # what is this for?
db_name = 'move_mood_motivation'
questionnaire = Questionnaire.find_by(name: db_name)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = db_name


question_content = [
  {
    type: :raw,
    content : { nl: "<h4 class=\"header\">Move, Mood & Motivation vragenlijst</h4>",
                en: "<h4 class=\"header\">Move, Mood & Motivation questionnaire</h4>" }
  },
  {
    # TODO This question should only be filled in the first time!
    id: :v0,
    type: :radio,
    title: {  nl: "Gebruik je een eigen activity tracker (b.v. Garmin, Fitbit)?",
              en: "Do you use your own activity tracker (i.e. Garmin, Fitbit)?" }
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
      },
    ]
  }
]

questionnaire.content = { questions: question_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!