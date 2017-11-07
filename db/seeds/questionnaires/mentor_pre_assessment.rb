vm_name1 = 'voormeting mentoren'
voormeting1 = Questionnaire.find_by_name(vm_name1)
voormeting1 ||= Questionnaire.new(name: vm_name1)
voormeting1.content = [{
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
                         title: 'Wat is je geboortedatum?',
                         tooltip: 'Noteer je geboortedatum als volgt: dd-mm-jjjj',
                         placeholder: 'dd-mm-jjjj',
                       }, {
                         id: :v3,
                         type: :textfield,
                         title: 'Hoeveel jaar heb jij tot nu toe gewerkt in de jongerenbegeleiding?'
                       }, {
                         id: :v4,
                         type: :textfield,
                         title: 'Wat is je nationaliteit?',
                       }]
voormeting1.title = 'Voormeting begeleiders'
voormeting1.save!
