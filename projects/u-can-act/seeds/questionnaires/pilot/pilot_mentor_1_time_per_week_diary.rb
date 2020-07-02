# frozen_string_literal: true

db_title = 'Webapp Begeleiders'

db_name1 = 'dagboek mentoren 1x per week donderdag'
dagboek1 = Questionnaire.find_by(name: db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [{
  section_start: 'De hoofddoelen',
  id: :v1,
  type: :checkbox,
  title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
  options: [
    { title: 'De relatie verbeteren en/of onderhouden', shows_questions: %i[v2 v3] },
    { title: 'Inzicht krijgen in de belevingswereld', shows_questions: %i[v4 v5] },
    { title: 'Inzicht krijgen in de omgeving', shows_questions: %i[v6 v7] },
    { title: 'Zelfinzicht geven', shows_questions: %i[v8 v9] },
    { title: 'Vaardigheden ontwikkelen', shows_questions: %i[v10 v11] },
    { title: 'De omgeving veranderen/afstemmen met de omgeving', shows_questions: %i[v12] }
  ],
  section_end: true
}, {
  section_start: 'De relatie verbeteren en/of onderhouden',
  hidden: true,
  id: :v2,
  type: :checkbox,
  title: 'Welke acties heb je deze week uitgevoerd om de relatie met deze student te verbeteren en/of te onderhouden?',
  options: ['Laagdrempelig contact gelegd',
            'Praktische oefeningen uitgevoerd',
            'Gespreks- interventies/technieken gebruikt',
            'Het netwerk betrokken',
            'Motiverende handelingen uitgevoerd',
            'Observaties gedaan']
}, {
  hidden: true,
  id: :v3,
  type: :range,
  title: 'In welke mate heb je aan de relatie gewerkt?',
  labels: %w[weinig veel],
  section_end: true
}, {
  section_start: 'Inzicht in de belevingswereld',
  hidden: true,
  id: :v4,
  type: :checkbox,
  title: 'Welke acties heb je deze week uitgevoerd om de belevingswereld van deze student te verbeteren en/of te onderhouden?',
  options: ['Laagdrempelig contact gelegd',
            'Praktische oefeningen uitgevoerd',
            'Gespreks- interventies/technieken gebruikt',
            'Het netwerk betrokken',
            'Motiverende handelingen uitgevoerd',
            'Observaties gedaan']
}, {
  hidden: true,
  id: :v5,
  type: :range,
  title: 'In welke mate heb je aan de belevingswereld gewerkt?',
  labels: %w[weinig veel],
  section_end: true
}, {
  section_start: 'Inizcht in de omgeving',
  hidden: true,
  id: :v6,
  type: :checkbox,
  title: 'Welke acties heb je deze week uitgevoerd om de omgeving van deze student te verbeteren?',
  options: ['Laagdrempelig contact gelegd',
            'Praktische oefeningen uitgevoerd',
            'Gespreks- interventies/technieken gebruikt',
            'Het netwerk betrokken',
            'Motiverende handelingen uitgevoerd',
            'Observaties gedaan']
}, {
  hidden: true,
  id: :v7,
  type: :range,
  title: 'In welke mate heb je aan de omgeving gewerkt?',
  labels: %w[weinig veel],
  section_end: true
}, {
  section_start: 'Zelfinzicht geven',
  hidden: true,
  id: :v8,
  type: :checkbox,
  title: 'Welke acties heb je deze week uitgevoerd om het zelfinzicht van deze student te verbeteren?',
  options: ['Laagdrempelig contact gelegd',
            'Praktische oefeningen uitgevoerd',
            'Gespreks- interventies/technieken gebruikt',
            'Het netwerk betrokken',
            'Motiverende handelingen uitgevoerd',
            'Observaties gedaan']
}, {
  hidden: true,
  id: :v9,
  type: :range,
  title: 'In welke mate heb je aan het zelfinzicht gewerkt?',
  labels: %w[weinig veel],
  section_end: true
}, {
  section_start: 'Vaardigheden ontwikkelen',
  hidden: true,
  id: :v10,
  type: :checkbox,
  title: 'Welke acties heb je deze week uitgevoerd om de vaardigheden van deze student te ontwikkelen?',
  options: ['Laagdrempelig contact gelegd',
            'Praktische oefeningen uitgevoerd',
            'Gespreks- interventies/technieken gebruikt',
            'Het netwerk betrokken',
            'Motiverende handelingen uitgevoerd',
            'Observaties gedaan']
}, {
  hidden: true,
  id: :v11,
  type: :range,
  title: 'In welke mate heb je aan vaardigheden ontwikkelen gewerkt?',
  labels: %w[weinig veel],
  section_end: true
}, {
  section_start: 'De omgeving veranderen / afstemmen met de omgeving',
  hidden: true,
  id: :v12,
  type: :checkbox,
  title: 'Met welke omgeving heb je deze week contact gehad en met welk doel?',
  options: ['School, met als doel afstemmen',
            'School, met als doel veranderen',
            'School, met een ander doel',
            'Hulpverlening, met als doel afstemmen',
            'Hulpverlening, met als doel veranderen',
            'Hulpverlening, met een ander doel',
            'Thuis, met als doel afstemmen',
            'Thuis, met als doel veranderen',
            'Thuis, met een ander doel'],
  section_end: true
}, {
  section_start: 'Algemene vragen',
  id: :v13,
  type: :range,
  title: 'Hoeveel tijd heb je deze week besteed aan de acties voor deze student?',
  labels: ['heel weinig', 'heel veel']
}, {
  id: :v14,
  type: :range,
  title: 'Waren je acties voor deze student deze week vooral gepland of vooral intuïtief?',
  labels: ['helemaal intuïtief', 'helemaal gepland']
}, {
  id: :v15,
  type: :range,
  title: 'Hoe effectief waren je acties voor deze student deze week, denk je?',
  labels: ['niet effectief', 'compleet effectief']
}, {
  id: :v16,
  type: :range,
  title: 'In hoeverre was deze student deze week in staat zijn/haar eigen gedrag te sturen?',
  labels: ['helemaal niet', 'helemaal'],
  section_end: true
}]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
