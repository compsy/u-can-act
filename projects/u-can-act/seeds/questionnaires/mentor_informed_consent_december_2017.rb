# frozen_string_literal: true

ic_name1 = 'informed consent mentoren december 2017'
informed_consent1 = Questionnaire.find_by(name: ic_name1)
informed_consent1 ||= Questionnaire.new(name: ic_name1)
informed_consent1.key = File.basename(__FILE__)[0...-3]
ic_content = <<~'END'
  <p class="flow-text"><em>Onderzoek naar ontwikkeling en begeleiding</em></p>
  <p class="flow-text">Door op de knop 'volgende' te klikken ga je akkoord met onderstaande afspraken:</p>
  <p class="flow-text">Ik stem toe mee te doen aan het onderzoek naar ontwikkeling en begeleiding van studenten op het MBO. Dit onderzoek wordt uitgevoerd door onderzoekers van de Rijksuniversiteit Groningen en is goedgekeurd door de Ethische Commissie Psychologie van de RuG.
  </p>
  <p class="flow-text">Ik ben me ervan bewust dat deelname aan dit onderzoek geheel vrijwillig is. Ik kan mijn medewerking op elk tijdstip stopzetten en de informatie verkregen uit dit onderzoek terugkrijgen of laten verwijderen uit de database.
  </p>
  <p class="flow-text">De volgende punten zijn mij duidelijk:</p>
  <ol class="flow-text">
    <li>Het doel van dit onderzoek is om meer inzicht te krijgen in ontwikkeling van jongeren en hoe begeleiding hierop
      inspeelt om zo het welzijn van jongeren te ondersteunen en voortijdig schoolverlaten te voorkomen.
    </li>
    <li>Deelname aan dit onderzoek betekent het volgende:
      <ol>
        <li>Ik zal elke week voor iedere jongere die ik begeleid en tevens mee doet aan dit onderzoek één vragenlijst invullen, tot en met de maand juli of totdat al mijn jongeren zomervakantie hebben. Deze vragenlijst duurt per jongere ongeveer twee minuten.
        </li>
        <li>Ik krijg elke week een herinnering via sms op de dag dat ik de vragenlijst moet invullen. In de herinnering staat een link naar de vragenlijst.
        </li>
        <li>Ik geef toestemming voor het bewaren van persoonlijke gegevens: mijn naam, telefoonnummer, en e-mailadres. Deze vragen de onderzoekers aan mij of mijn leidinggevende. Deze gegevens worden los van de onderzoeksgegevens opgeslagen (in een aparte database). De onderzoekers hebben dit nodig voor:
          <ol>
            <li>het versturen van herinneringen</li>
            <li>zodat de onderzoekers weten welke begeleider bij welke jongere hoort</li>
          </ol>
        </li>
        <li>Alle onderzoeksgegevens worden naar strikte ethische richtlijnen en met grote voorzichtigheid behandeld. Al mijn antwoorden op de vragen worden anoniem opgeslagen, en dit geldt ook voor de antwoorden van de jongeren die ik begeleid (die kan ik dan ook niet inzien). De onderzoekers rapporteren de onderzoeksresultaten zonder naam of andere identificerende informatie. Mijn leerlingen, projectleiders, andere teamcaptains, leraren etc. komen daardoor nooit te weten welke antwoorden ik heb gegeven.
        </li>
        <li>Het enige dat ik als begeleider wel kan zien, is of de jongeren die ik begeleid de vragenlijst wel of niet ingevuld hebben. Dit is omdat het best lastig kan zijn voor jongeren om het onderzoek zo lang vol te houden, en een begeleider kan helpen met herinneren. De onderzoekers hebben namelijk alleen wat aan de onderzoeksgegevens als begeleider én jongere allebei vragenlijsten invullen.
        </li>
        <li>De onderzoekers gebruiken cookies bij de webapp om te zien hoeveel mensen op de website van de webapp komen en hoe zij de webapp gebruiken. Deze cookies bevatten geen persoonsgegevens, en volgen me niet naar andere websites.
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
informed_consent1.title = 'u-can-act'
informed_consent1.save!
