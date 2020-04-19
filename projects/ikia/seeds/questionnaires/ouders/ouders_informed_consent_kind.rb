# frozen_string_literal: true

db_title = 'Informatie over deelname van uw kind aan Ieder Kind Is Anders'
db_name1 = 'Informed_consent_ouders_kind'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

ic_content = <<~'END'
  <div class="informed-consent">
    <p>
      Ieder Kind is Anders (IKIA) is een onderzoeksproject van de afdeling Ontwikkelingspsychologie van de Rijksuniversiteit Groningen. In het IKIA project proberen we antwoord te vinden op de vraag wat kinderen en jongeren gelukkig maakt. Is dit voor iedereen anders? En denken kinderen en jongeren hier hetzelfde over als hun ouders? Voor het IKIA onderzoek hebben we toestemming van de Ethische Commissie Psychologie (Psy-18269-O).
    </p>
    <p>
     Meedoen aan IKIA is vrijwillig. Wel is uw toestemming nodig voor deelname van uw kind als hij/zij jonger dan 16 jaar is. Lees daarom deze informatie goed door.
      Vragen die u misschien heeft kunt u stellen via <a
      href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>,
      bijvoorbeeld wanneer u iets
      niet begrijpt. Als u besluit om geen toestemming te geven, dan hoeft u niet uit te leggen waarom, en heeft dit geen negatieve gevolgen. U kunt uw toestemming voor de deelname van uw kind op elk moment weer intrekken.
    </p>
    <p><strong>Hoe gaat IKIA in zijn werk?</strong></p>
    <p>
      Het IKIA onderzoek zal de komende jaren plaatsvinden via deze website. Op elk gewenst moment kan uw kind inloggen op zijn/haar eigen IKIA profiel en hier vragen beantwoorden. Deze vragen gaan over emoties, geluk, vriendschap, de opvoeding, of ervaren klachten. Na iedere vragenlijst krijgt uw kind persoonlijke resultaten te zien. Hiernaast kan uw kind deelnemen aan een dagboekonderzoek, waarin hij/zij 30 dagen lang elke dag een vragenlijst via SMS ontvangt. Deze vragen gaan over emoties, gebeurtenissen van die dag en het contact tussen uw kind en u.
    </p>
    <p><strong>Welke gevolgen kan deelname hebben?</strong></p>
    <p>
      Aan deelname aan het IKIA onderzoek zijn geen ongemakken of risico’s verbonden voor uw kind. Door deelname aan het IKIA onderzoek helpt uw kind mee aan wetenschappelijk onderzoek naar kwetsbaarheid en veerkracht bij kinderen. Wij hebben veel deelnemers nodig voor de IKIA studie om goed te kunnen onderzoeken hoe kinderen van elkaar verschillen en hoe krachten en klachten samen voorkomen. De opgedane kennis wordt in de toekomst gedeeld met andere onderzoekers, scholen, leerkrachten en jeugdzorg.
    </p>
    <p><strong>Vertrouwelijkheid van gegevens</strong></p>
    <p>
      Voor het uitvoeren van het IKIA onderzoek is het noodzakelijk dat wij enkele persoonlijke gegevens verzamelen. Dit betreft leeftijd, geslacht, geboorteland en postcode. Deze gegevens zullen met uiterste zorgvuldigheid en vertrouwelijkheid worden behandeld. Hiernaast vragen we u om het emailadres van uw kind zodat we hem/haar een registratielink kunnen sturen. Ten slotte vragen we uw kind om zijn/haar mobiele telefoonnummer wanneer hij/zij het dagboekonderzoek start. Dit telefoonnummer wordt alleen gebruikt om de dagboekvragenlijsten op te sturen.
    </p>
    <p>
      Gegevens van uw kind zullen anoniem/gecodeerd worden verwerkt. Persoonlijk identificeerbare gegevens van uw kind, zoals het e-mailadres en de geboortedatum, zullen in een beveiligde computeromgeving worden bewaard, losgekoppeld van de antwoorden op de vragenlijsten. Deze volledig geanonimiseerde onderzoeksgegevens zullen gebruikt worden in wetenschappelijke publicaties, en langere tijd bewaard blijven om te helpen bij het beantwoorden van nieuwe onderzoeksvragen.
      </p>
    <p><strong>Wat moet u nog meer weten?</strong></p>
    <p>
      U of uw kind kan altijd vragen stellen over het IKIA onderzoek, ook tijdens verdere deelname of na afloop. Dit
      kan door ons een e-mail te sturen via <a href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>.
      Als u vragen of zorgen heeft over de
      privacy van uzelf of uw kind en de omgang met persoonsgegevens dan kunt u contact opnemen met de Functionaris
      Gegevensbescherming van de Rijksuniversiteit Groningen (<a href="mailto:privacy@rug.nl">privacy@rug.nl</a>).
      Als onderzoekdeelnemer heeft u recht op een kopie van deze onderzoek informatie. U kunt de informatie hier {link naar FAQ} terugvinden.
    </p>
  </div>
END

ic_footer = <<~'END'
  <p class="flow-text">U heeft recht op een kopie van dit toestemmingsformulier.</p>
  <p class="flow-text">Bij voorbaat dank voor uw deelname. Namens het onderzoeksteam,<br />
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
    title: 'Geïnformeerde Toestemming Ouders <br> Ieder Kind is Anders (Psy-18269-O)',
    options: [{
                title: 'Ik geef hierbij toestemming dat mijn minderjarige kind deelneemt aan het IKIA onderzoek. Ik heb de informatie over het onderzoek gelezen en mijn vragen kunnen stellen. Ik begrijp waar het onderzoek over gaat en wat er van mijn kind gevraagd wordt. Ik begrijp dat deelname vrijwillig is en dat ik op elk moment, zonder opgaaf van redenen, kan besluiten mijn toestemming weer in te trekken. Ik begrijp dat deelname geen negatieve gevolgen zal hebben en dat er zorgvuldig met de gegevens van mijn kind wordt omgegaan. <br>
Ik geef hierbij toestemming voor het gebruik van de geanonimiseerde gegevens van mijn kind voor wetenschappelijk onderzoek en in de bijbehorende publicaties. Ik geef toestemming voor de verwerking van de persoonsgegevens zoals vermeld in de onderzoeksinformatie.'
              }],
    show_otherwise: false
  }, {
    id: :v2,
    type: :checkbox,
    required: false,
    title: '',
    options: [{ title: '(optioneel) Jullie mogen contact met mij opnemen voor vervolgonderzoek waarna ik zelf zal bepalen of mijn kind daaraan mee mag doen.' }],
    show_otherwise: false
  }, {
    type: :raw,
    content: ic_footer
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
