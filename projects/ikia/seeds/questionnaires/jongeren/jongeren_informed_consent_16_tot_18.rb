# frozen_string_literal: true

db_title = 'Toestemmingsverklaring'
db_name1 = 'Informed_consent_jongeren_16_tot_18'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

ic_content = <<~'END'
  <div class="informed-consent">
    <p><strong>Over het onderzoek</strong></p>
    <p>
      Ieder Kind is Anders (IKIA) is een onderzoeksproject van de afdeling Ontwikkelingspsychologie van de
      Rijksuniversiteit Groningen. In het IKIA project proberen we antwoord te vinden op de vraag wat kinderen en jongeren
      gelukkig maakt. Is dit voor iedereen anders? En denken jongeren hier hetzelfde over als hun ouders? Voor het IKIA
      onderzoek hebben we toestemming van de Ethische Commissie Psychologie (Psy-18269-O).
    </p>
    <p>
      Meedoen aan IKIA is vrijwillig. Wel is jouw toestemming nodig. Lees daarom deze informatie goed door. Vragen die je
      misschien hebt kun je stellen via <a href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>,
      bijvoorbeeld als je iets niet begrijpt. Als je besluit
      om geen toestemming te geven voor je deelname dan hoeft je niet uit te leggen waarom, en zal dit geen negatieve
      gevolgen voor je hebben. Je kunt je toestemming voor deelname aan het IKIA onderzoek op elk moment weer intrekken.
    </p>
    <p><strong>Hoe werkt IKIA?</strong></p>
    <p>
      IKIA is een onderzoek dat de komende jaren plaats zal vinden via deze website. Op elk moment kun je inloggen op je
      IKIA profiel en hier vragen beantwoorden. Deze vragen gaan over emoties, geluk, vriendschap, opvoeding en klachten.
      Na iedere vragenlijst krijg je persoonlijke resultaten te zien. Je kunt hierna aan het volgende IKIA onderdeel
      werken, of stoppen en eventueel op een later moment met een nieuw onderdeel verdergaan. Ook kun je meedoen aan een
      dagboekonderzoek met je smartphone, waarbij je 30 dagen lang elke dag een korte vragenlijst via SMS krijgt
      opgestuurd. Ten slotte vragen we je wat achtergrondgegevens in te vullen zoals je leeftijd en schooljaar.
    </p>
    <p><strong>Welke gevolgen kan deelname hebben?</strong></p>
    <p>
      Aan deelname aan het IKIA onderzoek zijn geen ongemakken of risico’s verbonden. Door deelname aan het IKIA onderzoek
      help je mee om de wetenschappelijke kennis te vergroten over kwetsbaarheid en veerkracht bij jongeren. Wij hebben
      veel deelnemers nodig voor de IKIA studie om goed te kunnen onderzoeken hoe jongeren van elkaar verschillen en hoe
      krachten en klachten samen voorkomen. De opgedane kennis wordt in de toekomst gedeeld met andere onderzoekers,
      scholen, leerkrachten en jeugdzorg – alleen groepsgegevens, natuurlijk niet jouw individuele antwoorden.
    </p>
    <p><strong>Vertrouwelijkheid van gegevens</strong></p>
    <p>
      Voor het uitvoeren van het IKIA onderzoek is het noodzakelijk dat wij wat persoonlijke gegevens verzamelen die we
      met uiterste zorgvuldigheid en vertrouwelijkheid behandelen. Bijvoorbeeld jouw leeftijd, of je een jongen of een
      meisje bent en wat voor onderwijs je volgt. Ook vragen we je om je telefoonnummer als je wilt starten met het
      dagboekonderzoek. Dit telefoonnummer wordt alleen gebruikt om je de vragenlijsten per SMS op te sturen. Jouw
      geanonimiseerde onderzoeksgegevens zullen langere tijd bewaard blijven en helpen bij het beantwoorden van nieuwe
      onderzoeksvragen in wetenschappelijke publicaties. We kunnen ze ook delen met andere onderzoekers.
    </p>
    <p><strong>Wat moet je nog meer weten?</strong></p>
    <p>
      Je kunt altijd vragen stellen over het IKIA onderzoek, ook tijdens verdere deelname of na afloop. Dit kan door ons
      een e-mail te sturen via <a href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>. Als je vragen of
      zorgen hebt over je privacy en de omgang met je
      persoonsgegevens, dan kun je contact opnemen met de Functionaris Gegevensbescherming van de Rijksuniversiteit
      Groningen (<a href="mailto:privacy@rug.nl">privacy@rug.nl</a>). Dit mag ook
      via <a href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>. Als onderzoekdeelnemer heb je recht op
      een
      kopie van deze onderzoek informatie, en je kunt dit ook altijd nalezen bij
      de <a href="https://app.iederkindisanders.nl/jongeren/veelgestelde-vragen" rel="noreferrer noopener"
            target="_blank">veelgestelde vragen</a>.
    </p>
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
      'Ik kies ervoor deel te nemen aan het IKIA onderzoek. Ik heb de informatie voor deelnemers gelezen. Ik kon mijn vragen stellen en had genoeg tijd om te beslissen of ik meedoe. Ik weet dat deelname aan dit onderzoek geheel vrijwillig is en dat ik op elk moment kan stoppen. Daarvoor hoef ik geen reden te geven, en dit zal geen negatieve gevolgen voor mij hebben.<br />Ik geef hierbij toestemming dat mijn anonieme gegevens worden gebruikt in wetenschappelijk onderzoek en publicaties. Ik begrijp dat mijn anonieme onderzoeksgegevens lange tijd worden bewaard in een beveiligde computeromgeving en kunnen worden gedeeld met andere onderzoekers.'
    ],
    show_otherwise: false
  }, {
    id: :v2,
    type: :checkbox,
    required: false,
    title: '',
    options: ['(optioneel) Jullie mogen contact met me opnemen voor vervolgonderzoek waarna ik zelf zal bepalen of ik daaraan mee wil doen.'],
    show_otherwise: false
  }, {
    type: :raw,
    content: ic_footer
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
