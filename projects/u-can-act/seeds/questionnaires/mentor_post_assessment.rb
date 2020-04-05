# frozen_string_literal: true

nm_name1 = 'nameting mentoren'
nameting1 = Questionnaire.find_by_name(nm_name1)
nameting1 ||= Questionnaire.new(name: nm_name1)
nameting1.key = File.basename(__FILE__)[0...-3]
nameting1.content = { questions: [{
  id: :v1,
  type: :textfield,
  title: 'Kan je in één woord beschrijven hoe jij het ervaart om jongeren te begeleiden binnen {{je_begeleidingsinitiatief}}?'
}, {
  id: :v2,
  type: :range,
  title: 'In hoeverre vind jij dat {{deze_student}} vooruitgang heeft geboekt in {{zijn_haar_student}} begeleidingstraject?',
  foreach: :student,
  labels: ['helemaal niet', 'heel veel']
}, {
  id: :v3,
  type: :range,
  title: 'Hielp het invullen van de webapp je om jouw jongeren beter te begeleiden?',
  labels: ['helemaal niet', 'helemaal wel']
}, {
  id: :v4,
  type: :range,
  title: 'Hoe vond jij het om de webapp ongeveer een half jaar lang wekelijks in te vullen?',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v5,
  type: :range,
  min: 1,
  max: 10,
  step: 0.5,
  title: 'Wat voor cijfer zou je de webapp geven?',
  labels: %w[1 10]
}, {
  id: :v6,
  type: :range,
  title: "Zou je jouw collega's aanraden om ook mee te doen aan het u-can-act onderzoek?",
  labels: ['nee, totaal niet', 'ja, zeker wel']
}, {
  id: :v7,
  type: :textarea,
  title: 'Heb je nog tips hoe wij het onderzoek of de webapp beter kunnen maken in de toekomst?'
}], scores: [] }
nameting1.title = 'Eindmeting begeleiders'
nameting1.save!
