ev_name = 'evaluatieonderzoek'
evaluatie = Questionnaire.find_by_name(ev_name)
evaluatie ||= Questionnaire.new(name: ev_name)
evaluatie.key = File.basename(__FILE__)[0...-3]
evaluatie.content = [{
                       id: :v1,
                       type: :radio,
                       title: 'Wat is jouw hoogst genoten opleiding?',
                       options: ['Geen opleiding (lagere school of basisonderwijs niet afgemaakt)',
                                 'Lager onderwijs (basisonderwijs, speciaal basisonderwijs)',
                                 'Lager of voorbereidend beroepsonderwijs (zoals LTS, LEAO, LHNO, VMBO)',
                                 'Middelbaar algemeen voortgezet onderwijs (zoals MAVO, (M)ULO, MBO-kort, VMBO-t)',
                                 'Middelbaar beroepsonderwijs of beroepsbegeleidend onderwijs (zoals MBO-lang, MTS, MEAO, BOL, BBL, INAS)',
                                 'Hoger algemeen en voorbereidend wetenschappelijk onderwijs (zoals HAVO, VWO, Atheneum, Gymnasium, HBS, MMS)',
                                 'Hoger beroepsonderwijs (zoals HBO, HTS, HEAO, kandidaats wetenschappelijk onderwijs)',
                                 'Wetenschappelijk onderwijs (universiteit) of hoger']
                     }, {
                       id: :v2,
                       type: :textfield,
                       required: true,
                       title: 'Wat is je geboortejaar?',
                       tooltip: 'Noteer je geboortejaar als volgt: jjjj',
                       placeholder: 'jjjj',
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
                     }, {
                       id: :v5,
                       type: :dropdown,
                       title: 'Bij welke RMC-regio hoort uw school? [i: als u het niet zeker weet, kunt u op dit kaartje kijken',
                       label: 'RMC regio',
                       tooltip: 'link naar kaartje',
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
                     }]
evaluatie.title = 'Evaluatieonderzoek'
evaluatie.save!
