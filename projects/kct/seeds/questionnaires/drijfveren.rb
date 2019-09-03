# frozen_string_literal: true

title = 'Basale drijfveren'

name = 'KCT Drijfveren'
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
<ul class="flow-text section-explanation">

<li>
1 = helemaal niet
</li>

<li>
2 = in zeer geringe mate
</li>

<li>
3 = in enige mate
</li>

<li>
4 = in redelijke mate
</li>

<li>
5 = in sterke mate
</li>

<li>
6 = in zeer sterke mate
</li>

<li>
7 = in extreem sterke mate
</li>

</ul>
<p class="flow-text section-explanation">
<b>In het algemeen heb ik de behoefte ....</b>
</p>
'
  },
  create_question(:v1, '.... om zelf te kunnen beslissen wat ik moet doen om iets gedaan te krijgen.'),
  create_question(:v2, '.... om zelf invloed te hebben op de keuze van mijn activiteiten en taken.'),
  create_question(:v3, '.... om zelf te kunnen bepalen hoe ik iets aanpak.'),
  create_question(:v4, '.... aan vrijheid om dingen te doen zoals ik denk dat goed is.'),
  create_question(:v5, '.... om vertrouwen te hebben in de mensen om me heen.'),
  create_question(:v6, '.... om bij anderen terecht te kunnen als ik ergens mee zit.'),
  create_question(:v7, '.... aan échte vrienden.'),
  create_question(:v8, '.... om me deel te voelen van een team of groep.'),
  create_question(:v9, '.... aan het gevoel dat ik de kennis en vaardigheden heb om dingen goed te kunnen uitvoeren.'),
  create_question(:v10, '.... aan het gevoel vaardig en bekwaam te zijn in wat ik doe.'),
  create_question(:v11, '.... om het vertrouwen te hebben dat ik ook de moeilijke taken tot een goed einde kan brengen.'),
  create_question(:v12, '.... om goed te zijn in de dingen die ik aanpak.'),
  create_question(:v13, '.... aan vaste gewoonten en routines.'),
  create_question(:v14, '.... aan ordening en regelmaat.'),
  create_question(:v15, '.... om precies te weten waar ik aan toe ben.'),
  create_question(:v16, '.... aan duidelijke richtlijnen en principes die ik kan volgen.'),
  create_question(:v17, '.... in een groep actief de leiding te nemen.'),
  create_question(:v18, '.... anderen te zeggen wat zij moeten doen.'),
  create_question(:v19, '.... het voortouw te nemen in een groep.'),
  create_question(:v20, '.... te bepalen wat er gebeurt in een team of groep.'),
  create_question(:v21, '.... me in te zetten voor anderen.'),
  create_question(:v22, '.... iets te betekenen voor anderen.'),
  create_question(:v23, '.... anderen te helpen.'),
  create_question(:v24, '.... zinvolle bijdragen te leveren aan het welzijn van anderen.'),
  create_question(:v25, '.... om aanzien te hebben.'),
  create_question(:v26, '.... om het gevoel te hebben dat mensen tegen me opkijken.'),
  create_question(:v27, '.... aan respect en bewondering.'),
  create_question(:v28, '.... aan status.'),
]

questionnaire.content = content
questionnaire.title = title
questionnaire.save!
