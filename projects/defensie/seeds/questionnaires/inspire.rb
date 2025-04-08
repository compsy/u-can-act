# frozen_string_literal: true

db_title = '' # Shown to users as a big text, but cannot be localized, so often left empty.

likert_options = {
  type: :likert,
  show_otherwise: false,
  options: [
    { title: 'helemaal niet van toepassing', numeric_value: 1 },
    { title: 'niet van toepassing', numeric_value: 2 },
    { title: 'neutraal', numeric_value: 3 },
    { title: 'van toepassing', numeric_value: 4 },
    { title: 'helemaal van toepassing', numeric_value: 5 }
  ]
}
likert_options2 = {
  type: :likert,
  show_otherwise: false,
  options: [
    { title: 'helemaal mee oneens', numeric_value: 1 },
    { title: 'mee oneens', numeric_value: 2 },
    { title: 'neutraal', numeric_value: 3 },
    { title: 'mee eens', numeric_value: 4 },
    { title: 'helemaal mee eens', numeric_value: 5 }
  ]
}

db_name1 = 'inspire' # Internal name to identify this questionnaire by. Should be unique.
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: <<~HTML
      <div>
        <h1>De INSPIRE Resilience Scale</h1>
        <p class='flow-text'><strong>Algemene instructie</strong></p>
        <p class='flow-text'>Dit is de INSPIRE Resilience Scale. De IRS is een vragenlijst waarin een aantal uitspraken gedaan
      wordt waar mensen vaak verschillend over denken. Het is de bedoeling dat u voor elke uitspraak
      aangeeft in hoeverre u het met de uitspraak eens bent. De IRS bestaat uit vijf onderdelen. Voor elk
      onderdeel wordt een aparte instructie gegeven.</p>
        <p class='flow-text'>De totale IRS bestaat uit 103 uitspraken en het invullen duurt ongeveer 20 minuten. Op het invullen
      van de IRS staat geen tijdslimiet. Wel is het belangrijk dat u bij het invullen steeds afgaat op uw
      eerste indruk en dat u hiervoor niet teveel tijd neemt.</p>
        <p class='flow-text'>Er zijn geen goede of foute antwoorden. Het gaat hier namelijk om uw persoonlijke reactie op
      bepaalde situaties. Wel is het belangrijk om bij elke uitspraak slechts één antwoord te geven en geen
      uitspraken over te slaan.</p>
        <p class='flow-text'>De scoremogelijkheden lopen van "helemaal niet van toepassing" tot "helemaal van toepassing".
      Neutraal wil zeggen onbeslist (net zo vaak niet van toepassing als wel van toepassing).</p>
        <p class='flow-text'>Op de volgende bladzijden vindt u de uitspraken van de IRS.</p>
      </div>
    HTML
  }, {
    type: :raw,
    content: <<~HTML
      <div>
        <h2>Deel 1: Hoe gaat u in het algemeen om met lastige situaties?</h2>
        <p class='flow-text'>In het eerste deel van de IRS vragen we u om een of meer lastige situaties en gebeurtenissen in
      gedachten te nemen bij het beantwoorden van onderstaande uitspraken. Iedereen maakt wel eens
      lastige situaties mee. Te denken valt aan spanningen thuis, moeilijkheden op school, tijdens de
      opleiding of op het werk en problemen met de gezondheid. Iedereen heeft zo zijn of haar eigen
      manier om met dit soort lastige situaties om te gaan.</p>
        <p class='flow-text'>Vul in in hoeverre onderstaande reacties kenmerkend zijn voor u in een probleemsituatie.</p>
        <p class='flow-text'>Dit onderdeel bevat 40 uitspraken. Het is belangrijk dat u bij elke uitspraak slechts één reactie
      geeft en geen uitspraken overslaat!</p>
      </div>
    HTML
  }, {
    section_start: 'Hoe gaat u in het algemeen om met lastige situaties?',
    id: :v1,
    title: 'Ik doe iets zodat ik er minder aan denk, zoals sporten, slapen of naar muziek luisteren',
    **likert_options
  }, {
    id: :v2,
    title: 'Ik maak een actieplan',
    **likert_options
  }, {
    id: :v3,
    title: 'Ik denk erover na hoe ik het probleem het beste kan aanpakken',
    **likert_options
  }, {
    id: :v4,
    title: 'Ik ga met iemand praten om de situatie beter te begrijpen',
    **likert_options
  }, {
    id: :v5,
    title: 'Ik vraag anderen wat zij zouden doen in zo\'n situatie',
    **likert_options
  }, {
    id: :v6,
    title: 'Ik probeer ermee te leven',
    **likert_options
  }, {
    id: :v7,
    title: 'Ik probeer de humor van het probleem te zien',
    **likert_options
  }, {
    id: :v8,
    title: 'Ik doe iets anders om mijzelf af te leiden',
    **likert_options
  }, {
    id: :v9,
    title: 'Ik denk na over het probleem om het te kunnen begrijpen',
    **likert_options
  }, {
    id: :v10,
    title: 'Ik bespreek mijn gevoelens met iemand',
    **likert_options
  }, {
    id: :v11,
    title: 'Ik maak grappen over het probleem',
    **likert_options
  }, {
    id: :v12,
    title: 'Ik probeer de ervaring te gebruiken om mijn eigen grenzen te verleggen',
    **likert_options
  }, {
    id: :v13,
    title: 'Ik denk na over wat ik er van kan leren',
    **likert_options
  }, {
    id: :v14,
    title: 'Ik probeer de situatie te relativeren',
    **likert_options
  }, {
    id: :v15,
    title: 'Ik accepteer het probleem zoals het is',
    **likert_options
  }, {
    id: :v16,
    title: 'Ik vraag anderen advies over wat ik kan doen',
    **likert_options
  }, {
    id: :v17,
    title: 'Ik probeer de positieve aspecten van de situatie te zien',
    **likert_options
  }, {
    id: :v18,
    title: 'Ik denk na over de situatie voordat ik actie onderneem',
    **likert_options
  }, {
    id: :v19,
    title: 'Ik zoek afleiding in andere gedachten of bezigheden',
    **likert_options
  }, {
    id: :v20,
    title: 'Ik zoek naar mogelijkheden om me verder te ontwikkelen',
    **likert_options
  }, {
    id: :v21,
    title: 'Ik probeer de situatie van een positieve kant te bekijken',
    **likert_options
  }, {
    id: :v22,
    title: 'Ik probeer steun te vinden bij vrienden of collega\'s',
    **likert_options
  }, {
    id: :v23,
    title: 'Ik accepteer dat het is gebeurd en dat er niets aan gedaan kan worden',
    **likert_options
  }, {
    id: :v24,
    title: 'Ik denk zorgvuldig na over de stappen die genomen moeten worden',
    **likert_options
  }, {
    id: :v25,
    title: 'Ik maak een lijst van taken die echt belangrijk zijn',
    **likert_options
  }, {
    id: :v26,
    title: 'Ik maak het probleem belachelijk',
    **likert_options
  }, {
    id: :v27,
    title: 'Ik probeer op een andere manier naar het probleem te kijken',
    **likert_options
  }, {
    id: :v28,
    title: 'Ik probeer emotionele steun te krijgen van iemand',
    **likert_options
  }, {
    id: :v29,
    title: 'Ik probeer iets te leren van de ervaring',
    **likert_options
  }, {
    id: :v30,
    title: 'Ik probeer altijd aan iets grappigs te denken om mij op te vrolijken',
    **likert_options
  }, {
    id: :v31,
    title: 'Ik probeer de positieve kanten van een tegenslag te zien',
    **likert_options
  }, {
    id: :v32,
    title: 'Ik probeer te wennen aan het idee dat het gebeurd is',
    **likert_options
  }, {
    id: :v33,
    title: 'Ik probeer de grappige kant van de situatie te zien',
    **likert_options
  }, {
    id: :v34,
    title: 'Ik accepteer het feit dat het gebeurd is',
    **likert_options
  }, {
    id: :v35,
    title: 'Ik zoek naar iets goeds in wat er gebeurd is',
    **likert_options
  }, {
    id: :v36,
    title: 'Ik probeer als persoon te groeien als gevolg van de situatie',
    **likert_options
  }, {
    id: :v37,
    title: 'Ik kan geen grappen maken als ik problemen heb',
    **likert_options
  }, {
    id: :v38,
    title: 'Het is moeilijk voor mij om het probleem te accepteren',
    **likert_options
  }, {
    id: :v39,
    title: 'Ik vind het moeilijk om te lachen om mijn problemen',
    **likert_options
  }, {
    id: :v40,
    title: 'Ik zie bij tegenslag vooral de slechte kanten',
    **likert_options,
    section_end: true
  }, {
    type: :raw,
    content: <<~HTML
      <div>
        <h2>Deel 2: Hoe staat u over het algemeen in het leven?</h2>
        <p class='flow-text'>In het tweede onderdeel van de IRS wordt een aantal uitspraken gedaan over hoe u in het algemeen
      in het leven staat. Het kan daarbij gaan over angstwekkende, stressvolle en/of emotionele
      gebeurtenissen of bijvoorbeeld het omgaan met andere mensen.</p>
        <p class='flow-text'>Vul bij elke uitspraak in in hoeverre u het eens of oneens bent met de onderstaande uitspraken.</p>
        <p class='flow-text'>Dit onderdeel bevat 43 uitspraken. Het is belangrijk dat u bij elke uitspraak slechts één reactie geeft
      en geen uitspraken overslaat!</p>
      </div>
    HTML
  }, {
    section_start: 'Hoe staat u over het algemeen in het leven?',
    id: :v41,
    title: 'Ik bespreek bijna nooit mijn problemen met anderen',
    **likert_options2
  }, {
    id: :v42,
    title: 'Als iemand die ik ken zich ongelukkig voelt, voel ik zelf bijna zijn of haar pijn',
    **likert_options2
  }, {
    id: :v43,
    title: 'Ik voel tranen opkomen als ik anderen zie huilen',
    **likert_options2
  }, {
    id: :v44,
    title: 'Zelfs in crisissituaties blijf ik rustig',
    **likert_options2
  }, {
    id: :v45,
    title: 'Ik word erg emotioneel als iemand die belangrijk voor mij is een lange tijd weggaat',
    **likert_options2
  }, {
    id: :v46,
    title: 'Na een pijnlijke ervaring heb ik iemand nodig om mij te troosten',
    **likert_options2
  }, {
    id: :v47,
    title: 'Ik word bang als ik in slecht weer moet reizen',
    **likert_options2
  }, {
    id: :v48,
    title: 'Wanneer ik over iets inzit, wil ik het liefst met iemand over mijn zorgen praten',
    **likert_options2
  }, {
    id: :v49,
    title: 'Ik heb zelden of nooit slaapproblemen door stress of angst',
    **likert_options2
  }, {
    id: :v50,
    title: 'Ik maak me veel minder zorgen dan de meeste mensen',
    **likert_options2
  }, {
    id: :v51,
    title: 'Ik maak me soms zorgen over dingen die niet belangrijk zijn',
    **likert_options2
  }, {
    id: :v52,
    title: 'Moeilijke situaties kan ik aan zonder emotionele steun van anderen nodig te hebben',
    **likert_options2
  }, {
    id: :v53,
    title: 'Als het gaat om fysiek gevaar, ben ik angstig',
    **likert_options2
  }, {
    id: :v54,
    title: 'Ik heb er geen moeite mee om gevaarlijk werk te doen',
    **likert_options2
  }, {
    id: :v55,
    title: 'Ik word erg gespannen als ik moet wachten op een belangrijke beslissing',
    **likert_options2
  }, {
    id: :v56,
    title: 'Ik word niet snel emotioneel, zelfs niet in situaties waarin anderen erg verdrietig worden',
    **likert_options2
  }, {
    id: :v57,
    title: 'Ik weet hoe andere culturen kunnen verschillen van de mijne',
    **likert_options2
  }, {
    id: :v58,
    title: 'Als er iets fout kan gaan voor mij, dan zal het ook gebeuren',
    **likert_options2
  }, {
    id: :v59,
    title: 'Ik verwacht bijna nooit dat dingen gaan zoals ik wil',
    **likert_options2
  }, {
    id: :v60,
    title: 'Ik vind het makkelijk om nieuwe mensen te ontmoeten',
    **likert_options2
  }, {
    id: :v61,
    title: 'Ik ben optimistisch over mijn toekomst',
    **likert_options2
  }, {
    id: :v62,
    title: 'Ik vind het makkelijk om met mensen uit andere culturen om te gaan',
    **likert_options2
  }, {
    id: :v63,
    title: 'Over het algemeen reken ik erop dat mij meer goede dan slechte dingen zullen overkomen',
    **likert_options2
  }, {
    id: :v64,
    title: 'Als ik problemen heb met het uitvoeren van mijn werk, vraag ik iemand me te helpen',
    **likert_options2
  }, {
    id: :v65,
    title: 'Ik maak makkelijk nieuwe vrienden',
    **likert_options2
  }, {
    id: :v66,
    title: 'Ik vind het prettig om met anderen samen te zijn',
    **likert_options2
  }, {
    id: :v67,
    title: 'Ik reken er bijna nooit op dat mij goede dingen zullen overkomen',
    **likert_options2
  }, {
    id: :v68,
    title: 'Ik vraag makkelijk om hulp',
    **likert_options2
  }, {
    id: :v69,
    title: 'In onzekere tijden verwacht ik er het beste van',
    **likert_options2
  }, {
    id: :v70,
    title: 'Ik heb geen enkel probleem om samen te werken met iemand met een andere culturele achtergrond',
    **likert_options2
  }, {
    id: :v71,
    title: 'Als ik het emotioneel zwaar heb, vertel ik dit aan anderen',
    **likert_options2
  }, {
    id: :v72,
    title: 'Zelfs als ik onder grote druk sta, blijf ik kalm',
    **likert_options2
  }, {
    id: :v73,
    title: 'Ik heb niet veel tijd nodig om te herstellen van een stressvolle situatie',
    **likert_options2
  }, {
    id: :v74,
    title: 'Ik red me meestal zonder veel moeite uit moeilijke situaties',
    **likert_options2
  }, {
    id: :v75,
    title: 'Ik heb vertrouwen in mijn eigen vaardigheden',
    **likert_options2
  }, {
    id: :v76,
    title: 'Ik doe er niet lang over om tegenslagen in mijn leven te boven te komen',
    **likert_options2
  }, {
    id: :v77,
    title: 'Ik kan me concentreren onder druk',
    **likert_options2
  }, {
    id: :v78,
    title: 'Ik herstel snel na ziekte of tegenslag',
    **likert_options2
  }, {
    id: :v79,
    title: 'Ik lever een bijdrage aan het succes van mijn groep',
    **likert_options2
  }, {
    id: :v80,
    title: 'Ik denk dat ik in een crisissituatie mijn werk naar behoren kan uitvoeren',
    **likert_options2
  }, {
    id: :v81,
    title: 'Ik kan goed omgaan met vervelende gevoelens',
    **likert_options2
  }, {
    id: :v82,
    title: 'Ik vind het makkelijk mijn leven weer op te pakken als er iets vervelends gebeurd is',
    **likert_options2
  }, {
    id: :v83,
    title: 'Ik heb de vaardigheden die nodig zijn om mijn taken adequaat uit te voeren',
    **likert_options2,
    section_end: true
  }, {
    type: :raw,
    content: <<~HTML
      <div>
        <h2>Deel 3: Hoe denkt u na over uzelf?</h2>
        <p class='flow-text'>In het derde onderdeel van de IRS wordt een aantal eigenschappen en/of gedragingen gegeven. Het
        kan daarbij bijvoorbeeld gaan over hoe u over u zelf denkt. Vul bij elke uitspraak in in welke
        mate u vindt dat de uitspraken op u van toepassing zijn.</p>
        <p class='flow-text'>Dit onderdeel bevat 20 uitspraken. Het is belangrijk dat u bij elke uitspraak slechts één reactie geeft
        en geen uitspraken overslaat!</p>
      </div>
    HTML
  }, {
    section_start: 'Hoe denk u na over uzelf?',
    id: :v84,
    title: 'Van nadenken over mijn gedachten raak ik alleen maar meer in de war',
    **likert_options2
  }, {
    id: :v85,
    title: 'Ik ben er niet echt in geïnteresseerd om mijn gedrag volledig te analyseren',
    **likert_options2
  }, {
    id: :v86,
    title: 'Ik merk vaak bij mezelf dat ik een bepaald gevoel heb, maar waar het vandaan komt weet ik meestal niet',
    **likert_options2
  }, {
    id: :v87,
    title: 'Ik ben vaak in de war over wat ik echt van dingen vind',
    **likert_options2
  }, {
    id: :v88,
    title: 'Ik denk vaak na over hoe ik tegen zaken aankijk',
    **likert_options2
  }, {
    id: :v89,
    title: 'Ik vind het vaak moeilijk om mijn gevoelens te begrijpen',
    **likert_options2
  }, {
    id: :v90,
    title: 'Het is belangrijk voor mij om te begrijpen waar mijn gedachten vandaan komen',
    **likert_options2
  }, {
    id: :v91,
    title: 'Ik sta er niet echt bij stil waarom ik mij gedraag zoals ik doe',
    **likert_options2
  }, {
    id: :v92,
    title: 'Ik denk niet vaak na over mijn gedachten',
    **likert_options2
  }, {
    id: :v93,
    title: 'Ik heb een sterke behoefte om te begrijpen hoe mijn geest werkt',
    **likert_options2
  }, {
    id: :v94,
    title: 'Ik vind het interessant om te onderzoeken waar ik aan denk',
    **likert_options2
  }, {
    id: :v95,
    title: 'Meestal weet ik waarom ik mezelf op een bepaalde manier voel',
    **likert_options2
  }, {
    id: :v96,
    title: 'Ik ben mij meestal bewust van mijn gedachten',
    **likert_options2
  }, {
    id: :v97,
    title: 'Ik neem regelmatig de tijd om stil te staan bij mijn gedachten',
    **likert_options2
  }, {
    id: :v98,
    title: 'Meestal ben ik mij ervan bewust waarom ik mij op een bepaalde manier heb gedragen',
    **likert_options2
  }, {
    id: :v99,
    title: 'Ik denk achteraf bijna nooit na over mijn daden',
    **likert_options2
  }, {
    id: :v100,
    title: 'Ik verbaas mezelf vaak over hoe ik mij gedraag',
    **likert_options2
  }, {
    id: :v101,
    title: 'Ik vind het belangrijk om de dingen die ik doe te evalueren',
    **likert_options2
  }, {
    id: :v102,
    title: 'Het is belangrijk voor mij om te proberen te begrijpen wat mijn gevoelens betekenen',
    **likert_options2
  }, {
    id: :v103,
    title: 'Ik sta regelmatig stil bij mijn gevoelens',
    **likert_options2,
    section_end: true
  }, {
    type: :raw,
    content: <<~HTML
      <div>
        <p class='flow-text'>U bent klaar met het invullen van de vragenlijst.</p>
        <h2>Hartelijk dank!</h2>
      </div>
    HTML
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
