# frozen_string_literal: true

title = 'Type motivatie'

name = 'KCT Type motivatie'
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
Waarom vol je de ECO?
<ul class="flow-text section-explanation">

<li>
1 = helemaal mee oneens
</li>

<li>
2 = grotendeels mee oneens
</li>

<li>
3 = enigzins mee oneens
</li>

<li>
4 = niet eens en niet mee oneens
</li>

<li>
5 = enigzins mee eens
</li>

<li>
6 = grotendeels mee eens
</li>

<li>
7 = helemaal mee eens
</li>

</ul>
</p>
'
  },
  create_question(:v1, 'Omdat de ECO de kern weergeeft van de persoon die ik ben.'),
  create_question(:v2, 'Omdat ik het leuk vind om te leren in het kader van de ECO.'),
  create_question(:v3, 'Ik had m\'n redenen om de ECO te volgen, maar nu vraag ik me af of ik er wel mee door moet gaan.'),
  create_question(:v4, 'Omdat mensen om wie ik geef het me kwalijk zouden nemen als ik <i>niet</i> de ECO zou doen.'),
  create_question(:v5, 'Omdat de ECO een manier is om me verder te ontwikkelen.'),
  create_question(:v6, 'Omdat de ECO past bij alle andere dingen die ik belangrijk vind in het leven.'),
  create_question(:v7, 'Omdat ik een slecht gevoel over mijzelf zou hebben als ik de ECO <i>niet</i> zou doen.'),
  create_question(:v8, 'Omdat mensen uit mijn directe omgeving hun afkeuring naar mij zouden uitspreken als ik <i>niet</i> de ECO doe.'),
  create_question(:v9, 'Omdat de ECO een goede manier is om aspecten van mijzelf te ontwikkelen die ik waardevol vind.'),
  create_question(:v10, 'Omdat ik er plezier aan beleef om nieuwe acties en strategieën in de ECO te ontdekken.'),
  create_question(:v11, 'Ik weet het niet meer; ik heb de indruk dat ik niet de kwaliteiten heb om de ECO succesvol te volbrengen.'),
  create_question(:v12, 'Omdat ik een beter gevoel heb over mijzelf als ik de ECO volg.'),
  create_question(:v13, 'Omdat mensen uit mijn directe omgeving laten merken dat ze het waarderen dat ik de ECO doe.'),
  create_question(:v14, 'Omdat het interessant is om te leren hoe ik mijzelf tijdens de ECO kan verbeteren.'),
  create_question(:v15, 'Omdat de ECO één van de beste manieren is om verschillende aspecten van mijzelf te ontwikkelen'),
  create_question(:v16, 'Ik weet het niet meer; ik denk dat de ECO niet echt iets voor mij is.'),
  create_question(:v17, 'Omdat ik door de ECO het leven leidt dat helemaal bij mij past.'),
  create_question(:v18, 'Omdat ik me niet waardevol zou voelen als ik de ECO niet zou doen.')
]

questionnaire.content = content
questionnaire.title = title
questionnaire.save!
