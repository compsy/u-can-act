# frozen_string_literal: true

db_title = 'Toestemmingsverklaring'
db_name1 = 'Informed_consent_jongeren'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

ic_content = <<~'END'
<div class="informed-consent">
  <p><em>Beste deelnemer,</em></p>
  <p>
    Ieder Kind is Anders (IKIA) is een onderzoeksproject van de afdeling Ontwikkelingspsychologie van de
    Rijksuniversiteit Groningen. In het IKIA project proberen we antwoord te vinden op de vraag wat
    kinderen en jongeren gelukkig maakt. Is dit voor iedereen anders? En denken jongeren hier hetzelfde
    over als hun ouders? Voor de start van het IKIA onderzoek hebben we toestemming gevraagd en
    gekregen van de Ethische Commissie Psychologie (Psy-18269-O).
  </p>
  <p>
    Meedoen aan IKIA is vrijwillig. Wel is jouw toestemming nodig. Lees daarom deze informatie goed door.
    Vragen die je misschien hebt kun je stellen via <a
    href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>,
    bijvoorbeeld als je iets niet begrijpt. Besluit hierna of je mee wilt doen.
    Als je besluit om geen toestemming te geven voor je deelname dan hoeft je niet uit te leggen waarom, en
    zal dit geen negatieve gevolgen voor je hebben. Je kunt je toestemming voor deelname aan het IKIA onderzoek
    op elk moment weer intrekken.
  </p>
  <p><strong>Hoe werkt IKIA?</strong></p>
  <p>
    IKIA is een onderzoek dat komende jaren plaats zal vinden door gebruik te maken deze website. Op elk
    moment kun je inloggen op je IKIA profiel en hier vragen beantwoorden. Deze vragen gaan over
    emoties, geluk, vriendschap, opvoeding en klachten. Ook vragen we je wat achtergrondgegevens in te
    vullen zoals je leeftijd en schooljaar. Na iedere vragenlijst krijg je persoonlijke resultaten te zien. Je kunt
    hierna aan het volgende IKIA onderdeel werken, maar je kunt ook op een later moment met een nieuw
    onderdeel verdergaan.
  </p>
  <p><strong>Welke gevolgen kan deelname hebben?</strong></p>
  <p>
    Aan deelname aan het IKIA onderzoek zijn geen ongemakken of risico’s verbonden. Door deelname aan
    het IKIA onderzoek help je mee om de wetenschappelijke kennis te vergroten over kwetsbaarheid en
    veerkracht bij jongeren. Wij hebben veel deelnemers nodig voor de IKIA studie om goed te kunnen
    onderzoeken hoe jongeren van elkaar verschillen en hoe krachten en klachten samen voorkomen. De
    opgedane kennis wordt in de toekomst gedeeld met andere onderzoekers, scholen, leerkrachten en
    jeugdzorg – alleen groepsgegevens, natuurlijk niet jouw individuele antwoorden.
  </p>
  <p><strong>Vertrouwelijkheid van gegevens</strong></p>
  <p>
    Voor het uitvoeren van het IKIA onderzoek is het noodzakelijk dat wij wat persoonlijke gegevens
    verzamelen die we met uiterste zorgvuldigheid en vertrouwelijkheid behandelen. Bijvoorbeeld jouw
    leeftijd, of je een jongen of een meisje bent en wat voor onderwijs je volgt. Jouw geanonimiseerde
    onderzoeksgegevens zullen langere tijd bewaard blijven en helpen bij het beantwoorden van nieuwe
    onderzoeksvragen in wetenschappelijke publicaties. We kunnen ze ook delen met andere onderzoekers.
  </p>
  <p><strong>Wat moet je nog meer weten?</strong></p>
  <p>
    Je kunt altijd vragen stellen over het IKIA onderzoek, ook tijdens verdere deelname of na afloop. Dit kan
    door ons een e-mail te sturen via <a href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>.
    Als je vragen of zorgen hebt over je privacy en de omgang met je persoonsgegevens, dan kun je contact
    opnemen met de Functionaris Gegevensbescherming van de Rijksuniversiteit Groningen
    (<a href="mailto:privacy@rug.nl">privacy@rug.nl</a>).
    Dit mag ook via <a href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>.
    Als onderzoekdeelnemer heb je recht op een kopie van deze onderzoek
    informatie, en je kunt dit ook altijd nalezen bij
    de <a href="https://app.iederkindisanders.nl/jongeren/veelgestelde-vragen" rel="noreferrer noopener"
          target="_blank">veelgestelde vragen</a>.
  </p>
  <p><strong>Geïnformeerde Toestemming</strong></p>
  <p>Ieder Kind is Anders (Psy-18269-O)</p>
  <ul>
    <li>
      Ik heb de informatie over het onderzoek gelezen. Ik heb genoeg gelegenheid gehad om er
      vragen over te stellen.
    </li>
    <li>
      Ik begrijp waar het onderzoek over gaat, wat er van mij gevraagd wordt, dat mijn gegevens
      zullen worden bewaard en op welke manier deze worden bewaard, en wat mijn rechten zijn.
    </li>
    <li>
      Ik begrijp dat deelname aan het onderzoek vrijwillig is. Ik kies er zelf voor om mee te doen. Ik
      kan op elk moment, zonder opgaaf van redenen, besluiten om niet (verder) deel te nemen aan
      het IKIA onderzoek. Als ik stop, hoef ik niet uit te leggen waarom, en stoppen zal geen gevolgen
      hebben.
    </li>
    <li>
      Ik geef hierbij toestemming voor het gebruik van mijn geanonimiseerde gegevens voor
      wetenschappelijk onderzoek en in de bijbehorende wetenschappelijke publicaties. Ik geef
      toestemming voor de verwerking van de persoonsgegevens zoals vermeld in de
      onderzoeksinformatie. Ik begrijp dat deze gegevens anoniem/gecodeerd worden verwerkt en
      dat persoonlijk identificeerbare gegevens, zoals e-mailadres en geboortedatum, in een
      beveiligde computeromgeving worden bewaard, losgekoppeld van de antwoorden op de
      vragenlijsten. Ik begrijp dat deze geanonimiseerde onderzoeksgegevens lange tijd bewaard
      zullen blijven en helpen bij het beantwoorden van nieuwe onderzoeksvragen.
    </li>
    <li>
      Ik geef toestemming dat ik in de toekomst opnieuw benaderd mag worden voor eventueel
      vervolgonderzoek.
    </li>
  </ul>
</div>
END

ic_footer = <<~'END'
  <p class="flow-text">Je hebt recht op een kopie van dit toestemmingsformulier.</p>
  <p class="flow-text">Bij voorbaat dank voor je deelname. Namens het onderzoeksteam,<br />
    Anne Margit Reitsema, Bertus Jeronimus, Vera Heininga, Marijn van Dijk, en Peter de Jonge.
  </p>
END

dagboek_content = [
  {
    type: :raw,
    content: ic_content
  }, {
    id: :v1,
    type: :checkbox,
    required: true,
    title: '',
    options: [
      'Ik verklaar dat bovenstaande informatie mij duidelijk is en ga hiermee akkoord.'
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
