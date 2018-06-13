# frozen_string_literal: true

nm_name1 = 'nameting studenten'
nameting1 = Questionnaire.find_by_name(nm_name1)
nameting1 ||= Questionnaire.new(name: nm_name1)
nameting1.key = File.basename(__FILE__)[0...-3]
nameting1.content = [{
  id: :v1,
  type: :radio,
  title: 'Ben je gestopt met school?',
  options: [
    { title: 'Ja', shows_questions: %i[v2 v3] },
    'Nee'
  ],
  show_otherwise: false
}, {
  id: :v2,
  type: :textfield,
  required: true,
  title: 'Wanneer ben je ongeveer gestopt? Als je het niet precies meer weet, vul dan iets in dat zo goed mogelijk in de buurt komt'
}, {
  id: :v3,
  type: :radio,
  title: 'Hoeveel jaar moest je nog ongeveer tot je diploma? ',
  options: ['Minder dan 1 jaar',
            'Een jaar',
            'Twee jaar',
            'Drie jaar'],
  show_otherwise: true
}, {
  id: :v4,
  type: :radio,
  title: 'Zie jij de begeleiding van {{naam_initiatief}} als onderdeel van de school, of vind jij dat de begeleiding van {{naam_initiatief}} los staat van de school?',
  options: ['Minder dan 1 jaar',
            'Een jaar',
            'Twee jaar',
            'Drie jaar'],
  show_otherwise: true
}]
nameting1.title = 'Eindmeting'
nameting1.save!
