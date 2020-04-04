# frozen_string_literal: true

db_title = 'Informatie over het Ieder Kind Is Anders onderzoek'
db_name1 = 'Informed_consent_ouders'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

ic_content = <<~'END'
<div class="informed-consent">
  <p><em>Beste ouder(s) of verzorger(s),</em></p>
  <p>
    Ieder Kind is Anders (IKIA) is een onderzoeksproject van de afdeling Ontwikkelingspsychologie van de
    Rijksuniversiteit Groningen. In het IKIA project proberen we antwoord te vinden op de vraag wat
    kinderen en jongeren gelukkig maakt. Is dit voor iedereen anders? En denken kinderen en jongeren hier
    hetzelfde over als hun ouders?
  </p>
  <p>
    Zowel kinderen als hun ouder(s) of verzorger(s) die de Nederlandse taal machtig zijn kunnen bijdragen
    aan IKIA. Voor de start van het IKIA onderzoek hebben we toestemming gevraagd en gekregen van de
    Ethische Commissie Psychologie (Psy-18269-O).
  </p>
  <p>
    Meedoen aan IKIA is vrijwillig. Wel is uw toestemming nodig. Lees daarom deze informatie goed door.
    Vragen die u misschien heeft kunt u stellen via <a
    href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>,
    bijvoorbeeld wanneer u iets
    niet begrijpt. Besluit hierna of u wilt meedoen en of u uw kind toestemming geeft om mee te doen. Als u
    besluit om geen toestemming te geven voor uw eigen deelname of voor uw kind, dan hoeft u niet uit te
    leggen waarom, en zal dit geen negatieve gevolgen voor u hebben. U heeft ook nadat u toestemming
    geeft voor uw deelname of de deelname van uw kind aan het IKIA onderzoek op elk moment het recht
    om deze weer in te trekken.
  </p>
  <p><strong>Hoe gaat IKIA in zijn werk?</strong></p>
  <p>
    IKIA is een onderzoek dat de komende jaren plaats zal vinden via deze website. Op elk gewenst moment
    kunt u inloggen op uw IKIA profiel, of uw kind op zijn/haar eigen IKIA profiel, en hier vragen
    beantwoorden. Deze vragen gaan over emoties, geluk, vriendschap, de opvoeding, of ervaren klachten.
    Ook vragen we u en/of uw kind wat achtergrond gegevens in te vullen, waaronder geboortemaand en
    jaar, geboorteland, en opleidingsniveau. Na iedere vragenlijst krijgt u of uw kind persoonlijke resultaten
    te zien. Het staat u vrij om hierna aan het volgende IKIA onderdeel te werken, maar u kunt altijd stoppen
    wanneer u dat wil. En het later eventueel weer oppakken.
  </p>
  <p><strong>Welke gevolgen kan deelname hebben?</strong></p>
  <p>
    Aan deelname aan het IKIA onderzoek zijn geen ongemakken of risico’s verbonden voor u of uw kind.
    Door deelname aan het IKIA onderzoek dragen u en uw kind bij aan de uitbreiding van
    wetenschappelijke kennis op het gebied van kwetsbaarheid en veerkracht bij kinderen. Wij hebben veel
    deelnemers nodig voor de IKIA studie om goed te kunnen onderzoeken hoe kinderen van elkaar
    verschillen en hoe krachten en klachten samen voorkomen. De opgedane kennis wordt in de toekomst
    gedeeld met andere onderzoekers, scholen, leerkrachten, en jeugdzorg.
  </p>
  <p><strong>Vertrouwelijkheid van gegevens</strong></p>
  <p>
    Voor het uitvoeren van het IKIA onderzoek is het noodzakelijk dat wij wat persoonlijke gegevens van u
    en uw kind verzamelen. Deze gegevens zullen met uiterste zorgvuldigheid en vertrouwelijkheid worden
    behandeld. Dit betreft de leeftijd, het geslacht, en onderwijsvoortgang van uw kind.
    Onderzoeksresultaten worden volledig geanonimiseerd gebruikt in wetenschappelijke publicaties. Uw
    geanonimiseerde onderzoeksgegevens zullen langere tijd bewaard blijven en helpen bij het
    beantwoorden van nieuwe onderzoeksvragen.
  </p>
  <p><strong>Wat moet u nog meer weten?</strong></p>
  <p>
    U kunt altijd vragen stellen over het IKIA onderzoek ook tijdens uw verdere deelname of na afloop. Dit
    kan door ons een e-mail te sturen via <a href="mailto:iederkindisanders@rug.nl">iederkindisanders@rug.nl</a>.
    Als u vragen of zorgen heeft over uw
    privacy en de omgang met uw persoonsgegevens dan kunt u contact opnemen met de Functionaris
    Gegevensbescherming van de Rijksuniversiteit Groningen (<a href="mailto:privacy@rug.nl">privacy@rug.nl</a>).
    Als onderzoekdeelnemer heeft u recht op een kopie van deze onderzoek informatie.
  </p>
  <p><strong>Geïnformeerde Toestemming Ouders</strong></p>
  <p>
    Ieder Kind is Anders (Psy-18269-O)
  </p>
  <ul>
    <li>Ik heb de informatie over het onderzoek gelezen. Ik heb genoeg gelegenheid gehad om er
      vragen over te stellen.
    </li>
    <li>Ik begrijp waar het onderzoek over gaat, wat er van mij en/of mijn kind gevraagd wordt, welke
      gevolgen deelname kan hebben, hoe er met de gegevens wordt omgegaan, en wat onze rechten
      zijn.
    </li>
    <li>Ik begrijp dat deelname aan het onderzoek vrijwillig is. Ik kies er zelf voor om mijn kind mee te
      laten doen. Ik en mijn kind kunnen op elk moment, zonder opgaaf van redenen, besluiten niet
      (verder) deel te nemen aan het IKIA onderzoek. Als wij stoppen, hoeven we niet uit te leggen
      waarom. Stoppen zal geen gevolgen hebben.
    </li>
    <li>Ik geef hierbij mijn kind toestemming om mee te doen aan het IKIA onderzoek. Mijn kind mag
      meedoen zolang het onderzoek loopt of dat ik hier op terug kom. Mijn kind mag via het IKIA
      website vragenlijsten invullen en deze gegevens mogen worden gebruikt voor wetenschappelijk
      onderzoek.
    </li>
    <li>Ik geef hierbij toestemming voor het gebruik van onze geanonimiseerde gegevens voor
      wetenschappelijk onderzoek en in de bijbehorende wetenschappelijke publicaties. Ik geef
      toestemming voor de verwerking van de persoonsgegevens zoals vermeld in de
      onderzoeksinformatie. Ik begrijp dat deze gegevens anoniem/gecodeerd worden verwerkt en
      dat persoonlijk identificeerbare gegevens van mijn kind, zoals het e-mailadres en de
      geboortedatum, in een beveiligde computeromgeving worden bewaard, losgekoppeld van de
      antwoorden op de vragenlijsten. Ik begrijp dat deze geanonimiseerde onderzoeksgegevens
      lange tijd bewaard zullen blijven en helpen bij het beantwoorden van nieuwe
      onderzoeksvragen.
    </li>
    <li>Door het aanvinken van deze verklaring geef ik mijn kind toestemming
      voor deelname aan het IKIA onderzoek.
    </li>
    <li>Ik geef toestemming dat ik of mijn kind in de toekomst opnieuw benaderd mogen worden voor
      eventueel vervolgonderzoek.
    </li>
  </ul>
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
