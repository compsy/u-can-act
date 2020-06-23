# frozen_string_literal: true

db_title = 'Over school'
db_name1 = 'school'
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
    title: 'Leraren begrijpen mijn problemen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v2,
    type: :range,
    title: 'Leraren en andere volwassenen op school zijn echt geïnteresseerd in mijn toekomst',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v3,
    type: :range,
    title: 'Leraren zijn beschikbaar als ik iets met ze te bespreken heb',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v4,
    type: :range,
    title: 'Het is makkelijk om met leraren te praten',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v5,
    type: :range,
    title: 'Leerlingen kunnen goed opschieten met leraren',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v6,
    type: :range,
    title: 'Op mijn school is er een leraar of een andere volwassene die het opvalt als ik er niet ben',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v7,
    type: :range,
    title: 'Leraren op mijn school helpen ons met onze problemen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v8,
    type: :range,
    title: 'Mijn leraren geven om mij',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v9,
    type: :range,
    title: 'Mijn schoolwerk is interessant',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v10,
    type: :range,
    title: 'Mijn school motiveert leerlingen om te leren',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v11,
    type: :range,
    title: 'Meestal begrijp ik mijn huiswerkopdrachten',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v12,
    type: :range,
    title: 'Leraren leggen duidelijk uit wat ik moet doen om een goed cijfer te halen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v13,
    type: :range,
    title: 'Ik denk dat leraren verwachten dat alle leerlingen willen leren',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v14,
    type: :range,
    title: 'Ik heb het gevoel dat ik succesvol kan zijn op deze school',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v15,
    type: :range,
    title: 'Mijn leraren geloven dat ik mijn schoolwerk goed kan doen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v16,
    type: :range,
    title: 'Ik doe mijn best om goed te presteren op mijn vakken',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v17,
    type: :range,
    title: 'De schoolregels gelden voor iedereen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v18,
    type: :range,
    title: 'Op deze school worden problemen opgelost door leerlingen én leraren',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v19,
    type: :range,
    title: 'Leerlingen hebben een probleem als ze zich niet aan de schoolregels houden',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v20,
    type: :range,
    title: 'De schoolregels zijn redelijk',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v21,
    type: :range,
    title: 'De schoolregels worden eerlijk en altijd op dezelfde manier toegepast',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v22,
    type: :range,
    title: 'Mijn leraren geven het duidelijk aan als ik me niet goed gedraag in de klas',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v23,
    type: :range,
    title: 'De straffen op deze school zijn redelijk',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v24,
    type: :range,
    title: 'Ik ben tevreden met de hoeveelheid toetsen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v25,
    type: :range,
    title: 'Ik ben tevreden met de hoeveelheid huiswerk',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan hoe het met jou gaat op school. Klik het antwoord aan dat het beste bij jou past.
</p>'
  }, {
    id: :v26,
    type: :radio,
    show_otherwise: false,
    title: 'Hoe moeilijk vind je je schoolwerk?',
    options: ['Heel makkelijk', 'Behoorlijk makkelijk', 'Een beetje makkelijk', 'Een beetje moeilijk', 'Behoorlijk moeilijk', 'Heel moeilijk']
  }, {
    id: :v27,
    type: :radio,
    show_otherwise: false,
    title: 'Wat voor cijfers heb je het afgelopen jaar meestal gehaald?',
    options: ['Vooral onvoldoendes', 'Vooral zessen', 'Vooral zevens', 'Vooral achten', 'Vooral negens', 'Ik had vorig jaar geen cijfers (bijvoorbeeld omdat je nog op de basisschool zat)']
  }, {
    id: :v28,
    type: :radio,
    show_otherwise: false,
    title: 'Denk even na over de afgelopen 2 weken. Hoeveel lessen heb je in de afgelopen 2 weken gemist? Bijvoorbeeld omdat je ziek was, andere afspraken had, of aan het spijbelen was.',
    options: [
      { title: 'Ik heb geen lessen gemist' },
      { title: 'Ik heb een halve dag gemist', shows_questions: %i[v28_a] },
      { title: 'Ik heb 1 schooldag gemist', shows_questions: %i[v28_a] },
      { title: 'Ik heb 1.5 tot 2.5 dagen gemist', shows_questions: %i[v28_a] },
      { title: 'Ik heb 3 tot 7 dagen gemist', shows_questions: %i[v28_a] },
      { title: 'Ik heb 7.5 tot 9.5 dagen gemist', shows_questions: %i[v28_a] },
      { title: 'Ik heb alle lessen gemist', shows_questions: %i[v28_a] }
    ]
  }, {
    id: :v28_a,
    type: :checkbox,
    show_otherwise: false,
    hidden: true,
    required: true,
    title: 'Waarom heb je in de afgelopen 2 weken lessen gemist? Je kunt meerdere redenen aankruisen.',
    options: [
      { title: 'Ik had een afspraak, bijvoorbeeld met de dokter' },
      { title: 'Ik was ziek (bijvoorbeeld grieperig) of lag in het ziekenhuis' },
      { title: 'Ik vond het moeilijk om naar school te gaan of voelde me bang voor school' },
      { title: 'Ik was aan het spijbelen' },
      { title: 'Ik had een dagje vrij gekregen van mijn ouders' },
      { title: 'Ik mocht om andere redenen thuisblijven van mijn ouders, bijvoorbeeld om thuis te helpen' },
      { title: 'Ik was met mijn gezin op vakantie of een dagje weg' },
      { title: 'Ons gezin had iets dringends, bijvoorbeeld een begrafenis of iemand moest naar het ziekenhuis' },
      { title: 'Ons gezin had andere problemen, bijvoorbeeld een kapotte fiets of auto, of een doktersafspraak' },
      { title: 'Ons gezin had een religieuze feestdag' },
      { title: 'De school was gesloten, bijvoorbeeld vanwege een staking' },
      { title: 'Ik was van school gestuurd of geschorst' },
      { title: 'De school had mij gevraagd om thuis te blijven' },
      { title: 'Er was zwaar weer, bijvoorbeeld storm' },
      { title: 'Ik had een andere reden' }
    ]
  }, {
    id: :v29,
    type: :checkbox,
    show_otherwise: false,
    required: true,
    title: 'Heb je naast de gewone schoollessen extra ondersteuning voor je schoolwerk? Je kunt meerdere dingen aankruisen.',
    options: ['Ja, huiswerkbegeleiding', 'Ja, bijles', 'Ja, examentraining', 'Ja, iets anders', 'Nee']
  }, {
    id: :v30,
    type: :radio,
    show_otherwise: false,
    title: "Heb je in het afgelopen jaar minder tijd dan anders kunnen besteden aan hobby's of aan dingen doen met je vrienden, omdat je het te druk had met school?",
    options: ['Nee', 'Ja, een beetje minder tijd', 'Ja, veel minder tijd']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over hoeveel druk je voelt om goed te presteren op school. Verschuif de slider om aan te geven hoe eens of oneens je het bent met elke zin.
</p>'
  }, {
    id: :v31,
    type: :range,
    title: 'Ik geef mezelf de schuld als ik niet kan voldoen aan de verwachtingen van mijn ouders',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v32,
    type: :range,
    title: 'Ik heb het gevoel dat ik mijn leraren of mijn ouders teleurstel als ik slecht presteer op school',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v33,
    type: :range,
    title: 'Ik ben gestrest als ik weet dat mijn ouders teleurgesteld zijn over mijn cijfers',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v34,
    type: :range,
    title: 'Ik voel me beroerd als ik niet kan voldoen aan de verwachtingen van mijn leraren',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v35,
    type: :range,
    title: 'Ik ben gestrest als ik niet voldoe aan mijn eigen verwachtingen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v36,
    type: :range,
    title: 'Als ik niet voldoe aan mijn eigen verwachtingen, heb ik het gevoel dat ik niet goed genoeg ben',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v37,
    type: :range,
    title: 'Ik kan vaak niet slapen en pieker als ik de doelen die ik voor mezelf gesteld heb niet kan halen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v38,
    type: :range,
    title: 'Als ik minder goed presteer op een toets dan ik had gekund, ben ik gestrest',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
