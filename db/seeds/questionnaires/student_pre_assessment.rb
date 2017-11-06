nm_name1 = 'voormeting studenten'
nameting1 = Questionnaire.find_by_name(nm_name1)
nameting1 ||= Questionnaire.new(name: nm_name1)
nameting1.content = [{
                       type: :raw,
                       content: 'Voormeting u-can-act'
                     }, {
                       id: :v1,
                       type: :radio,
                       title: 'Wat is je geslacht?',
                       options: ['Man', 'Vrouw', 'Zeg ik liever niet']
                     }, {
                       id: :v2,
                       type: :textfield,
                       title: 'Wat is je geboortedatum? (dd-mm-jjjj)'
                     }, {
                       id: :v3,
                       type: :textfield,
                       title: 'Wat is op dit moment je woonplaats?'
                     }, {
                       id: :v4,
                       type: :textfield,
                       title: 'Wat is je nationaliteit?'
                     }, {
                       id: :v5,
                       type: :radio,
                       title: 'Heb je op dit moment een partner?',
                       options: ['Nee, ik heb geen relatie',
                                 'Ja, ik heb een partner',
                                 'Het is ingewikkeld',
                                 'Zeg ik liever niet']
                     }, {
                       id: :v6,
                       type: :radio,
                       title: 'Heb je op dit moment kinderen?',
                       options: ['Nee'],
                       otherwise_label: 'Ja, aantal:'
                     }, {
                       id: :v7,
                       type: :textfield,
                       title: 'Wat is de naam van de school waar je op zit?'
                     }, {
                       id: :v8,
                       type: :textfield,
                       title: 'Welke opleiding doe je daar?'
                     }, {
                       id: :v9,
                       type: :radio,
                       title: 'Op welk niveau is deze opleiding?',
                       options: ['MBO niveau 1', 'MBO niveau 2', 'MBO niveau 3', 'MBO niveau 4']
                     }, {
                       id: :v10,
                       type: :textfield,
                       title: 'Hoeveel jaar ben je inmiddels bezig met deze opleiding?'
                     }, {
                       id: :v11,
                       type: :radio,
                       title: 'Wat deed je voordat je aan deze opleiding begon?',
                       options: ['Werken', 'Middelbare school', 'Een andere MBO opleiding']
                     }]
nameting1.title = 'Voormeting'
nameting1.save!
