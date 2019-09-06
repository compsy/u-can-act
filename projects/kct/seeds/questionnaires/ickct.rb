# frozen_string_literal: true

title = 'Q-IC-KCT '

name = 'KCT Q-IC'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

content = <<~'END'
  <p class="flow-text"><em>Geïnformeerde toestemming</em></p>
  <p class="flow-text">Door op de knop 'volgende' te klikken ga je akkoord met onderstaande afspraken:</p>
  <p class="flow-text">Ik stem toe mee te doen aan een onderzoek, dat uitgevoerd wordt door majoor M. Baatenburg de
  Jong, onder begeleiding van dr. R. den Hartigh. De procedure is getoetst en goed bevonden door de
  ethische commissie van de Afdeling Psyshcologie, Rijksuniversiteit Groningen.
  </p>

  <ol class="flow-text">
    <li>In verschillende blokken deze week wordt mij gevraagd om vragenlijsten online in te vullen en om safe houses te herkennen in bepaalde steden.</li>
    <li>Ik ben me ervan bewust dat deelname aan dit onderzoek geheel vrijwillig is. Ik kan mijn medewerking op elk tijdstip stopzetten. Daarnaast kan ik de gegevens die verkregen zijn uit dit onderzoek terugkrijgen, laten verwijderen uit de database of laten vernietigen.</li>
    <li>Mijn gegevens zullen vertrouwelijk worden behandeld. Mijn persoonsgegevens worden fysiek gescheiden van mijn antwoordgegevens.</li>
    <li>Mijn geanonimiseerde antwoordgegevens kunnen worden gebruikt voor wetenschappelijk onderzoek.</li>
    <li>De antwoorden op de vragen kunnen geen invloed hebben op mijn selectietraject en worden niet gebruikt in een andere context dan dit onderzoek.</li>
    <li>De onderzoeker zal verdere vragen over het onderzoek nu of gedurende het onderzoek beantwoorden. Vragen over het onderzoek kunnen ook achteraf gesteld worden, via 
      <a href="mailto:j.r.den.hartigh@rug.nl">j.r.den.hartigh@rug.nl</a>.
    </li>
  </ol>
END
questionnaire.content = [{
  type: :raw,
  content: content
}]
questionnaire.title = title
questionnaire.save!
