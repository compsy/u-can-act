db_title = 'Webapp Jongeren'
db_name2 = 'dagboek studenten 5x per week dinsdag, woensdag, vrijdag'
dagboek2 = Questionnaire.find_by_name(db_name2)
dagboek2 ||= Questionnaire.new(name: db_name2)
dagboek2.key = File.basename(__FILE__)[0...-3]
dagboek_content = [{
                     section_start: 'School',
                     type: :raw,
                     content: '<p class="flow-text section-explanation">De volgende vragen gaan over school en stage. Je antwoorden zijn anoniem en alleen de onderzoekers kunnen ze zien.</p>'
                   }, {
                     id: :v1,
                     type: :radio,
                     title: 'Ben je sinds gisteren naar school en/of stage geweest?',
                     options: [
                       { title: 'Ja', shows_questions: %i[v2 v3 v4 v5 v6 v7] },
                       'Nee'
                     ]
                   }, {
                     id: :v2,
                     hidden: true,
                     type: :range,
                     title: 'Wat heb je sinds gisteren <strong>meegemaakt op school en/of stage?</strong>',
                     labels: ['vooral nare dingen', 'vooral leuke dingen']
                   }, {
                     id: :v3,
                     hidden: true,
                     type: :range,
                     title: 'Had je het gevoel dat je zelf <strong>invloed had op deze gebeurtenissen</strong> op school en/of stage?',
                     labels: ['zelf geen invloed', 'zelf veel invloed']
                   }, {
                     id: :v4,
                     hidden: true,
                     type: :range,
                     title: 'Ben je sinds gisteren vooral <strong>naar school en/of stage gegaan</strong> omdat je het moest of omdat je het zelf wilde?',
                     labels: ['omdat ik moest', 'omdat ik wilde']
                   }, {
                     id: :v5,
                     hidden: true,
                     type: :range,
                     title: '<strong>Hoe goed heb je het</strong> sinds gisteren <strong>gedaan</strong> op school en/of stage?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v6,
                     hidden: true,
                     type: :range,
                     title: 'Kon je sinds gisteren goed <strong>opschieten met vrienden op school en/of stage</strong>?',
                     labels: ['heel slecht', 'heel goed']
                   }, {
                     id: :v7,
                     hidden: true,
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
dagboek2.content = dagboek_content
dagboek2.title = db_title
dagboek2.save!
