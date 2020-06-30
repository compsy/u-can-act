# frozen_string_literal: true

ic_name = 'informed consent studenten'
informed_consent = Questionnaire.find_by(name: ic_name)
informed_consent ||= Questionnaire.new(name: ic_name)
informed_consent.key = File.basename(__FILE__)[0...-3]
ic_content = <<~'END'
  <p class="flow-text"><em>Onderzoek naar ontwikkeling en begeleiding</em></p>
  <style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; height: auto; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'><iframe src='https://player.vimeo.com/video/241526116?title=0&amp;byline=0&amp;portrait=0&amp;color=009a74' frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe></div>
  <p class="flow-text">Door op de knop 'volgende' te klikken ga je akkoord met onderstaande afspraken:</p>
  <p class="flow-text">Ik stem toe mee te doen aan het onderzoek naar ontwikkeling en begeleiding van studenten op het MBO. Dit onderzoek wordt uitgevoerd door onderzoekers van de Rijksuniversiteit Groningen en is goedgekeurd door de Ethische Commissie Psychologie van de RuG.
  </p>
  <p class="flow-text">Ik ben me ervan bewust dat deelname aan dit onderzoek geheel vrijwillig is. Ik kan mijn medewerking op elk tijdstip stopzetten en de informatie verkregen uit dit onderzoek terugkrijgen of laten verwijderen uit de database.
  </p>
  <p class="flow-text">De volgende punten zijn mij duidelijk:</p>
  <ol class="flow-text">
    <li>Het doel van dit onderzoek is om meer inzicht te krijgen in ontwikkeling van jongeren en hoe begeleiding hierop inspeelt om zo het welzijn van jongeren te ondersteunen en voortijdig schoolverlaten te voorkomen.
    </li>
    <li>Deelname aan dit onderzoek betekent het volgende:
      <ol>
        <li>Ik zal elke week één vragenlijst invullen, voor 30 weken in totaal. Deze vragenlijst duurt ongeveer twee minuten.
        </li>
        <li>Ik krijg elke week een herinnering via sms op de dag dat ik de vragenlijst moet invullen.
          In de herinnering staat een link naar de vragenlijst.
        </li>
        <li>Per ingevulde vragenlijst krijg ik een beloning van twee euro. Ik kan een bonus-streak krijgen wanneer ik drie of meer weken achter elkaar een vragenlijst heb ingevuld. Vanaf dan, en voor zolang ik geen week oversla, krijg ik per ingevulde vragenlijst een bonus-euro. De beloning in een bonus-streak is dus drie euro per vragenlijst. Het bedrag dat ik uiteindelijk verdien hangt af van hoeveel ik achter elkaar invul, en dit wordt per persoon achteraf berekend door de onderzoekers (deze berekening is leidend voor het vaststellen van het definitieve bedrag). De maximaal haalbare beloning na het afronden van het onderzoek is 88 euro. Afronden houdt in dat ik alle wekelijkse vragenlijsten (in totaal 30), de startvragenlijst en de afsluitende enquête invul. Voor het invullen van de wekelijkse vragenlijst heb ik telkens 30 uur de tijd.
        </li>
        <li>Ik geef toestemming voor het apart bewaren van persoonlijke gegevens: mijn naam en telefoonnummer. Deze vragen de onderzoekers aan mijn begeleider. Deze gegevens worden los van de onderzoeksgegevens opgeslagen (in een aparte beveiligde database). De onderzoekers hebben dit nodig voor:
          <ol>
            <li>het versturen van herinneringen</li>
            <li>zodat de onderzoekers weten welke begeleider bij welke jongere hoort</li>
          </ol>
        </li>
        <li>Alle onderzoeksgegevens worden naar strikte ethische richtlijnen en met grote voorzichtigheid behandeld. Al mijn antwoorden op de vragen worden anoniem opgeslagen. De onderzoekers rapporteren de onderzoeksresultaten zonder naam of andere identificerende informatie: begeleiders, ouders of leraren komen nooit te weten welke antwoorden ik heb gegeven.
        </li>
        <li>Het enige dat mijn begeleider kan zien, is of ik de vragenlijst wel of niet ingevuld heb. Dit is omdat het best lastig kan zijn om het onderzoek zo lang vol te houden, en een begeleider kan helpen met herinneren. De onderzoekers hebben namelijk alleen wat aan de onderzoeksgegevens als begeleider én jongere allebei vragenlijsten invullen.
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
informed_consent.content = { questions: [{
  type: :raw,
  content: ic_content
}], scores: [] }
informed_consent.title = 'u-can-act'
informed_consent.save!
