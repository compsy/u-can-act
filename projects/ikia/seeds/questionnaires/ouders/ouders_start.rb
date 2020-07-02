# frozen_string_literal: true

db_title = 'Start'

db_name1 = 'Start_Ouders'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! We beginnen ons onderzoek met een paar vragen over wie u bent. Het invullen van deze vragenlijst duurt ongeveer 5 minuten.</p>'
  }, {
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'Wat is uw geslacht?',
    options: ['Man', 'Vrouw', 'Anders/ wil ik niet zeggen']
  }, {
    id: :v2,
    type: :dropdown,
    title: 'Wanneer bent u geboren? <br><br>Maand:',
    options: %w[januari februari maart april mei juni juli augustus september oktober november december]
  }, {
    id: :v3,
    type: :number,
    title: 'Jaar:',
    tooltip: 'Vul een jaartal in vanaf 1940 als geboortejaar, bijvoorbeeld: 1976.',
    maxlength: 4,
    placeholder: 'Vul hier een getal in',
    min: 1940,
    max: 2005,
    required: true
  }, {
    id: :v4a,
    type: :dropdown,
    title: 'In welk land woont u?',
    options: ['Afghanistan', 'Albanië', 'Algerije', 'Amerikaans-Samoa', 'Amerikaanse Maagdeneilanden', 'Andorra', 'Angola', 'Anguilla', 'Antigua en Barbuda', 'Argentinië', 'Armenië', 'Aruba', 'Australië', 'Azerbeidzjan', 'Bahamas', 'Bahrein', 'Bangladesh', 'Barbados', 'België', 'Belize', 'Benin', 'Bermuda', 'Bhutan', 'Bolivia', 'Bosnië en Herzegovina', 'Botswana', 'Brazilië', 'Britse Maagdeneilanden', 'Brunei', 'Bulgarije', 'Burkina Faso', 'Burundi', 'Cambodja', 'Canada', 'Centraal-Afrikaanse Republiek', 'Chili', 'China', 'Christmaseiland', 'Cocoseilanden', 'Colombia', 'Comoren', 'Congo-Brazzaville', 'Congo-Kinshasa', 'Cookeilanden', 'Costa Rica', 'Cuba', 'Curaçao', 'Cyprus', 'Denemarken', 'Djibouti', 'Dominica', 'Dominicaanse Republiek', 'Duitsland', 'Ecuador', 'Egypte', 'El Salvador', 'Equatoriaal-Guinea', 'Eritrea', 'Estland', 'Ethiopië', 'Faeröer', 'Falkeilanden', 'Fiji', 'Filipijnen', 'Finland', 'Frankrijk', 'Frans-Polynesië', 'Gabon', 'Gambia', 'Georgië', 'Ghana', 'Gibraltar', 'Grenada', 'Griekenland', 'Groenland', 'Guam', 'Guatemala', 'Guernsey', 'Guinee', 'Guinee-Bissau', 'Guyana', 'Haïti', 'Honduras', 'Hongarije', 'Hongkong', 'Ierland', 'IJsland', 'India', 'Indonesië', 'Irak', 'Iran', 'Israël', 'Italië', 'Ivoorkust', 'Jamaica', 'Japan', 'Jemen', 'Jersey', 'Jordanië', 'Kaaimaneilanden', 'Kaapverdië', 'Kameroen', 'Kazachstan', 'Kenia', 'Kirgizië', 'Kiribati', 'Koeweit', 'Kosovo', 'Kroatië', 'Laos', 'Lesotho', 'Letland', 'Libanon', 'Liberia', 'Libië', 'Liechtenstein', 'Litouwen', 'Luxemburg', 'Macau', 'Madagaskar', 'Malawi', 'Maldiven', 'Maleisië', 'Mali', 'Malta', 'Man', 'Marokko', 'Marshalleilanden', 'Mauritanië', 'Mauritius', 'Mexico', 'Micronesia', 'Moldavië', 'Monaco', 'Mongolië', 'Montenegro', 'Montserrat', 'Mozambique', 'Myanmar', 'Namibië', 'Nauru', 'Nederland', 'Nepal', 'Nicaragua', 'Nieuw-Caledonië', 'Nieuw-Zeeland', 'Niger', 'Nigeria', 'Niue', 'Noord-Korea', 'Noord-Macedonië', 'Noordelijke Marianen', 'Noorwegen', 'Norfolk', 'Oeganda', 'Oekraïne', 'Oezbekistan', 'Oman', 'Oost-Timor', 'Oostenrijk', 'Pakistan', 'Palau', 'Palestina', 'Panama', 'Papoea-Nieuw-Guinea', 'Paraguay', 'Peru', 'Pitcairneilanden', 'Polen', 'Portugal', 'Puerto Rico', 'Qatar', 'Roemenië', 'Rusland', 'Rwanda', 'Saint Kitts en Nevis', 'Saint Lucia', 'Saint Vincent en de Grenadines', 'Saint-Barthélemy', 'Saint-Pierre en Miquelon', 'Salomonseilanden', 'Samoa', 'San Marino', 'Sao Tomé en Principe', 'Saoedi-Arabië', 'Senegal', 'Servië', 'Seychellen', 'Sierra Leone', 'Singapore', 'Sint Maarten', 'Sint-Maarten', 'Slovenië', 'Slowakije', 'Soedan', 'Somalië', 'Spanje', 'Spitsbergen en Jan Mayen', 'Sri Lanka', 'Suriname', 'Swaziland', 'Syrië', 'Tadzjikistan', 'Taiwan', 'Tanzania', 'Thailand', 'Togo', 'Tokelau', 'Tonga', 'Trinidad en Tobago', 'Tsjaad', 'Tsjechië', 'Tunesië', 'Turkije', 'Turkmenistan', 'Turks- en Caicoseilanden', 'Tuvalu', 'Uruguay', 'Vanuatu', 'Vaticaanstad', 'Venezuela', 'Verenigd Koninkrijk', 'Verenigde Arabische Emiraten', 'Verenigde Staten', 'Vietnam', 'Wallis en Futuna', 'Westelijke Sahara', 'Wit-Rusland', 'Zambia', 'Zimbabwe', 'Zuid-Afrika', 'Zuid-Korea', 'Zuid-Soedan', 'Zweden', 'Zwitserland']
  }, {
    id: :v4b,
    type: :number,
    title: 'Wat zijn de vier cijfers van uw postcode?',
    maxlength: 4,
    placeholder: 'Bijvoorbeeld: 9714',
    min: 0,
    max: 9999,
    required: true
  }, {
    id: :v5,
    type: :dropdown,
    title: 'Wat is uw hoogst afgeronde opleiding?',
    options: [
      'Geen opleiding (lagere school of basisonderwijs niet afgemaakt)',
      'Lager onderwijs (basisonderwijs, speciaal basisonderwijs)',
      'Lager of voorbereidend beroepsonderwijs (zoals LTS, LEAO, LHNO, VMBO)',
      'Middelbaar algemeen voortgezet onderwijs (zoals MAVO, (M)ULO, MBO-kort/MBO-2 of MBO-3, VMBO-t)',
      'Middelbaar beroepsonderwijs of beroepsbegeleidend onderwijs (zoals MBO-lang/ MBO-4, MTS, MEAO, BOL, BBL, INAS) ',
      'Hoger algemeen en voorbereidend wetenschappelijk onderwijs (zoals HAVO, VWO, Atheneum, Gymnasium, HBS, MMS, TTO)',
      'Hoger beroepsonderwijs (zoals HBO bachelor of master, HTS, HEAO, kandidaats wetenschappelijk onderwijs, propedeuse',
      'Wetenschappelijk onderwijs (universiteit bachelor, master, of gepromoveerd)',
      'Anders']
  }, {
    id: :v6,
    type: :number,
    title: 'Hoeveel jaar heeft u onderwijs gehad nadat u de basisschool hebt verlaten?',
    maxlength: 2,
    placeholder: 'Bijvoorbeeld: 3',
    min: 0,
    max: 50,
    required: true
  }, {
    id: :v7,
    type: :checkbox,
    title: 'Welke situatie is het meest op u van toepassing?',
    options: [
      { title: 'Ik werk betaald', shows_questions: %i[v7_a] },
      { title: 'Ik werk onbetaald', shows_questions: %i[v7_b] },
      { title: 'Ik studeer' },
      { title: 'Ik ben werkloos/ werkzoekend' },
      { title: 'Ik zit in de ziektewet of ben gedeeltelijk arbeidsongeschikt' },
      { title: 'Ik heb een bijstandsuitkering' },
      { title: 'Ik ben met pensioen' }]
  }, {
    id: :v7_a,
    hidden: true,
    type: :number,
    title: 'Hoeveel uur werkt u?',
    maxlength: 2,
    placeholder: 'Bijvoorbeeld: 36',
    min: 0,
    max: 100,
  }, {
    id: :v7_b,
    hidden: true,
    type: :checkbox,
    title: 'Wat voor onbetaald werk doet u?<br><br>Ik ben:',
    options: [
      'Ik ben thuisblijfmoeder/ thuisblijfvader',
      'Ik ben mantelzorger en zorg voor één of meerdere personen',
      'Ik doe vrijwilligerswerk']
  }, {
    type: :raw,
    content: '<p class="flow-text"> Het is belangrijk dat u de vragenlijsten in dit onderzoek steeds over hetzelfde kind invult. Als u meerdere kinderen heeft waarover u vragenlijsten in wilt vullen, dan kunt u meerdere accounts aanmaken. <br>
<br>
Beslis nu voor uzelf over welk kind u de vragenlijsten in wilt vullen. Als geheugensteuntje kunt u hieronder uw kind een nickname (bijnaam) geven. Deze nickname ziet u in de toekomst bij de vragenlijsten.</p>'
  }, {
    id: :v9,
    type: :textfield,
    title: 'Nickname van uw kind'
  }, {
    id: :v9_1,
    type: :radio,
    show_otherwise: false,
    title: 'Wat is het geslacht van uw kind?',
    options: ['Jongen', 'Meisje', 'Anders/ wil ik niet zeggen'],
    combines_with: %i[v9_3]
  }, {
    id: :v9_2,
    type: :dropdown,
    title: 'Wanneer is uw kind geboren? <br><br>Maand:',
    options: %w[januari februari maart april mei juni juli augustus september oktober november december]
  }, {
    id: :v9_3,
    type: :number,
    title: 'Jaar:',
    tooltip: 'Vul een jaartal in vanaf 2000 als geboortejaar van uw kind, bijvoorbeeld: 2011.',
    maxlength: 4,
    placeholder: 'Vul hier een getal in',
    min: 1990,
    max: 2020,
    required: true
  }, {
    id: :v9_4,
    type: :radio,
    title: 'Wat is uw relatie tot uw kind?<br><br>Ik ben zijn/haar:',
    options: [
      'Biologische ouder',
      'Adoptie-ouder of pleegouder',
      'Stiefouder of partner van biologische ouder']
  },{
    section_start: 'Tot slot: Digitale nieuwsbrief & vervolgonderzoek',
    id: :v10,
    type: :radio,
    title: 'Ieder Kind is Anders verstuurt 4x per jaar een nieuwsbrief via e-mail. Hierin delen we het laatste nieuws en de resultaten van het onderzoek. Wilt u deze nieuwsbrief ontvangen?',   
    options: [{title: 'Ja, ik wil de nieuwsbrief ontvangen'}, {title: 'Nee, ik heb geen interesse'}]
 },{
   id: :v11,
   type: :radio,
   title: 'Mogen we u na afloop van Ieder Kind is Anders eventueel benaderen voor vervolgonderzoek? Voordat u hieraan deel zou nemen krijgt u uiteraard informatie over de studie en wordt opnieuw toestemming gevraagd.',
   options: [{title: 'Ja, jullie mogen mij benaderen voor vervolgonderzoek'}, {title: 'Nee, ik heb geen interesse'}],
   section_end: true
   }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
