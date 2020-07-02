# frozen_string_literal: true

title = 'Hotel VCO'
name = 'KCT Hotel VCO'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question_five(id, title)
  res = {
    id: id,
    type: :likert,
    title: title,
    show_otherwise: false,
    options: %w[1 2 3 4 5]
  }
  res
end

def create_question_six(id, title)
  res = {
    id: id,
    type: :likert,
    title: title,
    show_otherwise: false,
    options: %w[1 2 3 4 5 6]
  }
  res
end

def create_question_seven(id, title)
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
  #
  # Mindsets
  #
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
Selecteer voor iedere vraag het getal dat het best JOUW MENING weergeeft.
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
  create_question_six(:v1, 'Je hebt bepaalde kwaliteiten als operator, en je kunt daar niet echt veel aan veranderen.'),
  create_question_six(:v2, 'Sommigen worden nooit een goede operator, hoe erg ze zich er ook voor inspannen.'),
  create_question_six(:v3, 'Je kwaliteiten als operator zijn iets van jezelf waaraan je niet veel kunt veranderen.'),
  create_question_six(:v4, 'Iedereen die zich ervoor wil inzetten, kan een goede operator worden.'),
  create_question_six(:v5, 'Je kunt misschien wel wat bijleren, maar als je geen aanleg hebt, kun je nooit een goede operator worden.'),
  create_question_six(:v6, 'Je kwaliteiten als operator zijn eerder het resultaat van training en hard werken dan van aanleg.'),
  #
  # Basale drijfveren
  #
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
  create_question_seven(:v7, '.... om zelf te kunnen beslissen wat ik moet doen om iets gedaan te krijgen.'),
  create_question_seven(:v8, '.... om zelf invloed te hebben op de keuze van mijn activiteiten en taken.'),
  create_question_seven(:v9, '.... om zelf te kunnen bepalen hoe ik iets aanpak.'),
  create_question_seven(:v10, '.... aan vrijheid om dingen te doen zoals ik denk dat goed is.'),
  create_question_seven(:v11, '.... om vertrouwen te hebben in de mensen om me heen.'),
  create_question_seven(:v12, '.... om bij anderen terecht te kunnen als ik ergens mee zit.'),
  create_question_seven(:v13, '.... aan échte vrienden.'),
  create_question_seven(:v14, '.... om me deel te voelen van een team of groep.'),
  create_question_seven(:v15, '.... aan het gevoel dat ik de kennis en vaardigheden heb om dingen goed te kunnen uitvoeren.'),
  create_question_seven(:v16, '.... aan het gevoel vaardig en bekwaam te zijn in wat ik doe.'),
  create_question_seven(:v17, '.... om het vertrouwen te hebben dat ik ook de moeilijke taken tot een goed einde kan brengen.'),
  create_question_seven(:v18, '.... om goed te zijn in de dingen die ik aanpak.'),
  create_question_seven(:v19, '.... aan vaste gewoonten en routines.'),
  create_question_seven(:v20, '.... aan ordening en regelmaat.'),
  create_question_seven(:v21, '.... om precies te weten waar ik aan toe ben.'),
  create_question_seven(:v22, '.... aan duidelijke richtlijnen en principes die ik kan volgen.'),
  create_question_seven(:v23, '.... in een groep actief de leiding te nemen.'),
  create_question_seven(:v24, '.... anderen te zeggen wat zij moeten doen.'),
  create_question_seven(:v25, '.... het voortouw te nemen in een groep.'),
  create_question_seven(:v26, '.... te bepalen wat er gebeurt in een team of groep.'),
  create_question_seven(:v27, '.... me in te zetten voor anderen.'),
  create_question_seven(:v28, '.... iets te betekenen voor anderen.'),
  create_question_seven(:v29, '.... anderen te helpen.'),
  create_question_seven(:v30, '.... zinvolle bijdragen te leveren aan het welzijn van anderen.'),
  create_question_seven(:v31, '.... om aanzien te hebben.'),
  create_question_seven(:v32, '.... om het gevoel te hebben dat mensen tegen me opkijken.'),
  create_question_seven(:v33, '.... aan respect en bewondering.'),
  create_question_seven(:v34, '.... aan status.'),
  #
  # Faalangst
  #
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
Wilt je hieronder aangeven in hoeverre je het met de volgende stellingen eens bent?
<ul class="flow-text section-explanation">

<li>
1 = helemaal mee oneens
</li>

<li>
2 = mee oneens
</li>

<li>
3 = oneens noch eens
</li>

<li>
4 = mee eens
</li>

<li>
5 = helemaal mee eens
</li>

</ul>
</p>
'
  },
  create_question_five(:v35, 'Als ik aan een taak begin en het gaat meteen al niet goed, dan heb ik de neiging om op te geven.'),
  create_question_five(:v36, 'Als ik moet kiezen, dan zal ik eerder een relatief makkelijke taak kiezen dan een taak die ik mogelijk niet aankan.'),
  create_question_five(:v37, 'Een faalervaring versterkt in het algemeen mijn overtuiging dat ik niet over de benodigde vaardigheden beschik.'),
  create_question_five(:v38, 'Vaak bereid ik me goed voor op een taak, maar desondanks gaat het meestal niet goed als de druk te hoog wordt.'),
  create_question_five(:v39, 'Doorgaans werk ik erg hard, maar tevens weet ik dat de kwaliteit van mijn inspanningen nogal eens te wensen overlaat.'),
  create_question_five(:v40, 'Ik denk wel eens dat het beter is om helemaal geen inspanningen te leveren dan om veel inspanningen te leveren en vervolgens te falen.'),
  create_question_five(:v41, 'Wanneer ik met iets moeilijks bezig ben, dan spoken eerdere faalervaringen nogal eens door mijn hoofd.'),
  create_question_five(:v42, 'Ik vermijd vaak lastige taken omdat ik bang ben om fouten te maken.'),
  create_question_five(:v43, 'Vaak heb ik het gevoel dat ik een bepaalde taak wel aankan, maar door de druk van het moment slaag ik er uiteindelijk toch niet in om mijn niveau te halen.'),
  #
  # Type motivatie
  #
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
Waarom volg je de VCO?
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
  create_question_seven(:v44, 'Omdat de VCO de kern weergeeft van de persoon die ik ben.'),
  create_question_seven(:v45, 'Omdat ik het leuk vind om te leren in het kader van de VCO.'),
  create_question_seven(:v46, 'Ik had m\'n redenen om de VCO te volgen, maar nu vraag ik me af of ik er wel mee door moet gaan.'),
  create_question_seven(:v47, 'Omdat mensen om wie ik geef het me kwalijk zouden nemen als ik <i>niet</i> de VCO zou doen.'),
  create_question_seven(:v48, 'Omdat de VCO een manier is om me verder te ontwikkelen.'),
  create_question_seven(:v49, 'Omdat de VCO past bij alle andere dingen die ik belangrijk vind in het leven.'),
  create_question_seven(:v50, 'Omdat ik een slecht gevoel over mijzelf zou hebben als ik de VCO <i>niet</i> zou doen.'),
  create_question_seven(:v51, 'Omdat mensen uit mijn directe omgeving hun afkeuring naar mij zouden uitspreken als ik <i>niet</i> de VCO doe.'),
  create_question_seven(:v52, 'Omdat de VCO een goede manier is om aspecten van mijzelf te ontwikkelen die ik waardevol vind.'),
  create_question_seven(:v53, 'Omdat ik er plezier aan beleef om nieuwe acties en strategieën in de VCO te ontdekken.'),
  create_question_seven(:v54, 'Ik weet het niet meer; ik heb de indruk dat ik niet de kwaliteiten heb om de VCO succesvol te volbrengen.'),
  create_question_seven(:v55, 'Omdat ik een beter gevoel heb over mijzelf als ik de VCO volg.'),
  create_question_seven(:v56, 'Omdat mensen uit mijn directe omgeving laten merken dat ze het waarderen dat ik de VCO doe.'),
  create_question_seven(:v57, 'Omdat het interessant is om te leren hoe ik mijzelf tijdens de VCO kan verbeteren.'),
  create_question_seven(:v58, 'Omdat de VCO één van de beste manieren is om verschillende aspecten van mijzelf te ontwikkelen'),
  create_question_seven(:v59, 'Ik weet het niet meer; ik denk dat de VCO niet echt iets voor mij is.'),
  create_question_seven(:v60, 'Omdat ik door de VCO het leven leidt dat helemaal bij mij past.'),
  create_question_seven(:v61, 'Omdat ik me niet waardevol zou voelen als ik de VCO niet zou doen.'),
  #
  # Approach-avoidance temperament
  #
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
  create_question_seven(:v62, 'Van nature ben ik een erg nerveus persoon.'),
  create_question_seven(:v63, 'Nadenken over de dingen die ik echt wil geeft me energie.'),
  create_question_seven(:v64, 'Er is niet veel voor nodig om me aan het piekeren te zetten.'),
  create_question_seven(:v65, 'Als ik een mogelijkheid zie voor iets wat ik leuk vind, dan ben ik meteen enthousiast.'),
  create_question_seven(:v66, 'Er is niet veel voor nodig om me enthousiast en gemotiveerd te krijgen.'),
  create_question_seven(:v67, 'Ik ervaar angst en vrees zeer intens.'),
  create_question_seven(:v68, 'Ik reageer erg sterk op negatieve ervaringen.'),
  create_question_seven(:v69, 'Ik ben altijd op zoek naar positieve mogelijkheden en ervaringen.'),
  create_question_seven(:v70, 'Wanneer iets vervelends kan gebeuren, dan heb ik een sterke drang om dit te ontlopen.'),
  create_question_seven(:v71, 'Goede dingen die me overkomen hebben een sterke invloed op mij.'),
  create_question_seven(:v72, 'Als ik iets wil, dan heb ik een sterke drang om dat ook te realiseren.'),
  create_question_seven(:v73, 'Het kost me weinig moeite om me in te beelden dat mij nare dingen zouden kunnen overkomen.'),
]

questionnaire.content = content
questionnaire.title = title
questionnaire.save!
