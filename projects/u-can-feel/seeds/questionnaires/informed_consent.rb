# frozen_string_literal: true

db_title = 'Toestemmingsverklaring'
db_name1 = 'informed_consent_16_plus'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

ic_content = <<~'END'
  <div class='informed-consent'>
    <h4>INFORMATIE OVER HET ONDERZOEK</h4>
    <h5>VOOR LEERLINGEN VAN 16 EN OUDER</h5>
    <h5><strong>"U-CAN-FEEL"</strong></h5>
    <p><strong><i class='material-icons'>chevron_right</i> Waarom krijg ik deze informatie?</strong></p>
    <p>
      We vragen je om mee te doen aan een onderzoek over gevoelens van geluk, angst en somberheid bij leerlingen op de
      middelbare school. Ook jouw school doet mee aan dit onderzoek, net als andere scholen in Zwolle.
    </p>
    <p>Het onderzoek loopt van 1 september 2020 tot april 2023. Het wordt gedaan door de afdeling Psychologie van de
      Rijksuniversiteit Groningen. Het onderzoeksplan is ook goed gekeurd door de ethische commissie van de afdeling
      Psychologie. De onderzoekers zijn: Ymkje Anna de Vries (<a href='mailto:y.a.de.vries@rug.nl'>y.a.de.vries@rug.nl</a>)
      en Bert Wienen (<a href='mailto:b.wienen@windesheim.nl'>b.wienen@windesheim.nl</a>).
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Moet ik meedoen aan dit onderzoek?</strong></p>
    <p>Je mag zelf kiezen of je mee doet aan dit onderzoek. Lees daarom de informatie goed door. Misschien heb je daarna
      nog vragen, bijvoorbeeld omdat je iets niet begrijpt. Je kunt al je vragen stellen aan de contactpersoon op jouw
      school of de onderzoekers. Je mag op elk moment besluiten om niet mee te doen aan het onderzoek, dus ook nadat je
      hebt toegestemd om mee te doen. Als je besluit om niet mee te doen, hoef je niet uit te leggen waarom. Het zal ook
      geen gevolgen voor je hebben op school.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Waarom dit onderzoek?</strong></p>
    <p>
      Middelbare scholieren hebben wel eens last van gevoelens zoals angst en depressiviteit. We weten niet goed hoe dit
      kan en ook niet hoe we leerlingen het beste kunnen helpen. Daarom doen we dit onderzoek bij alle leerlingen, ook als
      jij hier nog nooit last van hebt gehad.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Wat vragen we van je tijdens het onderzoek?</strong></p>
    <p>
      Allereerst vragen we jouw toestemming. Als je toestemming geeft, vragen wij je om de komende twee jaar elk half jaar
      een vragenlijst in te vullen (in totaal vijf keer). De eerste keer is in september 2020.
    </p>
    <p>
      De vragenlijst gaat over hoe het met jou gaat en dingen die je meemaakt, bijvoorbeeld op school. Het invullen zal
      maximaal 1 uur kosten. Je kunt de vragenlijst invullen op je eigen mobiele telefoon.
      <em>Dit kan tijdens een lesuur op school. / We vragen je om de vragenlijst thuis in te vullen, op een moment dat het
        je goed uitkomt.
      </em>
    </p>
    <p>
      Uit de hele groep leerlingen kiezen we een klein aantal leerlingen die we vragen om tijdens het schooljaar elke week
      een paar vragen te beantwoorden via een app op de telefoon. Dit kost ongeveer 5 minuten per week en hiervoor krijg
      je een vergoeding van 1 euro per ingevulde vragenlijst. Dit kan komend schooljaar gebeuren of pas het jaar daarna.
    </p>
    <p>
      We vragen ook jouw toestemming om gegevens van de school te krijgen over jouw verzuim (afwezigheid van school). Dit
      is niet verplicht. Je kunt meedoen aan het onderzoek, ook als je niet wil dat wij deze gegevens van de school
      krijgen.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Welke gevolgen kan deelname hebben?</strong></p>
    <p>
      We verwachten geen <strong>directe</strong> voordelen van het onderzoek voor jou. We hopen dat scholen door het
      onderzoek leerlingen in de toekomst beter kunnen helpen om gelukkig te blijven en om goed om te gaan met negatieve
      gevoelens. Het onderzoek kost wel tijd. Het gaat dan om het invullen van de lijsten (ongeveer 2 tot 5 uur per jaar).
      Als je naar aanleiding van het onderzoek ergens over wil praten, dan kun je contact opnemen met de contactpersoon of
      de jeugdverpleegkundige van jouw school. Je kunt ook contact opnemen met een jeugdarts of jeugdverpleegkundige van
      de GGD (telefoonnummer: 088-4430702). Hier krijgt je school niets over te horen.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Hoe gaan we met je gegevens om?</strong></p>
    <p>
      Om het onderzoek goed uit te kunnen voeren, is het nodig dat we je naam, je leerlingnummer en je mobiele
      telefoonnummer opslaan. Zo kunnen we later opnieuw contact met je opnemen. Na afloop van het onderzoek, op 1 april
      2023, vernietigen we deze gegevens.
    </p>
    <p>
      Alle informatie die je aan ons geeft, wordt vertrouwelijk behandeld. Dit betekent dat we deze informatie <strong>nooit</strong>
      aan je school, aan je ouders, of aan anderen geven.
    </p>
    <p>
      We slaan je gegevens en je antwoorden op in beveiligde databases. Daarbij worden je naam, leerlingnummer en
      telefoonnummer apart opgeslagen van de antwoorden op de vragen. Hierdoor zijn antwoorden niet naar jou terug te
      leiden, ook niet als er in één van de databases ingebroken wordt.
    </p>
    <p>
      Je hebt recht op toegang tot je eigen gegevens. Je hebt ook het recht om ons te vragen om gegevens te veranderen of
      te verwijderen. Hiervoor kun je contact opnemen met de onderzoekers. Je hoeft niet te zeggen waarom je dat wil. Dit
      kan tot 1 april 2023.
    </p>
    <p>
      Na afloop van het onderzoek worden de antwoorden op de vragenlijsten bewaard binnen de Rijksuniversiteit Groningen.
      De onderzoekers gebruiken de antwoorden voor het onderzoek. De resultaten van het onderzoek worden met de scholen
      gedeeld en gepubliceerd in wetenschappelijk tijdschriften. Deze resultaten gaan over alle leerlingen, nooit over een
      specifieke leerling.
    </p>
    <p>
      Om verder onderzoek mogelijk te maken, kunnen de antwoorden op de vragen onder bepaalde voorwaarden ook gedeeld
      worden met andere onderzoekers. Maar je naam, nummer en telefoonnummer worden <strong>nooit</strong> gedeeld. We
      delen alleen die gegevens die echt nodig zijn voor het verdere onderzoek. Andere onderzoekers moeten de gegevens na
      afloop vernietigen.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Wat moet je nog meer weten?</strong></p>
    <p>
      Je kunt altijd vragen stellen over het onderzoek: nu, tijdens het onderzoek, en na afloop. Dit kan door een van de
      onderzoekers te e-mailen (<a href='mailto:y.a.de.vries@rug.nl'>y.a.de.vries@rug.nl</a>
      of <a href='mailto:b.wienen@windesheim.nl'>b.wienen@windesheim.nl</a>) of te bellen (050-3633241 of 088-4699773).
      Je kunt ook contact opnemen met de contactpersoon op jouw school.
    </p>
    <p>
      Heb je vragen of zorgen over jouw rechten als onderzoeksdeelnemer? Hiervoor kun je ook contact opnemen met de
      Ethische Commissie Psychologie van de Rijksuniversiteit Groningen: <a href='mailto:ecp@rug.nl'>ecp@rug.nl</a>.
    </p>
    <p>
      Heb je vragen of zorgen over jouw privacy, of over hoe er met jouw persoonsgegevens wordt omgegaan? Hiervoor kun
      je ook contact opnemen met de Functionaris Gegevensbescherming van de Rijksuniversiteit
      Groningen: <a href='mailto:privacy@rug.nl'>privacy@rug.nl</a>.
    </p>
    <p>
      Als onderzoeksdeelnemer heb je recht op een kopie van deze onderzoeksinformatie.
    </p>
    <h4>GEÏNFORMEERDE TOESTEMMING</h4>
    <h5>(voor leerlingen)</h5>
    <h5><strong>"U-CAN-FEEL" ONDERZOEK</strong></h5>
    <ul>
      <li>
        Ik heb de informatie over het onderzoek gelezen. Ik heb alle vragen die ik had, kunnen stellen.
      </li>
      <li>
        Ik begrijp waar het onderzoek over gaat en wat ik moet doen om aan het onderzoek mee te doen. Ik weet dat de
        antwoorden die ik invul alleen door de onderzoekers gelezen worden en dat de antwoorden beveiligd worden
        opgeslagen.
      </li>
      <li>
        Ik begrijp dat ik er zelf voor kies om mee te doen aan het onderzoek. Ik weet dat ik op elk moment kan stoppen met
        meedoen. Als ik stop, hoef ik niet uit te leggen waarom. Stoppen zal geen negatieve gevolgen voor mij hebben.
      </li>
      <li>
        Ik geef hieronder aan waar ik toestemming voor geef.
      </li>
    </ul>
  </div>
END

ic_footer = <<~'END'
  <p class="flow-text"><em>U heeft recht op een kopie van dit toestemmingsformulier.</em></p>
END

dagboek_content = [
  {
    type: :raw,
    content: ic_content
  }, {
    id: :v1,
    type: :checkbox,
    required: true,
    title: 'Toestemming om mee te doen aan het onderzoek',
    options: [
      'Ja, ik geef toestemming om mee te doen aan het onderzoek. Deze toestemming loopt tot 01-04-2023, tenzij ik besluit om eerder te stoppen. Ik geef ook toestemming voor het verwerken van mijn persoonsgegevens zoals uitgelegd in de informatiebrief hierboven.'
    ],
    show_otherwise: false
  }, {
    id: :v2,
    type: :radio,
    required: true,
    title: 'Toestemming voor het delen van verzuimgegevens',
    options: [
      'Ja, ik geef toestemming aan de school om mijn verzuimgegevens te delen met de onderzoekers.',
      'Nee, ik geef geen toestemming voor het delen van verzuimgegevens.'
    ],
    show_otherwise: false
  }, {
    type: :raw,
    content: ic_footer
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
