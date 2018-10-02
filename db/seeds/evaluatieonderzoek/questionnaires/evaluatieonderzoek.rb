ev_name = 'evaluatieonderzoek'
evaluatie = Questionnaire.find_by_name(ev_name)
evaluatie ||= Questionnaire.new(name: ev_name)
maatregelitje = '<ul class="browser-default"><li>Er zijn geen tijdelijke convenanten en regelingen meer om de samenwerking te stimuleren of verzekeren, maar structurele borging van plichten, rollen en verantwoordelijkheden in de wetgeving.</li><li>De regionale samenwerking wordt geïntensiveerd en uitgebreid om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie (afkomstig uit entree, PrO en VSO).</li><li>De RMC contactgemeenten hebben de verantwoordelijkheid gekregen voor het opstellen van het vierjarig regionaal plan met maatregelen voor VSV en kwetsbare jongeren, voor het realiseren van het plan, voor de totstandkoming van de regionale samenwerking, en voor een deel van het regionaal budget.</li><li>De RMC afdeling van de gemeenten krijgt een taak erbij: het monitoren van jongeren van 16 en 17, afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs. Daarnaast krijgen zij een taak duidelijker belegd: monitoren van jongeren van 18 tot 23 jaar, afkomstig uit PrO en VSO, wat betreft hun deelname aan werk of onderwijs.</li></ul>'
evaluatie.key = File.basename(__FILE__)[0...-3]
evaluatie.content = [{
                       type: :raw,
                       content: '<p class="flow-text"><em>Wij vragen u eerst om enkele achtergrondgegevens, om te kunnen achterhalen welke rol u speelt in welke regio. De resultaten worden op landelijke niveau geanalyseerd en zijn niet terug te leiden op een specifieke regio. Uw privacy is gegarandeerd.</em></p>'
                     }, {
                       id: :v1,
                       type: :radio,
                       title: 'Bij welke organisatie werkt u?',
                       options: [
                         { title: 'Gemeente, afdeling RMC', tooltip: 'In sommige gemeenten wordt dit anders genoemd, bijv. leerplicht, het gaat erom dat u verantwoordelijk bent voor onder andere onderwijsparticipatie', shows_questions: %i[v3 v7] },
                         { title: 'Gemeente: afdeling dienst werk en inkomen', tooltip: 'In sommige gemeenten wordt dit anders genoemd, bijv. sociaal domein, participatie, het gaat erom dat je verantwoordelijk bent voor onder andere arbeidsparticipatie', shows_questions: %i[v4] },
                         { title: 'School', shows_questions: %i[v2 v5 v6] }
                       ],
                       show_otherwise: false
                     }, {
                       id: :v2,
                       hidden: true,
                       type: :dropdown,
                       label: 'RMC-regio',
                       title: 'Bij welke RMC-regio hoort uw school?',
                       tooltip: '<p>Als u het niet zeker weet, kunt u op dit kaartje kijken:</p><img width="90%" src="/evaluatieonderzoek/rmcregios.png">',
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
                       hidden: true,
                       type: :dropdown,
                       label: 'RMC-regio',
                       title: 'Bij welke RMC-regio hoort uw gemeente?',
                       tooltip: '<p>Als u het niet zeker weet, kunt u op dit kaartje kijken:</p><img width="90%" src="/evaluatieonderzoek/rmcregios.png">',
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
                       id: :v4,
                       hidden: true,
                       type: :dropdown,
                       label: 'arbeidsmarktregio',
                       title: 'Bij welke arbeidsmarktregio hoort uw gemeente?<br><em>N.B.: Indien u contactpersoon bent voor meerdere regio’s kunt u eerst de vragen invullen voor één regio, later krijgt u de optie om vragen in te vullen voor een andere regio.</em>',
                       tooltip: '<p>Als u het niet zeker weet, kunt u op dit kaartje kijken:</p><img width="90%" src="/evaluatieonderzoek/arbeidsmarktregios.png">',
                       options: [
                         'Achterhoek ',
                         'Amersfoort',
                         'Drechtsteden',
                         'Drenthe',
                         'Flevoland',
                         'Food Valley',
                         'Friesland',
                         'Gooi- en Vechtstreek',
                         'Gorinchem',
                         'Groningen',
                         'Groot Amsterdam',
                         'Haaglanden',
                         'Helmond-De Peel',
                         'Holland Rijnland',
                         'Midden-Brabant',
                         'Midden-Gelderland',
                         'Midden-Holland',
                         'Midden-Limburg',
                         'Midden-Utrecht',
                         'Noord-Holland (Noord)',
                         'Noord-Limburg',
                         'Noordoost-Brabant',
                         'Rijk van Nijmegen',
                         'Rijnmond',
                         'Rivierenland',
                         'Stedendriehoek en Noordwest Veluwe',
                         'Twente',
                         'West-Brabant',
                         'Zaanstreek/ Waterland',
                         'Zeeland',
                         'Zuid-Holland Centraal',
                         'Zuid-Kennemerland en IJmond',
                         'Zuid-Limburg',
                         'Zuidoost-Brabant',
                         'Zwolle'
                       ]
                     }, {
                       id: :v5,
                       hidden: true,
                       type: :radio,
                       title: 'Bij welk type school werkt u?',
                       options: [
                         'VO (Voortgezet onderwijs)',
                         'VSO (Voortgezet speciaal onderwijs)',
                         'PrO (Praktijkonderwijs)',
                         'MBO (Middelbaar beroepsonderwijs)'
                       ],
                       show_otherwise: true
                     }, {
                       id: :v6,
                       hidden: true,
                       type: :radio,
                       title: 'Is uw school een contactschool?',
                       tooltip: 'Binnen elke RMC-regio is er één school aangewezen als ‘contactschool’ voor het terugdringen van voortijdig schoolverlaten (VSV). Deze school is verantwoordelijk voor het informeren van de RMC contactgemeente en de onderwijsinstellingen binnen de RMC-regio over maatregelen in het regionale programma om VSV terug te dringen. De contactschool is deels verantwoordelijk voor de uitvoering van dit programma, waaronder de besteding van de subsidie.',
                       options: [
                         'Contactgemeente',
                         'Geen contactgemeente',
                         'Weet ik niet'
                       ],
                       show_otherwise: false
                     }, {
                       id: :v7,
                       hidden: true,
                       type: :radio,
                       title: 'Is uw gemeente een contactgemeente?',
                       tooltip: 'Binnen elke RMC-regio is er één gemeente aangewezen als ‘contactgemeente’ voor het terugdringen van voortijdig schoolverlaten en monitoren van kwetsbare jongeren. Zij coördineren de melding en registratie van voortijdig schoolverlaters door scholen in de regio en organiseren de samenwerking met diverse partijen op het gebied van werk, zorg en onderwijs om een passend traject voor individuele jongeren aan te bieden.',
                       options: [
                         'Contactgemeente',
                         'Geen contactgemeente',
                         'Weet ik niet'
                       ],
                       show_otherwise: false
                     }, {
                       section_start: 'Werkwijze RMC',
                       type: :raw,
                       content: '<p class="flow-text">Alle onderstaande vragen gaan over wat er veranderd is in de afgelopen twee jaar – de periode nadat er nieuwe beleidsafspraken zijn gemaakt over  voortijdig schoolverlaten (VSV) en jongeren in kwetsbare posities.  Deze beleidsafspraken zijn gemaakt in 2016 zijn en kunnen als volgt worden samengevat (klik <a href="/evaluatieonderzoek/Onderzoeksinformatie.pdf" target="_blank" rel="noopener noreferrer">hier</a> voor een uitgebreidere beschrijving):</p>
<ul class="flow-text browser-default">
<li>Er zijn geen tijdelijke convenanten en regelingen meer om de samenwerking te stimuleren of verzekeren, maar structurele borging van plichten, rollen en verantwoordelijkheden in de wetgeving.</li>
<li>De regionale samenwerking wordt geïntensiveerd en uitgebreid om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie (afkomstig uit entree, praktijkonderwijs (PrO) en voorgezet speciaal onderwijs (VSO)).</li>
<li>De RMC contactgemeenten hebben de verantwoordelijkheid gekregen voor het opstellen van het vierjarig regionaal plan met maatregelen voor VSV en kwetsbare jongeren, voor het realiseren van het plan, voor de totstandkoming van de regionale samenwerking, en voor een deel van het regionaal budget.</li>
<li>De RMC afdeling van de gemeenten krijgt een taak erbij: het monitoren van jongeren van 16 en 17, afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs. Daarnaast krijgen zij een taak duidelijker belegd: monitoren van jongeren van 18 tot 23 jaar, afkomstig uit PrO en VSO, wat betreft hun deelname aan werk of onderwijs</li>
</ul>
<p class="flow-text"><strong>Wilt u middels de onderstaande vragen de invloed van de beleidsafspraken van 2016 evalueren?</strong></p>'
                     }, {
                       id: :v8,
                       type: :range,
                       title: 'Hoe groot vindt u de impact van de beleidsmaatregelen uit 2016 op uw dagelijkse werkzaamheden?',
                       labels: ['Heel klein', 'Heel groot'],
                       tooltip: maatregelitje
                     }, {
                       id: :v9,
                       type: :range,
                       title: 'Hoe ervaart u deze impact van de beleidsmaatregelen uit 2016 op uw dagelijkse werkzaamheden?',
                       labels: ['Heel negatief', 'Heel positief'],
                       tooltip: maatregelitje
                     }, {
                       id: :v10,
                       title: 'Wat is er in de praktijk veranderd in uw dagelijkse werkzaamheden sinds de maatregelen uit 2016? Noem hieronder kort enkele belangrijke veranderingen in uw werk die u toeschrijft aan de maatregelen.',
                       type: :textarea,
                       tooltip: maatregelitje,
                       placeholder: 'Vul hier uw antwoord in'
                     }]
evaluatie.title = 'De huidige aanpak van voortijdig schoolverlaten en jongeren in kwetsbare posities: een evaluatie van het nationale beleid'
evaluatie.save!
