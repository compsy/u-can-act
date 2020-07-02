# frozen_string_literal: true

ic_name = 'informed consent studenten controle januari 2018'
informed_consent = Questionnaire.find_by(name: ic_name)
informed_consent ||= Questionnaire.new(name: ic_name)
informed_consent.key = File.basename(__FILE__)[0...-3]
ic_content = <<~'END'
  <p class="flow-text"><em>Onderzoek naar ontwikkeling en begeleiding</em></p>
  <p class="flow-text">Door op de knop 'volgende' te klikken ga je akkoord met onderstaande afspraken:</p>
  <p class="flow-text">Ik stem toe mee te doen aan het onderzoek naar ontwikkeling en begeleiding van studenten op het MBO. Dit onderzoek wordt uitgevoerd door onderzoekers van de Rijksuniversiteit Groningen en is goedgekeurd door de Ethische Commissie Psychologie van de RuG.</p>
  <p class="flow-text">Ik ben me ervan bewust dat deelname aan dit onderzoek geheel vrijwillig is. Ik kan mijn medewerking op elk tijdstip stopzetten en de informatie verkregen uit dit onderzoek terugkrijgen of laten verwijderen uit de database.</p>
  <p class="flow-text">De volgende punten zijn mij duidelijk:</p>
  <ol class="flow-text">
    <li>Het doel van dit onderzoek is om meer inzicht te krijgen in ontwikkeling van jongeren en hoe begeleiding hierop inspeelt om zo het welzijn van jongeren te ondersteunen en voortijdig schoolverlaten te voorkomen.</li>
    <li>Deelname aan dit onderzoek betekent het volgende:
      <ol>
        <li>Ik zal elke week één vragenlijst invullen, tot en met de maand juli of totdat ik zomervakantie heb. Deze vragenlijst duurt ongeveer twee minuten.</li>
        <li>Ik krijg elke week een herinnering via sms op de dag dat ik de vragenlijst moet invullen. In de herinnering staat een link naar de vragenlijst.</li>
        <li>Per ingevulde vragenlijst krijg ik een beloning van twee euro. Ik kan een bonus-streak krijgen wanneer ik drie of meer weken achter elkaar een vragenlijst heb ingevuld. Vanaf dan, en voor zolang ik geen week oversla, krijg ik per ingevulde vragenlijst een bonus-euro. De beloning in een bonus-streak is dus drie euro per vragenlijst. Het bedrag dat ik uiteindelijk verdien hangt af van de duur van het onderzoek en van hoeveel vragenlijsten ik achter elkaar invul. Het onderzoek loopt tot en met juli 2018, of totdat ik schoolvakantie heb. De hoogte van de beloning wordt per persoon achteraf berekend door de onderzoekers (deze berekening is leidend voor het vaststellen van het definitieve bedrag). Om aanspraak te maken op deze beloning moet ik het onderzoek afronden. Afronden houdt in dat ik alle wekelijkse vragenlijsten, de startvragenlijst en de afsluitende enquête invul. Voor het invullen van de wekelijkse vragenlijst heb ik telkens 30 uur de tijd.</li>
        <li>Ik geef toestemming voor het apart bewaren van persoonlijke gegevens: mijn naam en telefoonnummer. Deze gegevens worden los van de onderzoeksgegevens opgeslagen (in een aparte beveiligde database). De onderzoekers hebben dit nodig voor het versturen van herinneringen</li>
        <li>Alle onderzoeksgegevens worden naar strikte ethische richtlijnen en met grote voorzichtigheid behandeld. Al mijn antwoorden op de vragen worden anoniem opgeslagen. De onderzoekers rapporteren de onderzoeksresultaten zonder naam of andere identificerende informatie: ouders of leraren komen nooit te weten welke antwoorden ik heb gegeven.</li>
        <li>De onderzoekers gebruiken cookies bij de webapp om te zien hoeveel mensen op de website van de webapp komen en hoe zij de webapp gebruiken. Deze cookies bevatten geen persoonsgegevens, en volgen me niet naar andere websites.</li>
      </ol>
    </li>
    <li>Voor vragen over het onderzoek kan er contact opgenomen worden met Nick Snell:
      <a href="mailto:n.r.snell@rug.nl">n.r.snell@rug.nl</a>.
    </li>
  </ol>
END
informed_consent.content = { questions: [{
  type: :raw,
  content: ic_content
}], scores: [] }
informed_consent.title = 'u-can-act'
informed_consent.save!
