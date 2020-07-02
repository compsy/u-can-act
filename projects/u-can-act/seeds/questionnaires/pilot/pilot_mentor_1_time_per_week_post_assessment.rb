# frozen_string_literal: true

nm_name1 = 'nameting mentoren 1x per week'
nameting1 = Questionnaire.find_by(name: nm_name1)
nameting1 ||= Questionnaire.new(name: nm_name1)
nameting1.key = File.basename(__FILE__)[0...-3]
nameting1.content = { questions: [{
  section_start: 'Introductie',
  type: :raw,
  content: '<p class="flow-text">Al de volgende vragen gaan over de vragenlijsten die je de afgelopen drie weken hebt ingevuld. Wij willen heel graag weten wat je van deze vragenlijsten vond. Wees eerlijk, ook als je negatieve dingen te melden hebt. Daarmee kunnen wij de webapp verbeteren!</p>',
  section_end: true
}, {
  section_start: 'Algemeen',
  id: :v1,
  type: :range,
  title: 'Hoe vond je het om mee te doen aan dit onderzoek?',
  labels: ['niet leuk', 'heel leuk']
}, {
  id: :v2,
  type: :radio,
  title: 'Wat vond je van de vragen? Eén antwoord mogelijk: kies het antwoord dat je het best vindt passen.',
  options: ['Verwarrend', 'Duidelijk', 'Saai', 'Interessant', 'Geen mening']
}, {
  id: :v3,
  type: :range,
  title: 'Duurde het invullen van een vragenlijst te lang of was het kort genoeg?',
  labels: ['duurde veel te lang', 'duurde kort genoeg'],
  section_end: true
}, {
  section_start: 'User Interface',
  id: :v4,
  type: :textarea,
  title: 'Zie het voorbeeld hieronder: <br><img src="/images/begeleiders/landingspagina.png" class="questionnaire-image" /><br><br>Wat zou jij willen verbeteren aan deze pagina?',
  section_end: true
}, {
  section_start: 'Begrijpelijkheid',
  id: :v5,
  type: :range,
  title: 'Vond je de volgende vraag moeilijk of makkelijk te begrijpen? <br><span class="questionnaire-quote">"Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v6,
  type: :range,
  title: 'Vond je de volgende vraag moeilijk of makkelijk te begrijpen? <br><span class="questionnaire-quote">"Welke acties heb je deze week uitgevoerd om ...(het doel)… te bereiken?"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  type: :raw,
  content: '<p class="flow-text">Zie het voorbeeld hieronder:</p><img src="/images/begeleiders/doelen.png" class="questionnaire-image" /><p class="flow-text">Geef voor de volgende antwoordopties aan of ze moeilijk of makkelijk te begrijpen waren.</p>'
}, {
  id: :v7,
  type: :range,
  title: '<span class="questionnaire-quote">"Relatie verbeteren en/of onderhouden"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v8,
  type: :range,
  title: '<span class="questionnaire-quote">"Inzicht krijgen in de belevingswereld"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v9,
  type: :range,
  title: '<span class="questionnaire-quote">"Inzicht krijgen in de omgeving"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v10,
  type: :range,
  title: '<span class="questionnaire-quote">"Zelfinzicht geven"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v11,
  type: :range,
  title: '<span class="questionnaire-quote">"Vaardigheden ontwikkelen"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v12,
  type: :range,
  title: '<span class="questionnaire-quote">"De omgeving veranderen/afstemmen met de omgeving"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  type: :raw,
  content: '<p class="flow-text">Zie het voorbeeld hieronder:</p><img src="/images/begeleiders/acties.png" class="questionnaire-image" /><p class="flow-text">Geef voor de volgende antwoordopties aan of ze moeilijk of makkelijk te begrijpen waren.</p>'
}, {
  id: :v13,
  type: :range,
  title: '<span class="questionnaire-quote">"Laagdrempelig contact gelegd"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v14,
  type: :range,
  title: '<span class="questionnaire-quote">"Praktische oefeningen uitgevoerd"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v15,
  type: :range,
  title: '<span class="questionnaire-quote">"Gespreks- inteventies/technieken gebruikt"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v16,
  type: :range,
  title: '<span class="questionnaire-quote">"Het netwerk betrokken"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v17,
  type: :range,
  title: '<span class="questionnaire-quote">"Motiverende handelingen uitgevoerd"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v18,
  type: :range,
  title: '<span class="questionnaire-quote">"Observaties gedaan"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  type: :raw,
  content: '<p class="flow-text">Zie het voorbeeld hieronder:</p><img src="/images/begeleiders/omgeving.png" class="questionnaire-image" /><p class="flow-text">Geef voor de volgende antwoordopties aan of ze moeilijk of makkelijk te begrijpen waren.</p>'
}, {
  id: :v19,
  type: :range,
  title: '<span class="questionnaire-quote">"(omgeving), met als doel afstemmen"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v20,
  type: :range,
  title: '<span class="questionnaire-quote">"(omgeving), met als doel veranderen"</span>',
  labels: ['heel moeilijk', 'heel makkelijk']
}, {
  id: :v21,
  type: :range,
  title: 'Was het voor jou duidelijk over wie je een vragenlijst invulde?',
  labels: ['helemaal niet duidelijk', 'heel duidelijk'],
  section_end: true
}, {
  section_start: 'Timing',
  id: :v22,
  type: :radio,
  title: 'Je kreeg elke keer om 12 uur een sms als er weer een vragenlijst voor je open stond. Is dat een goede tijd voor jou?',
  options: ['Ja'],
  otherwise_label: 'Nee, liever een andere tijd, namelijk:'
}, {
  id: :v23,
  type: :radio,
  title: 'Als je de vragenlijst om 20:00 nog niet had ingevuld kreeg je een herinnerings sms. Is dat een goede tijd voor jou?',
  options: ['Ja'],
  otherwise_label: 'Nee, liever een andere tijd, namelijk:'
}, {
  id: :v24,
  type: :radio,
  title: 'Zou je nog een extra herinnering willen ontvangen op een bepaalde tijd?',
  options: ['Nee'],
  otherwise_label: 'Ja, namelijk om:'
}, {
  id: :v25,
  type: :radio,
  title: 'Je kreeg nu elke donderdag een vragenlijst. Zou je deze liever op een andere dag krijgen?',
  options: ['Nee', 'Ja, op maandag', 'Ja, op dinsdag', 'Ja, op woensdag', 'Ja, op vrijdag'],
  section_end: true
}, {
  section_start: 'Missen van vragenlijsten',
  id: :v26,
  type: :checkbox,
  title: 'Wat waren de redenen dat je wel eens een vragenlijst hebt gemist? (meerdere antwoorden mogelijk)',
  options: ['Ik heb nooit een vragenlijst gemist',
            'Ik kreeg geen sms',
            'De link naar de vragenlijst werkte niet',
            'Ik had geen tijd',
            'Ik had geen zin',
            'Ik was het vergeten',
            'Mijn batterij was leeg',
            'Ik zat op dat moment niet met mijn telefoon op wifi',
            'De databundel van mijn telefoon was op',
            'De vragenlijst was al verlopen'],
  section_end: true
}, {
  section_start: 'Volhouden',
  id: :v27,
  type: :radio,
  title: 'Je hebt nu drie weken meegedaan aan dit onderzoek. Denk je dat je ditzelfde onderzoek ook voor zeven maanden zou volhouden?',
  options: ['Ja'],
  otherwise_label: 'Nee, omdat:',
  section_end: true
}, {
  section_start: 'Tot slot',
  id: :v28,
  type: :textarea,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
  section_end: true
}], scores: [] }
nameting1.title = 'Eindmeting begeleiders'
nameting1.save!
