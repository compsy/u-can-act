# frozen_string_literal: true

db_title = 'Inschrijfformulier: boek u-can-act project' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'boek'
boek1 = Questionnaire.find_by(name: db_name1)
boek1 ||= Questionnaire.new(name: db_name1)
boek1.key = File.basename(__FILE__)[0...-3]
boek1_content = [
  {
    type: :raw,
    content: '<h4 class="center-align"><strong>Voortijdig schoolverlaten voorkomen: perspectieven van wetenschap, praktijk en beleid</strong></h4><p class="center-align">Met dit boek delen wij kennis en handvatten over het voorkomen van voortijdig schoolverlaten (VSV) vanuit drie perspectieven: wetenschap, praktijk en beleid. We presenteren wetenschappelijke theorieën over het voorkomen van VSV, beschrijven uitgebreid effectieve VSV-preventie methodieken, presenteren wat er belangrijk is bij het voorkomen van VSV volgens ons procesonderzoek, en tot slot gaan we in op het huidige VSV-beleid in Nederland inclusief verbetermogelijkheden op basis van ons beleidsonderzoek. Door deze perspectieven te integreren in een boek willen we bijdragen aan de verdere ontwikkeling van een coherente en effectieve aanpak van VSV, waarbij de jongere centraal staat.</p><p class="center-align">Eind dit jaar zal het boek verschijnen. Een online versie is dan te downloaden op onze <a href="https://u-can-act.nl" target="_blank">website</a> en bij Bol.com. Op deze pagina kun je je <strong>inschrijven voor een gratis gedrukt exemplaar</strong> van het boek u-can-act project. <a onclick="new window.M.Toast({html: &#39;Het onderzoek en de uitgave van het boek is gefinancierd door publieke middelen wat ons de mogelijkheid geeft om een aantal gedrukte exemplaren kosteloos aan te bieden (zolang de voorraad strekt).&#39;, displayLength: 16720});autoResizeImages();"><i class="tooltip flow-text material-icons info-outline">info</i></a></p><p><br>Vul de onderstaande gegevens in om een gedrukt exemplaar toegestuurd te krijgen: <a onclick="M.toast({html: &#39;Adresgegevens worden alleen gebruikt voor het versturen van de boeken en worden niet verspreid aan derden.&#39;, displayLength: 10420});autoResizeImages();"><i class="tooltip flow-text material-icons info-outline">info</i></a></p>'
  }, {
    id: :v1,
    type: :textfield,
    placeholder: 'Aanhef',
    required: true,
    title: ''
  }, {
    id: :v2,
    type: :textfield,
    placeholder: 'Voornaam',
    required: true,
    title: ''
  }, {
    id: :v3,
    type: :textfield,
    placeholder: 'Tussenvoegsel',
    title: ''
  }, {
    id: :v4,
    type: :textfield,
    placeholder: 'Achternaam',
    required: true,
    title: ''
  }, {
    id: :v5,
    type: :checkbox,
    required: false,
    title: '',
    options: [
      { title: 'Ik wil het boek toegestuurd krijgen op mijn werk.', shows_questions: %i[v6 v7] }
    ],
    show_otherwise: false
  }, {
    id: :v6,
    hidden: true,
    type: :textfield,
    placeholder: 'Organisatie',
    required: true,
    title: ''
  }, {
    id: :v7,
    hidden: true,
    type: :textfield,
    placeholder: 'Afdeling',
    title: ''
  }, {
    id: :v8,
    type: :textfield,
    placeholder: 'Straatnaam',
    required: true,
    title: ''
  }, {
    id: :v9,
    type: :textfield,
    placeholder: 'Huisnummer',
    required: true,
    title: ''
  }, {
    id: :v10,
    type: :textfield,
    placeholder: 'Postcode',
    required: true,
    title: ''
  }, {
    id: :v11,
    type: :textfield,
    placeholder: 'Plaats',
    required: true,
    title: ''
  }, {
    id: :v12,
    type: :checkbox,
    required: true,
    title: '',
    options: ['Ik geef hierbij toestemming om  mijn gegevens te gebruiken voor het toesturen van het boek. Mijn gegevens worden alleen hiervoor gebruikt en verwijderd na toezending van het boek.'],
    show_otherwise: false
  }
]
boek1.content = { questions: boek1_content, scores: [] }
boek1.title = db_title
boek1.save!
