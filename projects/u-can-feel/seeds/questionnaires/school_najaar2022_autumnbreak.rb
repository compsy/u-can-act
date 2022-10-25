# frozen_string_literal: true
db_title = 'Over school'
db_name1 = 'school_voorjaar2022'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Je bent hartstikke goed bezig! De volgende vragen gaan over hoe het op school gaat. We zijn benieuwd hoe je denkt over school en hoe moeilijk je school vindt. Er zijn GEEN goede of foute antwoorden. <br><br>
    Verschuif voor de volgende vragen de slider om aan te geven hoeveel je het eens of oneens bent met elke zin.
</p>'
  }, {
    id: :v1,
    type: :range,
    required: true,
    title: 'Er is tenminste één leraar op school die mijn problemen begrijpt',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v2,
    type: :range,
    required: true,
    title: 'Leraren en andere volwassenen op school zijn echt geïnteresseerd in mijn toekomst',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v3,
    type: :range,
    required: true,
    title: 'Leraren zijn beschikbaar als ik het ergens over wil hebben',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v4,
    type: :range,
    required: true,
    title: 'Het is makkelijk om met leraren te praten',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v5,
    type: :range,
    required: true,
    title: 'Leerlingen kunnen goed opschieten met leraren',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v6,
    type: :range,
    required: true,
    title: 'Op mijn school is er een leraar of een andere volwassene die het opvalt als ik er niet ben',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v7,
    type: :range,
    required: true,
    title: 'Leraren op mijn school helpen ons met onze problemen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v8,
    type: :range,
    required: true,
    title: 'Mijn leraren geven om mij',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v9,
    type: :range,
    required: true,
    title: 'Mijn leraar geeft mij een goed gevoel over mezelf',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v10,
    type: :range,
    required: true,
    title: 'Wat we op school leren is interessant',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v11,
    type: :range,
    required: true,
    title: 'Mijn school maakt leerlingen enthousiast over het leren',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v12,
    type: :range,
    required: true,
    title: 'Meestal begrijp ik mijn huiswerkopdrachten',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v13,
    type: :range,
    required: true,
    title: 'De meeste leraren leggen duidelijk uit wat ik moet doen om een goed cijfer te halen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v14,
    type: :range,
    required: true,
    title: 'Ik denk dat leraren ervan uitgaan dat alle leerlingen willen leren',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v15,
    type: :range,
    required: true,
    title: 'Ik heb het gevoel dat ik goed kan presteren op deze school',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v16,
    type: :range,
    required: true,
    title: 'Mijn leraren geloven dat ik goed kan presteren bij toetsen en opdrachten',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v17,
    type: :range,
    required: true,
    title: 'Ik doe mijn best om goed te presteren op mijn vakken',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v18,
    type: :range,
    required: true,
    title: 'De regels in het klaslokaal gelden voor iedereen hetzelfde',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v19,
    type: :range,
    required: true,
    title: 'Op deze school lossen leerlingen en leraren samen problemen op',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v20,
    type: :range,
    required: true,
    title: 'Leerlingen hebben een probleem als ze zich niet aan de schoolregels houden',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v21,
    type: :range,
    required: true,
    title: 'De schoolregels zijn redelijk',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v22,
    type: :range,
    required: true,
    title: 'De schoolregels worden door de meeste leraren eerlijk en altijd op dezelfde manier toegepast',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v23,
    type: :range,
    required: true,
    title: 'De meeste leraren geven het duidelijk aan als ik me niet goed gedraag in de klas',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v24,
    type: :range,
    required: true,
    title: 'De straffen op deze school zijn redelijk',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v25,
    type: :range,
    required: true,
    title: 'Ik ben tevreden met de hoeveelheid toetsen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v26,
    type: :range,
    required: true,
    title: 'Ik ben tevreden met de hoeveelheid huiswerk',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over hoe het met jou gaat op school. Klik het antwoord aan dat het beste bij jou past.
</p>'
  }, {
    id: :v27,
    type: :radio,
    show_otherwise: false,
    title: 'Hoe moeilijk vind je je schoolwerk?',
    options: ['Heel makkelijk', 'Behoorlijk makkelijk', 'Een beetje makkelijk', 'Een beetje moeilijk', 'Behoorlijk moeilijk', 'Heel moeilijk']
  }, {
    id: :v28a,
    type: :radio,
    show_otherwise: false,
    title: 'Hoe zeker ben je dat je dit jaar over zal gaan?',
    options: ['Helemaal niet zeker', 'Niet heel zeker', 'Behoorlijk zeker', 'Heel zeker']
  }, {
    id: :v29_alternate,
    type: :days,
    show_otherwise: false,
    title: 'Denk even na over de afgelopen weken sinds de herfstvakantie. Welke dagdelen ben je sinds de herfstvakantie niet naar school geweest? Het maakt niet uit wat de reden was. Als je minder dan een halve dag hebt gemist (bijvoorbeeld één lesuur), geef dan aan dat je een halve dag hebt gemist. Als je alleen een paar minuten te laat was, hoef je het niet mee te tellen.',
    shows_questions: %i[v29_a v29_b],
    from_days_ago: 10,
    exclude_weekends: true,
    include_today: false,
    morning_and_afternoon: true
  }, {
    id: :v29_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    required: true,
    title: 'Wat is <u>de belangrijkste reden</u> dat je in de afgelopen 2 weken lessen hebt gemist?',
    options: [
        { title: 'Ik had een afspraak (bijvoorbeeld met de huisarts of een specialist)' }, 
        { title: 'Ik was ziek (bijvoorbeeld grieperig) of lag in het ziekenhuis' },
        { title: 'Ik moest thuisblijven wegens corona (bijvoorbeeld quarantaine)' },
        { title: 'Ik vond het moeilijk om naar school te gaan of daar te blijven (bijvoorbeeld omdat je bang was)' },
        { title: 'Ik was aan het spijbelen' },
        { title: 'Ik had vrij gekregen van mijn ouders (bijvoorbeeld om rust te krijgen)' },
        { title: 'Ik mocht om andere redenen thuisblijven van mijn ouders (bijvoorbeeld om thuis te helpen)' },
        { title: 'Mijn ouders hadden vakantie geregeld onder schooltijd' },
        { title: 'Ons gezin had iets dringends (bijvoorbeeld een begrafenis of iemand moest naar het ziekenhuis)' },
        { title: 'Ons gezin had andere problemen (bijvoorbeeld een kapotte auto of fiets, of iemand in het gezin moest naar een afspraak)' },
        { title: 'Ons gezin had een religieuze feestdag' },
        { title: 'De school was gesloten (bijvoorbeeld vanwege een staking of een studiedag voor leraren)' },
        { title: 'Ik was naar huis gestuurd vanwege mijn gedrag (bijvoorbeeld een schorsing)' },
        { title: 'De school had mijn ouders gevraagd om mij thuis te houden' },
        { title: 'Er was zwaar weer (bijvoorbeeld een storm)' },
        { title: 'Ik had een andere reden' }
    ]
  }, {
    id: :v29_b,
    type: :checkbox,
    show_otherwise: false,
    hidden: true,
    required: true,
    title: 'Waren er nog <u>andere redenen</u> dat je in de afgelopen 2 weken lessen hebt gemist?',
    options: [
        { title: 'Ik had een afspraak (bijvoorbeeld met de huisarts of een specialist)' }, 
        { title: 'Ik was ziek (bijvoorbeeld grieperig) of lag in het ziekenhuis' },
        { title: 'Ik moest thuisblijven wegens corona (bijvoorbeeld quarantaine)' },
        { title: 'Ik vond het moeilijk om naar school te gaan of daar te blijven (bijvoorbeeld omdat je bang was)' },
        { title: 'Ik was aan het spijbelen' },
        { title: 'Ik had vrij gekregen van mijn ouders (bijvoorbeeld om rust te krijgen)' },
        { title: 'Ik mocht om andere redenen thuisblijven van mijn ouders (bijvoorbeeld om thuis te helpen)' },
        { title: 'Mijn ouders hadden vakantie geregeld onder schooltijd' },
        { title: 'Ons gezin had iets dringends (bijvoorbeeld een begrafenis of iemand moest naar het ziekenhuis)' },
        { title: 'Ons gezin had andere problemen (bijvoorbeeld een kapotte auto of fiets, of iemand in het gezin moest naar een afspraak)' },
        { title: 'Ons gezin had een religieuze feestdag' },
        { title: 'De school was gesloten (bijvoorbeeld vanwege een staking of een studiedag voor leraren)' },
        { title: 'Ik was naar huis gestuurd vanwege mijn gedrag (bijvoorbeeld een schorsing)' },
        { title: 'De school had mijn ouders gevraagd om mij thuis te houden' },
        { title: 'Er was zwaar weer (bijvoorbeeld een storm)' },
        { title: 'Een andere reden' },
        { title: 'Geen andere redenen'}
    ]
  },{
    id: :v30,
    type: :checkbox,
    show_otherwise: false,
    required: true,
    title: 'Heb je in het afgelopen half jaar extra ondersteuning voor je schoolwerk gehad? Je kunt meerdere dingen aankruisen.',
    options: [
      { title: 'Ja, huiswerkbegeleiding' }, 
      { title: 'Ja, bijles' }, 
      { title: 'Ja, examentraining' }, 
      { title: 'Ja, iets anders' }, 
      { title: 'Nee' }
    ]
  }, {
    id: :v31,
    type: :radio,
    show_otherwise: false,
    title: "Heb je in het afgelopen half jaar minder tijd dan anders kunnen besteden aan hobby's of aan dingen doen met je vrienden, omdat je het te druk had met school?",
    options: ['Nee', 'Ja, een beetje minder tijd', 'Ja, veel minder tijd']
  },  {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over hoeveel druk je voelt om goed te presteren op school. Verschuif de slider om aan te geven hoe eens of oneens je het bent met elke zin. 
</p>'
  }, {
    id: :v35,
    type: :range,
    required: true,
    title: 'Ik geef mezelf de schuld als ik niet kan voldoen aan de verwachtingen van mijn ouders',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v36,
    type: :range,
    required: true,
    title: 'Ik heb het gevoel dat ik mijn leraren of mijn ouders heb teleurgesteld als ik slecht presteer op school',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v37,
    type: :range,
    required: true,
    title: 'Ik ben gestrest als ik weet dat mijn ouders teleurgesteld zijn over mijn cijfers',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v38,
    type: :range,
    required: true,
    title: 'Ik voel me slecht als ik niet kan voldoen aan de verwachtingen van mijn leraren',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v39,
    type: :range,
    required: true,
    title: 'Ik ben gestrest als ik niet voldoe aan mijn eigen verwachtingen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v40,
    type: :range,
    required: true,
    title: 'Als ik niet voldoe aan mijn eigen verwachtingen, heb ik het gevoel dat ik niet goed genoeg ben',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v41,
    type: :range,
    required: true,
    title: 'Ik kan vaak niet slapen en lig te piekeren als ik mijn eigen doelen niet kan halen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v42,
    type: :range,
    required: true,
    title: 'Als ik minder goed presteer op een toets dan ik had gekund, ben ik gestrest',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
