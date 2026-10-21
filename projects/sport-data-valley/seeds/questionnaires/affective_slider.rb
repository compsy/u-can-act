# frozen_string_literal: true

# TODO: Only the English text of the affective slider exists. Since nl is required, the nl slots contain the English
# text as a placeholder. Replace them, and add the fi, de, es and pt texts, as soon as the client delivers the official
# translations. Do not translate these texts ourselves.

slider_min = 0
slider_max = 100
slider_start = (slider_min + slider_max) / 2

db_title = ''

db_name1 = 'affective_slider'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    id: :v1,
    type: :affective_slider,
    variant: :pleasure,
    required: true,
    min: slider_min,
    max: slider_max,
    value: slider_start,
    title: { nl: 'Move the slider to rate your level of Pleasure',
             en: 'Move the slider to rate your level of Pleasure' },
    labels: [{ nl: 'Unhappy', en: 'Unhappy' },
             { nl: 'Happy', en: 'Happy' }]
  },
  {
    id: :v2,
    type: :affective_slider,
    variant: :activation,
    required: true,
    min: slider_min,
    max: slider_max,
    value: slider_start,
    title: { nl: 'Move the slider to rate how Activated your body feels right now',
             en: 'Move the slider to rate how Activated your body feels right now' },
    labels: [{ nl: 'Calm / resting', en: 'Calm / resting' },
             { nl: 'Racing / highly activated', en: 'Racing / highly activated' }]
  },
  {
    type: :next_questionnaire_notice
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
