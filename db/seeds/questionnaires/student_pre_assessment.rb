nm_name1 = 'voormeting studenten'
nameting1 = Questionnaire.find_by_name(nm_name1)
nameting1 ||= Questionnaire.new(name: nm_name1)
nameting1.content = [{
                       type: :raw,
                       content: 'voormeting studenten'
                     }]
nameting1.title = 'Voormeting'
nameting1.save!
