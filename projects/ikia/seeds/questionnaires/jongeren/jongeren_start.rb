# frozen_string_literal: true

db_title = 'Start'
db_name1 = 'Start jongeren'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
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
    options: ['Jongen', 'Meisje', 'Anders'],
    combines_with: %i[v2]
  }, {
    id: :v2,
    type: :date,
    Required: true,
    title: 'Wanneer ben je geboren?'
  }, {
    id: :v3,
    title: 'In welk land ben je geboren?',
    type: :radio,
    show_otherwise: false,
    options: [
      {title: 'Nederland'}, {title: 'Anders', shows_questions: %i[v3_a, v3_b]}
    ]
  }, {
    id: :v3_a,
    type: :dropdown,
    hidden: true,
    title: 'Welk land is dit?',
    options: ['Afghanistan', 'Albanië', 'Algerije', 'Amerikaans-Samoa', 'Amerikaanse Maagdeneilanden', 'Andorra', 'Angola', 'Anguilla', 'Antigua en Barbuda', 'Argentinië', 'Armenië', 'Aruba', 'Australië', 'Azerbeidzjan', 'Bahamas', 'Bahrein', 'Bangladesh', 'Barbados', 'België', 'Belize', 'Benin', 'Bermuda', 'Bhutan', 'Bolivia', 'Bosnië en Herzegovina', 'Botswana', 'Brazilië', 'Britse Maagdeneilanden', 'Brunei', 'Bulgarije', 'Burkina Faso', 'Burundi', 'Cambodja', 'Canada', 'Centraal-Afrikaanse Republiek', 'Chili', 'China', 'Christmaseiland', 'Cocoseilanden', 'Colombia', 'Comoren', 'Congo-Brazzaville', 'Congo-Kinshasa', 'Cookeilanden', 'Costa Rica', 'Cuba', 'Curaçao', 'Cyprus', 'Denemarken', 'Djibouti', 'Dominica', 'Dominicaanse Republiek', 'Duitsland', 'Ecuador', 'Egypte', 'El Salvador', 'Equatoriaal-Guinea', 'Eritrea', 'Estland', 'Ethiopië', 'Faeröer', 'Falkeilanden', 'Fiji', 'Filipijnen', 'Finland', 'Frankrijk', 'Frans-Polynesië', 'Gabon', 'Gambia', 'Georgië', 'Ghana', 'Gibraltar', 'Grenada', 'Griekenland', 'Groenland', 'Guam', 'Guatemala', 'Guernsey', 'Guinee', 'Guinee-Bissau', 'Guyana', 'Haïti', 'Honduras', 'Hongarije', 'Hongkong', 'Ierland', 'IJsland', 'India', 'Indonesië', 'Irak', 'Iran', 'Israël', 'Italië', 'Ivoorkust', 'Jamaica', 'Japan', 'Jemen', 'Jersey', 'Jordanië', 'Kaaimaneilanden', 'Kaapverdië', 'Kameroen', 'Kazachstan', 'Kenia', 'Kirgizië', 'Kiribati', 'Koeweit', 'Kosovo', 'Kroatië', 'Laos', 'Lesotho', 'Letland', 'Libanon', 'Liberia', 'Libië', 'Liechtenstein', 'Litouwen', 'Luxemburg', 'Macau', 'Madagaskar', 'Malawi', 'Maldiven', 'Maleisië', 'Mali', 'Malta', 'Man', 'Marokko', 'Marshalleilanden', 'Mauritanië', 'Mauritius', 'Mexico', 'Micronesia', 'Moldavië', 'Monaco', 'Mongolië', 'Montenegro', 'Montserrat', 'Mozambique', 'Myanmar', 'Namibië', 'Nauru', 'Nepal', 'Nicaragua', 'Nieuw-Caledonië', 'Nieuw-Zeeland', 'Niger', 'Nigeria', 'Niue', 'Noord-Korea', 'Noord-Macedonië', 'Noordelijke Marianen', 'Noorwegen', 'Norfolk', 'Oeganda', 'Oekraïne', 'Oezbekistan', 'Oman', 'Oost-Timor', 'Oostenrijk', 'Pakistan', 'Palau', 'Palestina', 'Panama', 'Papoea-Nieuw-Guinea', 'Paraguay', 'Peru', 'Pitcairneilanden', 'Polen', 'Portugal', 'Puerto Rico', 'Qatar', 'Roemenië', 'Rusland', 'Rwanda', 'Saint Kitts en Nevis', 'Saint Lucia', 'Saint Vincent en de Grenadines', 'Saint-Barthélemy', 'Saint-Pierre en Miquelon', 'Salomonseilanden', 'Samoa', 'San Marino', 'Sao Tomé en Principe', 'Saoedi-Arabië', 'Senegal', 'Servië', 'Seychellen', 'Sierra Leone', 'Singapore', 'Sint Maarten', 'Sint-Maarten', 'Slovenië', 'Slowakije', 'Soedan', 'Somalië', 'Spanje', 'Spitsbergen en Jan Mayen', 'Sri Lanka', 'Suriname', 'Swaziland', 'Syrië', 'Tadzjikistan', 'Taiwan', 'Tanzania', 'Thailand', 'Togo', 'Tokelau', 'Tonga', 'Trinidad en Tobago', 'Tsjaad', 'Tsjechië', 'Tunesië', 'Turkije', 'Turkmenistan', 'Turks- en Caicoseilanden', 'Tuvalu', 'Uruguay', 'Vanuatu', 'Vaticaanstad', 'Venezuela', 'Verenigd Koninkrijk', 'Verenigde Arabische Emiraten', 'Verenigde Staten', 'Vietnam', 'Wallis en Futuna', 'Westelijke Sahara', 'Wit-Rusland', 'Zambia', 'Zimbabwe', 'Zuid-Afrika', 'Zuid-Korea', 'Zuid-Soedan', 'Zweden', 'Zwitserland']
  }, {
    id: :v3_b,
    type: :dropdown,
    hidden: true,
    title: 'Hoe oud was je toen je naar Nederland kwam?',
    options: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18']
  }, {
    id: :v4,
    type: :radio,
    show_otherwise: false,
    title: 'Naar wat voor school ga je?',
    options: [
      {title: 'Basisschool', shows_questions: %i[v4_a]}, {title: 'Middelbare school', shows_questions: %i[v4_b, v4_c]}, {title: 'Speciaal onderwijs', shows_questions: %i[v4_d]}, {title: 'Ik krijg thuisonderwijs'}, {title: 'Ik krijg geen onderwijs'}
    ]
  }, {
    id: :v4_a,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'In welke groep zit je?',
    options: ['Groep 3', 'Groep 4', 'Groep 5', 'Groep 6', 'Groep 7', 'Groep 8', 'Groep 9']
  }, {
    id: :v4_b,
    type: :radio,
    hidden: true,
    show_otherwise: false,
    title: 'Wat voor type middelbare school is dit? Als je in een combinatieklas zit, kies dan het hoogste niveau',
    options: ['Praktijkonderwijs (bijvoorbeeld houtbewerking, groenvoorziening, bouw)', 'VMBO of MAVO', 'HAVO', 'VWO, atheneum of gymnasium']
  }, {
    id: :v4c,
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
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
