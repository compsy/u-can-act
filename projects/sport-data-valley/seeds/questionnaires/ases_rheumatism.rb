# frozen_string_literal: true

db_title = ''
db_name1 = 'ases_rheumatism'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

class RheumatismAsesMethods
  DEFAULT_QUESTION_OPTIONS = {
    type: :range,
    min: 1,
    max: 10,
    step: 1,
    required: true,
    labels: ['erg onzeker', 'erg zeker']
  }
end

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Geef voor elk van de volgende vragen aan welk nummer het best weergeeft hoe zeker u bent dat u deze taken regelmatig kunt uitvoeren.</p>',
  }, RheumatismAsesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v1,
    title: 'Ik ben er zeker van dat ik mijn vermoeidheid kan beheersen.'
  }), RheumatismAsesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v2,
    title: 'Ik ben er zeker van dat ik mijn bezigheden zo kan regelen dat mijn reumatische aandoening er niet door wordt verergerd.'
  }), RheumatismAsesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v3,
    title: 'Ik ben er zeker van dat ik me er zelf weer bovenop kan helpen als ik me een beetje somber voel.'
  }), RheumatismAsesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v4,
    title: 'Ik ben er zeker van dat ik mijn reumatische aandoening zodanig kan beheersen dat ik kan doen wat ik leuk vind.'
  }), RheumatismAsesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v5,
    title: 'Ik ben er zeker van dat ik de frustraties die ik door mijn reumatische aandoening ondervind, aankan.'
  }), {
    type: :raw,
    content: '<p class="flow-text">Klik hieronder op \'Opslaan\' om de antwoorden in te leveren en door te gaan naar de volgende vragenlijst.</p>'
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
