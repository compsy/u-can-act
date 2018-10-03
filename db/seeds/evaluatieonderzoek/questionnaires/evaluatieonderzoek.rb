ev_name = 'evaluatieonderzoek'
evaluatie = Questionnaire.find_by_name(ev_name)
evaluatie ||= Questionnaire.new(name: ev_name)
maatregelitje = 'Deze maatregelen zijn:<ul class="browser-default"><li>De regionale samenwerking wordt geïntensiveerd en uitgebreid om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie (afkomstig uit entree, PrO en VSO).</li><li>De RMC contactgemeenten hebben de verantwoordelijkheid gekregen voor het opstellen van het vierjarig regionaal plan met maatregelen voor VSV en kwetsbare jongeren, voor het realiseren van het plan, voor de totstandkoming van de regionale samenwerking, en voor een deel van het regionaal budget.</li><li>De RMC afdeling van de gemeenten krijgt een taak erbij: het monitoren van jongeren van 16 en 17, afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs. Daarnaast krijgen zij een taak duidelijker belegd: monitoren van jongeren van 18 tot 23 jaar, afkomstig uit PrO en VSO, wat betreft hun deelname aan werk of onderwijs.</li></ul>'
evaluatie.key = File.basename(__FILE__)[0...-3]
evaluatie.content = [{
                       type: :raw,
                       content: '<p class="flow-text"><em>Wij vragen u eerst om enkele achtergrondgegevens, om te kunnen achterhalen welke rol u speelt in welke regio. De resultaten worden op landelijk niveau geanalyseerd en zijn niet terug te leiden op een specifieke regio. Uw privacy is gegarandeerd.</em></p>'
                     }, {
                       id: :v1,
                       type: :checkbox,
                       title: 'Bij welke organisatie werkt u?',
                       options: [
                         { title: 'Gemeente, afdeling RMC',
                           tooltip: 'In sommige gemeenten wordt dit anders genoemd, bijv. leerplicht, het gaat erom dat u verantwoordelijk bent voor onder andere onderwijsparticipatie',
                           shows_questions: %i[v3 v7 v15 v16 v25 v26 v26_1 v27 v27_1 v28 v28_1 v29 v29_1 v30 v31 v32 v33 v33_1 v34 v34_1 v35 v36 v37 v39 v40 v40_1 v41 v41_1 v42 v43 v44 v45 v45_1 v46 v46_1 v47 v48 v49 v49_1 v50 v50_1 v51 v52 v52_1 v53 v53_1 v54 v55 v56 v56_1 v57 v57_1 v72 v72_1 v76 v77 v78 v79 v80 v81] },
                         { title: 'Gemeente: afdeling dienst werk en inkomen',
                           tooltip: 'In sommige gemeenten wordt dit anders genoemd, bijv. sociaal domein, participatie, het gaat erom dat je verantwoordelijk bent voor onder andere arbeidsparticipatie',
                           shows_questions: %i[v4 v15 v16 v71 v71_1] },
                         { title: 'School',
                           shows_questions: %i[v2 v5 v6 v25 v26 v26_1 v27 v27_1 v28 v28_1 v29 v29_1 v30 v31 v32 v33 v33_1 v34 v34_1 v35 v36 v37 v39 v40 v40_1 v41 v41_1 v42 v43] }
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
                         '1. Oost-Groningen',
                         '2. Noord-Groningen-Eemsmond',
                         '3. Centraal en Westelijk Groningen',
                         '4. Friesland Noord',
                         '5. Zuid-West Friesland',
                         '6. De Friese Wouden',
                         '7. Noord- en Midden Drenthe',
                         '8. Zuid-Oost Drenthe',
                         '9. Zuid-West Drenthe',
                         '10. IJssel-Vecht',
                         '11. Stedendriehoek',
                         '12. Twente',
                         '13. Achterhoek',
                         '14. Arnhem/Nijmegen',
                         '15. Rivierenland',
                         '16. Eem en Vallei',
                         '17. Noordwest-Veluwe',
                         '18. Flevoland',
                         '19. Utrecht',
                         '20. Gooi en Vechtstreek',
                         '21. Agglomeratie Amsterdam',
                         '22. West-Friesland',
                         '23. Kop van Noord-Holland',
                         '24. Noord-Kennemerland',
                         '25. West-Kennemerland',
                         '26. Zuid-Holland-Noord',
                         '27. Zuid-Holland-Oost',
                         '28. Haaglanden',
                         '29. Rijnmond',
                         '30. Zuid-Holland-Zuid',
                         '31. Oosterschelde regio',
                         '32. Walcheren',
                         '33. Zeeuwsch-Vlaanderen',
                         '34. West-Brabant',
                         '35. Midden-Brabant',
                         '36. Noord-Oost-Brabant',
                         '37. Zuidoost-Brabant',
                         '38. Gewest Limburg-Noord',
                         '39. Gewest Zuid-Limburg'
                       ]
                     }, {
                       id: :v3,
                       hidden: true,
                       type: :dropdown,
                       label: 'RMC-regio',
                       title: 'Bij welke RMC-regio hoort uw gemeente?',
                       tooltip: '<p>Als u het niet zeker weet, kunt u op dit kaartje kijken:</p><img width="90%" src="/evaluatieonderzoek/rmcregios.png">',
                       options: [
                         '1. Oost-Groningen',
                         '2. Noord-Groningen-Eemsmond',
                         '3. Centraal en Westelijk Groningen',
                         '4. Friesland Noord',
                         '5. Zuid-West Friesland',
                         '6. De Friese Wouden',
                         '7. Noord- en Midden Drenthe',
                         '8. Zuid-Oost Drenthe',
                         '9. Zuid-West Drenthe',
                         '10. IJssel-Vecht',
                         '11. Stedendriehoek',
                         '12. Twente',
                         '13. Achterhoek',
                         '14. Arnhem/Nijmegen',
                         '15. Rivierenland',
                         '16. Eem en Vallei',
                         '17. Noordwest-Veluwe',
                         '18. Flevoland',
                         '19. Utrecht',
                         '20. Gooi en Vechtstreek',
                         '21. Agglomeratie Amsterdam',
                         '22. West-Friesland',
                         '23. Kop van Noord-Holland',
                         '24. Noord-Kennemerland',
                         '25. West-Kennemerland',
                         '26. Zuid-Holland-Noord',
                         '27. Zuid-Holland-Oost',
                         '28. Haaglanden',
                         '29. Rijnmond',
                         '30. Zuid-Holland-Zuid',
                         '31. Oosterschelde regio',
                         '32. Walcheren',
                         '33. Zeeuwsch-Vlaanderen',
                         '34. West-Brabant',
                         '35. Midden-Brabant',
                         '36. Noord-Oost-Brabant',
                         '37. Zuidoost-Brabant',
                         '38. Gewest Limburg-Noord',
                         '39. Gewest Zuid-Limburg'
                       ]
                     }, {
                       id: :v4,
                       hidden: true,
                       type: :dropdown,
                       label: 'arbeidsmarktregio',
                       title: 'Bij welke arbeidsmarktregio hoort uw gemeente?<br><em>N.B.: Indien u contactpersoon bent voor meerdere regio’s kunt u eerst de vragen invullen voor één regio, later krijgt u de optie om vragen in te vullen voor een andere regio.</em>',
                       tooltip: '<p>Als u het niet zeker weet, kunt u op dit kaartje kijken:</p><img width="90%" src="/evaluatieonderzoek/arbeidsmarktregios.png">',
                       options: [
                         '1. Groningen',
                         '2. Friesland',
                         '3. Drenthe',
                         '4. Noord-Holland (Noord)',
                         '5. IJsselvechtstreek / Zwolle',
                         '6. Flevoland',
                         '7. Zaanstreek/ Waterland',
                         '8. Zuid-Kennemerland en IJmond',
                         '9. Stedendriehoek en Noordwest Veluwe',
                         '10. Groot Amsterdam',
                         '11. Twente',
                         '12. Gooi- en Vechtstreek',
                         '13. Holland Rijnland',
                         '14. Amersfoort',
                         '15. Midden-Utrecht',
                         '16. Food Valley',
                         '17. Zuid-Holland Centraal',
                         '18. Haaglanden',
                         '19. Achterhoek',
                         '20. Midden-Holland',
                         '21. Midden-Gelderland',
                         '22. Gorinchem',
                         '23. Rivierenland',
                         '24. Rijk van Nijmegen',
                         '25. Drechtsteden',
                         '26. Rijnmond',
                         '27. Noordoost-Brabant',
                         '28. West-Brabant',
                         '29. Zeeland',
                         '30. Midden-Brabant',
                         '31. Noord-Limburg',
                         '32. Helmond-De Peel',
                         '33. Zuidoost-Brabant',
                         '34. Midden-Limburg',
                         '35. Zuid-Limburg'
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
                       tooltip: 'Binnen elke RMC-regio is er één school aangewezen als ‘contactschool’ voor het terugdringen van voortijdig schoolverlaten (VSV). Deze school heeft o.a. als taak het informeren van de RMC contactgemeente en de onderwijsinstellingen binnen de RMC regio over maatregelen in het regionale programma om VSV terug te dringen, en de uitvoering van dit programma, waaronder de besteding van de subsidie.',
                       options: [
                         { title: 'Contactschool', shows_questions: %i[v61] },
                         'Geen contactschool',
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
                         { title: 'Contactgemeente', shows_questions: %i[v61] },
                         'Geen contactgemeente',
                         'Weet ik niet'
                       ],
                       show_otherwise: false
                     }, {
                       section_start: 'Werkwijze RMC',
                       type: :raw,
                       content: '<div class="divider"></div><p class="flow-text">Onderstaande vragen gaan over wat er veranderd is in de afgelopen twee jaar – de periode nadat er nieuwe beleidsafspraken zijn gemaakt over voortijdig schoolverlaten (VSV) en jongeren in kwetsbare posities. Deze beleidsafspraken zijn gemaakt in 2016 zijn en kunnen als volgt worden samengevat (klik <a href="/evaluatieonderzoek/Onderzoeksinformatie.pdf" target="_blank" rel="noopener noreferrer">hier</a> voor een uitgebreidere beschrijving):</p><ul class="flow-text browser-default"><li>De regionale samenwerking wordt geïntensiveerd en uitgebreid om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie (afkomstig uit entree, praktijkonderwijs (PrO) en voorgezet speciaal onderwijs (VSO)).</li><li>De RMC contactgemeenten hebben de verantwoordelijkheid gekregen voor het opstellen van het vierjarig regionaal plan met maatregelen voor VSV en kwetsbare jongeren, voor het realiseren van het plan, voor de totstandkoming van de regionale samenwerking, en voor een deel van het regionaal budget.</li><li>De RMC afdeling van de gemeenten krijgt een taak erbij: het monitoren van jongeren van 16 en 17, afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs. Daarnaast krijgen zij een taak duidelijker belegd: monitoren van jongeren van 18 tot 23 jaar, afkomstig uit PrO en VSO, wat betreft hun deelname aan werk of onderwijs</li></ul><p class="flow-text"><strong>Wilt u middels de onderstaande vragen de invloed van de beleidsafspraken van 2016 evalueren?</strong></p>'
                     }, {
                       id: :v8,
                       type: :range,
                       title: 'Hoe <strong>groot</strong> vindt u de impact van de beleidsmaatregelen uit 2016 op uw dagelijkse werkzaamheden?',
                       labels: ['Heel klein', 'Heel groot'],
                       tooltip: maatregelitje
                     }, {
                       id: :v9,
                       type: :range,
                       title: 'Hoe <strong>ervaart u</strong> deze impact van de beleidsmaatregelen uit 2016 op uw dagelijkse werkzaamheden?',
                       labels: ['Heel negatief', 'Heel positief'],
                       tooltip: maatregelitje
                     }, {
                       id: :v10,
                       type: :textarea,
                       title: 'Wat is er in de praktijk veranderd in uw dagelijkse werkzaamheden sinds de maatregelen uit 2016? Noem hieronder kort enkele belangrijke veranderingen in uw werk die u toeschrijft aan de maatregelen.',
                       tooltip: maatregelitje,
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       id: :v11,
                       type: :range,
                       title: 'Ervaart u een verandering in werkdruk, sinds de invoering van de maatregelen in 2016?',
                       labels: ['Veel minder werkdruk', 'Veel meer werkdruk'],
                       tooltip: maatregelitje
                     }, {
                       id: :v12,
                       type: :range,
                       title: 'Hoe groot vindt u de impact van de nieuwe, structurele borging van verantwoordelijkheden i.p.v. tijdelijke VSV convenanten?',
                       labels: ['Heel klein', 'Heel groot'],
                       tooltip: 'Er is een wettelijke basis gecreëerd voor een aantal taken die eerder op basis van de convenanten werden uitgevoerd, om er voor te zorgen dat deze taken structureel worden uitgevoerd. Bijvoorbeeld scholen en gemeenten zijn nu verplicht om samen te komen tot regionale afspraken over de aanpak van VSV en de begeleiding van jongeren in een kwetsbare positie, in samenwerking met het arbeidsmarktdomein (bijv. dienst werk en inkomen) en partijen uit de zorg, en er is een duidelijke basis voor de financiering van de afgesproken regionale maatregelen.'
                     }, {
                       id: :v13,
                       type: :range,
                       title: 'Ervaart u een verandering in de kwaliteit van het werk dat u kunt leveren, sinds de invoering van de beleidsmaatregelen in 2016?',
                       labels: ['Veel minder kwaliteit', 'Veel meer kwaliteit'],
                       tooltip: maatregelitje,
                     }, {
                       id: :v13_1,
                       type: :textarea,
                       title: 'Eventuele toelichting (bij bovenstaand antwoord)',
                       placeholder: 'Vul hier een eventuele toelichting in'
                     }, {
                       id: :v14,
                       type: :range,
                       title: 'Hoe ervaart u de kwaliteit van de monitoring/begeleiding van jongeren vergeleken met de periode voor de invoering van de beleidsmaatregelen in 2016?',
                       labels: ['Veel minder kwaliteit', 'Veel meer kwaliteit'],
                       tooltip: maatregelitje
                     }, {
                       id: :v14_1,
                       type: :textarea,
                       title: 'Eventuele toelichting (bij bovenstaand antwoord)',
                       placeholder: 'Vul hier een eventuele toelichting in'
                     }, {
                       id: :v15,
                       hidden: true,
                       type: :range,
                       title: 'Is er verandering gekomen in de hoeveelheid jongeren die u monitort/begeleidt vanaf het <strong>praktijkgericht onderwijs (PrO)</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       labels: ['Veel minder jongeren van PrO', 'Veel meer jongeren van PrO'],
                       tooltip: maatregelitje
                     }, {
                       id: :v16,
                       hidden: true,
                       type: :range,
                       title: 'Is er verandering gekomen in de hoeveelheid jongeren die u monitort/begeleidt vanaf het <strong>voortgezet speciaal onderwijs (VSO)</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       labels: ['Veel minder jongeren van VSO', 'Veel meer jongeren van VSO'],
                       tooltip: maatregelitje,
                     }, {
                       section_start: '',
                       type: :raw,
                       content: '<div class="divider"></div><p class="flow-text"><strong>Wilt u onderstaande deel-maatregelen op enkele aspecten evalueren?</strong></p><p class="flow-text"><strong>Maatregel 1</strong>: de regionale samenwerking wordt geïntensiveerd en uitgebreid om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie, afkomstig uit het praktijkonderwijs en voortgezet speciaal onderwijs. <a onclick="M.toast({html: &#39;Voor deze jongeren moet in de regio een sluitend vangnet zijn tussen gemeenten (RMC en Dienst Werk &amp; Inkomen), onderwijs (PrO, VSO, VO, MBO), (jeugd)zorg en werkgevers/arbeidsmarktdomein (zoals UWV, jongerenloket, servicepunt arbeid).&#39;}, 6000)"><i class="tooltip flow-text material-icons info-outline">info</i></a></p>',
                     }, {
                       id: :v17,
                       type: :range,
                       title: 'Heeft u in de praktijk <strong>iets gemerkt</strong> van de intensivering van de regionale samenwerking om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie?',
                       labels: ['Helemaal niks gemerkt', 'Heel veel gemerkt']
                     }, {
                       id: :v18,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'In hoeverre is er binnen uw regio een <strong>sluitend vangnet</strong> voor jongeren in een kwetsbare positie?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v18_1] }]
                     }, {
                       id: :v18_1,
                       hidden: false,
                       type: :range,
                       title: '',
                       labels: ['Helemaal niet', 'Helemaal wel']
                     }, {
                       id: :v19,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Hoe ervaart u de <strong>kwaliteit</strong> van het vangnet voor kwetsbare jongeren?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v19_1] }]
                     }, {
                       id: :v19_1,
                       hidden: false,
                       type: :range,
                       title: '',
                       labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
                     }, {
                       id: :v20,
                       type: :range,
                       title: 'Hoe <strong>groot</strong> is het gevolg van deze maatregel (1) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel klein', 'Heel groot']
                     }, {
                       id: :v21,
                       type: :range,
                       title: '<strong>Wat vindt u</strong> van de gevolgen van deze maatregel (1) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       id: :v22,
                       type: :radio,
                       title: 'Zijn er nieuwe partijen toegevoegd aan de (bestuurlijke) samenwerking?',
                       options: [
                         { title: 'Ja', shows_questions: %i[v23] },
                         { title: 'Nee', shows_questions: %i[v24] },
                         { title: 'Ik weet het niet' }
                       ],
                       show_otherwise: false
                     }, {
                       id: :v23,
                       hidden: true,
                       type: :textarea,
                       title: 'Welke nieuwe partijen zijn er toegevoegd aan de (bestuurlijke) samenwerking?',
                       placeholder: 'Vul hier uw antwoord in',
                     }, {
                       id: :v24,
                       hidden: true,
                       type: :textarea,
                       title: 'Waarom zijn er geen nieuwe partijen toegevoegd aan de (bestuurlijke) samenwerking?',
                       placeholder: 'Vul hier uw antwoord in',
                     }, {
                       section_start: '<div class="divider"></div><p class="flow-text"><strong>Maatregel 2</strong>: De RMC contactgemeenten hebben de verantwoordelijkheid gekregen om een vierjarig regionaal plan met maatregelen voor VSV en kwetsbare jongeren op te stellen en te realiseren.</p>',
                       id: :v25,
                       hidden: true,
                       type: :range,
                       title: 'Heeft u in de praktijk iets gemerkt van het verschuiven van een deel van de verantwoordelijkheden van de contactschool naar de contactgemeente?',
                       labels: ['Helemaal niks gemerkt', 'Heel veel gemerkt']
                     }, {
                       id: :v26,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'In hoeverre is er binnen uw RMC regio een vierjarig regionaal plan opgesteld?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v26_1] }]
                     }, {
                       id: :v26_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Helemaal niet', 'Helemaal wel']
                     }, {
                       id: :v27,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Hoe ervaart u de kwaliteit van het regionale plan?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v27_1] }]
                     }, {
                       id: :v27_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
                     }, {
                       id: :v28,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'In hoeverre is het regionale plan uitgevoerd?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v28_1] }]
                     }, {
                       id: :v28_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Helemaal niet', 'Helemaal wel']
                     }, {
                       id: :v29,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Hoe ervaart u de kwaliteit van de uitvoering van het regionale plan?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v29_1] }]
                     }, {
                       id: :v29_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
                     }, {
                       id: :v30,
                       hidden: true,
                       type: :range,
                       title: 'Hoe groot is het gevolg van deze maatregel (2) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel klein', 'Heel groot']
                     }, {
                       id: :v31,
                       hidden: true,
                       type: :range,
                       title: 'Wat vindt u van de gevolgen van deze maatregel (2) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       section_start: '<div class="divider"></div><p class="flow-text"><strong>Maatregel 3</strong>: De RMC contactgemeenten hebben de verantwoordelijkheid gekregen voor de totstandkoming van de regionale samenwerking.</p>',
                       id: :v32,
                       hidden: true,
                       type: :range,
                       title: 'Heeft u in de praktijk iets gemerkt van de verandering in de verantwoordelijkheid voor de regionale samenwerking?',
                       labels: ['Helemaal niks gemerkt', 'Heel veel gemerkt']
                     }, {
                       id: :v33,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'In hoeverre heeft de RMC contactgemeente het totstandkomen van een regionale samenwerking verzorgd?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v33_1] }]
                     }, {
                       id: :v33_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Helemaal niet', 'Helemaal wel']
                     }, {
                       id: :v34,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Hoe ervaart u de kwaliteit van de regionale samenwerking?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v34_1] }]
                     }, {
                       id: :v34_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
                     }, {
                       id: :v35,
                       hidden: true,
                       type: :range,
                       title: 'Hoe groot is het gevolg van deze maatregel (3) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel klein', 'Heel groot']
                     }, {
                       id: :v36,
                       hidden: true,
                       type: :range,
                       title: 'Wat vindt u van de gevolgen van deze maatregel (3) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       id: :v37,
                       hidden: true,
                       type: :radio,
                       title: 'Heeft u een verandering gemerkt sinds de RMC contactgemeente verantwoordelijk is voor de totstandkoming van de samenwerking?',
                       options: [
                         { title: 'Ja', shows_questions: %i[v38] },
                         { title: 'Nee' }
                       ],
                       show_otherwise: false
                     }, {
                       id: :v38,
                       hidden: true,
                       type: :textarea,
                       title: 'Wat is er veranderd sinds de RMC contactgemeente hiervoor verantwoordelijk is?',
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       section_start: '<div class="divider"></div><p class="flow-text"><strong>Maatregel 4</strong>: De RMC contactgemeente heeft de verantwoordelijkheid voor een deel van het regionaal budget: de kassiersrol van het regionaal budget wordt nu gedeeld door de school én door de RMC contactgemeente.</p>',
                       id: :v39,
                       hidden: true,
                       type: :range,
                       title: 'Heeft u in de praktijk iets gemerkt van de verandering in de verantwoordelijkheid voor het regionaal budget?',
                       labels: ['Helemaal niks gemerkt', 'Heel veel gemerkt']
                     }, {
                       id: :v40,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'In hoeverre nemen de RMC contactgemeente en de contactschool samen hun verantwoordelijkheid voor de besteding van het regionale budget binnen uw regio?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v40_1] }]
                     }, {
                       id: :v40_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Helemaal niet', 'Helemaal wel']
                     }, {
                       id: :v41,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Hoe ervaart u de kwaliteit van de besteding van het regionale budget?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v41_1] }]
                     }, {
                       id: :v41_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
                     }, {
                       id: :v42,
                       hidden: true,
                       type: :range,
                       title: 'Hoe <strong>groot</strong> is het gevolg van deze maatregel (4) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel klein', 'Heel groot']
                     }, {
                       id: :v43,
                       hidden: true,
                       type: :range,
                       title: '<strong>Wat vindt u</strong> van de gevolgen van deze maatregel (4) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       section_start: '<div class="divider"></div><p class="flow-text"><strong>Maatregel 5</strong>: De RMC afdeling van de gemeenten krijgt een taak erbij: het monitoren van jongeren van 16 en 17, afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs.</p>',
                       id: :v44,
                       hidden: true,
                       type: :range,
                       title: 'Heeft u in de praktijk iets gemerkt van de toegevoegde taak om jongeren van 16 en 17 jaar en afkomstig uit PrO en VSO te monitoren?',
                       labels: ['Helemaal niks gemerkt', 'Heel veel gemerkt']
                     }, {
                       id: :v45,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'In hoeverre monitort de RMC gemeente jongeren van 16 en 17 jaar en afkomstig uit PrO en VSO wat betreft hun deelname aan werk (incl. dagbesteding en beschut werk) of onderwijs?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v45_1] }]
                     }, {
                       id: :v45_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Helemaal niet', 'Helemaal wel']
                     }, {
                       id: :v46,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Hoe ervaart u de kwaliteit van deze monitoring?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v46_1] }]
                     }, {
                       id: :v46_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
                     }, {
                       id: :v47,
                       hidden: true,
                       type: :range,
                       title: 'Hoe <strong>groot</strong> is het gevolg van deze maatregel (5) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel klein', 'Heel groot']
                     }, {
                       id: :v48,
                       hidden: true,
                       type: :range,
                       title: '<strong>Wat vindt u</strong> van de gevolgen van deze maatregel (5) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       id: :v49,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Zijn er volgens u meer of minder jongeren van 16 en 17 jaar en afkomstig uit PrO en VSO succesvol naar <strong>onderwijs</strong> begeleid sinds de invoering van deze maatregel (5)?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v49_1] }]
                     }, {
                       id: :v49_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Veel minder', 'Veel meer']
                     }, {
                       id: :v50,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Zijn er volgens u meer of minder jongeren van 16 en 17 jaar en afkomstig uit PrO en VSO succesvol naar <strong>werk</strong> begeleid sinds de invoering van deze maatregel (5)?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v50_1] }]
                     }, {
                       id: :v50_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Veel minder', 'Veel meer']
                     }, {
                       section_start: '<div class="divider"></div><p class="flow-text"><strong>Maatregel 6</strong>: De RMC afdeling van de gemeenten krijgt een taak duidelijker belegd: het monitoren van jongeren van 18 tot 23 jaar, afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs.</p>',
                       id: :v51,
                       hidden: true,
                       type: :range,
                       title: 'Heeft u in de praktijk iets gemerkt van de duidelijker belegde taak om jongeren van 18 tot 23 jaar en afkomstig uit PrO en VSO te monitoren?',
                       labels: ['Helemaal niks gemerkt', 'Heel veel gemerkt']
                     }, {
                       id: :v52,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'In hoeverre monitort de RMC gemeente jongeren van 18 tot 23 jaar en afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v52_1] }]
                     }, {
                       id: :v52_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Helemaal niet', 'Helemaal wel']
                     }, {
                       id: :v53,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Hoe ervaart u de kwaliteit van deze monitoring?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v53_1] }]
                     }, {
                       id: :v53_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
                     }, {
                       id: :v54,
                       hidden: true,
                       type: :range,
                       title: 'Hoe <strong>groot</strong> is het gevolg van deze maatregel (6) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel klein', 'Heel groot']
                     }, {
                       id: :v55,
                       hidden: true,
                       type: :range,
                       title: '<strong>Wat vindt u</strong> van de gevolgen van deze maatregel (6) voor uw dagelijkse werkzaamheden?',
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       id: :v56,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Zijn er volgens u meer of minder jongeren van 18 tot 23 jaar en afkomstig uit PrO en VSO succesvol naar <strong>onderwijs</strong> begeleid sinds de invoering van deze maatregel (5)?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v56_1] }]
                     }, {
                       id: :v56_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Veel minder', 'Veel meer']
                     }, {
                       id: :v57,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Zijn er volgens u meer of minder jongeren van 18 tot 23 jaar en afkomstig uit PrO en VSO succesvol naar <strong>werk</strong> begeleid sinds de invoering van deze maatregel (5)?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v57_1] }]
                     }, {
                       id: :v57_1,
                       hidden: true,
                       type: :range,
                       title: '',
                       labels: ['Veel minder', 'Veel meer']
                     }, {
                       section_start: '',
                       type: :raw,
                       content: '<div class="divider"></div><p class="flow-text"><strong>Financiële situatie</strong></p>',
                     }, {
                       id: :v58,
                       type: :radio,
                       title: 'Zijn de huidige financiële middelen voor het voorkomen van VSV en het begeleiden van jongeren in een kwetsbare positie toereikend voor de uitvoering van uw taken?',
                       options: [
                         { title: 'Ja' },
                         { title: 'Nee', shows_questions: %i[v59 v59_1 v60] }
                       ],
                       show_otherwise: false
                     }, {
                       id: :v59,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Welk bedrag komt u ongeveer tekort voor de uitvoering van de taken?',
                       options: [{ title: 'Ik weet het niet', hides_questions: %i[v59_1] }]
                     }, {
                       id: :v59_1,
                       hidden: true,
                       type: :textfield,
                       title: '',
                       placeholder: 'Vul een bedrag in'
                     }, {
                       id: :v60,
                       hidden: true,
                       type: :textarea,
                       title: 'Welke taken kunt u niet of moeilijk uitvoeren door de ontoereikende financiële situatie?',
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       id: :v61,
                       hidden: true,
                       type: :range,
                       title: 'Hoe ervaart u de verdeling van de gelden over contactgemeente en contactschool?',
                       labels: ['Heel oneerlijk', 'Heel eerlijk']
                     }, {
                       section_start: '',
                       type: :raw,
                       content: '<div class="divider"></div><p class="flow-text"><strong>Samenwerking</strong></p>',
                     }, {
                       id: :v62,
                       type: :checkbox,
                       show_otherwise: true,
                       title: 'Met wie heeft u in de afgelopen twee jaar samengewerkt in de aanpak van VSV en het begeleiden van kwetsbare jongeren?',
                       options: [
                         { title: 'Gemeente, afdeling RMC', shows_questions: %i[v63_gem_rmc v64_gem_rmc] },
                         { title: 'Gemeente, afdeling dienst werk en inkomen', shows_questions: %i[v63_gem_dwi v64_gem_dwi] },
                         { title: 'Scholen', shows_questions: %i[v63_scholen v64_scholen] },
                         { title: '(Jeugd)zorg', shows_questions: %i[v63_zorg v64_zorg] },
                         { title: 'Werkgevers / Arbeidsmarktdomein (zoals UWV, jongerenloket, servicepunt arbeid)', shows_questions: %i[v63_werkgvr v64_werkgvr] },
                         { title: 'Ministerie van Onderwijs Cultuur en wetenschap', shows_questions: %i[v63_minist v64_minist] }
                       ]
                     }, {
                       id: :v63_gem_rmc,
                       hidden: true,
                       type: :range,
                       title: 'Hoe intensief heeft u samengewerkt met <strong>Gemeente, afdeling RMC</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Niet samengewerkt', 'Heel intensief samengewerkt']
                     }, {
                       id: :v64_gem_rmc,
                       hidden: true,
                       type: :range,
                       title: 'Hoe ervaart u de kwaliteit van de samenwerking met <strong>Gemeente, afdeling RMC</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       id: :v63_gem_dwi,
                       hidden: true,
                       type: :range,
                       title: 'Hoe intensief heeft u samengewerkt met <strong>Gemeente, afdeling dienst werk en inkomen</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Niet samengewerkt', 'Heel intensief samengewerkt']
                     }, {
                       id: :v64_gem_dwi,
                       hidden: true,
                       type: :range,
                       title: 'Hoe ervaart u de kwaliteit van de samenwerking met <strong>Gemeente, afdeling dienst werk en inkomen</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       id: :v63_scholen,
                       hidden: true,
                       type: :range,
                       title: 'Hoe intensief heeft u samengewerkt met <strong>Scholen</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Niet samengewerkt', 'Heel intensief samengewerkt']
                     }, {
                       id: :v64_scholen,
                       hidden: true,
                       type: :range,
                       title: 'Hoe ervaart u de kwaliteit van de samenwerking met <strong>Scholen</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       id: :v63_zorg,
                       hidden: true,
                       type: :range,
                       title: 'Hoe intensief heeft u samengewerkt met <strong>(Jeugd)zorg</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Niet samengewerkt', 'Heel intensief samengewerkt']
                     }, {
                       id: :v64_zorg,
                       hidden: true,
                       type: :range,
                       title: 'Hoe ervaart u de kwaliteit van de samenwerking met <strong>(Jeugd)zorg</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       id: :v63_werkgvr,
                       hidden: true,
                       type: :range,
                       title: 'Hoe intensief heeft u samengewerkt met <strong>Werkgevers / Arbeidsmarktdomein (zoals UWV, jongerenloket, servicepunt arbeid)</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Niet samengewerkt', 'Heel intensief samengewerkt']
                     }, {
                       id: :v64_werkgvr,
                       hidden: true,
                       type: :range,
                       title: 'Hoe ervaart u de kwaliteit van de samenwerking met <strong>Werkgevers / Arbeidsmarktdomein (zoals UWV, jongerenloket, servicepunt arbeid)</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       id: :v63_minist,
                       hidden: true,
                       type: :range,
                       title: 'Hoe intensief heeft u samengewerkt met het <strong>Ministerie van Onderwijs Cultuur en wetenschap</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Niet samengewerkt', 'Heel intensief samengewerkt']
                     }, {
                       id: :v64_minist,
                       hidden: true,
                       type: :range,
                       title: 'Hoe ervaart u de kwaliteit van de samenwerking met het <strong>Ministerie van Onderwijs Cultuur en wetenschap</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
                       tooltip: maatregelitje,
                       labels: ['Heel negatief', 'Heel positief']
                     }, {
                       id: :v65,
                       type: :range,
                       title: 'In welke mate heeft u de afgelopen twee jaar samengewerkt met partners in de regio om voortijdig schoolverlaten te verminderen?',
                       labels: ['Helemaal niet', 'Heel veel'],
                     }, {
                       id: :v65_1,
                       type: :textarea,
                       title: 'Eventuele toelichting (bij bovenstaand antwoord)',
                       placeholder: 'Vul hier een eventuele toelichting in'
                     }, {
                       id: :v66,
                       type: :range,
                       title: 'Hoe ervaart u de samenwerking met partners in de regio om voortijdig schoolverlaten te verminderen?',
                       labels: ['Heel negatief', 'Heel positief'],
                     }, {
                       id: :v67,
                       type: :range,
                       title: '<strong>In welke mate</strong> heeft u de afgelopen twee jaar samengewerkt met partners in de regio om een vangnet te creëren voor jongeren van het PrO en VSO?',
                       labels: ['Helemaal niet', 'Heel veel'],
                     }, {
                       id: :v67_1,
                       type: :textarea,
                       title: 'Eventuele toelichting (bij bovenstaand antwoord)',
                       placeholder: 'Vul hier een eventuele toelichting in'
                     }, {
                       id: :v68,
                       type: :range,
                       title: '<strong>Hoe ervaart u</strong> de samenwerking met partners in de regio om een vangnet te creëren voor jongeren van het PrO en VSO?',
                       labels: ['Heel negatief', 'Heel positief'],
                     }, {
                       id: :v69,
                       type: :radio,
                       title: 'Zijn er voor zover u weet sinds de invoering van de beleidsmaatregelen in 2016 nieuwe samenwerkingspartners bij gekomen?',
                       options: [
                         { title: 'Ja', shows_questions: %i[v70] },
                         { title: 'Nee' }
                       ],
                       show_otherwise: false
                     }, {
                       id: :v70,
                       hidden: true,
                       type: :textarea,
                       title: 'Kunt u kort omschrijven wie dit zijn en waarin u samenwerkt?',
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       id: :v71,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Kunt u kort de belangrijkste taken noemen die u uitvoert in samenwerking met de RMC afdelingen van gemeenten in uw regio?',
                       options: [{ title: 'Niet van toepassing', hides_questions: %i[v71_1] }]
                     }, {
                       id: :v71_1,
                       hidden: true,
                       type: :textarea,
                       title: '',
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       id: :v72,
                       hidden: true,
                       type: :checkbox,
                       show_otherwise: false,
                       title: 'Kunt u kort de belangrijkste taken noemen die u uitvoert in samenwerking met de afdelingen ‘dienst werk en inkomen’ van gemeenten in uw regio?',
                       options: [{ title: 'Niet van toepassing', hides_questions: %i[v72_1] }],
                       tooltip: 'In sommige gemeenten wordt dit anders genoemd, bijv. sociaal domein, participatie: het gaat hier om de afdeling verantwoordelijk voor onder andere arbeidsparticipatie.'
                     }, {
                       id: :v72_1,
                       hidden: true,
                       type: :textarea,
                       title: '',
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       section_start: '',
                       type: :raw,
                       content: '<div class="divider"></div><p class="flow-text"><strong>Vooruitblik en Decentralisatie-uitkering</strong></p>',
                     }, {
                       id: :v73,
                       type: :textarea,
                       title: 'Heeft u nog advies of opmerkingen voor landelijk beleid om uw <strong>dagelijkse werkzaamheden</strong> te ondersteunen?',
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       id: :v74,
                       type: :textarea,
                       title: 'Heeft u nog advies of opmerkingen voor landelijk beleid om de <strong>samenwerking in uw regio</strong> verder te verbeteren?',
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       id: :v75,
                       type: :textarea,
                       title: 'Heeft u nog advies of opmerkingen voor landelijk beleid wat betreft de <strong>verdeling van financiële middelen</strong>?',
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       id: :v76,
                       hidden: true,
                       type: :radio,
                       title: 'Momenteel wordt een deel van het regionaal budget in de vorm van een specifieke uitkering (geoormerkt geld) uitgekeerd.<br>Is het volgens u mogelijk om deze specifieke uitkering van het regionaal budget om te zetten in een decentralisatie-uitkering (niet geoormerkt)?',
                       options: [
                         { title: 'Ja' },
                         { title: 'Nee' },
                         { title: 'Weet ik niet' }
                       ],
                       show_otherwise: false,
                       tooltip: 'Een deel van het regionaal budget voor VSV en kwetsbare jongeren komt via de contactgemeente naar de regio in de vorm van een specifieke uitkering met een specifiek doel (geoormerkt). Bij een decentralisatie-uitkering komt het bij de contactgemeente binnen ‘op de grote hoop’, via het Gemeentefonds.'
                     }, {
                       id: :v77,
                       hidden: true,
                       type: :range,
                       title: 'In hoeverre is een decentralisatie-uitkering wenselijk?',
                       labels: ['Helemaal niet wenselijk', 'Heel wenselijk'],
                     }, {
                       id: :v78,
                       hidden: true,
                       type: :textarea,
                       title: 'Wat voor gevolgen zou dat hebben voor uw werkzaamheden als RMC-coördinator?',
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       id: :v79,
                       hidden: true,
                       type: :textarea,
                       title: 'Wat voor gevolgen zou dat volgens u hebben voor de samenwerking met uw partners in de regio?',
                       placeholder: 'Vul hier uw antwoord in'
                     }, {
                       section_start: '<div class="divider"></div><p class="flow-text"><strong>Evaluatie register vrijstellingen leerplichtwet</strong></p>',
                       id: :v80,
                       hidden: true,
                       type: :range,
                       title: 'In hoeverre heeft het registreren van vrijstellingen eraan bijgedragen dat de betreffende jongeren niet meer onterecht als VSV-er werden benaderd?',
                       labels: ['Geen bijdrage', 'Heel veel bijdrage']
                     }, {
                       id: :v81,
                       hidden: true,
                       type: :radio,
                       title: 'Komt u nog steeds jongeren tegen die een vrijstelling hebben, maar toch als VSV-er worden geteld?',
                       options: [
                         { title: 'Ja', shows_questions: %i[v82] },
                         { title: 'Nee' }
                       ],
                       show_otherwise: false
                     }, {
                       id: :v82,
                       hidden: true,
                       type: :textarea,
                       title: 'Kunt u dit toelichten?',
                       placeholder: 'Vul hier uw antwoord in'
                     }]
evaluatie.title = 'De huidige aanpak van voortijdig schoolverlaten en jongeren in kwetsbare posities: een evaluatie van het nationale beleid'
evaluatie.save!
