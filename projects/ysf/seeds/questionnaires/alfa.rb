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
  <p class="flow-text"><em>Geïnformeerde toestemming</em></p>
  <p class="flow-text">
  <br><b>Achtergrondinformatie over het project</b>

  <p>De ontwikkeling van (kandidaat)operators wordt gevolgd door onder andere de technische en medische staf van het KCT. Daarnaast werkt het KCT samen met de Rijksuniversiteit Groningen (RUG) om onderzoek uit te voeren rondom de selectie en ontwikkeling van operators. Via de bijgevoegde toestemmingsverklaring wordt uw toestemming gevraagd om uw gegevens te gebruiken voor de wetenschap.</p>

<p>De studie waarvoor uw toestemming wordt gevraagd is gericht op het onderzoeken van mogelijke factoren die bijdragen aan het succesvol doorlopen van de commando opleiding. Vanuit de wetenschappelijke literatuur is er nog weinig duidelijkheid over mentale en fysieke factoren die (het meest) belangrijk zijn. Het doel van het huidige onderzoek is daarom om op enkele momenten (begin VO, einde ECO) online tests en vragenlijsten af te nemen bij de kandidaten. Daarnaast worden factoren gerelateerd aan stress en herstel gemeten tijdens de ECO. Deze gegevens worden verzameld via een veilig online platform, genaamd “Your Special Forces”. Door die gegevens vervolgens te analyseren willen wij als onderzoekers, in samenwerking met het KCT, bijdragen aan verbeteringen van het trainingsprogramma, en indien mogelijk ontwikkelingen van normgroepen. Zijn er bijvoorbeeld bepaalde profielen van kandidaten die relatief vaak de ECO halen (of juist niet)?</p>
  </p>

  <br><b>Wat betekent deelname voor u?</b>
<p>Als u de toestemmingsverklaring ondertekent, betekent dit dat u ermee instemt dat de gegevens die worden verzameld via Your Special Forces, voor wetenschappelijk onderzoek worden gebruikt. Uw gegevens worden opgeslagen binnen een beveiligde server, beheerd door de RUG. Van het KCT ontvangt u een codenaam voor Your Special Forces. De RUG slaat uw codenaam en antwoorden op; uw eigen naam is niet bekend bij de RUG. De volledige naam, behorend bij een codenaam, liggen achter slot en grendel (in een kluis) op de kazerne in Roosendaal. De RUG gaat zorgvuldig om met uw antwoorden en zal deze behandelen in overeenstemming met de Europese regels voor de verwerking van persoonsgegevens: de Algemene verordening gegevensbescherming.</p>

<p>Onderzoekers die betrokken zijn bij het project (de personen onderaan deze mail, collega’s en masterstudenten van de RUG) kunnen via de beveiligde server wetenschappelijke analyses uitvoeren op geanonimiseerde gegevens die bij de (kandidaat)operators verzameld zijn. Resultaten van die analyses kunnen gebruikt worden voor publicaties in wetenschappelijke tijdschriften, presentaties voor het KCT en presentaties op congressen. Hierbij zal nooit direct-identificeerbare informatie, zoals naam, geboortedatum, etc. vermeld worden.</p>

<p><b>Vrijwilligheid van deelname</b></p>
<p>Als u besluit medewerking te verlenen aan dit onderzoek, verzoek ik u de toestemmingsverklaring (informed consent) te ondertekenen onder “Ik doe mee aan het onderzoek” op de volgende pagina. Indien u wenst dat uw gegevens niet gebruikt worden voor wetenschappelijk onderzoek, tekent u onder “Ik doe niet mee aan het onderzoek”. Als u heeft bevestigd dat u meedoet aan het onderzoek, blijft u de vrijheid behouden om wegens voor u relevante redenen uw medewerking te stoppen, zonder dat hieraan consequenties verbonden zijn. U behoudt ook het recht om al uw gegevens te laten verwijderen voor verder wetenschappelijk onderzoek. Gegevens kunnen echter niet meer verwijderd worden als hierover is gerapporteerd in een wetenschappelijke publicatie. De onderzoeker zal het formulier eveneens ondertekenen en bevestigt dat zij u heeft geïnformeerd over het onderzoek, deze informatiebrief heeft overhandigd en bereid is om waar mogelijk in te gaan op nog opkomende vragen.</p>

<p><b>Data fysieke testen</b></p>
<p>Vanaf augustus 2021 vragen wij u ook afzonderlijk om toestemming voor het gebruik van uw gegevens van de fysieke testen. Het KCT verzamelt deze gegevens in het kader van de opleiding. Wij zouden deze gegevens graag, geanonimiseerd, willen gebruiken voor wetenschappelijk onderzoek naar de bijdrage van fysieke parameters op prestaties van (kandidaat) operators. Hier geldt ook dat resultaten van die analyses kunnen gebruikt worden voor publicaties in wetenschappelijke tijdschriften, presentaties voor het KCT en presentaties op congressen. Hierbij zal nooit direct-identificeerbare informatie, zoals naam, geboortedatum, etc. vermeld worden.</p>

<p><b>Vragen</b></p>
<p>Indien u na het lezen van de brief, voor of tijdens het onderzoek nog nadere informatie wil ontvangen over het onderzoek, dan kunt u contact opnemen met:</p>
<a href="mailto:aj.d.wit@mindef.nl">aj.d.wit@mindef.nl</a>,
<a href="mailto:j.r.den.hartigh@rug.nl">j.r.den.hartigh@rug.nl</a> of
<a href="mailto:t.h.huijzer@rug.nl">t.h.huijzer@rug.nl</a>.

  <ol class="flow-text">
<li>
Ik ben me ervan bewust dat deelname aan dit onderzoek geheel vrijwillig is.
Ik kan mijn medewerking op elk tijdstip stopzetten, zonder een reden te geven.
Daarnaast kan ik de gegevens die verkregen zijn uit dit onderzoek terugkrijgen, laten verwijderen uit de database of laten vernietigen.
</li>

<li>
De antwoorden op de vragen kunnen geen invloed hebben op mijn functie en worden niet gebruikt in een andere context dan dit onderzoek.
</li>

<li>
Er wordt mij gevraagd om vragenlijsten online in te vullen en om safe houses te herkennen in bepaalde steden.
</li>

<li>
Mijn gegevens zullen vertrouwelijk worden behandeld.
Mijn persoonsgegevens worden fysiek gescheiden van mijn antwoordgegevens.
</li>

<li>
Mijn geanonimiseerde antwoordgegevens kunnen worden gebruikt voor wetenschappelijk onderzoek.
</li>

  </ol>'
  },
  {
    id: :v1,
    type: :radio,
    title: '',
    options: [
      'Ik heb bovenstaande informatie gelezen en heb besloten om <b>wel</b> deel te nemen aan het onderzoek',
      'Ik heb bovenstaande informatie gelezen en heb besloten om <b>niet</b> deel te nemen aan het onderzoek'
    ],
    show_otherwise: false
  },
  {
    id: :v2,
    type: :radio,
    title: '',
    options: [
      'Mijn geanonimiseerde gegevens van de fysieke testen mogen <b>wel</b> gedeeld worden met de Rijksuniversiteit Groningen',
      'Mijn geanonimiseerde gegevens van de fysieke testen mogen <b>niet</b> gedeeld worden met de Rijksuniversiteit Groningen'
    ],
    show_otherwise: false
  },

]

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
