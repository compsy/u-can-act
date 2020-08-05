# frozen_string_literal: true

ic_name1 = 'evaluatieonderzoek informed consent'
informed_consent1 = Questionnaire.find_by(name: ic_name1)
informed_consent1 ||= Questionnaire.new(name: ic_name1)
informed_consent1.key = File.basename(__FILE__)[0...-3]
ic_content = <<~'END'
  <p class="flow-text"><em>Beste onderzoeksdeelnemer,</em></p>
  <p class="flow-text">Hartelijk dank voor uw deelname aan dit <strong>evaluatieonderzoek naar de aanpak van voortijdig schoolverlaten en jongeren in een kwetsbare positie</strong>. In 2016 zijn er nieuwe beleidsafspraken gemaakt over de aanpak van voortijdig schoolverlaten en jongeren in een kwetsbare positie. Deze vervolgaanpak kenmerkt zich door een aantal veranderingen ten opzichte van de jaren ervoor en treedt formeel per 1-1-2019 in werking. Vooruitlopend hierop zijn echter een aantal beleidsafspraken reeds in werking gesteld en deze afspraken worden in het huidige onderzoek geëvalueerd.</p>
  <p class="flow-text">Deelname aan dit onderzoek is mogelijk als de volgende punten voor u duidelijk zijn:</p>
  <ol class="flow-text">
    <li>Het doel van dit onderzoek is om de in 2016 gemaakte beleidsafspraken te evalueren over de aanpak van voortijdig schoolverlaten en jongeren in een kwetsbare positie.
    </li>
    <li>Dit onderzoek wordt uitgevoerd door onderzoekers van de Rijksuniversiteit Groningen in opdracht van het Ministerie van Onderwijs, Cultuur en Wetenschap en is goedgekeurd door de Ethische Commissie Psychologie van de Rijksuniversiteit Groningen.
    </li>
    <li>Deelname aan dit onderzoek betekent het volgende:
      <ol>
        <li>Ik stem toe mee te doen aan het onderzoek naar de huidige aanpak voortijdig schoolverlaten en jongeren in kwetsbare posities.
        </li>
        <li>Ik vul eenmalig een online vragenlijst in en het invullen van deze vragenlijst duurt ongeveer 15 minuten.
        </li>
        <li>Ik stem er vrijwillig mee in dat mijn gegevens worden gebruikt voor de doeleinden die zijn vermeld op deze webpagina.
        </li>
        <li>Ik snap dat ik mijn medewerking op elk tijdstip kan stopzetten zonder dat ik hier een reden voor hoef te geven.
        </li>
        <li>Alle onderzoeksgegevens worden naar strikte ethische richtlijnen en met grote voorzichtigheid behandeld. Al mijn antwoorden op de vragen worden anoniem opgeslagen en zijn niet tot mijn persoon te herleiden. De onderzoekers gebruiken cookies bij de online vragenlijst om te zien hoeveel mensen op de website van de vragenlijst komen en hoe zij de vragenlijst gebruiken. Deze cookies bevatten geen persoonsgegevens, en volgen me niet naar andere websites.
        </li>
        <li>Het staat mij vrij om mijn e-mailadres op te geven aan het einde van het onderzoek. Dit is nodig om eenmalig aanspraak te kunnen maken op een bol.com cadeaubon ter waarde van €10,-. Indien ik hiervoor kies wordt ook mijn IP-adres versleuteld opgeslagen om eventueel misbruik te kunnen voorkomen. Deze persoonsgegevens worden apart van de onderzoeksdata opgeslagen en deze twee vormen van data zijn voor de onderzoekers niet te koppelen. Het is mij duidelijk dat het opgeven van mijn e-mailadres geheel vrijwillig is: ik mag er ook voor kiezen om dit niet in te vullen. In dat geval kan ik geen beloning ontvangen, maar wel meedoen aan het onderzoek.
        </li>
      </ol>
    </li>
    <li>Voor vragen over het onderzoek kan er contact opgenomen worden met het algemene informatie e-mailadres van het u-can-act projectteam van de Rijksuniversiteit Groningen (<a href="mailto:info@u-can-act.nl">info@u-can-act.nl</a>).
    </li>
    <li>Klik <a href="/evaluatieonderzoek/Onderzoeksinformatie.pdf" target="_blank" rel="noopener noreferrer">hier</a> voor meer informatie over het onderzoek. Op deze manier download u een PDF bestand met alle informatie over het onderzoek op uw telefoon, tablet of computer, zodat u deze informatie ten allen tijde kunt raadplegen.
    </li>
  </ol>
END
informed_consent1.content = { questions: [{
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
}], scores: [] }
informed_consent1.title = ''
informed_consent1.save!
