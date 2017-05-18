# frozen_string_literal: true

puts 'Generating questionnaires - Started'

dagboekvragenlijst = Questionnaire.find_by_name('Dagboekvragenlijst Studenten')
dagboekvragenlijst ||= Questionnaire.new(name: 'Dagboekvragenlijst Studenten')
dagboek_content = [{
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
                     labels: ['Geen vertrouwen', 'Veel vertrouwen']
                   }, {
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
                     labels: ['niet prettig', 'heel prettig']
                   }, {
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
                     labels: ['Niet goed geholpen', 'Heel goed geholpen']
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

puts 'Generating questionnaires - Finished'
