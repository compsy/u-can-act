# frozen_string_literal: true

ic_name1 = 'informed consent studenten 2x per week'
informed_consent1 = Questionnaire.find_by(name: ic_name1)
informed_consent1 ||= Questionnaire.new(name: ic_name1)
informed_consent1.key = File.basename(__FILE__)[0...-3]
ic_content = <<~'END'
  <p class="flow-text">Door op de knop 'volgende' te klikken ga je akkoord met onderstaande afspraken:</p>
  <p class="flow-text">Ik stem toe mee te doen aan het onderzoek naar ontwikkeling en begeleiding van studenten op het
    MBO.
    Dit onderzoek wordt uitgevoerd door onderzoekers van de Rijksuniversiteit Groningen en Umanise en is goedgekeurd
    door de Ethische Commissie Psychologie van de RuG.
  </p>
  <p class="flow-text">Ik ben me ervan bewust dat deelname aan dit onderzoek geheel vrijwillig is.
    Ik kan mijn medewerking op elk tijdstip stopzetten en de informatie verkregen uit dit onderzoek terugkrijgen of laten
    verwijderen uit de database.
  </p>
  <p class="flow-text">De volgende punten zijn mij duidelijk:</p>
  <ol class="flow-text">
    <li>Het doel van dit onderzoek is om meer inzicht te krijgen in ontwikkeling van jongeren en hoe begeleiding hierop
      inspeelt om zo het welzijn van jongeren te ondersteunen en voortijdig schoolverlaten te voorkomen.
    </li>
    <li>Deelname aan dit onderzoek betekent het volgende:
      <ol>
        <li>Ik zal elke week twee vragenlijsten invullen, voor drie weken in totaal. Deze vragenlijst duurt ongeveer drie
          minuten.
        </li>
        <li>Ik krijg twee keer per week een herinnering via sms op de dag dat ik de vragenlijst moet invullen. In de
          herinnering staat een link naar de vragenlijst.
        </li>
        <li>Bij het afronden van het onderzoek krijg ik een beloning van 7 euro. Afronden houdt in dat ik alle wekelijkse
          vragenlijsten (in totaal 6) en de afsluitende enquête invul binnen 24 uur na ontvangst van de sms.
        </li>
        <li>Ik geef toestemming voor het bewaren van persoonlijke gegevens: mijn naam en telefoonnummer. Deze vragen de
          onderzoekers aan mijn begeleider. Deze gegevens worden los van de onderzoeksgegevens opgeslagen (in een aparte
          database). De onderzoekers hebben dit nodig voor:
          <ol>
            <li>het versturen van herinneringen</li>
            <li>zodat de onderzoekers weten welke begeleider bij welke jongere hoort</li>
          </ol>
        </li>
        <li>Alle onderzoeksgegevens worden met grote voorzichtigheid behandeld. Al mijn antwoorden op de vragen worden
          anoniem opgeslagen. De onderzoekers rapporteren de onderzoeksresultaten zonder naam of andere identificerende
          informatie. Begeleiders, ouders of leraren komen daardoor nooit te weten welke antwoorden ik heb gegeven.
        </li>
      </ol>
    </li>
    <li>Voor vragen over het onderzoek kan er contact opgenomen worden met Nick Snell:
      <a href="mailto:n.r.snell@rug.nl">n.r.snell@rug.nl</a>.
    </li>
  </ol>
END
informed_consent1.content = { questions: [{
  type: :raw,
  content: ic_content
}], scores: [] }
informed_consent1.title = 'Informed consent pilot onderzoek naar ontwikkeling en begeleiding'
informed_consent1.save!
