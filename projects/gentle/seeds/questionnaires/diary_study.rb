# frozen_string_literal: true

db_title = 'GENTLE Diary study'

db_name1 = 'gentle_diary_study'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    id: :v1,
    title: 'Select your network',
    type: :gentle,
    network: '{{previous_v1}}',
    uses: {
      previous: :v1,
      default: "{\"nodes\":[{\"key\":0,\"name\":\"You\",\"categoryColor\":\"green\",\"color\":\"green\",\"size\":10,\"x\":250,\"y\":250,\"floatX\":250,\"floatY\":250,\"fixed\":false,\"float\":false,\"link\":false,\"shouldFloat\":false}],\"links\":[],\"foci\":[{\"key\":0,\"x\":250,\"y\":250}],\"counter\":0,\"source\":-1,\"correction\":0}",
    },
    required: true
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
