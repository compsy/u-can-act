# frozen_string_literal: true

ev_name = 'evaluatieonderzoek'
evaluatie = Questionnaire.find_by_name(ev_name)
evaluatie ||= Questionnaire.new(name: ev_name)

maatregelitje = 'Deze maatregelen zijn:<ul class="browser-default"><li>De regionale samenwerking wordt geïntensiveerd en uitgebreid om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie (afkomstig uit entree, PrO en VSO).</li><li>De RMC contactgemeenten hebben de verantwoordelijkheid gekregen voor het opstellen van een vierjarig regionaal plan met maatregelen voor VSV en jongeren in een kwetsbare positie, voor het realiseren van het plan, voor de totstandkoming van de regionale samenwerking, en voor een deel van het regionale budget.</li><li>De RMC afdeling van de gemeenten krijgt een taak erbij: het monitoren van jongeren van 16 en 17, afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs. Daarnaast krijgen zij een taak duidelijker belegd: monitoren van jongeren van 18 tot 23 jaar, afkomstig uit PrO en VSO, wat betreft hun deelname aan werk, dagbesteding of onderwijs.</li></ul>'
maatregel1 = '<p class="flow-text"><strong>Maatregel 1</strong>: de regionale samenwerking wordt geïntensiveerd en uitgebreid om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie, afkomstig uit het praktijkonderwijs en voortgezet speciaal onderwijs.'
maatregel2 = '<p class="flow-text"><strong>Maatregel 2</strong>: De RMC contactgemeenten hebben de verantwoordelijkheid gekregen om een vierjarig regionaal plan met maatregelen voor VSV en jongeren in een kwetsbare positie op te stellen en te realiseren.</p>'
maatregel3 = '<p class="flow-text"><strong>Maatregel 3</strong>: De RMC contactgemeenten hebben de verantwoordelijkheid gekregen voor de totstandkoming van de regionale samenwerking.</p>'
maatregel4 = '<p class="flow-text"><strong>Maatregel 4</strong>: De RMC contactgemeente heeft de verantwoordelijkheid voor een deel van het regionale budget: de kassiersrol van het regionale budget wordt nu gedeeld door de school én door de RMC contactgemeente.</p>'
maatregel5 = '<p class="flow-text"><strong>Maatregel 5</strong>: De RMC afdeling van de gemeenten krijgt een taak erbij: het monitoren van jongeren van 16 en 17, afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs (incl. dagbesteding en beschut werk).</p>'
maatregel6 = '<p class="flow-text"><strong>Maatregel 6</strong>: De RMC afdeling van de gemeenten krijgt een taak duidelijker belegd: het monitoren van jongeren van 18 tot 23 jaar, afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs (incl. dagbesteding en beschut werk).</p>'
rmcregioitje = '<p>Als u het niet zeker weet, kunt u op dit kaartje kijken:</p><img class="auto-resize" data-ratio="1.2" src="/evaluatieonderzoek/rmcregios.png">'
rmcregioarray = [
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
maatregel_text = '<div class="divider"></div><p class="flow-text"><em>De volgende vragen gaan over onderstaande maatregel.</em></p>'
evaluatie.key = File.basename(__FILE__)[0...-3]
evaluatie.content = { questions: [{
  type: :raw,
  content: '<p class="flow-text"><em>Wij vragen u eerst om enkele achtergrondgegevens, om te kunnen achterhalen welke rol u speelt in welke regio. De resultaten worden op landelijk niveau geanalyseerd en zijn niet terug te leiden naar een specifieke regio. Uw privacy is gegarandeerd. Als er een i-button staat bij een vraag, dan kunt u daar op klikken voor meer informatie.</em></p>'
}, {
  id: :v1,
  type: :radio,
  title: 'Bij wat voor organisatie bent u werkzaam?',
  options: [
    { title: 'Een gemeente, afdeling RMC of aanverwant',
      tooltip: 'In sommige gemeenten wordt dit anders genoemd, bijv. leerplicht, het gaat erom dat u verantwoordelijk bent voor onder andere onderwijsparticipatie bij jongeren.',
      shows_questions: %i[v3 v7 v15 v16 v25 v26 v26_1 v27 v27_1 v28 v28_1 v29 v29_1 v30 v31 v32 v33 v33_1 v34 v34_1 v35 v36 v37 v39 v40 v40_1 v41 v41_1 v42 v42_1 v43 v44 v45 v46 v47 v48 v48_1 v49 v49_1 v50 v51 v52 v52_1 v53 v53_1 v54 v55 v55_1 v56 v56_1 v57 v58 v59 v59_1 v60 v60_1 v75 v75_1 v79 v80 v81 v82 v83 v84] },
    { title: 'Een gemeente, afdeling werk en inkomen of ander arbeidsmarktdomein',
      tooltip: 'In sommige gemeenten wordt dit anders genoemd of is dit anders ingedeeld, bijv. als sociaal domein, participatie, of UWV, het gaat erom dat u verantwoordelijk bent voor onder andere arbeidsparticipatie bij jongeren.',
      shows_questions: %i[v4 v15 v16 v74 v74_1] },
    { title: 'Een school',
      shows_questions: %i[v2 v5 v6 v25 v26 v26_1 v27 v27_1 v28 v28_1 v29 v29_1 v30 v31 v32 v33 v33_1 v34 v34_1 v35 v36 v37 v39 v40 v40_1 v41 v41_1 v42 v42_1 v43 v44 v45 v46] }
  ],
  show_otherwise: false
}, {
  id: :v2,
  hidden: true,
  type: :dropdown,
  label: 'RMC-regio',
  title: 'Bij welke RMC-regio hoort uw school?<br><em>N.B.: Indien u betrokken bent bij meerdere regio’s mag u zelf kiezen voor welke regio u de vragen invult, bijvoorbeeld de regio waar het meeste speelt wat betreft voortijdig schoolverlaten of jongeren in kwetsbare posities. Alle vragen die volgen hebben betrekking op de regio die u hier kiest.</em>',
  tooltip: rmcregioitje,
  options: rmcregioarray
}, {
  id: :v3,
  hidden: true,
  type: :dropdown,
  label: 'RMC-regio',
  title: 'Bij welke RMC-regio bent u werkzaam?<br><em>N.B.: Indien u betrokken bent bij meerdere regio’s mag u zelf kiezen voor welke regio u de vragen invult, bijvoorbeeld de regio waar het meeste speelt wat betreft voortijdig schoolverlaten of jongeren in kwetsbare posities. Alle vragen die volgen hebben betrekking op de regio die u hier kiest.</em>',
  tooltip: rmcregioitje,
  options: rmcregioarray
}, {
  id: :v4,
  hidden: true,
  type: :dropdown,
  label: 'arbeidsmarktregio',
  title: 'Bij welke arbeidsmarktregio hoort uw gemeente?<br><em>N.B.: Indien u contactpersoon bent voor meerdere regio’s mag u zelf kiezen voor welke regio u de vragen invult, bijvoorbeeld de regio waar het meeste speelt wat betreft voortijdig schoolverlaten of jongeren in kwetsbare posities. Alle vragen die volgen hebben betrekking op de regio die u hier kiest.</em>',
  tooltip: '<p>Als u het niet zeker weet, kunt u op dit kaartje kijken:</p><img class="auto-resize" data-ratio="1.2" src="/evaluatieonderzoek/arbeidsmarktregios.png">',
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
  title: 'Is uw gemeente een contactgemeente voor de RMC-regio?',
  tooltip: 'Binnen elke RMC-regio is er één gemeente aangewezen als ‘contactgemeente’ voor het terugdringen van voortijdig schoolverlaten en monitoren van jongeren in een kwetsbare positie. Zij coördineren de melding en registratie van voortijdig schoolverlaters door scholen in de regio en organiseren de samenwerking met diverse partijen op het gebied van werk, zorg en onderwijs om een passend traject voor individuele jongeren aan te bieden.',
  options: [
    { title: 'Contactgemeente', shows_questions: %i[v61] },
    'Geen contactgemeente',
    'Weet ik niet'
  ],
  show_otherwise: false
}, {
  section_start: '<div class="divider"></div>',
  type: :raw,
  content: '<p class="flow-text">Onderstaande vragen gaan over wat er veranderd is in de afgelopen twee jaar – de periode nadat er nieuwe beleidsafspraken zijn gemaakt over voortijdig schoolverlaten (VSV) en jongeren in kwetsbare posities. Deze beleidsafspraken zijn gemaakt in 2016 zijn en kunnen als volgt worden samengevat (klik <a href="/evaluatieonderzoek/Onderzoeksinformatie.pdf" target="_blank" rel="noopener noreferrer">hier</a> voor een uitgebreidere beschrijving):</p><ul class="flow-text browser-default"><li>De regionale samenwerking wordt geïntensiveerd en uitgebreid om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie (afkomstig uit entree, praktijkonderwijs (PrO) en voorgezet speciaal onderwijs (VSO)).</li><li>De RMC contactgemeenten hebben de verantwoordelijkheid gekregen voor het opstellen van een vierjarig regionaal plan met maatregelen voor VSV en jongeren in een kwetsbare positie, voor het realiseren van het plan, voor de totstandkoming van de regionale samenwerking, en voor een deel van het regionale budget.</li><li>De RMC afdeling van de gemeenten krijgt een taak erbij: het monitoren van jongeren van 16 en 17, afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs. Daarnaast krijgen zij een taak duidelijker belegd: monitoren van jongeren van 18 tot 23 jaar, afkomstig uit PrO en VSO, wat betreft hun deelname aan werk, dagbesteding of onderwijs</li></ul><p class="flow-text" style="margin-bottom:-40px;margin-top:100px;"><em>Wilt u middels de onderstaande vragen de invloed van de beleidsafspraken van 2016 evalueren?</em></p>'
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
  tooltip: 'Er is een wettelijke basis gecreëerd voor een aantal taken die eerder op basis van de convenanten werden uitgevoerd, om er voor te zorgen dat deze taken structureel worden uitgevoerd. Bijvoorbeeld scholen en gemeenten zijn nu verplicht om samen te komen tot regionale afspraken over de aanpak van VSV en de begeleiding van jongeren in een kwetsbare positie, in samenwerking met het arbeidsmarktdomein (bijv. afdeling werk en inkomen) en partijen uit de zorg, en er is een duidelijke basis voor de financiering van de afgesproken regionale maatregelen.'
}, {
  id: :v13,
  type: :range,
  title: 'Ervaart u een verandering in de kwaliteit van het werk dat u kunt leveren, sinds de invoering van de beleidsmaatregelen in 2016?',
  labels: ['Veel minder kwaliteit', 'Veel meer kwaliteit'],
  tooltip: maatregelitje
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
  tooltip: maatregelitje
}, {
  section_start: '',
  type: :raw,
  content: '<div class="divider"></div><p class="flow-text"><em>Wilt u onderstaande deel-maatregelen op enkele aspecten evalueren?</em></p><p class="flow-text"><strong>Maatregel 1</strong>: de regionale samenwerking wordt geïntensiveerd en uitgebreid om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie, afkomstig uit het praktijkonderwijs en voortgezet speciaal onderwijs. <a onclick="M.toast({html: &#39;Voor deze jongeren moet in de regio een sluitend vangnet zijn tussen gemeenten (RMC en Afdeling Werk &amp; Inkomen), onderwijs (PrO, VSO, VO, MBO), (jeugd)zorg en werkgevers/arbeidsmarktdomein (zoals UWV, jongerenloket, servicepunt arbeid).&#39;, displayLength: 19380});autoResizeImages();"><i class="tooltip flow-text material-icons info-outline">info</i></a></p>'
}, {
  id: :v17,
  type: :range,
  title: 'Heeft u in de praktijk iets gemerkt van de intensivering van de regionale samenwerking om een sluitend vangnet te creëren voor jongeren in een kwetsbare positie?',
  labels: ['Helemaal niks gemerkt', 'Heel veel gemerkt']
}, {
  id: :v18,
  type: :checkbox,
  show_otherwise: false,
  title: 'In hoeverre is er binnen uw regio een sluitend vangnet voor jongeren in een kwetsbare positie?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v18_1] }]
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
  title: 'Hoe ervaart u de kwaliteit van het vangnet voor jongeren in een kwetsbare positie?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v19_1] }]
}, {
  id: :v19_1,
  hidden: false,
  type: :range,
  title: '',
  labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
}, {
  id: :v20,
  type: :range,
  title: 'Hoe <strong>groot</strong> is het gevolg van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel klein', 'Heel groot'],
  tooltip: maatregel1
}, {
  id: :v21,
  type: :range,
  title: '<strong>Wat vindt u</strong> van de gevolgen van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel negatief', 'Heel positief'],
  tooltip: maatregel1
}, {
  id: :v22,
  type: :radio,
  title: 'Zijn er nieuwe partijen toegevoegd aan de (bestuurlijke) samenwerking?',
  options: [
    { title: 'Ja', shows_questions: %i[v23] },
    { title: 'Nee', shows_questions: %i[v24] },
    { title: 'Weet ik niet' }
  ],
  show_otherwise: false
}, {
  id: :v23,
  hidden: true,
  type: :textarea,
  title: 'Welke nieuwe partijen zijn er toegevoegd aan de (bestuurlijke) samenwerking?',
  placeholder: 'Vul hier uw antwoord in'
}, {
  id: :v24,
  hidden: true,
  type: :textarea,
  title: 'Waarom zijn er geen nieuwe partijen toegevoegd aan de (bestuurlijke) samenwerking?',
  placeholder: 'Vul hier uw antwoord in'
}, {
  section_start: maatregel_text + maatregel2,
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
  title: 'In hoeverre is er binnen uw RMC regio een regionaal plan opgesteld?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v26_1] }],
  tooltip: 'Dit zijn meestal vierjarige plannen, maar in sommige regio\'s zijn dit ook eenjarige of tweejarige deelplannen.'
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
  title: 'Hoe ervaart u de kwaliteit van de inhoud van het regionale plan?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v27_1] }]
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
  options: [{ title: 'Weet ik niet', hides_questions: %i[v28_1] }]
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
  options: [{ title: 'Weet ik niet', hides_questions: %i[v29_1] }]
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
  title: 'Hoe groot is het gevolg van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel klein', 'Heel groot'],
  tooltip: maatregel2
}, {
  id: :v31,
  hidden: true,
  type: :range,
  title: 'Wat vindt u van de gevolgen van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel negatief', 'Heel positief'],
  tooltip: maatregel2
}, {
  section_start: maatregel_text + maatregel3,
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
  options: [{ title: 'Weet ik niet', hides_questions: %i[v33_1] }]
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
  options: [{ title: 'Weet ik niet', hides_questions: %i[v34_1] }]
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
  title: 'Hoe groot is het gevolg van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel klein', 'Heel groot'],
  tooltip: maatregel3
}, {
  id: :v36,
  hidden: true,
  type: :range,
  title: 'Wat vindt u van de gevolgen van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel negatief', 'Heel positief'],
  tooltip: maatregel3
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
  section_start: maatregel_text + maatregel4,
  id: :v39,
  hidden: true,
  type: :range,
  title: 'Heeft u in de praktijk iets gemerkt van de verandering in de verantwoordelijkheid voor het regionale budget?',
  labels: ['Helemaal niks gemerkt', 'Heel veel gemerkt']
}, {
  id: :v40,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'In hoeverre worden de budgetten verdeeld tussen de school én de RMC contactgemeente (i.p.v. samengevoegd)?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v40_1] }]
}, {
  id: :v40_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Helemaal samengevoegd', 'Helemaal verdeeld']
}, {
  id: :v41,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'In hoeverre ervaart u door het verdelen van het regionale budget een verandering in verantwoordelijkheid?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v41_1] }]
}, {
  id: :v41_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Veel minder verantwoordelijkheid', 'Veel meer verantwoordelijkheid']
}, {
  id: :v42,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'Hoe ervaart u de kwaliteit van de besteding van het regionale budget?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v42_1] }]
}, {
  id: :v42_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
}, {
  id: :v43,
  hidden: true,
  type: :range,
  title: 'Hoe <strong>groot</strong> is het gevolg van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel klein', 'Heel groot'],
  tooltip: maatregel4
}, {
  id: :v44,
  hidden: true,
  type: :range,
  title: '<strong>Wat vindt u</strong> van de gevolgen van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel negatief', 'Heel positief'],
  tooltip: maatregel4
}, {
  id: :v45,
  hidden: true,
  type: :range,
  title: 'Hoe <strong>groot</strong> is het gevolg van deze maatregel voor de samenwerking in de regio?',
  labels: ['Heel klein', 'Heel groot'],
  tooltip: maatregel4
}, {
  id: :v46,
  hidden: true,
  type: :range,
  title: '<strong>Wat vindt u</strong> van de gevolgen van deze maatregel voor de samenwerking in de regio?',
  labels: ['Heel negatief', 'Heel positief'],
  tooltip: maatregel4
}, {
  section_start: maatregel_text + maatregel5,
  id: :v47,
  hidden: true,
  type: :range,
  title: 'Heeft u in de praktijk iets gemerkt van de toegevoegde taak om jongeren van 16 en 17 jaar en afkomstig uit PrO en VSO te monitoren?',
  labels: ['Helemaal niks gemerkt', 'Heel veel gemerkt']
}, {
  id: :v48,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'In hoeverre monitort de RMC gemeente jongeren van 16 en 17 jaar en afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs (incl. dagbesteding en beschut werk)?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v48_1] }]
}, {
  id: :v48_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Helemaal niet', 'Helemaal wel']
}, {
  id: :v49,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'Hoe ervaart u de kwaliteit van deze monitoring?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v49_1] }]
}, {
  id: :v49_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
}, {
  id: :v50,
  hidden: true,
  type: :range,
  title: 'Hoe <strong>groot</strong> is het gevolg van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel klein', 'Heel groot'],
  tooltip: maatregel5
}, {
  id: :v51,
  hidden: true,
  type: :range,
  title: '<strong>Wat vindt u</strong> van de gevolgen van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel negatief', 'Heel positief'],
  tooltip: maatregel5
}, {
  id: :v52,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'Zijn er volgens u meer of minder jongeren van 16 en 17 jaar en afkomstig uit PrO en VSO succesvol naar <strong>onderwijs</strong> begeleid sinds de invoering van deze maatregel?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v52_1] }],
  tooltip: maatregel5
}, {
  id: :v52_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Veel minder', 'Veel meer']
}, {
  id: :v53,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'Zijn er volgens u meer of minder jongeren van 16 en 17 jaar en afkomstig uit PrO en VSO succesvol naar <strong>werk</strong> begeleid sinds de invoering van deze maatregel?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v53_1] }],
  tooltip: maatregel5
}, {
  id: :v53_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Veel minder', 'Veel meer']
}, {
  section_start: maatregel_text + maatregel6,
  id: :v54,
  hidden: true,
  type: :range,
  title: 'Heeft u in de praktijk iets gemerkt van de duidelijker belegde taak om jongeren van 18 tot 23 jaar en afkomstig uit PrO en VSO te monitoren?',
  labels: ['Helemaal niks gemerkt', 'Heel veel gemerkt']
}, {
  id: :v55,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'In hoeverre monitort de RMC gemeente jongeren van 18 tot 23 jaar en afkomstig uit PrO en VSO wat betreft hun deelname aan werk of onderwijs (incl. dagbesteding en beschut werk)?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v55_1] }]
}, {
  id: :v55_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Helemaal niet', 'Helemaal wel']
}, {
  id: :v56,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'Hoe ervaart u de kwaliteit van deze monitoring?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v56_1] }]
}, {
  id: :v56_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Heel lage kwaliteit', 'Heel hoge kwaliteit']
}, {
  id: :v57,
  hidden: true,
  type: :range,
  title: 'Hoe <strong>groot</strong> is het gevolg van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel klein', 'Heel groot'],
  tooltip: maatregel6
}, {
  id: :v58,
  hidden: true,
  type: :range,
  title: '<strong>Wat vindt u</strong> van de gevolgen van deze maatregel voor uw dagelijkse werkzaamheden?',
  labels: ['Heel negatief', 'Heel positief'],
  tooltip: maatregel6
}, {
  id: :v59,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'Zijn er volgens u meer of minder jongeren van 18 tot 23 jaar en afkomstig uit PrO en VSO succesvol naar <strong>onderwijs</strong> begeleid sinds de invoering van deze maatregel?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v59_1] }],
  tooltip: maatregel6
}, {
  id: :v59_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Veel minder', 'Veel meer']
}, {
  id: :v60,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'Zijn er volgens u meer of minder jongeren van 18 tot 23 jaar en afkomstig uit PrO en VSO succesvol naar <strong>werk</strong> begeleid sinds de invoering van deze maatregel?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v60_1] }],
  tooltip: maatregel6
}, {
  id: :v60_1,
  hidden: true,
  type: :range,
  title: '',
  labels: ['Veel minder', 'Veel meer']
}, {
  section_start: '',
  type: :raw,
  content: '<div class="divider"></div><p class="flow-text"><strong>Financiële situatie</strong></p>'
}, {
  id: :v61,
  type: :radio,
  title: 'Zijn de huidige financiële middelen voor het voorkomen van VSV en het begeleiden van jongeren in een kwetsbare positie toereikend voor de uitvoering van uw taken?',
  options: [
    { title: 'Ja' },
    { title: 'Nee', shows_questions: %i[v62 v62_1 v63] }
  ],
  show_otherwise: false,
  hidden: true
}, {
  id: :v62,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'Welk bedrag komt u ongeveer tekort voor de uitvoering van de taken?',
  options: [{ title: 'Weet ik niet', hides_questions: %i[v62_1] }]
}, {
  id: :v62_1,
  hidden: true,
  type: :textfield,
  title: '',
  placeholder: 'Vul een bedrag in',
  pattern: '^(€ *)?[,.]?[0-9][0-9.,]{0,13}-{0,2}$',
  hint: 'Vul a.u.b. een bedrag in euros in. bv.: 300.000',
  required: true
}, {
  id: :v63,
  hidden: true,
  type: :textarea,
  title: 'Welke taken kunt u niet of moeilijk uitvoeren door de ontoereikende financiële situatie?',
  placeholder: 'Vul hier uw antwoord in'
}, {
  id: :v64,
  hidden: true,
  type: :range,
  title: 'Hoe ervaart u de verdeling van de gelden over contactgemeente en contactschool?',
  labels: ['Heel negatief', 'Heel positief']
}, {
  section_start: '',
  type: :raw,
  content: '<div class="divider"></div><p class="flow-text"><strong>Samenwerking</strong></p>'
}, {
  id: :v65,
  type: :checkbox,
  show_otherwise: true,
  title: 'Met wie heeft u in de afgelopen twee jaar samengewerkt in de aanpak van VSV en het begeleiden van jongeren in een kwetsbare positie?',
  options: [
    { title: 'Gemeente, afdeling RMC', shows_questions: %i[v66_gem_rmc v67_gem_rmc] },
    { title: 'Gemeente, afdeling werk en inkomen', shows_questions: %i[v66_gem_dwi v67_gem_dwi] },
    { title: 'Scholen', shows_questions: %i[v66_scholen v67_scholen] },
    { title: '(Jeugd)zorg', shows_questions: %i[v66_zorg v67_zorg] },
    { title: 'Werkgevers / Arbeidsmarktdomein (zoals UWV, jongerenloket, servicepunt arbeid)', shows_questions: %i[v66_werkgvr v67_werkgvr] },
    { title: 'Ministerie van Onderwijs, Cultuur en Wetenschap', shows_questions: %i[v66_minist v67_minist] }
  ]
}, {
  id: :v66_gem_rmc,
  hidden: true,
  type: :range,
  title: 'Hoe intensief heeft u samengewerkt met <strong>Gemeente, afdeling RMC</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Helemaal niet samengewerkt', 'Heel intensief samengewerkt']
}, {
  id: :v67_gem_rmc,
  hidden: true,
  type: :range,
  title: 'Hoe ervaart u de kwaliteit van de samenwerking met <strong>Gemeente, afdeling RMC</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Heel negatief', 'Heel positief']
}, {
  id: :v66_gem_dwi,
  hidden: true,
  type: :range,
  title: 'Hoe intensief heeft u samengewerkt met <strong>Gemeente, afdeling werk en inkomen</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Helemaal niet samengewerkt', 'Heel intensief samengewerkt']
}, {
  id: :v67_gem_dwi,
  hidden: true,
  type: :range,
  title: 'Hoe ervaart u de kwaliteit van de samenwerking met <strong>Gemeente, afdeling werk en inkomen</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Heel negatief', 'Heel positief']
}, {
  id: :v66_scholen,
  hidden: true,
  type: :range,
  title: 'Hoe intensief heeft u samengewerkt met <strong>Scholen</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Helemaal niet samengewerkt', 'Heel intensief samengewerkt']
}, {
  id: :v67_scholen,
  hidden: true,
  type: :range,
  title: 'Hoe ervaart u de kwaliteit van de samenwerking met <strong>Scholen</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Heel negatief', 'Heel positief']
}, {
  id: :v66_zorg,
  hidden: true,
  type: :range,
  title: 'Hoe intensief heeft u samengewerkt met <strong>(Jeugd)zorg</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Helemaal niet samengewerkt', 'Heel intensief samengewerkt']
}, {
  id: :v67_zorg,
  hidden: true,
  type: :range,
  title: 'Hoe ervaart u de kwaliteit van de samenwerking met <strong>(Jeugd)zorg</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Heel negatief', 'Heel positief']
}, {
  id: :v66_werkgvr,
  hidden: true,
  type: :range,
  title: 'Hoe intensief heeft u samengewerkt met <strong>Werkgevers / Arbeidsmarktdomein (zoals UWV, jongerenloket, servicepunt arbeid)</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Helemaal niet samengewerkt', 'Heel intensief samengewerkt']
}, {
  id: :v67_werkgvr,
  hidden: true,
  type: :range,
  title: 'Hoe ervaart u de kwaliteit van de samenwerking met <strong>Werkgevers / Arbeidsmarktdomein (zoals UWV, jongerenloket, servicepunt arbeid)</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Heel negatief', 'Heel positief']
}, {
  id: :v66_minist,
  hidden: true,
  type: :range,
  title: 'Hoe intensief heeft u samengewerkt met het <strong>Ministerie van Onderwijs, Cultuur en Wetenschap</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Helemaal niet samengewerkt', 'Heel intensief samengewerkt']
}, {
  id: :v67_minist,
  hidden: true,
  type: :range,
  title: 'Hoe ervaart u de kwaliteit van de samenwerking met het <strong>Ministerie van Onderwijs, Cultuur en Wetenschap</strong>, sinds de invoering van de beleidsmaatregelen in 2016?',
  tooltip: maatregelitje,
  labels: ['Heel negatief', 'Heel positief']
}, {
  id: :v68,
  type: :range,
  title: 'In welke mate heeft u de afgelopen twee jaar samengewerkt met partners in de regio met het doel om voortijdig schoolverlaten te verminderen?',
  labels: ['Helemaal niet', 'Heel veel']
}, {
  id: :v68_1,
  type: :textarea,
  title: 'Eventuele toelichting (bij bovenstaand antwoord)',
  placeholder: 'Vul hier een eventuele toelichting in'
}, {
  id: :v69,
  type: :range,
  title: 'Hoe ervaart u de samenwerking met partners in de regio om voortijdig schoolverlaten te verminderen?',
  labels: ['Heel negatief', 'Heel positief']
}, {
  id: :v70,
  type: :range,
  title: 'In welke mate heeft u de afgelopen twee jaar samengewerkt met partners in de regio met het doel om een vangnet te creëren voor jongeren van het PrO en VSO?',
  labels: ['Helemaal niet', 'Heel veel']
}, {
  id: :v70_1,
  type: :textarea,
  title: 'Eventuele toelichting (bij bovenstaand antwoord)',
  placeholder: 'Vul hier een eventuele toelichting in'
}, {
  id: :v71,
  type: :range,
  title: 'Hoe ervaart u de samenwerking met partners in de regio om een vangnet te creëren voor jongeren van het PrO en VSO?',
  labels: ['Heel negatief', 'Heel positief']
}, {
  id: :v72,
  type: :radio,
  title: 'Zijn er voor zover u weet sinds de invoering van de beleidsmaatregelen in 2016 nieuwe samenwerkingspartners bij gekomen?',
  options: [
    { title: 'Ja', shows_questions: %i[v73] },
    { title: 'Nee' }
  ],
  show_otherwise: false
}, {
  id: :v73,
  hidden: true,
  type: :textarea,
  title: 'Kunt u kort omschrijven wie dit zijn en waarin u samenwerkt?',
  placeholder: 'Vul hier uw antwoord in'
}, {
  id: :v74,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'Kunt u kort de belangrijkste taken noemen die u uitvoert in samenwerking met de RMC afdelingen van gemeenten in uw regio?',
  options: [{ title: 'Niet van toepassing', hides_questions: %i[v74_1] }]
}, {
  id: :v74_1,
  hidden: true,
  type: :textarea,
  title: '',
  placeholder: 'Vul hier uw antwoord in'
}, {
  id: :v75,
  hidden: true,
  type: :checkbox,
  show_otherwise: false,
  title: 'Kunt u kort de belangrijkste taken noemen die u uitvoert in samenwerking met de afdeling werk en inkomen of andere arbeidsmarktdomeinen van gemeenten in uw regio?',
  options: [{ title: 'Niet van toepassing', hides_questions: %i[v75_1] }],
  tooltip: 'In sommige gemeenten wordt dit anders genoemd of is dit anders ingedeeld, bijv. als sociaal domein, participatie, of UWV, het gaat hier om gemeentelijke afdelingen verantwoordelijk voor onder andere arbeidsparticipatie bij jongeren.'
}, {
  id: :v75_1,
  hidden: true,
  type: :textarea,
  title: '',
  placeholder: 'Vul hier uw antwoord in'
}, {
  section_start: '',
  type: :raw,
  content: '<div class="divider"></div><p class="flow-text"><strong>Vooruitblik en Decentralisatie-uitkering</strong></p>'
}, {
  id: :v76,
  type: :textarea,
  title: 'Heeft u nog advies of opmerkingen voor landelijk beleid om uw <strong>dagelijkse werkzaamheden</strong> te ondersteunen?',
  placeholder: 'Vul hier uw antwoord in'
}, {
  id: :v77,
  type: :textarea,
  title: 'Heeft u nog advies of opmerkingen voor landelijk beleid om de <strong>samenwerking in uw regio</strong> verder te verbeteren?',
  placeholder: 'Vul hier uw antwoord in'
}, {
  id: :v78,
  type: :textarea,
  title: 'Heeft u nog advies of opmerkingen voor landelijk beleid wat betreft de <strong>verdeling van financiële middelen</strong>?',
  placeholder: 'Vul hier uw antwoord in'
}, {
  id: :v79,
  hidden: true,
  type: :radio,
  title: 'Momenteel wordt een deel van het regionale budget in de vorm van een specifieke uitkering (geoormerkt geld) uitgekeerd.<br>Is het volgens u mogelijk om deze specifieke uitkering van het regionale budget om te zetten in een decentralisatie-uitkering (niet geoormerkt)?',
  options: [
    { title: 'Ja' },
    { title: 'Nee' },
    { title: 'Weet ik niet' }
  ],
  show_otherwise: false,
  tooltip: 'Een deel van het regionale budget voor VSV en jongeren in een kwetsbare positie komt via de contactgemeente naar de regio in de vorm van een specifieke uitkering met een specifiek doel (geoormerkt). Bij een decentralisatie-uitkering komt het bij de contactgemeente binnen ‘op de grote hoop’, via het Gemeentefonds.'
}, {
  id: :v80,
  hidden: true,
  type: :range,
  title: 'In hoeverre is een decentralisatie-uitkering wenselijk?',
  labels: ['Helemaal niet wenselijk', 'Heel wenselijk']
}, {
  id: :v81,
  hidden: true,
  type: :textarea,
  title: 'Wat voor gevolgen zou dat hebben voor uw werkzaamheden als RMC-coördinator?',
  placeholder: 'Vul hier uw antwoord in'
}, {
  id: :v82,
  hidden: true,
  type: :textarea,
  title: 'Wat voor gevolgen zou dat volgens u hebben voor de samenwerking met uw partners in de regio?',
  placeholder: 'Vul hier uw antwoord in'
}, {
  section_start: '<div class="divider"></div><p class="flow-text"><strong>Evaluatie register vrijstellingen leerplichtwet</strong></p><p class="flow-text"><em>De volgende vragen gaan over de vrijstelling van jongeren van de leerplicht (op grond van de leerplichtwet artikel 3, 5 en 15).</em></p>',
  id: :v83,
  hidden: true,
  type: :range,
  title: 'In hoeverre heeft het registreren van vrijstellingen eraan bijgedragen dat de betreffende jongeren niet meer onterecht als VSV-er werden benaderd?',
  labels: ['Helemaal geen bijdrage', 'Heel veel bijdrage']
}, {
  id: :v84,
  hidden: true,
  type: :radio,
  title: 'Komt u nog steeds jongeren tegen die een vrijstelling hebben, maar toch als VSV-er worden geteld?',
  options: [
    { title: 'Ja', shows_questions: %i[v85] },
    { title: 'Nee' }
  ],
  show_otherwise: false
}, {
  id: :v85,
  hidden: true,
  type: :textarea,
  title: 'Kunt u dit toelichten?',
  placeholder: 'Vul hier uw antwoord in'
}, {
  section_start: '<div class="divider"></div>',
  id: :v86,
  type: :textarea,
  title: 'Indien u nog aanvullende op- of aanmerkingen heeft over de aanpak van voortijdig schoolverlaten en jongeren in een kwetsbare positie dan kunt u die hier benoemen.',
  placeholder: 'Vul hier uw antwoord in'
}], scores: [] }
evaluatie.title = 'De huidige aanpak van voortijdig schoolverlaten en jongeren in kwetsbare posities: een evaluatie van het nationale beleid'
evaluatie.save!
