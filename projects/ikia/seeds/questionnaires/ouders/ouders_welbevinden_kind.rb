# frozen_string_literal: true

db_title = 'Leefplezier van mijn kind'
db_name1 = 'Welbevinden_Kind_Ouderrapportage_6plus'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! De volgende vragen gaan over het leefplezier van uw kind. Met leefplezier bedoelen we: hoe tevreden uw kind is thuis, op school, met zijn of haar vrienden, en met zichzelf. Maak bij elke vraag een inschatting van hoe uw kind zich de afgelopen twee weken voelde. Verplaats het bolletje naar het antwoord dat het beste past. </p>'
  }, {
    section_start: 'De volgende vragen gaan over de thuissituatie van uw kind.',
    id: :v1,
    type: :range,
    title: 'Mijn kind maakt thuis een tevreden indruk.',
    labels: ['Helemaal niet mee eens', 'Een beetje mee eens', 'Helemaal wel mee eens'],
    required: true,
    section_end: false
  }, {
    id: :v2,
    type: :range,
    title: 'Mijn kind brengt graag tijd door met andere gezinsleden.',
    labels: ['Helemaal niet mee eens', 'Een beetje mee eens', 'Helemaal wel mee eens'],
    required: true,
    section_end: true
  }, {
    section_start: ' De volgende vragen gaan over de vriendschappen van uw kind.',
    id: :v3,
    type: :range,
    title: 'Mijn kind is tevreden met zijn/haar vrienden of vriendinnen.',
    labels: ['Helemaal niet mee eens', 'Een beetje mee eens', 'Helemaal wel mee eens'],
    required: true,
    section_end: false
  }, {
    id: :v4,
    type: :range,
    title: 'Mijn kind heeft het gevoel buiten de groep te vallen.',
    labels: ['Helemaal niet mee eens', 'Een beetje mee eens', 'Helemaal wel mee eens'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over hoe uw kind zich op school voelt.',
    id: :v5,
    type: :range,
    title: 'Mijn kind gaat met plezier naar school.',
    labels: ['Helemaal niet mee eens', 'Een beetje mee eens', 'Helemaal wel mee eens'],
    required: true,
    section_end: false
  }, {
    id: :v6,
    type: :range,
    title: 'Mijn kind heeft een leuke klas.',
    labels: ['Helemaal niet mee eens', 'Een beetje mee eens', 'Helemaal wel mee eens'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over de wijk waar jullie wonen.',
    id: :v7,
    type: :range,
    title: 'Mijn kind voelt zich op zijn/haar gemak in de wijk.',
    labels: ['Helemaal niet mee eens', 'Een beetje mee eens', 'Helemaal wel mee eens'],
    required: true,
    section_end: false
  }, {
    id: :v8,
    type: :range,
    title: 'Er zijn voldoende leuke dingen te doen voor mijn kind in de wijk.',
    labels: ['Helemaal niet mee eens', 'Een beetje mee eens', 'Helemaal wel mee eens'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over hoe tevreden uw kind is met zichzelf.',
    id: :v9,
    type: :range,
    title: 'Mijn kind is tevreden met hoe hij/zij eruit ziet.',
    labels: ['Helemaal niet mee eens', 'Een beetje mee eens', 'Helemaal wel mee eens'],
    required: true,
    section_end: false
  }, {
    id: :v10,
    type: :range,
    title: 'Mijn kind voelt zich goed over zichzelf.',
    labels: ['Helemaal niet mee eens', 'Een beetje mee eens', 'Helemaal wel mee eens'],
    required: true,
    section_end: true
  }, {
    id: :v11,
    type: :range,
    title: 'In het algemeen, hoe gelukkig is uw kind?',
    labels: ['Helemaal niet gelukkig', 'Redelijk gelukkig', 'Heel erg gelukkig'],
    required: true
  }
]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
