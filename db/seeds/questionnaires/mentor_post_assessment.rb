nm_name1 = 'nameting mentoren'
nameting1 = Questionnaire.find_by_name(nm_name1)
nameting1 ||= Questionnaire.new(name: nm_name1)
nameting1.key = File.basename(__FILE__)[0...-3]
nameting1.content = [{
  id: :v1,
  type: :textarea,
  title: 'Kan je in één woord beschrijven hoe jij het ervaart jij om jongeren te begeleiden binnen {{je_begeleidingsinitiatief}}?'
}, {
  id: :v2,
  type: :range,
  title: 'In hoeverre vind jij dat {{deze_student}} vooruitgang heeft geboekt in {{zijn_haar_student}} begeleidingstraject?',
  foreach: :student,
  labels: ['Helemaal niet ', 'heel veel']
}, {
  id: :v3,
  type: :range,
  title: 'Hielp het invullen van de app je om jouw jongeren beter te begeleiden? ',
  labels: ['Helemaal niet ', 'helemaal wel']
}, {
  id: :v3,
  type: :range,
  title: 'Hoe moeilijk was het om zo lang elke week de app in te vullen?',
  labels: ['Heel moeilijk', 'heel makkelijk']
}, {
  id: :v4,
  type: :range,
  min: 1,
  max: 10,
  step: 0.5,
  title: 'Wat voor cijfer zou je de app geven?',
  labels: ['1', '10']
}, {
  id: :v5,
  type: :range,
  title: 'In hoeverre zou je collega’s aanraden om ook mee te doen aan het u-can-act onderzoek?',
  labels: ['Helemaal niet', 'helemaal wel']
}, {
  id: :v6,
  type: :textarea,
  title: 'Heb je nog tips voor ons om het onderzoek of de app beter te maken in de toekomst?'
}]
nameting1.title = 'Eindmeting begeleiders'
nameting1.save!
