ev_name = 'evaluatieonderzoek'
evaluatie = Questionnaire.find_by_name(ev_name)
evaluatie ||= Questionnaire.new(name: ev_name)
evaluatie.key = File.basename(__FILE__)[0...-3]
evaluatie.content = [{
                       type: :raw,
                       content: '<p class="flow-text"><em>Wij vragen u eerst om enkele achtergrondgegevens, om te kunnen achterhalen welke rol u speelt in welke regio. De resultaten worden op landelijke niveau geanalyseerd en zijn niet terug te leiden op een specifieke regio. Uw privacy is gegarandeerd.</em></p>'
                     }, {
                       id: :v1,
                       type: :radio,
                       title: 'Bij welke organisatie werkt u?',
                       options: [
                         { title: 'Gemeente, afdeling RMC', tooltip: 'In sommige gemeenten wordt dit anders genoemd, bijv. leerplicht, het gaat erom dat u verantwoordelijk bent voor onder andere onderwijsparticipatie' },
                         { title: 'Gemeente: afdeling dienst werk en inkomen', tooltip: 'In sommige gemeenten wordt dit anders genoemd, bijv. sociaal domein, participatie, het gaat erom dat je verantwoordelijk bent voor onder andere arbeidsparticipatie' },
                         { title: 'School', shows_questions: %i[v2] }
                       ],
                       show_otherwise: false
                     }, {
                       id: :v2,
                       hidden: true,
                       type: :dropdown,
                       label: 'RMC-regio',
                       title: 'Bij welke RMC-regio hoort uw school?',
                       tooltip: '<p>Als u het niet zeker weet, kunt u op dit kaartje kijken:</p><img style="height:400px;margin:10px;" src="/evaluatieonderzoek/rmcregios.png">',
                       options: [
                         '1 Oost-Groningen',
                         '2 Noord-Groningen-Eemsmond',
                         '3 Centraal en Westelijk Groningen',
                         '4 Friesland Noord',
                         '5 Zuid-West Friesland',
                         '6 De Friese Wouden',
                         '7 Noord- en Midden Drenthe',
                         '8 Zuid-Oost Drenthe',
                         '9 Zuid-West Drenthe',
                         '10 IJssel-Vecht',
                         '11 Stedendriehoek',
                         '12 Twente',
                         '13 Achterhoek',
                         '14 Arnhem/Nijmegen',
                         '15 Rivierenland',
                         '16 Eem en Vallei',
                         '17 Noordwest-Veluwe',
                         '18 Flevoland',
                         '19 Utrecht',
                         '20 Gooi en Vechtstreek',
                         '21 Agglomeratie Amsterdam',
                         '22 West-Friesland',
                         '23 Kop van Noord-Holland',
                         '24 Noord-Kennemerland',
                         '25 West-Kennemerland',
                         '26 Zuid-Holland-Noord',
                         '27 Zuid-Holland-Oost',
                         '28 Haaglanden',
                         '29 Rijnmond',
                         '30 Zuid-Holland-Zuid',
                         '31 Oosterschelde regio',
                         '32 Walcheren',
                         '33 Zeeuwsch-Vlaanderen',
                         '34 West-Brabant',
                         '35 Midden-Brabant',
                         '36 Noord-Oost-Brabant',
                         '37 Zuidoost-Brabant',
                         '38 Gewest Limburg-Noord',
                         '39 Gewest Zuid-Limburg'
                       ]
                     }, {
                       id: :v3,
                       type: :textfield,
                       required: true,
                       title: 'Hoeveel jaar heb jij tot nu toe gewerkt in de jongerenbegeleiding?',
                       placeholder: 'bv. 3'
                     }, {
                       id: :v4,
                       type: :textfield,
                       required: true,
                       title: 'Wat is je nationaliteit?',
                       placeholder: 'bv. Nederlandse'
                     }]
evaluatie.title = 'De huidige aanpak van voortijdig schoolverlaten en jongeren in kwetsbare posities: een evaluatie van het nationale beleid'
evaluatie.save!
