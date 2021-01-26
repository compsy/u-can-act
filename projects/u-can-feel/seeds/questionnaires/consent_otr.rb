# frozen_string_literal: true
db_title = 'Toestemmingsformulier voor het onderzoek'
db_name1 = 'consent_otr'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

SCHOOLS = [
  'Zone.college',
  'Greijdanus College',
  'Capellen Campus',
  'Thorbecke Scholengemeenschap MHA',
  'Thomas á Kempis College',
  'Jena XL',
  'Meander College',
  'Mens&'
]
PHONE_REGEX = '^06([\s-]?[0-9]){8}$'
EMAIL_REGEX = '^[^@\s]+@[^@\s]+$'

ic_content_ouders = <<~'END'
  <div class='informed-consent'>
    <h4>INFORMATIE OVER HET ONDERZOEK</h4>
    <h5><strong>"U-CAN-FEEL"</strong></h5>
    <p><strong><i class='material-icons'>chevron_right</i> Waarom krijg ik deze informatie?</strong></p>
    <p>
      We vragen uw kind om mee te doen aan een onderzoek, omdat zijn/haar school komend schooljaar meedoet. Andere scholen
      in Zwolle doen ook mee. Het onderzoek gaat over gevoelens zoals geluk, angst en depressiviteit, en de rol van de
      school daarbij.
    </p>
    <p>
      Het onderzoek loopt van 1 september 2020 tot 1 september 2023. Het wordt gedaan door de afdeling Psychologie van de
      Rijksuniversiteit Groningen. Het onderzoeksplan is ook goedgekeurd door de ethische commissie van de afdeling
      Psychologie (PSY-1920-S-0429). De verantwoordelijke onderzoekers zijn: dr. Ymkje Anna de Vries (afdeling
      Psychologie) en dr. Bert Wienen (Hogeschool Windesheim Zwolle).
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Moet mijn kind meedoen aan dit onderzoek?</strong></p>
    <p>Meedoen aan het onderzoek is vrijwillig. Wel is toestemming nodig van zowel u als uw kind. Lees deze informatie
      daarom goed door. Stel alle vragen die u misschien heeft, bijvoorbeeld omdat u iets niet begrijpt. U kunt vragen
      stellen aan de contactpersoon op de school van uw kind of aan de onderzoekers. Pas daarna besluit u of uw kind mee doet. Als u
      besluit dat uw kind niet mee doet, hoeft u niet uit te leggen waarom, en zal dit geen negatieve gevolgen voor u of
      uw kind hebben op school. Dit recht geldt op elk moment, dus ook nadat u hebt toegestemd in deelname aan het
      onderzoek.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Waarom dit onderzoek?</strong></p>
    <p>
      Leerlingen op de middelbare school hebben steeds vaker last van gevoelens zoals angst en depressiviteit. We weten
      niet goed hoe dit kan en ook niet hoe we leerlingen het beste kunnen helpen. Daarom doen we dit onderzoek bij alle
      leerlingen, ook leerlingen die nog nooit last hebben gehad van dit soort gevoelens.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Wat vragen we van uw kind tijdens het onderzoek?</strong></p>
    <p>
      Allereerst vragen we toestemming van zowel u als uw kind. Als u en uw kind toestemming geven, vragen wij uw kind de
      komende twee jaar elk half jaar om een vragenlijst in te vullen (in totaal vijf keer). De eerste keer is ongeveer in
      maart 2021.
    </p>
    <p>
      De vragenlijst gaat over de gevoelens van uw kind en dingen die uw kind meemaakt, bijvoorbeeld op school. Het
      invullen zal maximaal 1 uur kosten. Uw kind kan de vragenlijst invullen op zijn/haar eigen mobiele telefoon of laptop.
    </p>
    <p>
      Uit de hele groep leerlingen kiezen we een klein aantal leerlingen die we vragen om tijdens het schooljaar elke week
      een paar vragen te beantwoorden via een app op de telefoon. Dit kost ongeveer 5 minuten per week. Dit gebeurt pas
      het volgende schooljaar. Leerlingen die hieraan meedoen, krijgen een kleine vergoeding van 1 euro
      per ingevulde vragenlijst.
    </p>
    <p>
      We vragen ook toestemming om gegevens te krijgen van de school over het verzuim (afwezigheid) van uw kind. Dit is
      niet verplicht. Uw kind kan mee doen aan het onderzoek, ook als u of uw kind niet wil dat de school ons deze
      gegevens geeft.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Welke gevolgen kan deelname hebben?</strong></p>
    <p>
      We verwachten geen <strong>directe</strong> voordelen van het onderzoek voor uw kind. We hopen dat scholen door het onderzoek
      leerlingen in de toekomst beter kunnen helpen om gelukkig te blijven en goed om te gaan met negatieve gevoelens. Het
      onderzoek zal wel tijd kosten. Het gaat om ongeveer 2 tot 5 uur per jaar tijdens 2 jaar. Ook kunnen de vragen over
      gevoelens voor sommige leerlingen misschien confronterend zijn. Leerlingen die ergens over willen praten naar
      aanleiding van het onderzoek kunnen contact opnemen met de contactpersoon of jeugdverpleegkundige op hun school. Ze
      kunnen ook bellen met een arts of verpleegkundige van de GGD (telefoonnummer: 088-4430702). Hier krijgt de school
      niets over te horen.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Hoe gaan we met uw gegevens om?</strong></p>
    <p>
      Om het onderzoek goed uit te kunnen voeren, is het nodig dat wij wat persoonsgegevens van uw kind verzamelen.
      Bijvoorbeeld zijn/haar leerlingnummer en telefoonnummer. Zo kunnen wij opnieuw contact opnemen met uw kind.
      We vernietigen deze gegevens op 1 september 2023. Ook gaat het om de antwoorden op de vragenlijsten.
    </p>
    <p>
      Alle informatie die uw kind aan ons geeft, wordt vertrouwelijk behandeld. Dit betekent dat we deze informatie <strong>nooit</strong>
      aan de school, de ouders, of anderen geven. Gegevens zoals het telefoonnummer van uw kind worden apart opgeslagen van de
      antwoorden op de vragenlijsten, in beveiligde databases. Hierdoor zijn de antwoorden niet naar uw kind terug te
      leiden.
    </p>
    <p>
      Uw kind heeft tot 1 september 2023 recht op toegang tot zijn/haar gegevens en vanaf zijn/haar 16e verjaardag ook op het
      wijzigen en het verwijderen van zijn/haar gegevens. Hiervoor kan uw kind contact opnemen met de onderzoekers. Uw
      kind hoeft niet te zeggen waarom hij/zij dat wil. Als ouder hebt u géén recht op toegang tot de gegevens van uw
      kind. U kunt wél vragen om wijziging of verwijdering van de gegevens. Dit recht bestaat tot 1 september 2023 of tot uw
      kind 16 wordt. Als de antwoorden op de vragenlijsten al gebruikt zijn voor wetenschappelijk onderzoek, zijn we
      verplicht om de antwoorden te bewaren. U of uw kind kan ons dan wel vragen om de antwoorden niet meer te gebruiken
      voor nieuw onderzoek.
    </p>
    <p>
      Na afloop van het onderzoek bewaren we de antwoorden op de vragenlijsten binnen de Rijksuniversiteit Groningen. De
      resultaten worden gedeeld met de scholen en gepubliceerd in tijdschriften. Deze resultaten gaan over alle
      leerlingen, nooit over een specifieke leerling. Ze bevatten géén gegevens waarmee een leerling geïdentificeerd kan
      worden.
    </p>
    <p>
      De gegevens kunnen ook gedeeld worden met andere onderzoekers voor verder onderzoek. Het gaat hier <strong>alleen</strong> om de
      antwoorden op de vragenlijsten, waarmee uw kind niet te identificeren is. Alleen gegevens die echt nodig zijn voor
      het verdere onderzoek worden gedeeld. Andere onderzoekers moeten de gegevens na afloop vernietigen.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Wat moet u nog meer weten?</strong></p>
    <p>
      U kunt altijd vragen stellen over het onderzoek: nu, tijdens het onderzoek, en na afloop. Dit kan door met de
      onderzoekers te e-mailen (<a href='mailto:y.a.de.vries@rug.nl' target='_blank' rel='noopener noreferrer'>y.a.de.vries@rug.nl</a>
      of <a href='mailto:b.wienen@windesheim.nl' target='_blank' rel='noopener noreferrer'>b.wienen@windesheim.nl</a>) of te bellen (050-3633241 of 088-4699773).
      U kunt ook contact op nemen met de contactpersoon op school.
    </p>
    <p>
      Heeft u vragen of zorgen over de rechten van u of uw kind als onderzoeksdeelnemer? Hiervoor kunt u contact opnemen
      met de Ethische Commissie Psychologie van de Rijksuniversiteit Groningen: <a href='mailto:ecp@rug.nl' target='_blank' rel='noopener noreferrer'>ecp@rug.nl</a>.
    </p>
    <p>
      Heeft u vragen of zorgen over de privacy van uw kind, of over hoe er met de persoonsgegevens van uw kind wordt
      omgegaan? Hiervoor kunt u ook contact opnemen met de Functionaris Gegevensbescherming van de Rijksuniversiteit
      Groningen: <a href='mailto:privacy@rug.nl' target='_blank' rel='noopener noreferrer'>privacy@rug.nl</a>.
    </p>
    <p>
      Als ouder van een onderzoeksdeelnemer heeft u recht op een kopie van deze onderzoeksinformatie. U kunt daarvoor deze pagina opslaan of uitprinten.
    </p>
    <h4>GEÏNFORMEERDE TOESTEMMING</h4>
    <h5><strong>"U-CAN-FEEL" ONDERZOEK</strong></h5>
    <ul class='flow-text browser-default'>
      <li>
        Ik heb de informatie over het onderzoek gelezen. Ik heb alle vragen die ik had, kunnen stellen.
      </li>
      <li>
        Ik begrijp waar het onderzoek over gaat en wat er van mijn kind gevraagd wordt. Ik begrijp ook welke gevolgen
        deelname voor mijn kind kan hebben, hoe er met de gegevens van mijn kind wordt omgegaan, en wat de rechten van
        mijn kind zijn.
      </li>
      <li>
        Ik begrijp dat deelname aan het onderzoek vrijwillig is. Mijn kind kiest er zelf voor om mee te doen. Mijn kind
        kan op elk moment stoppen met meedoen. Als mijn kind stopt, hoeft hij/zij niet uit te leggen waarom. Stoppen zal
        geen negatieve gevolgen voor mijn kind of voor mij hebben.
      </li>
      <li>
        Ik geef hieronder aan waar ik toestemming voor geef.
      </li>
    </ul>
  </div>
END

ic_content_16_plus = <<~'END'
  <div class='informed-consent'>
    <h4>INFORMATIE OVER HET ONDERZOEK</h4>
    <h5><strong>"U-CAN-FEEL"</strong></h5>
    <p><strong><i class='material-icons'>chevron_right</i> Waarom krijg ik deze informatie?</strong></p>
    <p>
      We vragen je om mee te doen aan een onderzoek over gevoelens van geluk, angst en somberheid bij leerlingen op de
      middelbare school. Ook jouw school doet mee aan dit onderzoek, net als andere scholen in Zwolle.
    </p>
    <p>Het onderzoek loopt van 1 september 2020 tot 1 september 2023. Het wordt gedaan door de afdeling Psychologie van de
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
      een vragenlijst in te vullen (in totaal vijf keer). De eerste keer is ongeveer in maart 2021.
    </p>
    <p>
      De vragenlijst gaat over hoe het met jou gaat en dingen die je meemaakt, bijvoorbeeld op school. Het invullen zal
      maximaal 1 uur kosten. Je kunt de vragenlijst invullen op je eigen mobiele telefoon of laptop.
    </p>
    <p>
      Uit de hele groep leerlingen kiezen we een klein aantal leerlingen die we vragen om tijdens het schooljaar elke week
      een paar vragen te beantwoorden via een app op de telefoon. Dit kost ongeveer 5 minuten per week en hiervoor krijg
      je een vergoeding van 1 euro per ingevulde vragenlijst. Dit gebeurt pas volgend schooljaar.
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
      Om het onderzoek goed uit te kunnen voeren, is het nodig dat we je leerlingnummer en je mobiele
      telefoonnummer opslaan. Zo kunnen we later opnieuw contact met je opnemen. Na afloop van het onderzoek, op 1 september
      2023, vernietigen we deze gegevens.
    </p>
    <p>
      Alle informatie die je aan ons geeft, wordt vertrouwelijk behandeld. Dit betekent dat we deze informatie <strong>nooit</strong>
      aan je school, aan je ouders, of aan anderen geven.
    </p>
    <p>
      We slaan je gegevens en je antwoorden op in beveiligde databases. Daarbij worden je leerlingnummer en
      telefoonnummer apart opgeslagen van de antwoorden op de vragen. Hierdoor zijn antwoorden niet naar jou terug te
      leiden, ook niet als er in één van de databases ingebroken wordt.
    </p>
    <p>
      Je hebt recht op toegang tot je eigen gegevens. Je hebt ook het recht om ons te vragen om gegevens te veranderen
      of te verwijderen. Hiervoor kun je contact opnemen met de onderzoekers. Je hoeft niet te zeggen waarom je dat wil.
      Dit kan tot 1 september 2023. Als je antwoorden op de vragenlijsten al gebruikt zijn voor wetenschappelijk onderzoek,
      zijn we verplicht om de antwoorden te bewaren. Je kunt ons dan wel vragen om jouw antwoorden niet meer te gebruiken
      voor nieuw onderzoek.
    </p>
    <p>
      Na afloop van het onderzoek worden de antwoorden op de vragenlijsten bewaard binnen de Rijksuniversiteit Groningen.
      De onderzoekers gebruiken de antwoorden voor het onderzoek. De resultaten van het onderzoek worden met de scholen
      gedeeld en gepubliceerd in wetenschappelijk tijdschriften. Deze resultaten gaan over alle leerlingen, nooit over een
      specifieke leerling.
    </p>
    <p>
      Om verder onderzoek mogelijk te maken, kunnen de antwoorden op de vragen onder bepaalde voorwaarden ook gedeeld
      worden met andere onderzoekers. Maar je leerlingnummer en telefoonnummer worden <strong>nooit</strong> gedeeld. We
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
      Als onderzoeksdeelnemer heb je recht op een kopie van deze onderzoeksinformatie. Je kunt daarvoor deze pagina opslaan of uitprinten.
    </p>
    <h4>GEÏNFORMEERDE TOESTEMMING</h4>
    <h5><strong>"U-CAN-FEEL" ONDERZOEK</strong></h5>
    <ul class='flow-text browser-default'>
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

dagboek_content = [
  {
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'Bent u ouder van een leerling van 15 of jonger of ben je zelf leerling (en minstens 16 jaar oud)?',
    options: [
      { title: 'Ouder van een leerling van 15 of jonger', shows_questions: %i[v2parent v3parent v4parent v5parent v6parent v7parent v8parent v9parent v10parent v11parent v12parent] },
      { title: 'Leerling van 16 of ouder', shows_questions: %i[v2child v3child v4child v5child v6child v7child v8child v9child v10child] }
    ]
  }, {
    id: :v2parent,
    hidden: true,
    type: :raw,
    content: ic_content_ouders
  }, {
    id: :v3parent,
    hidden: true,
    type: :radio,
    required: true,
    title: 'Toestemming voor deelname aan het onderzoek',
    options: [
      'Ja, ik geef toestemming voor deelname van mijn kind aan het onderzoek. Ik geef de onderzoekers ook toestemming om mijn kind te vragen over zijn/haar geloofsovertuiging en over zijn/haar gezondheid. Deze toestemming loopt tot 01-09-2023.',
      'Nee, ik geef geen toestemming voor deelname van mijn kind.'
    ],
    show_otherwise: false
  }, {
    id: :v4parent,
    hidden: true,
    type: :radio,
    required: true,
    title: 'Toestemming voor het ontvangen en koppelen van verzuimgegevens',
    options: [
      'Ja, ik geef toestemming aan de school om de verzuimgegevens van mijn kind te delen met de onderzoekers.',
      'Nee, ik geef geen toestemming voor het koppelen van verzuimgegevens.'
    ],
    show_otherwise: false
  }, {
    id: :v5parent,
    hidden: true,
    type: :radio,
    required: true,
    title: 'Toestemming voor de verwerking van mijn persoonsgegevens',
    options: [
      'Ja, ik geef toestemming voor de verwerking van de persoonsgegevens van mijn kind, zoals vermeld in de onderzoeksinformatie. Ik weet dat ik of mijn kind tot 01-09-2023 kan vragen om de gegevens van mijn kind te laten verwijderen, zoals uitgelegd in de informatiebrief. Ook als mijn kind besluit om te stoppen met deelname, kan ik of mijn kind hierom vragen.',
      'Nee, ik geef geen toestemming voor de verwerking van de persoonsgegevens van mijn kind.'
    ],
    show_otherwise: false
  }, {
    id: :v6parent,
    hidden: true,
    type: :textfield,
    title: 'Wat is uw naam?',
    required: true
  }, {
    id: :v7parent,
    hidden: true,
    type: :raw,
    content: '<p class="flow-text">Om contact op te kunnen nemen met uw kind voor het invullen van de vragenlijsten, hebben we de volgende informatie nodig. Wij gaan zorgvuldig met deze gegevens om en zullen die onder geen enkele omstandigheid met anderen delen.</p>'
  }, {
    id: :v8parent,
    hidden: true,
    type: :textfield,
    title: 'Mobiele telefoonnummer van uw kind',
    pattern: PHONE_REGEX,
    hint: 'Vul a.u.b. een geldig 06-nummer in.',
    required: true
  }, {
    id: :v9parent,
    hidden: true,
    type: :textfield,
    title: 'Emailadres van uw kind',
    pattern: EMAIL_REGEX,
    hint: 'Vul a.u.b. een geldig e-mailadres in.',
    required: true
  }, {
    id: :v10parent,
    hidden: true,
    type: :radio,
    required: true,
    title: 'Naar welke school gaat uw kind?',
    options: SCHOOLS,
    show_otherwise: true,
  }, {
    id: :v11parent,
    hidden: true,
    type: :textfield,
    required: true,
    title: 'In welke klas zit uw kind? We bedoelen de specifieke klas (bijvoorbeeld H3c), niet alleen het leerjaar',
  }, {
    id: :v12parent,
    hidden: true,
    type: :textfield,
    title: 'Wat is het leerlingnummer van uw kind?',
    required: true
  }, {
    id: :v2child,
    hidden: true,
    type: :raw,
    content: ic_content_16_plus
  }, {
    id: :v3child,
    hidden: true,
    type: :radio,
    required: true,
    title: 'Toestemming om mee te doen aan het onderzoek',
    options: [
      'Ja, ik geef toestemming om mee te doen aan het onderzoek. Ik geef de onderzoekers ook toestemming om mij te vragen over mijn geloofsovertuiging en over mijn gezondheid. Deze toestemming loopt tot 01-09-2023, tenzij ik besluit om eerder te stoppen. Ik geef ook toestemming voor het verwerken van mijn persoonsgegevens zoals uitgelegd in de informatiebrief.',
      'Nee, ik geef geen toestemming.'
    ],
    show_otherwise: false
  }, {
    id: :v4child,
    hidden: true,
    type: :radio,
    required: true,
    title: 'Toestemming voor het delen van verzuimgegevens',
    options: [
      'Ja, ik geef toestemming aan de school om mijn verzuimgegevens te delen met de onderzoekers.',
      'Nee, ik geef geen toestemming voor het delen van verzuimgegevens.'
    ],
    show_otherwise: false
  }, {
    id: :v5child,
    hidden: true,
    type: :raw,
    content: '<p class="flow-text">Om contact met je op te kunnen nemen voor het invullen van de vragenlijsten, hebben we de volgende informatie nodig. We gaan zorgvuldig met je gegevens om en zullen die nooit met anderen delen.</p>'
  }, {
    id: :v6child,
    hidden: true,
    type: :textfield,
    title: 'Wat is je mobiele telefoonnummer?',
    pattern: PHONE_REGEX,
    hint: 'Vul a.u.b. een geldig 06-nummer in.',
    required: true
  }, {
    id: :v7child,
    hidden: true,
    type: :textfield,
    title: 'Wat is je emailadres?',
    pattern: EMAIL_REGEX,
    hint: 'Vul a.u.b. een geldig e-mailadres in.',
    required: true
  }, {
    id: :v8child,
    hidden: true,
    type: :radio,
    required: true,
    title: 'Naar welke school ga je?',
    options: SCHOOLS,
    show_otherwise: true,
  }, {
    id: :v9child,
    hidden: true,
    type: :textfield,
    title: 'In welke klas zit je? We bedoelen de specifieke klas (bijvoorbeeld H3c), niet alleen het leerjaar',
    required: true,
  }, {
    id: :v10child,
    hidden: true,
    type: :textfield,
    title: 'Wat is je leerlingnummer?',
    required: true
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
