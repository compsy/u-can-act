# frozen_string_literal: true

title = 'Mindsets'

name = 'KCT Mindsets'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title)
  res = {
    id: id,
    type: :likert,
    title: title,
    show_otherwise: false,
    options: %w[1 2 3 4 5 6]
  }
  res
end

content = [
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
Selecteer voor iedere vraag het getal dat het best UW MENING weergeeft.
<ul class="flow-text section-explanation">

<li>
1 = helemaal mee oneens
</li>

<li>
2 = mee oneens
</li>

<li>
3 = enigzins mee oneens
</li>

<li>
4 = enigzins mee eens
</li>

<li>
5 = mee eens
</li>

<li>
6 = helemaal mee eens
</li>

</ul>
</p>
'
  },
  create_question(:v1, 'Je hebt bepaalde kwaliteiten als operator, en je kunt daar niet echt veel aan veranderen.'),
  create_question(:v2, 'Sommigen worden nooit een goede operator, hoe erg ze zich er ook voor inspannen.'),
  create_question(:v3, 'Je kwaliteiten als operator zijn iets van jezelf waaraan je niet veel kunt veranderen.'),
  create_question(:v4, 'Iedereen die zich ervoor wil inzetten, kan een goede operator worden.'),
  create_question(:v5, 'Je kunt misschien wel wat bijleren, maar als je geen aanleg hebt, kun je nooit een goede operator worden.'),
  create_question(:v6, 'Je kwaliteiten als operator zijn eerder het resultaat van training en hard werken dan van aanleg.')
]

questionnaire.content = content
questionnaire.title = title
questionnaire.save!
