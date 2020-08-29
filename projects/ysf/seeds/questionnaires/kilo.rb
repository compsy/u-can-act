# frozen_string_literal: true

title = 'Kilo'

name = 'KCT Kilo'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title, section_end)
  default_options = [
    'Absoluut niet<br> mee eens',
    'Niet<br>mee eens',
    'Deels<br>mee eens',
    'Mee<br>eens',
    'Absoluut<br>mee eens'
  ]

  res = {
    id: id,
    type: :likert,
    title: title,
    options: default_options,
    show_otherwise: false
  }
  res[:section_end] = true if section_end
  res
end

content = [
  {
    type: :raw,
    content: '<p class="flow-text section-explanation">
      Er volgen 10 vragen met uitspraken over persoonlijke doelen en ervaringen.
      Geef bij elke uitspraak aan in welke mate deze in het algemeen op je van toepassing is.
    </p>
    '
  },
  create_question(:v1, "Op momenten van onzekerheid en twijfel heb ik toch meestal de beste verwachtingen.", false),
  create_question(:v2, "Ik kan me gemakkelijk ontspannen.", false),
  create_question(:v3, "Als er iets in mijn leven mis kan gaan, dan gaat het ook mis.", false),
  create_question(:v4, "Ik ben altijd optimistisch over mijn eigen toekomst.", false),
  create_question(:v5, "Ik kan mijn vrienden veel plezier geven.", false),
  create_question(:v6, "Het is belangrijk voor mij actief te blijven.", false),
  create_question(:v7, "Ik verwacht eigenlijk nooit dat de dingen zullen lopen zoals ik graag zou willen dat ze lopen.", false),
  create_question(:v8, "Ik raak niet snel opgewonden.", false),
  create_question(:v9, "Ik reken er meestal niet op dat mij iets goeds zal overkomen.", false),
  create_question(:v10, "Over het algemeen verwacht ik dat me meer goede dingen dan slechte dingen zullen overkomen.", false)
]
questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
