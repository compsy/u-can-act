# frozen_string_literal: true

nm_name1 = 'nameting studenten 1x per week'
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
  type: :range,
  title: 'Zie het voorbeeld hieronder: <br><img src="/images/studenten/opleiding.png" class="questionnaire-image" /><br><br>Hoe vond je het om de vragen te beantwoorden door een bolletje te verschuiven?',
  labels: ['heel vervelend', 'heel prettig']
}, {
  id: :v5,
  type: :radio,
  title: 'Zie het voorbeeld hieronder: <br><img src="/images/studenten/ballonnetje.png" class="questionnaire-image" /><br><br>Wanneer je het bolletje verplaatst komt er een ballonnetje met een getal tevoorschijn. Vond je dit handig?',
  options: ['Handig', 'Niet handig', 'Maakt me niet uit']
}, {
  id: :v6,
  type: :radio,
  title: 'Zie het voorbeeld hieronder: <br><img src="/images/studenten/dikgedrukt.png" class="questionnaire-image" /><br><br>Wat vond je van de dikgedrukte woorden in de vragen?',
  options: ['Handig', 'Niet handig', 'Maakt me niet uit']
}, {
  id: :v7,
  type: :textarea,
  title: 'Dit is een voorbeeld van de dankpagina na het opslaan van een vragenlijst: <br><img src="/images/studenten/dankpagina.png" class="questionnaire-image" /><br><br>Wat zou jij willen verbeteren aan deze dankpagina?',
  section_end: true
}, {
  section_start: 'Begrijpelijkheid',
  id: :v8,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v1.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v9,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v2.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v10,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v3.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v11,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v4.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v12,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v4b.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v13,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v5.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v14,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v6.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v15,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v7.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v16,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v8.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v17,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v9.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v18,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v10.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v19,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v11.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v20,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v12.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v21,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v13.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v22,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v14.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v23,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v15.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v24,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v16.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v25,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v16b.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v26,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v17.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v27,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v18.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v28,
  type: :range,
  title: 'Vond je de onderstaande vraag moeilijk of makkelijk te begrijpen? <br><img src="/images/studenten/questions/v19.png" class="questionnaire-image" />',
  labels: ['heel moeilijk', 'heel makkelijk'],
  section_end: true
}, {
  id: :v29,
  type: :radio,
  title: 'Was het je duidelijk dat jouw begeleider nooit je antwoorden zal zien?',
  options: %w[Ja Nee],
  section_end: true
}, {
  section_start: 'Timing',
  id: :v30,
  type: :radio,
  title: 'Je kreeg elke keer om 12 uur een sms als er weer een vragenlijst voor je open stond. Is dat een goede tijd voor jou?',
  options: ['Ja'],
  otherwise_label: 'Nee, liever een andere tijd, namelijk:'
}, {
  id: :v31,
  type: :radio,
  title: 'Als je de vragenlijst om 20:00 nog niet had ingevuld kreeg je een herinnerings sms. Is dat een goede tijd voor jou?',
  options: ['Ja'],
  otherwise_label: 'Nee, liever een andere tijd, namelijk:'
}, {
  id: :v32,
  type: :radio,
  title: 'Zou je nog een extra herinnering willen ontvangen op een bepaalde tijd?',
  options: ['Nee'],
  otherwise_label: 'Ja, namelijk om:'
}, {
  id: :v33,
  type: :radio,
  title: 'Je kreeg nu elke donderdag een vragenlijst. Zou je deze liever op een andere dag krijgen?',
  options: ['Nee', 'Ja, op maandag', 'Ja, op dinsdag', 'Ja, op woensdag', 'Ja, op vrijdag'],
  section_end: true
}, {
  section_start: 'Notificatieteksten',
  id: :v34,
  type: :radio,
  title: 'Welke notificatietekst vond jij het prettigst om te krijgen?',
  options: ['Welkom bij het onderzoek naar ontwikkeling en begeleiding. Er staat een vragenlijst voor je klaar. Vul deze nu in! LINK',
            'Bedankt voor je hulp! Er staat een vragenlijst voor je klaar. Vul deze nu in! LINK',
            'Je bent fantastisch op weg! Ga zo door. LINK'],
  section_end: true
}, {
  section_start: 'Missen van vragenlijsten',
  id: :v35,
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
            'De vragenlijst was al verlopen']
}, {
  id: :v36,
  type: :radio,
  title: 'Zou je het erg vinden als jouw begeleider op de hoogte wordt gesteld als jij twee of meer metingen mist?',
  options: %w[Ja Nee],
  section_end: true
}, {
  section_start: 'Beloning',
  id: :v37,
  type: :radio,
  title: 'Vind je dat je genoeg beloning krijgt voor wat je moet doen?',
  options: ['Ja'],
  otherwise_label: 'Nee, voor het werk dat ik heb gedaan zou ik dit een eerlijke beloning vinden: €'
}, {
  id: :v38,
  type: :radio,
  title: 'Je hebt nu drie weken meegedaan aan dit onderzoek. Denk je dat je ditzelfde onderzoek ook voor zeven maanden zou volhouden voor €70?',
  options: ['Ja'],
  otherwise_label: 'Nee, omdat:',
  section_end: true
}, {
  section_start: 'Tot slot',
  id: :v39,
  type: :textarea,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
  section_end: true
}], scores: [] }
nameting1.title = 'Eindmeting'
nameting1.save!
