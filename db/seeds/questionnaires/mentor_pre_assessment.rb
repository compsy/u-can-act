nm_name1 = 'voormeting mentoren'
nameting1 = Questionnaire.find_by_name(nm_name1)
nameting1 ||= Questionnaire.new(name: nm_name1)
nameting1.content = [{
                       type: :raw,
                       content: 'voormeting mentoren'
                     }]
nameting1.title = 'Voormeting begeleiders'
nameting1.save!
