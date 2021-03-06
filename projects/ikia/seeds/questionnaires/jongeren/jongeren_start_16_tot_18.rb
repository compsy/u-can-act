# frozen_string_literal: true

db_title = 'Start'
db_name1 = 'Start jongeren 16 tot 18'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! We beginnen ons onderzoek met een paar vragen over wie je bent. Het invullen van deze vragenlijst duurt ongeveer 5 minuten.
</p>'
  }, {
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'Ben je een jongen of een meisje?',
    options: %w[Jongen Meisje Anders],
    combines_with: %i[v2]
  }, {
    id: :v2,
    type: :date,
    required: true,
    title: 'Wanneer ben je geboren?',
    min: '2000/01/01',
    default_date: '2005/01/01',
    max: '2014/01/01'
  }, {
    id: :v3_a,
    type: :radio,
    title: 'In welk land woon je?',
    show_otherwise: false,
    options: [
      { title: 'Nederland' }, { title: 'België' }, { title: 'Anders', shows_questions: %i[v3_b] }]
  }, {
    id: :v3_b,
    type: :dropdown,
    hidden: true,
    title: 'Welk land is dit?',
    options: ['Afghanistan', 'Albanië', 'Algerije', 'Amerikaans-Samoa', 'Amerikaanse Maagdeneilanden', 'Andorra', 'Angola', 'Anguilla', 'Antigua en Barbuda', 'Argentinië', 'Armenië', 'Aruba', 'Australië', 'Azerbeidzjan', 'Bahamas', 'Bahrein', 'Bangladesh', 'Barbados', 'Belize', 'Benin', 'Bermuda', 'Bhutan', 'Bolivia', 'Bosnië en Herzegovina', 'Botswana', 'Brazilië', 'Britse Maagdeneilanden', 'Brunei', 'Bulgarije', 'Burkina Faso', 'Burundi', 'Cambodja', 'Canada', 'Centraal-Afrikaanse Republiek', 'Chili', 'China', 'Christmaseiland', 'Cocoseilanden', 'Colombia', 'Comoren', 'Congo-Brazzaville', 'Congo-Kinshasa', 'Cookeilanden', 'Costa Rica', 'Cuba', 'Curaçao', 'Cyprus', 'Denemarken', 'Djibouti', 'Dominica', 'Dominicaanse Republiek', 'Duitsland', 'Ecuador', 'Egypte', 'El Salvador', 'Equatoriaal-Guinea', 'Eritrea', 'Estland', 'Ethiopië', 'Faeröer', 'Falkeilanden', 'Fiji', 'Filipijnen', 'Finland', 'Frankrijk', 'Frans-Polynesië', 'Gabon', 'Gambia', 'Georgië', 'Ghana', 'Gibraltar', 'Grenada', 'Griekenland', 'Groenland', 'Guam', 'Guatemala', 'Guernsey', 'Guinee', 'Guinee-Bissau', 'Guyana', 'Haïti', 'Honduras', 'Hongarije', 'Hongkong', 'Ierland', 'IJsland', 'India', 'Indonesië', 'Irak', 'Iran', 'Israël', 'Italië', 'Ivoorkust', 'Jamaica', 'Japan', 'Jemen', 'Jersey', 'Jordanië', 'Kaaimaneilanden', 'Kaapverdië', 'Kameroen', 'Kazachstan', 'Kenia', 'Kirgizië', 'Kiribati', 'Koeweit', 'Kosovo', 'Kroatië', 'Laos', 'Lesotho', 'Letland', 'Libanon', 'Liberia', 'Libië', 'Liechtenstein', 'Litouwen', 'Luxemburg', 'Macau', 'Madagaskar', 'Malawi', 'Maldiven', 'Maleisië', 'Mali', 'Malta', 'Man', 'Marokko', 'Marshalleilanden', 'Mauritanië', 'Mauritius', 'Mexico', 'Micronesia', 'Moldavië', 'Monaco', 'Mongolië', 'Montenegro', 'Montserrat', 'Mozambique', 'Myanmar', 'Namibië', 'Nauru', 'Nepal', 'Nicaragua', 'Nieuw-Caledonië', 'Nieuw-Zeeland', 'Niger', 'Nigeria', 'Niue', 'Noord-Korea', 'Noord-Macedonië', 'Noordelijke Marianen', 'Noorwegen', 'Norfolk', 'Oeganda', 'Oekraïne', 'Oezbekistan', 'Oman', 'Oost-Timor', 'Oostenrijk', 'Pakistan', 'Palau', 'Palestina', 'Panama', 'Papoea-Nieuw-Guinea', 'Paraguay', 'Peru', 'Pitcairneilanden', 'Polen', 'Portugal', 'Puerto Rico', 'Qatar', 'Roemenië', 'Rusland', 'Rwanda', 'Saint Kitts en Nevis', 'Saint Lucia', 'Saint Vincent en de Grenadines', 'Saint-Barthélemy', 'Saint-Pierre en Miquelon', 'Salomonseilanden', 'Samoa', 'San Marino', 'Sao Tomé en Principe', 'Saoedi-Arabië', 'Senegal', 'Servië', 'Seychellen', 'Sierra Leone', 'Singapore', 'Sint Maarten', 'Sint-Maarten', 'Slovenië', 'Slowakije', 'Soedan', 'Somalië', 'Spanje', 'Spitsbergen en Jan Mayen', 'Sri Lanka', 'Suriname', 'Swaziland', 'Syrië', 'Tadzjikistan', 'Taiwan', 'Tanzania', 'Thailand', 'Togo', 'Tokelau', 'Tonga', 'Trinidad en Tobago', 'Tsjaad', 'Tsjechië', 'Tunesië', 'Turkije', 'Turkmenistan', 'Turks- en Caicoseilanden', 'Tuvalu', 'Uruguay', 'Vanuatu', 'Vaticaanstad', 'Venezuela', 'Verenigd Koninkrijk', 'Verenigde Arabische Emiraten', 'Verenigde Staten', 'Vietnam', 'Wallis en Futuna', 'Westelijke Sahara', 'Wit-Rusland', 'Zambia', 'Zimbabwe', 'Zuid-Afrika', 'Zuid-Korea', 'Zuid-Soedan', 'Zweden', 'Zwitserland']
  }, {
    id: :v3_c,
    title: 'In welk land ben je geboren?',
    type: :radio,
    show_otherwise: false,
    options: [
      { title: 'Nederland' }, { title: 'België' }, { title: 'Anders', shows_questions: %i[v3_d v3_e] }]
  }, {
    id: :v3_d,
    type: :dropdown,
    hidden: true,
    title: 'Welk land is dit?',
    options: ['Afghanistan', 'Albanië', 'Algerije', 'Amerikaans-Samoa', 'Amerikaanse Maagdeneilanden', 'Andorra', 'Angola', 'Anguilla', 'Antigua en Barbuda', 'Argentinië', 'Armenië', 'Aruba', 'Australië', 'Azerbeidzjan', 'Bahamas', 'Bahrein', 'Bangladesh', 'Barbados', 'Belize', 'Benin', 'Bermuda', 'Bhutan', 'Bolivia', 'Bosnië en Herzegovina', 'Botswana', 'Brazilië', 'Britse Maagdeneilanden', 'Brunei', 'Bulgarije', 'Burkina Faso', 'Burundi', 'Cambodja', 'Canada', 'Centraal-Afrikaanse Republiek', 'Chili', 'China', 'Christmaseiland', 'Cocoseilanden', 'Colombia', 'Comoren', 'Congo-Brazzaville', 'Congo-Kinshasa', 'Cookeilanden', 'Costa Rica', 'Cuba', 'Curaçao', 'Cyprus', 'Denemarken', 'Djibouti', 'Dominica', 'Dominicaanse Republiek', 'Duitsland', 'Ecuador', 'Egypte', 'El Salvador', 'Equatoriaal-Guinea', 'Eritrea', 'Estland', 'Ethiopië', 'Faeröer', 'Falkeilanden', 'Fiji', 'Filipijnen', 'Finland', 'Frankrijk', 'Frans-Polynesië', 'Gabon', 'Gambia', 'Georgië', 'Ghana', 'Gibraltar', 'Grenada', 'Griekenland', 'Groenland', 'Guam', 'Guatemala', 'Guernsey', 'Guinee', 'Guinee-Bissau', 'Guyana', 'Haïti', 'Honduras', 'Hongarije', 'Hongkong', 'Ierland', 'IJsland', 'India', 'Indonesië', 'Irak', 'Iran', 'Israël', 'Italië', 'Ivoorkust', 'Jamaica', 'Japan', 'Jemen', 'Jersey', 'Jordanië', 'Kaaimaneilanden', 'Kaapverdië', 'Kameroen', 'Kazachstan', 'Kenia', 'Kirgizië', 'Kiribati', 'Koeweit', 'Kosovo', 'Kroatië', 'Laos', 'Lesotho', 'Letland', 'Libanon', 'Liberia', 'Libië', 'Liechtenstein', 'Litouwen', 'Luxemburg', 'Macau', 'Madagaskar', 'Malawi', 'Maldiven', 'Maleisië', 'Mali', 'Malta', 'Man', 'Marokko', 'Marshalleilanden', 'Mauritanië', 'Mauritius', 'Mexico', 'Micronesia', 'Moldavië', 'Monaco', 'Mongolië', 'Montenegro', 'Montserrat', 'Mozambique', 'Myanmar', 'Namibië', 'Nauru', 'Nepal', 'Nicaragua', 'Nieuw-Caledonië', 'Nieuw-Zeeland', 'Niger', 'Nigeria', 'Niue', 'Noord-Korea', 'Noord-Macedonië', 'Noordelijke Marianen', 'Noorwegen', 'Norfolk', 'Oeganda', 'Oekraïne', 'Oezbekistan', 'Oman', 'Oost-Timor', 'Oostenrijk', 'Pakistan', 'Palau', 'Palestina', 'Panama', 'Papoea-Nieuw-Guinea', 'Paraguay', 'Peru', 'Pitcairneilanden', 'Polen', 'Portugal', 'Puerto Rico', 'Qatar', 'Roemenië', 'Rusland', 'Rwanda', 'Saint Kitts en Nevis', 'Saint Lucia', 'Saint Vincent en de Grenadines', 'Saint-Barthélemy', 'Saint-Pierre en Miquelon', 'Salomonseilanden', 'Samoa', 'San Marino', 'Sao Tomé en Principe', 'Saoedi-Arabië', 'Senegal', 'Servië', 'Seychellen', 'Sierra Leone', 'Singapore', 'Sint Maarten', 'Sint-Maarten', 'Slovenië', 'Slowakije', 'Soedan', 'Somalië', 'Spanje', 'Spitsbergen en Jan Mayen', 'Sri Lanka', 'Suriname', 'Swaziland', 'Syrië', 'Tadzjikistan', 'Taiwan', 'Tanzania', 'Thailand', 'Togo', 'Tokelau', 'Tonga', 'Trinidad en Tobago', 'Tsjaad', 'Tsjechië', 'Tunesië', 'Turkije', 'Turkmenistan', 'Turks- en Caicoseilanden', 'Tuvalu', 'Uruguay', 'Vanuatu', 'Vaticaanstad', 'Venezuela', 'Verenigd Koninkrijk', 'Verenigde Arabische Emiraten', 'Verenigde Staten', 'Vietnam', 'Wallis en Futuna', 'Westelijke Sahara', 'Wit-Rusland', 'Zambia', 'Zimbabwe', 'Zuid-Afrika', 'Zuid-Korea', 'Zuid-Soedan', 'Zweden', 'Zwitserland']
  }, {
    id: :v3_e,
    type: :dropdown,
    hidden: true,
    title: 'Hoe oud was je toen je naar het land kwam waar je nu woont?',
    options: (0..18).to_a.map(&:to_s)
  }, {
    id: :v4,
    type: :radio,
    show_otherwise: false,
    title: 'Naar wat voor school ga je?',
    options: [
      { title: 'Middelbare school', shows_questions: %i[v4_b v4_c] },
      { title: 'Speciaal onderwijs', shows_questions: %i[v4_d] },
      { title: 'Middelbaar beroepsonderwijs (MBO)' },
      { title: 'Hoger beroepsonderwijs (HBO)' },
      { title: 'Wetenschappelijk onderwijs (WO)' },
      { title: 'Ik krijg thuisonderwijs' },
      { title: 'Ik krijg geen onderwijs' }
    ]
  }, {
    id: :v4_b,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Wat voor type middelbare school is dit? Als je in een combinatieklas zit, kies dan het hoogste niveau',
    options: ['Praktijkonderwijs (bijvoorbeeld houtbewerking, groenvoorziening, bouw)', 'VMBO of MAVO', 'HAVO', 'VWO, atheneum of gymnasium']
  }, {
    id: :v4_c,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'In welke klas zit je?',
    options: ['Klas 1', 'Klas 2', 'Klas 3', 'Klas 4', 'Klas 5', 'Klas 6']
  }, {
    id: :v4_d,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Om welk cluster gaat het?',
    options: ['Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Weet ik niet']
 },{
    section_start: 'Tot slot:',
   id: :v10a,
   type: :checkbox,
   title: 'Hoe ben je op deze website terecht gekomen?',
   options: ['Via Facebook of Instagram', 'Via OCRN', 'Iemand die ik ken vertelde erover', 'Via een flyer of poster', 'Via een bericht in het nieuws'],
   show_otherwise: true,
   otherwise_label: 'Anders, namelijk:',
   section_end: false
  },{
    id: :v10,
    type: :radio,
    title: 'Ieder Kind is Anders verstuurt 4x per jaar een nieuwsbrief via e-mail. Hierin delen we het laatste nieuws en de resultaten van het onderzoek. Wil je deze nieuwsbrief ontvangen?',   
    options: [{title: 'Ja, ik wil de nieuwsbrief ontvangen'}, {title: 'Nee, ik heb geen interesse'}]
 },{
   id: :v11,
   type: :radio,
   title: 'Mogen we je na afloop van Ieder Kind is Anders uitnodigen voor vervolgonderzoek? Je krijgt dan natuurlijk eerst informatie over het onderzoek waarna je kunt beslissen of je mee wilt doen.',
   options: [{title: 'Ja, jullie mogen mij uitnodigen voor vervolgonderzoek'}, {title: 'Nee, ik heb geen interesse'}],
   section_end: true
   }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
