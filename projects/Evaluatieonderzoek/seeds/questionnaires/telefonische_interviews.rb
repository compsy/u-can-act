ic_name1 = 'telefonische interviews'
informed_consent1 = Questionnaire.find_by(name: ic_name1)
informed_consent1 ||= Questionnaire.new(name: ic_name1)
informed_consent1.key = File.basename(__FILE__)[0...-3]
ic_content = <<~'END'
    <p class="flow-text"><em>Beste onderzoeksdeelnemer,</em></p>
    <p class="flow-text">Hartelijk dank voor uw deelname aan het <strong>evaluatieonderzoek naar de aanpak van voortijdig
  schoolverlaten en jongeren in een kwetsbare positie</strong>. In 2016 zijn er nieuwe beleidsafspraken
  gemaakt over de aanpak van voortijdig schoolverlaten en jongeren in een kwetsbare positie. Deze
  vervolgaanpak kenmerkt zich door een aantal veranderingen ten opzichte van de jaren ervoor en
  treedt formeel per 1-1-2019 in werking. Vooruitlopend hierop zijn echter een aantal
  beleidsafspraken reeds in werking gesteld en deze afspraken worden in het huidige onderzoek
  geëvalueerd.</p>
    <p class="flow-text">Deelname aan dit onderzoek is mogelijk als de volgende punten voor u duidelijk zijn:</p>
    <ol class="flow-text">
      <li>Het doel van dit onderzoek is om de in 2016 gemaakte beleidsafspraken te evalueren over de aanpak van voortijdig schoolverlaten en jongeren in een kwetsbare positie.
      </li>
      <li>Dit onderzoek wordt uitgevoerd door onderzoekers van de Rijksuniversiteit Groningen in opdracht van het Ministerie van Onderwijs, Cultuur en Wetenschap en is goedgekeurd door de Ethische Commissie Psychologie van de Rijksuniversiteit Groningen.
      </li>
      <li>Deelname aan dit onderzoek betekent het volgende:
        <ol>
          <li>Ik stem vrijwillig toe mee te doen aan het onderzoek naar de huidige aanpak
  voortijdig schoolverlaten en jongeren in een kwetsbare positie.
          </li>
          <li>Ik doe eenmalig mee aan een telefonisch interview, deze duurt ongeveer 60
  minuten.
          </li>
          <li>Ik snap dat ik mijn medewerking op elk tijdstip kan stopzetten zonder dat ik hier een
  reden voor hoef te geven.
          </li>
          <li>Alle onderzoeksgegevens worden naar strikte ethische richtlijnen en met grote
  voorzichtigheid behandeld. Al mijn antwoorden op de vragen worden
  geanonimiseerd en zijn niet tot mijn persoon te herleiden.
          </li>
        </ol>
      </li>
      <li>Voor vragen over het onderzoek kan er contact opgenomen worden met het algemene informatie e-mailadres van het u-can-act projectteam van de Rijksuniversiteit Groningen (<a href="mailto:info@u-can-act.nl">info@u-can-act.nl</a>).
      </li>
      <li>Klik <a href="/evaluatieonderzoek/Onderzoeksinformatie_telefonische_interviews.pdf" target="_blank" rel="noopener noreferrer">hier</a> voor meer informatie over het onderzoek. Op deze manier download u een PDF bestand met alle informatie over het onderzoek op uw telefoon, tablet of computer, zodat u deze informatie ten allen tijde kunt raadplegen.
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
                             }, {
                               type: :raw,
                               content: '<p class="flow-text">Om het interview zo correct mogelijk te rapporteren willen wij graag een opname maken van het gesprek. Deze opname wordt alleen gebruikt voor de verwerking van het interview en wordt in zijn geheel verwijderd na 6 maanden.</p>'
                             }, {
                               id: :v2,
                               type: :checkbox,
                               required: false,
                               title: '',
                               options: [
                                 'Ik begrijp bovenstaande informatie en geef toestemming voor het opnemen van het interview.'
                               ],
                               show_otherwise: false
                             }, {
                               type: :raw,
                               content: '<p class="flow-text">Datum: {{datum_lang}}</p><p class="flow-text">Naam: {{deze_student}} {{achternaam_student}}</p>'
                             }], scores: [] }
informed_consent1.title = ''
informed_consent1.save!
