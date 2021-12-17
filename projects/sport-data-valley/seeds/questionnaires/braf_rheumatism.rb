# frozen_string_literal: true

db_title = ''
db_name1 = 'braf_rheumatism'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

class RheumatismBrafMethods
  DEFAULT_QUESTION_OPTIONS = {
    type: :likert,
    options: ['Helemaal niet', 'Een beetje', 'Nogal', 'Heel erg'],
  }
end

dagboek_content = [
  {
    section_start: '',
    type: :raw,
    content: '<p class="flow-text">Wij willen graag weten welke invloed vermoeidheid op u heeft gehad in <strong>de afgelopen 7 dagen</strong>. Wilt u alstublieft alle vragen beantwoorden? Denk er niet te lang en te diep over na, maar geef uw eerste reactie - er zijn geen goede of foute antwoorden!</p>',
  }, {
    id: :v1,
    type: :range,
    title: 'Selecteer het cijfer dat uw gemiddelde vermoeidheidsniveau weergeeft in de afgelopen 7 dagen.',
    min: 0,
    max: 10,
    step: 1,
    required: true,
    no_initial_thumb: true,
    labels: ['Geen vermoeidheid', 'Volledig uitgeput'],
    section_end: true
  }, {
    section_start: 'Vink voor elk van de volgende vragen <strong>één</strong> antwoord aan dat het best op u van toepassing is.',
    id: :v2,
    type: :radio,
    title: 'Hoeveel dagen hebt u vermoeidheid ervaren in de afgelopen week (7 dagen)',
    options: ['0', '1', '2', '3', '4', '5', '6', 'Elke dag'],
    show_otherwise: false
  }, {
    id: :v3,
    type: :radio,
    title: 'Hoe lang duurde elke periode van vermoeidheid gemiddeld de afgelopen 7 dagen?',
    options: ['Minder dan een uur', 'Meer dan een uur, maar niet de hele dag', 'De hele dag'],
    show_otherwise: false,
    section_end: true,
  }, RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    section_start: 'De afgelopen 7 dagen...',
    id: :v4,
    title: 'Had u te weinig <em>lichamelijke</em> energie vanwege vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v5,
    title: 'Had u moeite met in bad gaan of douchen vanwege vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v6,
    title: 'Had u moeite met het aankleden vanwege vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v7,
    title: 'Had u moeite met het uitoefenen van uw werkzaamheden of andere dagelijkse activiteiten vanwege vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v8,
    title: 'Hebt u het maken van plannen vermeden vanwege vermoeidheid?',
    tooltip: 'Bijvoorbeeld: plannen om uit te gaan, of klusjes in huis of tuin te doen.'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v9,
    title: 'Heeft vermoeidheid uw sociale leven beïnvloed?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v10,
    title: 'Hebt u plannen geannuleerd vanwege vermoeidheid?',
    tooltip: 'Bijvoorbeeld: plannen om uit te gaan, of klusjes in huis of tuin te doen.'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v11,
    title: 'Hebt u  uitnodigingen afgeslagen vanweged vermoeidheid?',
    tooltip: 'Bijvoorbeeld: afspreken met een vriend(in).'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v12,
    title: 'Had u te weinig <em>geestelijke</em> energie vanwege vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v13,
    title: 'Bent u dingen vergeten vanwege vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v14,
    title: 'Kon u moeilijk helder denken vanwege vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v15,
    title: 'Kon u zich moeilijk concentreren vanwege vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v16,
    title: 'Hebt u vergissingen gemaakt vanwege vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v17,
    title: 'Hebt u het gevoel gehad dat u minder controle had over bepaalde zaken in uw leven vanwege vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v18,
    title: 'Voelde u zich in verlegenheid gebracht als gevolg van vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v19,
    title: 'Bent u van streek geweest als gevolg van vermoeidheid?'
  }), RheumatismBrafMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v20,
    title: 'Hebt u zich somder of depressief gevoeld vanwege vermoeidheid?',
    section_end: true
  })
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
