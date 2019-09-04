# frozen_string_literal: true

title = 'Temperament'

name = 'KCT Temperament'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title)
  res = {
    id: id,
    type: :likert,
    title: title,
    show_otherwise: false,
    options: %w[1 2 3 4 5 6 7]
  }
  res
end

content = [
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
Geef aan in hoeverre je het eens of oneens bent met elk van de volgende stellingen.
<ul class="flow-text section-explanation">

<li>
1 = helemaal mee oneens
</li>

<li>
2 = mee oneens
</li>

<li>
3 = merendeel mee oneens
</li>

<li>
4 = neutraal
</li>

<li>
5 = merendeel mee eens
</li>

<li>
6 = mee eens
</li>

<li>
7 = helemaal mee eens
</ul>
</p>
'
  },
  create_question(:v1, 'Van nature ben ik een erg nerveus persoon.'),
  create_question(:v2, 'Nadenken over de dingen die ik echt wil geeft me energie.'),
  create_question(:v3, 'Er is niet veel voor nodig om me aan het piekeren te zetten.'),
  create_question(:v4, 'Als ik een mogelijkheid zie voor iets wat ik leuk vind, dan ben ik meteen enthousiast.'),
  create_question(:v5, 'Er is niet veel voor nodig om me enthousiast en gemotiveerd te krijgen.'),
  create_question(:v6, 'Ik ervaar angst en vrees zeer intens.'),
  create_question(:v7, 'Ik reageer erg sterk op negatieve ervaringen.'),
  create_question(:v8, 'Ik ben altijd op zoek naar positieve mogelijkheden en ervaringen.'),
  create_question(:v9, 'Wanneer iets vervelends kan gebeuren, dan heb ik een sterke drang om dit te ontlopen.'),
  create_question(:v10, 'Goede dingen die me overkomen hebben een sterke invloed op mij.'),
  create_question(:v11, 'Als ik iets wil, dan heb ik een sterke drang om dat ook te realiseren.'),
  create_question(:v12, 'Het kost me weinig moeite om me in te beelden dat mij nare dingen zouden kunnen overkomen.')
]

questionnaire.content = content
questionnaire.title = title
questionnaire.save!
