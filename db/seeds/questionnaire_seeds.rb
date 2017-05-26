# frozen_string_literal: true

puts 'Generating questionnaires - Started'

dagboekvragenlijst = Questionnaire.find_by_name('Dagboekvragenlijst Studenten')
dagboekvragenlijst ||= Questionnaire.new(name: 'Dagboekvragenlijst Studenten')
dagboek_content = [{
                     section_start: 'School',
                     id: :v1,
                     type: :range,
                     title: 'Heb je afgelopen week vooral leuke of nare dingen meegemaakt op school?',
                     labels: ['alleen nare dingen', 'alleen leuke dingen']
                   }, {
                     id: :v2,
                     type: :range,
                     title: 'Had je het gevoel dat je zelf invloed had op deze gebeurtenissen op school?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v3,
                     type: :range,
                     title: 'Heb je deze week successen gehad op school?',
                     labels: ['weining successen', 'veel successen']
                   }, {
                     id: :v4,
                     type: :range,
                     title: 'Voelde je deze week een sterke band met <b>vrienden op school</b>?',
                     labels: ['geen sterke band', 'erg sterke band']
                   }, {
                     id: :v5,
                     type: :range,
                     title: 'Voelde je deze week een sterke band met <b>leraren</b>?',
                     labels: ['geen sterke band', 'erg sterke band']
                   }, {
                     id: :v6,
                     type: :range,
                     title: 'Hoeveel tijd heb je besteed aan school? In totaal, dus met naar school gaan, stage en huiswerk. Dit hoeft alleen een grove gok te zijn, het is helemaal niet erg als je er een paar uur naast zit.',
                     labels: ['0 uur', '40 uur'],
                     max: 40
                   }, {
                     id: :v7,
                     type: :range,
                     title: 'Ben je deze week vooral naar school gegaan omdat je moest of omdat je zelf wilde?',
                     labels: ['omdat ik moet', 'omdat ik wil']
                   }, {
                     id: :v8,
                     type: :range,
                     title: 'Hoe prettig voelde je jezelf deze week op school?',
                     labels: ['niet prettig', 'heel prettig']
                   }, {
                     id: :v9,
                     type: :range,
                     title: 'Ben je nog blij met je keuze voor deze studie?',
                     labels: ['Niet blij met keuze', 'Heel blij met keuze']
                   }, {
                     id: :v10,
                     type: :range,
                     title: 'Vind je dat je studierichting bij je past?',
                     labels: ['Past niet goed', 'Past heel goed']
                   }, {
                     id: :v11,
                     type: :range,
                     title: 'Heb je er vertrouwen in dat je dit schooljaar gaat halen?',
                     labels: ['Geen vertrouwen', 'Veel vertrouwen'],
                     section_end: true
                   }, {
                     section_start: 'Buiten School',
                     id: :v12,
                     type: :range,
                     title: 'Heb je afgelopen week vooral leuke of nare dingen meegemaakt buiten school?',
                     labels: ['alleen nare dingen', 'alleen leuke dingen']
                   }, {
                     id: :v13,
                     type: :range,
                     title: 'Had je het gevoel dat je zelf invloed had op deze gebeurtenissen buiten school?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v14,
                     type: :range,
                     title: 'Heb je deze week successen gehad buiten school?',
                     labels: ['weining successen', 'veel successen']
                   }, {
                     id: :v15,
                     type: :range,
                     title: 'Voelde je deze week een sterke band met <b>vrienden buiten school</b>?',
                     labels: ['geen sterke band', 'erg sterke band']
                   }, {
                     id: :v16,
                     type: :range,
                     title: 'Voelde je deze week een sterke band met <b>ouders/familie</b>?',
                     labels: ['geen sterke band', 'erg sterke band']
                   }, {
                     id: :v17,
                     type: :checkbox,
                     title: 'Waar heb je de meeste tijd aan besteedt buiten school? Je mag meerdere antwoorden geven.',
                     options: ['vrienden', 'ouders/familie', 'hobby\'s', 'werk', 'niks doen']
                   }, {
                     id: :v18,
                     type: :range,
                     title: 'Heb je deze dingen buiten school vooral gedaan omdat je moest of omdat je het zelf wilde?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v19,
                     type: :range,
                     title: 'Hoe prettig voelde je jezelf deze week buiten school?',
                     labels: ['niet prettig', 'heel prettig'],
                     section_end: true
                   }, {
                     section_start: 'Begeleiding',
                     id: :v20,
                     type: :range,
                     title: 'Voelde je deze week een sterke band  met je begeleider? Je kan gewoon eerlijk zijn - je begeleider kan niet zien wat je antwoordt.',
                     labels: ['geen sterke band', 'erg sterke band']
                   }, {
                     id: :v21,
                     type: :range,
                     title: 'Wat durf je allemaal te vertellen aan je begeleider?',
                     labels: ['Helemaal niks', 'Alles']
                   }, {

                     id: :v22,
                     type: :range,
                     title: 'Heeft je begeleider je goed geholpen deze week?',
                     labels: ['Niet goed geholpen', 'Heel goed geholpen'],
                     section_end: true
                   }]
dagboekvragenlijst.content = dagboek_content
dagboekvragenlijst.save!

voormeting = Questionnaire.find_by_name('Voormeting Studenten')
voormeting ||= Questionnaire.new(name: 'Voormeting Studenten')
voormeting.content = [{
                        id: :v1,
                        type: :radio,
                        title: 'Hoe voelt u zich vandaag?',
                        options: %w[slecht goed]
                      }, {
                        id: :v2,
                        type: :checkbox,
                        title: 'Wat heeft u vandaag gegeten?',
                        options: ['brood', 'kaas en ham', 'pizza']
                      }, {
                        id: :v3,
                        type: :range,
                        title: 'Ik heb zin om naar school te gaan.',
                        labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens']
                      }]
voormeting.save!

informed_consent =
  Questionnaire.find_by_name('Informed consent pilot onderzoek naar ontwikkeling en begeleiding (wekelijks)')
informed_consent ||=
  Questionnaire.new(name: 'Informed consent pilot onderzoek naar ontwikkeling en begeleiding (wekelijks)')
ic_content = <<'END'
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
      <li>Ik zal elke week 1 vragenlijst invullen, voor 3 weken in totaal. Deze vragenlijst duurt ongeveer 3 minuten.
      </li>
      <li>Ik krijg elke week een herinnering via sms op de dag dat ik de vragenlijst moet invullen.
        In de herinnering staat een link naar de vragenlijst.
      </li>
      <li>Bij het afronden van het onderzoek krijg ik een beloning van 3 euro.
        Afronden houdt in dat ik alle wekelijkse vragenlijsten (in totaal 3) en de afsluitende enquête invul binnen 24
        uur na ontvangst van de sms.
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
informed_consent.content = [{
                              type: :raw,
                              content: ic_content
                            }]
informed_consent.save!


informed_consent2 =
  Questionnaire.find_by_name('Informed consent pilot onderzoek naar ontwikkeling en begeleiding (twee-wekelijks)')
informed_consent2 ||=
  Questionnaire.new(name: 'Informed consent pilot onderzoek naar ontwikkeling en begeleiding (twee-wekelijks)')
ic_content2 = <<'END'
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
      <li>Ik zal elke week 2 vragenlijsten invullen, voor 3 weken in totaal. Deze vragenlijst duurt ongeveer 3
        minuten.
      </li>
      <li>Ik krijg twee keer per week een herinnering via sms op de dag dat ik de vragenlijst moet invullen. In de
        herinnering staat een link naar de vragenlijst.
      </li>
      <li>Bij het afronden van het onderzoek krijg ik een beloning van 6 euro. Afronden houdt in dat ik alle wekelijkse
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
informed_consent2.content = [{
                              type: :raw,
                              content: ic_content2
                            }]
informed_consent2.save!


informed_consent3 =
  Questionnaire.find_by_name('Informed consent pilot onderzoek naar ontwikkeling en begeleiding (dagelijks)')
informed_consent3 ||=
  Questionnaire.new(name: 'Informed consent pilot onderzoek naar ontwikkeling en begeleiding (dagelijks)')
ic_content3 = <<'END'
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
      <li>Ik zal elke week 5 vragenlijsten invullen, voor 3 weken in totaal. Deze vragenlijst duurt ongeveer 3
        minuten.
      </li>
      <li>Ik krijg elke doordeweekse dag een herinnering via sms op de dag dat ik de vragenlijst moet invullen. In de
        herinnering staat een link naar de vragenlijst.
      </li>
      <li>Bij het afronden van het onderzoek krijg ik een beloning van 15 euro. Afronden houdt in dat ik alle wekelijkse
        vragenlijsten (in totaal 15) en de afsluitende enquête invul binnen 24 uur na ontvangst van de sms.
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
informed_consent3.content = [{
                              type: :raw,
                              content: ic_content3
                            }]
informed_consent3.save!

puts 'Generating questionnaires - Finished'
