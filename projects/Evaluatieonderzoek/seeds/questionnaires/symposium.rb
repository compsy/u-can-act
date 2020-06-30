# frozen_string_literal: true

db_title = 'Inschrijfformulier voor het u-can-act symposium op donderdag 16 mei 2019' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'symposium'
symp1 = Questionnaire.find_by(name: db_name1)
symp1 ||= Questionnaire.new(name: db_name1)
symp1.key = File.basename(__FILE__)[0...-3]
symp1_content = [
  {
    type: :raw,
    content: '<p class="flow-text"><strong>DEADLINE INSCHRIJVING 3 MEI</strong></p>'
  }, {
    id: :v1,
    type: :textfield,
    placeholder: 'Voornaam',
    required: true,
    title: ''
  }, {
    id: :v2,
    type: :textfield,
    placeholder: 'Tussenvoegsel',
    title: ''
  }, {
    id: :v3,
    type: :textfield,
    placeholder: 'Achternaam',
    required: true,
    title: ''
  }, {
    id: :v4,
    type: :textfield,
    placeholder: 'Functie',
    required: true,
    title: ''
  }, {
    id: :v5,
    type: :textfield,
    placeholder: 'Affiliatie',
    required: true,
    title: ''
  }, {
    id: :v6,
    type: :textfield,
    placeholder: 'E-mailadres',
    pattern: '^[^@\s]+@[^@\s]+$',
    hint: 'Vul a.u.b. een geldig e-mailadres in.',
    required: true,
    title: '<em>Uw e-mailadres wordt alleen gebruikt voor het sturen van de bevestigingsmail en voor updates over het symposium. Alleen wanneer u toestemming geeft wordt uw e-mailadres gedeeld met andere bezoekers, zie onderstaande optie.</em>'
  }, {
    id: :v7,
    type: :checkbox,
    required: false,
    title: '',
    options: ['Optioneel: om naar aanleiding van het u-can-act symposium makkelijker te netwerken geef ik toestemming voor het delen van mijn contactgegevens met andere deelnemers van het symposium.'],
    show_otherwise: false
  }, {
    id: :v8,
    type: :checkbox,
    required: false,
    title: 'Dieetwensen (optioneel)',
    options: %w[Vegetarisch Veganist Glutenvrij]
  }, {
    type: :raw,
    content: '<p class="flow-text">Door op onderstaande \'opslaan\'-knop te klikken verzendt u uw gegevens. U ontvangt een bevestigingsmail van uw aanmelding.</p><p>Voor vragen neem contact op met Lucia Boer <a href="mailto:info@u-can-act.nl">info@u-can-act.nl</a></p>'
  }
]
symp1.content = { questions: symp1_content, scores: [] }
symp1.title = db_title
symp1.save!
