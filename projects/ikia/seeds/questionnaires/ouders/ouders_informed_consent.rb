# frozen_string_literal: true

db_title = 'Informatie over het Ieder Kind Is Anders onderzoek'
db_name1 = 'Informed_consent_ouders'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

ic_content = <<~'END'
<div class="informed-consent">
  <p><strong>Informatie over het Ieder Kind Is Anders onderzoek</strong></p>
  <p>
    Ieder Kind is Anders (IKIA) is een onderzoeksproject van de afdeling Ontwikkelingspsychologie van de Rijksuniversiteit Groningen. In het IKIA project proberen we antwoord te vinden op de vraag wat kinderen en jongeren gelukkig maakt. Is dit voor iedereen anders? En denken kinderen en jongeren hier hetzelfde over als hun ouders? Voor het IKIA onderzoek hebben we toestemming van de Ethische Commissie Psychologie (Psy-18269-O). 
  </p>
  <p>
    Meedoen aan IKIA is vrijwillig. Wel is uw toestemming nodig. Lees daarom deze informatie goed door.
    Vragen die u misschien heeft kunt u stellen via <a
    href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>,
    bijvoorbeeld wanneer u iets
    niet begrijpt. Als u besluit om geen toestemming te geven, dan hoeft u niet uit te leggen waarom, en zal dit geen negatieve gevolgen voor u hebben. U kunt uw toestemming  voor deelname aan het IKIA onderzoek ook op elk moment weer intrekken. 
  </p>
  <p><strong>Hoe gaat IKIA in zijn werk?</strong></p>
  <p>
    Het IKIA onderzoek zal de komende jaren plaatsvinden via deze website. U kunt inloggen op uw IKIA profiel wanneer u wilt en vragenlijsten invullen. Deze vragen gaan over emoties, geluk, vriendschap, de opvoeding, of ervaren klachten. Na iedere vragenlijst krijgt u uw resultaten te zien. U kunt hierna aan het volgende IKIA onderdeel werken of stoppen wanneer u dat wil, en het eventueel later weer oppakken. Hiernaast kunt u deelnemen aan een dagboekonderzoek, waarin u 30 dagen lang elke dag een vragenlijst via SMS ontvangt. Deze vragen gaan over emoties, gebeurtenissen van die dag en het contact tussen u en uw kind. 
  </p>
  <p><strong>Welke gevolgen kan deelname hebben?</strong></p>
  <p>
    Aan deelname aan het IKIA onderzoek zijn geen ongemakken of risico’s verbonden. Door deelname aan het IKIA onderzoek helpt u wetenschappelijk onderzoek naar kwetsbaarheid en veerkracht bij kinderen. Wij hebben veel deelnemers nodig voor de IKIA studie om goed te kunnen onderzoeken hoe kinderen van elkaar verschillen en hoe krachten en klachten samen voorkomen. De opgedane kennis wordt in de toekomst gedeeld met andere onderzoekers, scholen, leerkrachten en jeugdzorg.
  </p>
  <p><strong>Vertrouwelijkheid van gegevens</strong></p>
  <p>
    Voor het uitvoeren van het IKIA onderzoek is het noodzakelijk dat wij wat persoonlijke gegevens van u en uw kind verzamelen. Deze gegevens zullen met uiterste zorgvuldigheid en vertrouwelijkheid worden behandeld. Dit betreft leeftijd, geslacht, geboorteland, postcode en onderwijsvoortgang van uw kind. Ten slotte vragen we u om uw mobiele telefoonnummer wanneer u het dagboekonderzoek start. Dit telefoonnummer wordt alleen gebruikt om de dagboekvragenlijsten op te sturen. 
  </p>
  <p>  
  Uw gegevens zullen anoniem/gecodeerd worden verwerkt en persoonlijk identificeerbare gegevens van U of uw kind, zoals geboortedatum, zullen in een beveiligde computeromgeving worden bewaard, losgekoppeld van de antwoorden op de vragenlijsten. Uw volledig geanonimiseerde onderzoeksgegevens zullen gebruikt worden in wetenschappelijke publicaties, en langere tijd bewaard blijven om te helpen bij het beantwoorden van nieuwe onderzoeksvragen.
  </p>
  <p><strong>Wat moet u nog meer weten?</strong></p>
  <p>
    U kunt altijd vragen stellen over het IKIA onderzoek, ook tijdens uw verdere deelname of na afloop. Dit
    kan door ons een e-mail te sturen via <a href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>.
    Als u vragen of zorgen heeft over uw
    privacy en de omgang met uw persoonsgegevens dan kunt u contact opnemen met de Functionaris
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
      title: 'Ik kies ervoor deel te nemen aan het IKIA onderzoek. Ik heb de informatie over het onderzoek gelezen en mijn vragen kunnen stellen. Ik begrijp waar het onderzoek over gaat, en wat er van mij gevraagd wordt. Ik begrijp dat deelname vrijwillig is en dat ik op elk moment, zonder opgaaf van redenen, kan besluiten te stoppen. Ik begrijp dat deelname geen negatieve gevolgen zal hebben en dat er zorgvuldig met mijn gegevens wordt omgegaan. Ik geef hierbij toestemming voor het gebruik van mijn geanonimiseerde gegevens voor wetenschappelijk onderzoek en in de bijbehorende publicaties. Ik geef toestemming voor de verwerking van de persoonsgegevens zoals vermeld in de onderzoeksinformatie.'}
    ],
    show_otherwise: false
  }, {
    id: :v2,
    type: :checkbox,
    required: false,
    title: '',
    options: [{title: 'Ik geef hierbij toestemming om in de toekomst opnieuw benaderd te worden voor eventueel vervolgonderzoek. Ik kan dan opnieuw kiezen of ik deel wil nemen.'}],
      show_otherwise: false
      },{
    type: :raw,
    content: ic_footer
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
