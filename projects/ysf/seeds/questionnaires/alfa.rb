# frozen_string_literal: true

title = 'Alfa'

name = 'KCT Alfa'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

content = [
  {
    type: :raw,
    content: '
  <p class="flow-text">
    <em><center>Toestemmingsverklaring - "Your Special Forces"</center></em>
  </p>
  <center>
    Voor deelname aan wetenschappelijk onderzoek<br />
  </center>

  <p class="flow-text">
    Onderstaande <b>informatiebrief</b> is ook beschikbaar op
    <a href="https://yourspecialforces.nl/sep2020" target="_blank">
      https://yourspecialforces.nl/sep2020
    </a>.
  </p>

<h2> Informatiebrief </h2>

De ontwikkeling van (kandidaat)operators wordt gevolgd door onder andere de technische en medische staf van het Korps Commandotroepen (KCT).
Daarnaast werkt het KCT samen met de Rijksuniversiteit Groningen (RUG) om onderzoek uit te voeren rondom de selectie en ontwikkeling van operators.
Via de bijgevoegde toestemmingsverklaring wordt uw toestemming gevraagd om uw gegevens te gebruiken voor de wetenschap.<br />
<br />
De studie waarvoor uw toestemming wordt gevraagd is gericht op het onderzoeken van mogelijke factoren die bijdragen aan het succesvol doorlopen van de commando opleiding.
Vanuit de wetenschappelijke literatuur is er nog weinig duidelijkheid over mentale en fysieke factoren die (het meest) belangrijk zijn. Het doel van het huidige onderzoek is daarom om op enkele momenten (begin VO, einde ECO) online tests en vragenlijsten af te nemen bij de kandidaten. Daarnaast worden factoren gerelateerd aan stress en herstel gemeten tijdens de ECO. Deze gegevens worden verzameld via een online platform, genaamd Your Special Forces.
Door die gegevens vervolgens te analyseren willen wij als onderzoekers, in samenwerking met het KCT, bijdragen aan verbeteringen van het trainingsprogramma, en indien mogelijk ontwikkelingen van normgroepen.
Zijn er bijvoorbeeld bepaalde profielen van kandidaten die relatief vaak de ECO halen (of juist niet)?<br />
<br />
<h4>Wat betekent deelname voor u?</h4>

Als u de toestemmingsverklaring ondertekent, betekent dit dat u ermee instemt dat de gegevens die worden verzameld via Your Special Forces, voor wetenschappelijk onderzoek worden gebruikt.
Uw gegevens worden opgeslagen binnen een beveiligde server, beheerd door de RUG.
Van het KCT ontvangt u een codenaam voor Your Special Forces.
De RUG slaat uw codenaam en antwoorden op; uw eigen naam is niet bekend bij de RUG.
De volledige naam, behorend bij een codenaam, is alleen bekend bij het KCT.
De RUG gaat zorgvuldig om met uw antwoorden en zal deze behandelen in overeenstemming met de Europese regels voor de verwerking van persoonsgegevens: de Algemene verordening gegevensbescherming.<br />
<br />
Onderzoekers die betrokken zijn bij het project (de personen onderaan deze mail, collega’s en masterstudenten van de RUG) kunnen via de beveiligde server wetenschappelijke analyses uitvoeren op geanonimiseerde gegevens die bij de (kandidaat)operators verzameld zijn. Resultaten van die analyses kunnen gebruikt worden voor publicaties in wetenschappelijke tijdschriften, presentaties voor het KCT en presentaties op congressen. Hierbij zal nooit direct-identificeerbare informatie, zoals naam, geboortedatum, etc. vermeld worden.<br />
<br />
<h4>Vrijwilligheid van deelname</h4>

Als u besluit medewerking te verlenen aan dit onderzoek, verzoek ik u de toestemmingsverklaring (informed consent) te ondertekenen onder “Ik doe mee aan het onderzoek” op de volgende pagina. Indien u wenst dat uw gegevens niet gebruikt worden voor wetenschappelijk onderzoek, tekent u onder “Ik doe niet mee aan het onderzoek”. Als u heeft bevestigd dat u meedoet aan het onderzoek, blijft u de vrijheid behouden om wegens voor u relevante redenen uw medewerking te stoppen, zonder dat hieraan consequenties verbonden zijn. U behoudt ook het recht om al uw gegevens te laten verwijderen voor verder wetenschappelijk onderzoek. Gegevens kunnen echter niet meer verwijderd worden als hierover is gerapporteerd in een wetenschappelijke publicatie. De onderzoeker zal het formulier eveneens ondertekenen en bevestigt dat zij u heeft geïnformeerd over het onderzoek, deze informatiebrief heeft overhandigd en bereid is om waar mogelijk in te gaan op nog opkomende vragen.<br/>
<br />
<h4>Vragen</h4>
Indien u na het lezen van deze brief, voor of tijdens het onderzoek nog nadere informatie wil ontvangen over het onderzoek, dan kunt u contact opnemen met:<br />
<br />
<h5>Contactpersoon Ministerie van Defensie / Korps Commandotroepen</h5>
Lkol Maurits Baatenburg de Jong<br />
Projectbegeleider vanuit het Ministerie van Defensie<br />
mail: MJS.BaatenburgDeJong@mindef.nl <br />
<br />
<h5>Contactpersoon uitvoerend onderzoeker RUG</h5>
Ir. Rik Huijzer<br />
Promovendus en programmeur Your Special Forces<br />
Heymans Instituut voor Psychologisch onderzoek, afdeling Psychologie<br />
Rijksuniversiteit Groningen<br />
mail: t.h.huijzer@rug.nl<br />
<br />
<h5>Contactpersoon projectleider RUG</h5>
Dr. Ruud den Hartigh<br />
Hoofdonderzoeker van het project vanuit de RUG<br />
Heymans Instituut voor Psychologisch onderzoek, afdeling Psychologie<br />
Rijksuniversiteit Groningen<br />
mail: j.r.den.hartigh@rug.nl<br />
<br/>

<h2>Toestemmingsverklaring</h2>

  <ol>
    <li>
    Ik verklaar op een voor mij duidelijke wijze te zijn ingelicht over de aard en het doel van het
    onderzoek. Ik ben in de gelegenheid gesteld om vragen over het onderzoek te stellen en mijn
    vragen zijn naar tevredenheid beantwoord.
    </li>

    <li>
    Ik weet dat de gegevens en resultaten uit dit onderzoek op een beveiligde server worden
    opgeslagen en gebruikt worden in toekomstig onderzoek rondom de selectie en ontwikkeling
    van operators.
    </li>

    <li>
    Ik geef toestemming om de gegevens te verwerken voor de doeleinden zoals beschreven in
    de informatiebrief.
    </li>

    <li>
    Ik begrijp dat ik mijn deelname op ieder moment, om wat voor reden dan ook, mag en kan
    beëindigen zonder dat hieraan enige consequenties verbonden zijn.
    </li>
  </ol>
  '
  }, {
    id: :v1,
    type: :radio,
    title: '',
    options: [
      'Ik doe <b>wel</b> mee aan het onderzoek',
      'Ik doe <b>niet</b> mee aan het onderzoek'
    ],
    show_otherwise: false
  }
]

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
