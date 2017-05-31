# frozen_string_literal: true

puts 'Generating questionnaires - Started'

=begin
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
=end


################################
## Informed Consent Studenten ##
################################

ic_name = 'informed consent studenten 1x per week'
informed_consent = Questionnaire.find_by_name(ic_name)
informed_consent ||= Questionnaire.new(name: ic_name)
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
        <li>Ik zal elke week 1 vragenlijst invullen, voor 3 weken in totaal. Deze vragenlijst duurt ongeveer 3 minuten.
        </li>
        <li>Ik krijg elke week een herinnering via sms op de dag dat ik de vragenlijst moet invullen.
          In de herinnering staat een link naar de vragenlijst.
        </li>
        <li>Bij het afronden van het onderzoek krijg ik een beloning van 4 euro.
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
informed_consent.title = 'Informed consent pilot onderzoek naar ontwikkeling en begeleiding'
informed_consent.save!


ic_name2 = 'informed consent studenten 2x per week'
informed_consent2 = Questionnaire.find_by_name(ic_name2)
informed_consent2 ||= Questionnaire.new(name: ic_name2)
ic_content2 = <<~'END'
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
informed_consent2.content = [{
                               type: :raw,
                               content: ic_content2
                             }]
informed_consent2.title = 'Informed consent pilot onderzoek naar ontwikkeling en begeleiding'
informed_consent2.save!

ic_name3 = 'informed consent studenten 5x per week'
informed_consent3 = Questionnaire.find_by_name(ic_name3)
informed_consent3 ||= Questionnaire.new(name: ic_name3)
ic_content3 = <<~'END'
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
        <li>Bij het afronden van het onderzoek krijg ik een beloning van 16 euro. Afronden houdt in dat ik alle wekelijkse
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
informed_consent3.title = 'Informed consent pilot onderzoek naar ontwikkeling en begeleiding'
informed_consent3.save!


#########################
## Dagboeken Studenten ##
#########################

db_title = 'Webapp Jongeren'

db_name1 = 'dagboek studenten 1x per week donderdag'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek_content = [{
                     section_start: 'School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over school en stage. Je antwoorden zijn anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v1,
                     type: :checkbox,
                     title: 'Ben je de afgelopen week naar school en/of stage geweest?',
                     options: ['Ja', 'Nee (de volgende vijf vragen mag je over slaan, je mag starten bij de vraag: Hoeveel tijd heb je afgelopen week besteed...)']
                   }, {
                     id: :v2,
                     type: :range,
                     title: 'Wat heb je de afgelopen week <strong>meegemaakt op school en/of stage?</strong>',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v3,
                     type: :range,
                     title: 'Had je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> op school en/of stage?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v4,
                     type: :range,
                     title: 'Ben je afgelopen week vooral <strong>naar school en/of stage gegaan</strong> omdat je het moest of omdat je het zelf wilde?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v5,
                     type: :range,
                     title: '<strong>Hoe goed heb je het gedaan</strong> afgelopen week op school en/of stage?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v6,
                     type: :range,
                     title: 'Kon je afgelopen week goed <strong>opschieten met vrienden op school en/of stage</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v7,
                     type: :range,
                     title: 'Kon je afgelopen week goed <strong>opschieten met leraren op school en/of begeleiders op stage</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v8,
                     type: :range,
                     title: '<strong>Hoeveel tijd</strong> heb je afgelopen week besteed aan school, stage en huiswerk bij elkaar opgeteld? Een grove gok is prima, het is niet erg als je er een paar uur naast zit.',
                     labels: ['0 uur', '40 uur of meer'],
                     max: 40
                   }, {
                     id: :v9,
                     type: :range,
                     title: ' Was dit <strong>genoeg tijd</strong> om goed te presteren op school?',
                     labels: ['niet genoeg tijd', 'te veel tijd']
                   }, {
                     id: :v10,
                     type: :range,
                     title: 'Ben je op dit moment blij met je <strong>keuze voor deze opleiding</strong>?',
                     labels: ['niet blij met keuze', 'heel blij met keuze']
                   }, {
                     id: :v11,
                     type: :range,
                     title: 'Vind je op dit moment dat je <strong>opleiding</strong> bij je past?',
                     labels: ['past niet goed', 'past heel goed']
                   }, {
                     id: :v12,
                     type: :range,
                     title: 'Heb je er op dit moment vertrouwen in dat je dit <strong>schooljaar gaat halen</strong>?',
                     labels: ['geen vertrouwen', 'veel vertrouwen'],
                     section_end: true
                   }, {
                     section_start: 'Buiten School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over de tijd die je besteedt buiten school. Je antwoorden zijn helemaal anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v13,
                     type: :range,
                     title: 'Wat heb je afgelopen week <strong>meegemaakt buiten school</strong>?',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v14,
                     type: :checkbox,
                     title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken? Je mag meerdere antwoorden geven.',
                     options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
                   }, {
                     id: :v15,
                     type: :range,
                     title: 'Heb je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> buiten school?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v16,
                     type: :range,
                     title: 'Heb je afgelopen week jouw activiteiten <strong>buiten school vooral gedaan</strong> omdat je het moest doen of omdat je het zelf wilde doen?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v17,
                     type: :range,
                     title: 'Heb je afgelopen week dingen gedaan waar je <strong>trots</strong> op bent?',
                     labels: ['helemaal niet', 'heel veel']
                   }, {
                     id: :v18,
                     type: :range,
                     title: 'Kon je afgelopen week goed <strong>opschieten met vrienden buiten school</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v19,
                     type: :range,
                     title: 'Kon je afgelopen week goed <strong>opschieten met ouders/familie</strong>?',
                     labels: ['heel slecht', 'heel goed'],
                     section_end: true
                   }, {
                     section_start: 'Begeleiding',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over de begeleiding die je krijgt van het S-team. Je antwoorden zijn helemaal anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v20,
                     type: :checkbox,
                     title: 'Heb je de afgelopen week je begeleider gesproken?',
                     options: ['Ja', 'Nee (de volgende drie vragen mag je overslaan)']
                   }, {
                     id: :v21,
                     type: :range,
                     title: 'Kon je afgelopen week goed <strong>opschieten met je begeleider</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v22,
                     type: :range,
                     title: 'Hoe <strong>open</strong> was je <strong>in wat je vertelde</strong> aan je begeleider afgelopen week?',
                     labels: ['gesloten', 'open']
                   }, {
                     id: :v23,
                     type: :range,
                     title: 'Heeft je begeleider je goed geholpen afgelopen week?',
                     labels: ['niet goed geholpen', 'heel goed geholpen'],
                     section_end: true
                   }]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!


db_name2 = 'dagboek studenten 2x per week maandag'
dagboek2 = Questionnaire.find_by_name(db_name2)
dagboek2 ||= Questionnaire.new(name: db_name2)
dagboek_content = [{
                     section_start: 'School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over school en stage. Je antwoorden zijn anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v1,
                     type: :range,
                     title: '<strong>Hoeveel tijd</strong> heb je sinds afgelopen donderdag besteed aan school, stage en huiswerk bij elkaar opgeteld? Een grove gok is prima, het is niet erg als je er een paar uur naast zit.',
                     labels: ['0 uur', '40 uur of meer'],
                     max: 40
                   }, {
                     id: :v2,
                     type: :range,
                     title: ' Was dit <strong>genoeg tijd</strong> om goed te presteren op school?',
                     labels: ['niet genoeg tijd', 'te veel tijd']
                   }, {
                     id: :v3,
                     type: :range,
                     title: 'Ben je op dit moment blij met je <strong>keuze voor deze opleiding</strong>?',
                     labels: ['niet blij met keuze', 'heel blij met keuze']
                   }, {
                     id: :v4,
                     type: :range,
                     title: 'Vind je op dit moment dat je <strong>opleiding</strong> bij je past?',
                     labels: ['past niet goed', 'past heel goed']
                   }, {
                     id: :v5,
                     type: :range,
                     title: 'Heb je er op dit moment vertrouwen in dat je dit <strong>schooljaar gaat halen</strong>?',
                     labels: ['geen vertrouwen', 'veel vertrouwen'],
                     section_end: true
                   }, {
                     section_start: 'Buiten School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over de tijd die je besteedt buiten school. Je antwoorden zijn helemaal anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v6,
                     type: :range,
                     title: 'Wat heb je sinds afgelopen donderdag <strong>meegemaakt buiten school</strong>?',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v7,
                     type: :checkbox,
                     title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken? Je mag meerdere antwoorden geven.',
                     options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
                   }, {
                     id: :v8,
                     type: :range,
                     title: 'Heb je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> buiten school?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v9,
                     type: :range,
                     title: 'Heb je sinds afgelopen donderdag jouw activiteiten <strong>buiten school vooral gedaan</strong> omdat je het moest doen of omdat je het zelf wilde doen?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v10,
                     type: :range,
                     title: 'Heb je sinds afgelopen donderdag dingen gedaan waar je <strong>trots</strong> op bent?',
                     labels: ['helemaal niet', 'heel veel']
                   }, {
                     id: :v11,
                     type: :range,
                     title: 'Kon je sinds afgelopen donderdag goed <strong>opschieten met vrienden buiten school</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v12,
                     type: :range,
                     title: 'Kon je sinds afgelopen donderdag goed <strong>opschieten met ouders/familie</strong>?',
                     labels: ['heel slecht', 'heel goed'],
                     section_end: true
                   }]
dagboek2.content = dagboek_content
dagboek2.title = db_title
dagboek2.save!


db_name3 = 'dagboek studenten 2x per week donderdag'
dagboek3 = Questionnaire.find_by_name(db_name3)
dagboek3 ||= Questionnaire.new(name: db_name3)
dagboek_content = [{
                     section_start: 'School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over school en stage. Je antwoorden zijn anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v1,
                     type: :checkbox,
                     title: 'Ben je sinds maandag naar school en/of stage geweest?',
                     options: ['Ja', 'Nee (de volgende vijf vragen mag je over slaan, je mag starten bij de vraag: Hoeveel tijd heb je sinds maandag besteed...)']
                   }, {
                     id: :v2,
                     type: :range,
                     title: 'Wat heb je sinds maandag <strong>meegemaakt op school en/of stage?</strong>',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v3,
                     type: :range,
                     title: 'Had je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> op school en/of stage?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v4,
                     type: :range,
                     title: 'Ben je sinds maandag vooral <strong>naar school en/of stage gegaan</strong> omdat je het moest of omdat je het zelf wilde?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v5,
                     type: :range,
                     title: '<strong>Hoe goed heb je het</strong> sinds maandag <strong>gedaan</strong> op school en/of stage?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v6,
                     type: :range,
                     title: 'Kon je sinds maandag goed <strong>opschieten met vrienden op school en/of stage</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v7,
                     type: :range,
                     title: 'Kon je sinds maandag goed <strong>opschieten met leraren op school en/of begeleiders op stage</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v8,
                     type: :range,
                     title: '<strong>Hoeveel tijd</strong> heb je sinds maandag besteed aan school, stage en huiswerk bij elkaar opgeteld? Een grove gok is prima, het is niet erg als je er een paar uur naast zit.',
                     labels: ['0 uur', '40 uur of meer'],
                     max: 40
                   }, {
                     id: :v9,
                     type: :range,
                     title: ' Was dit <strong>genoeg tijd</strong> om goed te presteren op school?',
                     labels: ['niet genoeg tijd', 'te veel tijd']
                   }, {
                     id: :v10,
                     type: :range,
                     title: 'Ben je op dit moment blij met je <strong>keuze voor deze opleiding</strong>?',
                     labels: ['niet blij met keuze', 'heel blij met keuze']
                   }, {
                     id: :v11,
                     type: :range,
                     title: 'Vind je op dit moment dat je <strong>opleiding</strong> bij je past?',
                     labels: ['past niet goed', 'past heel goed']
                   }, {
                     id: :v12,
                     type: :range,
                     title: 'Heb je er op dit moment vertrouwen in dat je dit <strong>schooljaar gaat halen</strong>?',
                     labels: ['geen vertrouwen', 'veel vertrouwen'],
                     section_end: true
                   }, {
                     section_start: 'Buiten School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over de tijd die je besteedt buiten school. Je antwoorden zijn helemaal anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v13,
                     type: :range,
                     title: 'Wat heb je sinds maandag <strong>meegemaakt buiten school</strong>?',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v14,
                     type: :checkbox,
                     title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken? Je mag meerdere antwoorden geven.',
                     options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
                   }, {
                     id: :v15,
                     type: :range,
                     title: 'Heb je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> buiten school?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v16,
                     type: :range,
                     title: 'Heb je sinds maandag jouw activiteiten <strong>buiten school vooral gedaan</strong> omdat je het moest doen of omdat je het zelf wilde doen?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v17,
                     type: :range,
                     title: 'Heb je sinds maandag dingen gedaan waar je <strong>trots</strong> op bent?',
                     labels: ['helemaal niet', 'heel veel']
                   }, {
                     id: :v18,
                     type: :range,
                     title: 'Kon je sinds maandag goed <strong>opschieten met vrienden buiten school</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v19,
                     type: :range,
                     title: 'Kon je sinds maandag goed <strong>opschieten met ouders/familie</strong>?',
                     labels: ['heel slecht', 'heel goed'],
                     section_end: true
                   }, {
                     section_start: 'Begeleiding',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over de begeleiding die je krijgt van het S-team. Je antwoorden zijn helemaal anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v20,
                     type: :checkbox,
                     title: 'Heb je de afgelopen week je begeleider gesproken?',
                     options: ['Ja', 'Nee (de volgende drie vragen mag je overslaan)']
                   }, {
                     id: :v21,
                     type: :range,
                     title: 'Kon je afgelopen week goed <strong>opschieten met je begeleider</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v22,
                     type: :range,
                     title: 'Hoe <strong>open</strong> was je <strong>in wat je vertelde</strong> aan je begeleider afgelopen week?',
                     labels: ['gesloten', 'open']
                   }, {
                     id: :v23,
                     type: :range,
                     title: 'Heeft je begeleider je goed geholpen afgelopen week?',
                     labels: ['niet goed geholpen', 'heel goed geholpen'],
                     section_end: true
                   }]
dagboek3.content = dagboek_content
dagboek3.title = db_title
dagboek3.save!


db_name4 = 'dagboek studenten 5x per week maandag'
dagboek4 = Questionnaire.find_by_name(db_name4)
dagboek4 ||= Questionnaire.new(name: db_name4)
dagboek_content = [{
                     section_start: 'School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over school en stage. Je antwoorden zijn anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v1,
                     type: :range,
                     title: '<strong>Hoeveel tijd</strong> heb je sinds afgelopen vrijdag besteed aan school, stage en huiswerk bij elkaar opgeteld? Een grove gok is prima, het is niet erg als je er een paar uur naast zit.',
                     labels: ['0 uur', '12 uur of meer'],
                     max: 12
                   }, {
                     id: :v2,
                     type: :range,
                     title: ' Was dit <strong>genoeg tijd</strong> om goed te presteren op school?',
                     labels: ['niet genoeg tijd', 'te veel tijd']
                   }, {
                     id: :v3,
                     type: :range,
                     title: 'Ben je op dit moment blij met je <strong>keuze voor deze opleiding</strong>?',
                     labels: ['niet blij met keuze', 'heel blij met keuze']
                   }, {
                     id: :v4,
                     type: :range,
                     title: 'Vind je op dit moment dat je <strong>opleiding</strong> bij je past?',
                     labels: ['past niet goed', 'past heel goed']
                   }, {
                     id: :v5,
                     type: :range,
                     title: 'Heb je er op dit moment vertrouwen in dat je dit <strong>schooljaar gaat halen</strong>?',
                     labels: ['geen vertrouwen', 'veel vertrouwen'],
                     section_end: true
                   }, {
                     section_start: 'Buiten School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over de tijd die je besteedt buiten school. Je antwoorden zijn helemaal anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v6,
                     type: :range,
                     title: 'Wat heb je sinds afgelopen vrijdag <strong>meegemaakt buiten school</strong>?',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v7,
                     type: :checkbox,
                     title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken? Je mag meerdere antwoorden geven.',
                     options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
                   }, {
                     id: :v8,
                     type: :range,
                     title: 'Heb je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> buiten school?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v9,
                     type: :range,
                     title: 'Heb je sinds afgelopen vrijdag jouw activiteiten <strong>buiten school vooral gedaan</strong> omdat je het moest doen of omdat je het zelf wilde doen?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v10,
                     type: :range,
                     title: 'Heb je sinds afgelopen vrijdag dingen gedaan waar je <strong>trots</strong> op bent?',
                     labels: ['helemaal niet', 'heel veel']
                   }, {
                     id: :v11,
                     type: :range,
                     title: 'Kon je sinds afgelopen vrijdag goed <strong>opschieten met vrienden buiten school</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v12,
                     type: :range,
                     title: 'Kon je sinds afgelopen vrijdag goed <strong>opschieten met ouders/familie</strong>?',
                     labels: ['heel slecht', 'heel goed'],
                     section_end: true
                   }]
dagboek4.content = dagboek_content
dagboek4.title = db_title
dagboek4.save!



db_name5 = 'dagboek studenten 5x per week dinsdag, woensdag, vrijdag'
dagboek5 = Questionnaire.find_by_name(db_name5)
dagboek5 ||= Questionnaire.new(name: db_name5)
dagboek_content = [{
                     section_start: 'School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over school en stage. Je antwoorden zijn anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v1,
                     type: :checkbox,
                     title: 'Ben je sinds gisteren naar school en/of stage geweest?',
                     options: ['Ja', 'Nee (de volgende vijf vragen mag je over slaan, je mag starten bij de vraag: Hoeveel tijd heb je sinds gisteren besteed...)']
                   }, {
                     id: :v2,
                     type: :range,
                     title: 'Wat heb je sinds gisteren <strong>meegemaakt op school en/of stage?</strong>',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v3,
                     type: :range,
                     title: 'Had je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> op school en/of stage?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v4,
                     type: :range,
                     title: 'Ben je sinds gisteren vooral <strong>naar school en/of stage gegaan</strong> omdat je het moest of omdat je het zelf wilde?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v5,
                     type: :range,
                     title: '<strong>Hoe goed heb je het</strong> sinds gisteren <strong>gedaan</strong> op school en/of stage?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v6,
                     type: :range,
                     title: 'Kon je sinds gisteren goed <strong>opschieten met vrienden op school en/of stage</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v7,
                     type: :range,
                     title: 'Kon je sinds gisteren goed <strong>opschieten met leraren op school en/of begeleiders op stage</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v8,
                     type: :range,
                     title: '<strong>Hoeveel tijd</strong> heb je sinds gisteren besteed aan school, stage en huiswerk bij elkaar opgeteld? Een grove gok is prima, het is niet erg als je er een paar uur naast zit.',
                     labels: ['0 uur', '12 uur of meer'],
                     max: 12
                   }, {
                     id: :v9,
                     type: :range,
                     title: ' Was dit <strong>genoeg tijd</strong> om goed te presteren op school?',
                     labels: ['niet genoeg tijd', 'te veel tijd']
                   }, {
                     id: :v10,
                     type: :range,
                     title: 'Ben je op dit moment blij met je <strong>keuze voor deze opleiding</strong>?',
                     labels: ['niet blij met keuze', 'heel blij met keuze']
                   }, {
                     id: :v11,
                     type: :range,
                     title: 'Vind je op dit moment dat je <strong>opleiding</strong> bij je past?',
                     labels: ['past niet goed', 'past heel goed']
                   }, {
                     id: :v12,
                     type: :range,
                     title: 'Heb je er op dit moment vertrouwen in dat je dit <strong>schooljaar gaat halen</strong>?',
                     labels: ['geen vertrouwen', 'veel vertrouwen'],
                     section_end: true
                   }, {
                     section_start: 'Buiten School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over de tijd die je besteedt buiten school. Je antwoorden zijn helemaal anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v13,
                     type: :range,
                     title: 'Wat heb je sinds gisteren <strong>meegemaakt buiten school</strong>?',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v14,
                     type: :checkbox,
                     title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken? Je mag meerdere antwoorden geven.',
                     options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
                   }, {
                     id: :v15,
                     type: :range,
                     title: 'Heb je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> buiten school?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v16,
                     type: :range,
                     title: 'Heb je sinds gisteren jouw activiteiten <strong>buiten school vooral gedaan</strong> omdat je het moest doen of omdat je het zelf wilde doen?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v17,
                     type: :range,
                     title: 'Heb je sinds gisteren dingen gedaan waar je <strong>trots</strong> op bent?',
                     labels: ['helemaal niet', 'heel veel']
                   }, {
                     id: :v18,
                     type: :range,
                     title: 'Kon je sinds gisteren goed <strong>opschieten met vrienden buiten school</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v19,
                     type: :range,
                     title: 'Kon je sinds gisteren goed <strong>opschieten met ouders/familie</strong>?',
                     labels: ['heel slecht', 'heel goed'],
                     section_end: true
                   }]
dagboek5.content = dagboek_content
dagboek5.title = db_title
dagboek5.save!



db_name6 = 'dagboek studenten 5x per week donderdag'
dagboek6 = Questionnaire.find_by_name(db_name6)
dagboek6 ||= Questionnaire.new(name: db_name6)
dagboek_content = [{
                     section_start: 'School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over school en stage. Je antwoorden zijn anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v1,
                     type: :checkbox,
                     title: 'Ben je sinds gisteren naar school en/of stage geweest?',
                     options: ['Ja', 'Nee (de volgende vijf vragen mag je over slaan, je mag starten bij de vraag: Hoeveel tijd heb je sinds gisteren besteed...)']
                   }, {
                     id: :v2,
                     type: :range,
                     title: 'Wat heb je sinds gisteren <strong>meegemaakt op school en/of stage?</strong>',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v3,
                     type: :range,
                     title: 'Had je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> op school en/of stage?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v4,
                     type: :range,
                     title: 'Ben je sinds gisteren vooral <strong>naar school en/of stage gegaan</strong> omdat je het moest of omdat je het zelf wilde?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v5,
                     type: :range,
                     title: '<strong>Hoe goed heb je het</strong> sinds gisteren <strong>gedaan</strong> op school en/of stage?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v6,
                     type: :range,
                     title: 'Kon je sinds gisteren goed <strong>opschieten met vrienden op school en/of stage</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v7,
                     type: :range,
                     title: 'Kon je sinds gisteren goed <strong>opschieten met leraren op school en/of begeleiders op stage</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v8,
                     type: :range,
                     title: '<strong>Hoeveel tijd</strong> heb je sinds gisteren besteed aan school, stage en huiswerk bij elkaar opgeteld? Een grove gok is prima, het is niet erg als je er een paar uur naast zit.',
                     labels: ['0 uur', '12 uur of meer'],
                     max: 12
                   }, {
                     id: :v9,
                     type: :range,
                     title: ' Was dit <strong>genoeg tijd</strong> om goed te presteren op school?',
                     labels: ['niet genoeg tijd', 'te veel tijd']
                   }, {
                     id: :v10,
                     type: :range,
                     title: 'Ben je op dit moment blij met je <strong>keuze voor deze opleiding</strong>?',
                     labels: ['niet blij met keuze', 'heel blij met keuze']
                   }, {
                     id: :v11,
                     type: :range,
                     title: 'Vind je op dit moment dat je <strong>opleiding</strong> bij je past?',
                     labels: ['past niet goed', 'past heel goed']
                   }, {
                     id: :v12,
                     type: :range,
                     title: 'Heb je er op dit moment vertrouwen in dat je dit <strong>schooljaar gaat halen</strong>?',
                     labels: ['geen vertrouwen', 'veel vertrouwen'],
                     section_end: true
                   }, {
                     section_start: 'Buiten School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over de tijd die je besteedt buiten school. Je antwoorden zijn helemaal anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v13,
                     type: :range,
                     title: 'Wat heb je sinds gisteren <strong>meegemaakt buiten school</strong>?',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v14,
                     type: :checkbox,
                     title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken? Je mag meerdere antwoorden geven.',
                     options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
                   }, {
                     id: :v15,
                     type: :range,
                     title: 'Heb je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> buiten school?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v16,
                     type: :range,
                     title: 'Heb je sinds gisteren jouw activiteiten <strong>buiten school vooral gedaan</strong> omdat je het moest doen of omdat je het zelf wilde doen?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v17,
                     type: :range,
                     title: 'Heb je sinds gisteren dingen gedaan waar je <strong>trots</strong> op bent?',
                     labels: ['helemaal niet', 'heel veel']
                   }, {
                     id: :v18,
                     type: :range,
                     title: 'Kon je sinds gisteren goed <strong>opschieten met vrienden buiten school</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v19,
                     type: :range,
                     title: 'Kon je sinds gisteren goed <strong>opschieten met ouders/familie</strong>?',
                     labels: ['heel slecht', 'heel goed'],
                     section_end: true
                   }, {
                     section_start: 'Begeleiding',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over de begeleiding die je krijgt van het S-team. Je antwoorden zijn helemaal anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v20,
                     type: :checkbox,
                     title: 'Heb je de afgelopen week je begeleider gesproken?',
                     options: ['Ja', 'Nee (de volgende drie vragen mag je overslaan)']
                   }, {
                     id: :v21,
                     type: :range,
                     title: 'Kon je afgelopen week goed <strong>opschieten met je begeleider</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v22,
                     type: :range,
                     title: 'Hoe <strong>open</strong> was je <strong>in wat je vertelde</strong> aan je begeleider afgelopen week?',
                     labels: ['gesloten', 'open']
                   }, {
                     id: :v23,
                     type: :range,
                     title: 'Heeft je begeleider je goed geholpen afgelopen week?',
                     labels: ['niet goed geholpen', 'heel goed geholpen'],
                     section_end: true
                   }]
dagboek6.content = dagboek_content
dagboek6.title = db_title
dagboek6.save!


########################
## Nameting Studenten ##
########################

nm_name1 = 'nameting studenten 1x per week'
nameting1 = Questionnaire.find_by_name(nm_name1)
nameting1 ||= Questionnaire.new(name: nm_name1)
# TODO: add content for nametingen below
nameting1.content = [{
                       section_start: 'Enquête',
                       type: :raw,
                       content: '<p class="flow-text">Dit is de nameting.</p>'
                     }]
nameting1.title = 'Enquête'
nameting1.save!

nm_name2 = 'nameting studenten 2x per week'
nameting2 = Questionnaire.find_by_name(nm_name2)
nameting2 ||= Questionnaire.new(name: nm_name2)
nameting2.content = [{
                       section_start: 'Enquête',
                       type: :raw,
                       content: '<p class="flow-text">Dit is de nameting.</p>'
                     }]
nameting2.title = 'Enquête'
nameting2.save!

nm_name3 = 'nameting studenten 5x per week'
nameting3 = Questionnaire.find_by_name(nm_name3)
nameting3 ||= Questionnaire.new(name: nm_name3)
nameting3.content = [{
                       section_start: 'Enquête',
                       type: :raw,
                       content: '<p class="flow-text">Dit is de nameting.</p>'
                     }]
nameting3.title = 'Enquête'
nameting3.save!


##############
## Mentoren ##
##############
db_title = 'Webapp Begeleiders'


ic_name4 = 'informed consent mentoren 1x per week'
informed_consent4 = Questionnaire.find_by_name(ic_name4)
informed_consent4 ||= Questionnaire.new(name: ic_name4)
ic_content4 = <<~'END'
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
        <li>Bij het afronden van het onderzoek krijg ik een beloning van 16 euro. Afronden houdt in dat ik alle wekelijkse
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
informed_consent4.content = [{
                               type: :raw,
                               content: ic_content4
                             }]
informed_consent4.title = 'Informed consent pilot onderzoek naar ontwikkeling en begeleiding'
informed_consent4.save!


db_name7 = 'dagboek mentoren 1x per week donderdag'
dagboek7 = Questionnaire.find_by_name(db_name7)
dagboek7 ||= Questionnaire.new(name: db_name7)
dagboek_content = [{
                     section_start: 'De hoofddoelen',
                     id: :v1,
                     type: :checkbox,
                     title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
                     options: [
                       { title: 'De relatie verbeteren en/of onderhouden', shows_questions: %i[v2 v3] },
                       { title: 'Inzicht krijgen in de belevingswereld', shows_questions: %i[v4 v5] },
                       { title: 'Inzicht krijgen in de omgeving', shows_questions: %i[v6 v7] },
                       { title: 'Zelfinzicht geven', shows_questions: %i[v8 v9] },
                       { title: 'Vaardigheden ontwikkelen', shows_questions: %i[v10 v11] },
                       { title: 'De omgeving vreanderen/afstemmen met de omgeving', shows_questions: %i[v12] }
                     ],
                     section_end: true
                   }, {
                     section_start: 'De relatie verbeteren en/of onderhouden',
                     hidden: true,
                     id: :v2,
                     type: :checkbox,
                     title: 'Welke acties heb je deze week uitgevoerd om de relatie met deze student te verbeteren en/of te onderhouden?',
                     options: ['Laagdrempelig contact gelegd',
                               'Praktische oefeningen uitgevoerd',
                               'Gespreks- interventies/technieken gebruikt',
                               'Het netwerk betrokken',
                               'Motiverende handelingen uitgevoerd',
                               'Observaties gedaan'],
                   }, {
                     hidden: true,
                     id: :v3,
                     type: :range,
                     title: 'In welke mate heb je aan de relatie gewerkt?',
                     labels: ['weinig', 'veel'],
                     section_end: true
                   }, {
                     section_start: 'Inzicht in de belevingswereld',
                     hidden: true,
                     id: :v4,
                     type: :checkbox,
                     title: 'Welke acties heb je deze week uitgevoerd om de belevingswereld van deze student te verbeteren en/of te onderhouden?',
                     options: ['Laagdrempelig contact gelegd',
                               'Praktische oefeningen uitgevoerd',
                               'Gespreks- interventies/technieken gebruikt',
                               'Het netwerk betrokken',
                               'Motiverende handelingen uitgevoerd',
                               'Observaties gedaan'],
                   }, {
                     hidden: true,
                     id: :v5,
                     type: :range,
                     title: 'In welke mate heb je aan de belevingswereld gewerkt?',
                     labels: ['weinig', 'veel'],
                     section_end: true
                   }, {
                     section_start: 'Inizcht in de omgeving',
                     hidden: true,
                     id: :v6,
                     type: :checkbox,
                     title: 'Welke acties heb je deze week uitgevoerd om de omgeving van deze student te verbeteren?',
                     options: ['Laagdrempelig contact gelegd',
                               'Praktische oefeningen uitgevoerd',
                               'Gespreks- interventies/technieken gebruikt',
                               'Het netwerk betrokken',
                               'Motiverende handelingen uitgevoerd',
                               'Observaties gedaan'],
                   }, {
                     hidden: true,
                     id: :v7,
                     type: :range,
                     title: 'In welke mate heb je aan de omgeving gewerkt?',
                     labels: ['weinig', 'veel'],
                     section_end: true
                   }, {
                     section_start: 'Zelfinzicht geven',
                     hidden: true,
                     id: :v8,
                     type: :checkbox,
                     title: 'Welke acties heb je deze week uitgevoerd om het zelfinzicht van deze student te verbeteren?',
                     options: ['Laagdrempelig contact gelegd',
                               'Praktische oefeningen uitgevoerd',
                               'Gespreks- interventies/technieken gebruikt',
                               'Het netwerk betrokken',
                               'Motiverende handelingen uitgevoerd',
                               'Observaties gedaan'],
                   }, {
                     hidden: true,
                     id: :v9,
                     type: :range,
                     title: 'In welke mate heb je aan het zelfinzicht gewerkt?',
                     labels: ['weinig', 'veel'],
                     section_end: true
                   }, {
                     section_start: 'Vaardigheden ontwikkelen',
                     hidden: true,
                     id: :v10,
                     type: :checkbox,
                     title: 'Welke acties heb je deze week uitgevoerd om de vaardigheden van deze student te ontwikkelen?',
                     options: ['Laagdrempelig contact gelegd',
                               'Praktische oefeningen uitgevoerd',
                               'Gespreks- interventies/technieken gebruikt',
                               'Het netwerk betrokken',
                               'Motiverende handelingen uitgevoerd',
                               'Observaties gedaan'],
                   }, {
                     hidden: true,
                     id: :v11,
                     type: :range,
                     title: 'In welke mate heb je aan vaardigheden ontwikkelen gewerkt?',
                     labels: ['weinig', 'veel'],
                     section_end: true
                   }, {
                     section_start: 'De omgeving veranderen / afstemmen met de omgeving',
                     hidden: true,
                     id: :v12,
                     type: :checkbox,
                     title: 'Met welke omgeving heb je deze week contact gehad en met welk doel?',
                     options: ['School, met als doel afstemmen',
                               'School, met als doel veranderen',
                               'School, met een ander doel',
                               'Hulpverlening, met als doel afstemmen',
                               'Hulpverlening, met als doel veranderen',
                               'Hulpverlening, met een ander doel',
                               'Thuis, met als doel afstemmen',
                               'Thuis, met als doel veranderen',
                               'Thuis, met een ander doel'],
                   }]
dagboek7.content = dagboek_content
dagboek7.title = db_title
dagboek7.save!

nm_name4 = 'nameting mentoren 1x per week'
nameting4 = Questionnaire.find_by_name(nm_name4)
nameting4 ||= Questionnaire.new(name: nm_name4)
nameting4.content = [{
                       section_start: 'Enquête',
                       type: :raw,
                       content: '<p class="flow-text">Dit is de nameting.</p>'
                     }]
nameting4.title = 'Enquête'
nameting4.save!

puts 'Generating questionnaires - Finished'
