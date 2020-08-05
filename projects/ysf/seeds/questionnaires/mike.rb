# frozen_string_literal: true

title = 'Mike'

name = 'KCT Mike'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title)
  res = {
    id: id,
    type: :likert,
    title: title,
    show_otherwise: false,
    options: %w[1 2 3 4 5]
  }
  res
end

content = [
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
In deze vragenlijst worden een aantal uitspraken gedaan wordt waar mensen vaak verschillend over denken.
Het is de bedoeling dat je voor elke uitspraak aangeeft in hoeverre je het met de uitspraak eens bent.
De vragenlijst bestaat uit vijf onderdelen.
Voor elk onderdeel wordt een aparte instructie gegeven.
</p>

<p class="flow-text section-explanation">
Het is belangrijk dat je bij het invullen steeds afgaat op je eerste indruk en dat je hiervoor niet teveel tijd neemt.
Er zijn geen goede of foute antwoorden.
Het gaat hier namelijk om je persoonlijke reactie op bepaalde situaties.
</p>
'
  },
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
In het eerste deel van de vragenlijst vragen we je om één of meer lastige situaties en gebeurtenissen in gedachten te nemen bij het beantwoorden van onderstaande uitspraken.
Iedereen maakt wel eens lastige situaties mee.
Te denken valt aan spanningen thuis, moeilijkheden op school, tijdens de opleiding of op het werk en problemen met de gezondheid.
Iedereen heeft zo zijn of haar eigen manier om met dit soort lastige situaties om te gaan.
</p>

<p class="flow-text section-explanation">
Selecteer in hoeverre onderstaande reacties kenmerkend zijn voor je in een probleemsituatie, de betekenis van de cijfers 1 tot en met 5 is als volgt:
<ul class="flow-text section-explanation">

<li>
1 = helemaal niet van toepassing
</li>

<li>
2 = niet van toepassing
</li>

<li>
3 = neutraal
</li>

<li>
4 = van toepassing
</li>

<li>
5 = helemaal van toepassing
</li>

</ul>
</p>
'
  },
  {
    section_start: 'Hoe gaat je in het algemeen om met lastige situaties?',
    id: :v1,
    type: :likert,
    title: 'Ik doe iets zodat ik er minder aan denk, zoals sporten, slapen of naar muziek luisteren',
    show_otherwise: false,
    options: %w[1 2 3 4 5]
  },
	create_question(:v2, 'Ik maak een actieplan'),
	create_question(:v3, 'Ik denk erover na hoe ik het probleem het beste kan aanpakken'),
	create_question(:v4, 'Ik ga met iemand praten om de situatie beter te begrijpen'),
	create_question(:v5, 'Ik vraag anderen wat zij zouden doen in zo\'n situatie'),
	create_question(:v6, 'Ik probeer ermee te leven'),
	create_question(:v7, 'Ik probeer de humor van het probleem te zien'),
	create_question(:v8, 'Ik doe iets anders om mijzelf af te leiden'),
	create_question(:v9, 'Ik denk na over het probleem om het te kunnen begrijpen'),
	create_question(:v10, 'Ik bespreek mijn gevoelens met iemand'),
	create_question(:v11, 'Ik maak grappen over het probleem'),
	create_question(:v12, 'Ik probeer de ervaring te gebruiken om mijn eigen grenzen te verleggen'),
	create_question(:v13, 'Ik denk na over wat ik er van kan leren'),
	create_question(:v14, 'Ik probeer de situatie te relativeren'),
	create_question(:v15, 'Ik accepteer het probleem zoals het is'),
	create_question(:v16, 'Ik vraag anderen advies over wat ik kan doen'),
	create_question(:v17, 'Ik probeer de positieve aspecten van de situatie te zien'),
	create_question(:v18, 'Ik denk na over de situatie voordat ik actie onderneem'),
	create_question(:v19, 'Ik zoek afleiding in andere gedachten of bezigheden'),
	create_question(:v20, 'Ik zoek naar mogelijkheden om me verder te ontwikkelen'),
	create_question(:v21, 'Ik probeer de situatie van een positieve kant te bekijken'),
	create_question(:v22, 'Ik probeer steun te vinden bij vrienden of collega\'s'),
	create_question(:v23, 'Ik accepteer dat het is gebeurd en dat er niets aan gedaan kan worden'),
	create_question(:v24, 'Ik denk zorgvuldig na over de stappen die genomen moeten worden'),
	create_question(:v25, 'Ik maak een lijst van taken die echt belangrijk zijn'),
	create_question(:v26, 'Ik maak het probleem belachelijk'),
	create_question(:v27, 'Ik probeer op een andere manier naar het probleem te kijken'),
	create_question(:v28, 'Ik probeer emotionele steun te krijgen van iemand'),
	create_question(:v29, 'Ik probeer iets te leren van de ervaring'),
	create_question(:v30, 'Ik probeer altijd aan iets grappigs te denken om mij op te vrolijken'),
	create_question(:v31, 'Ik probeer de positieve kanten van een tegenslag te zien'),
	create_question(:v32, 'Ik probeer te wennen aan het idee dat het gebeurd is'),
	create_question(:v33, 'Ik probeer de grappige kant van de situatie te zien'),
	create_question(:v34, 'Ik accepteer het feit dat het gebeurd is'),
	create_question(:v35, 'Ik zoek naar iets goeds in wat er gebeurd is'),
	create_question(:v36, 'Ik probeer als persoon te groeien als gevolg van de situatie'),
	create_question(:v37, 'Ik kan geen grappen maken als ik problemen heb'),
	create_question(:v38, 'Het is moeilijk voor mij om het probleem te accepteren'),
	create_question(:v39, 'Ik vind het moeilijk om te lachen om mijn problemen'),
  {
    id: :v40,
    type: :likert,
    title: 'Ik zie bij tegenslag vooral de slechte kanten',
    show_otherwise: false,
    options: %w[1 2 3 4 5],
    section_end: true
  },
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
In het tweede onderdeel van de vragenlijst wordt een aantal uitspraken gedaan over hoe je in het algemeen in het leven staat.
Het kan daarbij gaan over angstwekkende, stressvolle en/of emotionele gebeurtenissen of bijvoorbeeld het omgaan met andere mensen.<br><br>

Selecteer bij elke uitspraak in hoeverre je het eens of oneens bent met de onderstaande uitspraken, de betekenis van de cijfers 1 tot en met 5 is als volgt:

<ul class="flow-text section-explanation">

<li>
1 = helemaal mee oneens
</li>

<li>
2 = mee oneens
</li>

<li>
3 = neutraal
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
  {
    section_start: 'Hoe sta je over het algemeen in het leven?',
    id: :v41,
    type: :likert,
    title: 'Ik bespreek bijna nooit mijn problemen met anderen',
    show_otherwise: false,
    options: %w[1 2 3 4 5]
  },
	create_question(:v42, 'Als iemand die ik ken zich ongelukkig voelt, voel ik zelf bijna zijn of haar pijn'),
	create_question(:v43, 'Ik voel tranen opkomen als ik anderen zie huilen'),
	create_question(:v44, 'Zelfs in crisissituaties blijf ik rustig'),
	create_question(:v45, 'Ik word erg emotioneel als iemand die belangrijk voor mij is een lange tijd weggaat'),
	create_question(:v46, 'Na een pijnlijke ervaring heb ik iemand nodig om mij te troosten'),
	create_question(:v47, 'Ik word bang als ik in slecht weer moet reizen'),
	create_question(:v48, 'Wanneer ik over iets inzit, wil ik het liefst met iemand over mijn zorgen praten'),
	create_question(:v49, 'Ik heb zelden of nooit slaapproblemen door stress of angst'),
	create_question(:v50, 'Ik maak me veel minder zorgen dan de meeste mensen'),
	create_question(:v51, 'Ik maak me soms zorgen om dingen die niet belangrijk zijn'),
	create_question(:v52, 'Moeilijke situaties kan ik aan zonder emotionele steun van anderen nodig te hebben'),
	create_question(:v53, 'Als het gaat om fysiek gevaar, ben ik angstig'),
	create_question(:v54, 'Ik heb er geen moeite mee om gevaarlijk werk te doen'),
	create_question(:v55, 'Ik word erg gespannen als ik moet wachten op een belangrijke beslissing'),
	create_question(:v56, 'Ik word niet snel emotioneel, zelfs niet in situaties waarin anderen erg verdrietig worden'),
	create_question(:v57, 'Ik weet hoe andere culturen kunnen verschillen van de mijne'),
	create_question(:v58, 'Als er iets fout kan gaan voor mij, dan zal het ook gebeuren'),
	create_question(:v59, 'Ik verwacht bijna nooit dat dingen gaan zoals ik wil'),
	create_question(:v60, 'Ik vind het makkelijk om nieuwe mensen te ontmoeten'),
	create_question(:v61, 'Ik ben optimistisch over mijn toekomst'),
	create_question(:v62, 'Ik vind het makkelijk om met mensen uit andere culturen om te gaan'),
	create_question(:v63, 'Over het algemeen reken ik erop dat mij meer goede dan slechte dingen zullen overkomen'),
	create_question(:v64, 'Als ik problemen heb met het uitvoeren van mijn werk, vraag ik iemand me te helpen'),
	create_question(:v65, 'Ik maak makkelijk nieuwe vrienden'),
	create_question(:v66, 'Ik vind het prettig om met anderen samen te zijn'),
	create_question(:v67, 'Ik reken er bijna nooit op dat mij goede dingen zullen overkomen'),
	create_question(:v68, 'Ik vraag makkelijk om hulp'),
	create_question(:v69, 'In onzekere tijden verwacht ik er het beste van'),
	create_question(:v70, 'Ik heb geen enkel probleem om samen te werken met iemand met een andere culturele achtergrond'),
	create_question(:v71, 'Als ik het emotioneel zwaar heb, vertel ik dit aan anderen'),
	create_question(:v72, 'Zelfs als ik onder grote druk sta, blijf ik kalm'),
	create_question(:v73, 'Ik heb niet veel tijd nodig om te herstellen van een stressvolle situatie'),
	create_question(:v74, 'Ik red me meestal zonder veel moeite uit moeilijke situaties'),
	create_question(:v75, 'Ik heb vertrouwen in mijn eigen vaardigheden'),
	create_question(:v76, 'Ik doe er niet lang over om tegenslagen in mijn leven boven te komen'),
	create_question(:v77, 'Ik kan me concentreren onder druk'),
	create_question(:v78, 'Ik herstel snel na ziekte of tegenslag'),
	create_question(:v79, 'Ik lever een bijdrage aan het succes van mijn groep'),
	create_question(:v80, 'Ik denk dat ik in een crisissituatie mijn werk naar behoren kan uitvoeren'),
	create_question(:v81, 'Ik kan goed omgaan met vervelende gevoelens'),
	create_question(:v82, 'Ik vind het makkelijk mijn leven weer op te pakken als er iets vervelends gebeurd is'),
  {
    id: :v83,
    type: :likert,
    title: 'Ik heb de vaardigheden die nodig zijn om mijn taken adequaat uit te voeren',
    show_otherwise: false,
    options: %w[1 2 3 4 5],
    section_end: true
  },
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
In het derde onderdeel van de vragenlijst wordt een aantal eigenschappen en/of gedragingen gegeven.
Het kan daarbij bijvoorbeeld gaan over hoe je over jezelf denkt.
Selecteer bij elke uitspraak in welke mate je vindt dat de uitspraken op je van toepassing zijn, de betekenis van de cijfers 1 tot en met 5 is als volgt:

<ul class="flow-text section-explanation">

<li>
1 = helemaal mee oneens
</li>

<li>
2 = mee oneens
</li>

<li>
3 = neutraal
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
  {
    section_start: 'Hoe denkt je na over jezelf?',
    id: :v84,
    type: :likert,
    title: 'Van nadenken over mijn gedachten raak ik alleen maar meer in de war',
    show_otherwise: false,
    options: %w[1 2 3 4 5]
  },
	create_question(:v85, 'Ik ben er niet echt in geïnteresseerd om mijn gedrag volledig te analyseren'),
	create_question(:v86, 'Ik merk vaak bij mijzelf dat ik een bepaald gevoel heb, maar waar het vandaan komt weet ik meestal niet'),
	create_question(:v87, 'Ik ben vaak in de war over wat ik echt van dingen vind'),
	create_question(:v88, 'Ik denk vaak na over hoe ik tegen zaken aankijk'),
	create_question(:v89, 'Ik vind het vaak moeilijk om mijn gevoelens te begrijpen'),
	create_question(:v90, 'Het is belangrijk voor mij om te begrijpen waar mijn gedachten vandaan komen'),
	create_question(:v91, 'Ik sta er niet echt bij stil waarom ik mij gedraag zoals ik doe'),
	create_question(:v92, 'Ik denk niet vaak na over mijn gedachten'),
	create_question(:v93, 'Ik heb een sterke behoefte om te begrijpen hoe mijn geest werkt'),
	create_question(:v94, 'Ik vind het interessant om te onderzoeken waar ik aan denk'),
	create_question(:v95, 'Meestal weet ik waarom ik mijzelf op een bepaalde manier voel'),
	create_question(:v96, 'Ik ben mij meestal bewust van mijn gedachten'),
	create_question(:v97, 'Ik neem regelmatig de tijd om stil te staan bij mijn gedachten'),
	create_question(:v98, 'Meestal ben ik mij ervan bewust waarom ik mij op een bepaalde manier heb gedragen'),
	create_question(:v99, 'Ik denk achteraf bijna nooit na over mijn daden'),
	create_question(:v100, 'Ik verbaas mezelf vaak over hoe ik mij gedraag'),
	create_question(:v101, 'Ik vind het belangrijk om de dingen die ik doe te evalueren'),
	create_question(:v102, 'Het is belangrijk voor mij om te proberen te begrijpen wat mijn gevoelens betekenen'),
  {
    id: :v103,
    type: :likert,
    title: 'Ik sta regelmatig stil bij mijn gevoelens',
    show_otherwise: false,
    options: %w[1 2 3 4 5],
    section_end: true
  },
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
Je bent klaar met het invullen van de vragenlijst.
</p>
<p class="flow-text section-explanation">
Hartelijk dank!
</p>
'
  }
]

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
