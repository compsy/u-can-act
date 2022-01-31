# frozen_string_literal: true

db_title = ''
db_name1 = 'ov'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

OV_ABONNEMENT_QUESTIONS = %i[v39]

dagboek_content = [
  {
    id: :v37,
    type: :radio,
    title: 'Heeft u een OV-chipcard?',
    options: %w[Ja Nee],
    required: true,
    show_otherwise: false
  }, {
    id: :v38,
    type: :radio,
    title: 'Heeft u een OV abonnement? (NS Flex/basis telt ook als is hier ook een abonnement)',
    options: [
      { title: 'Ja', shows_questions: OV_ABONNEMENT_QUESTIONS },
      'Nee'
    ],
    required: true,
    show_otherwise: false
  }, {
    id: :v39,
    hidden: true,
    type: :checkbox,
    title: 'Welke OV abonnement(en) heeft u?',
    options: [
      'NS Basis (NS Flex)',
      'NS Weekend Voordeel',
      'NS Dal Voordeel',
      'NS Altijd Voordeel',
      'NS Weekend Vrij',
      'NS Dal Vrij',
      'NS Altijd Vrij',
      'NS Traject Vrij',
      'Bus/tram/metro korting (beperkt gebied)',
      'Bus/tram/metro vrij (beperkt gebied)',
      'Bus/tram/metro korting (Heel Nederland)',
      'Bus/tram/metro vrij (Heel Nederland)'
    ],
    required: true,
    show_otherwise: true,
    section_end: true
  }, {
    type: :raw,
    section_start: 'U bent klaar met de vragenlijst. U verzendt door op volgende te klikken.',
    content: '<div></div>'
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
