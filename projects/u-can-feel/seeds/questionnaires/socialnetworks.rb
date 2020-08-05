# frozen_string_literal: true

db_title = 'De mensen om je heen'
db_name1 = 'socialnetworks'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over de mensen om je heen, zoals je vrienden, je klasgenoten en je ouders.
    </p>'
  }, {
    id: :v1_a,
    type: :dropdown,
    show_otherwise: false,
    title: 'Hoeveel vrienden heb je in je eigen klas op school?',
    options: (0..30).to_a.map(&:to_s)
  }, {
    id: :v1_b,
    type: :dropdown,
    show_otherwise: false,
    title: 'Hoeveel vrienden heb je buiten je eigen schoolklas?',
    options: (0..30).to_a.map(&:to_s)
  }, {
    id: :v2,
    type: :radio,
    show_otherwise: false,
    title: 'Heb je op dit moment verkering met iemand?',
    options: [{ title: 'Ja', shows_questions: %i[v3_a v3_b v3_c v3_d] }, { title: 'Nee' }]
  }, {
    id: :v3_a,
    type: :range,
    hidden: true,
    title: 'De volgende 4 vragen gaan over degene met wie je verkering hebt. Verschuif de slider om aan te geven hoeveel je het eens of oneens bent met elke zin. <br><br> Mijn vriend/vriendin is er voor mij als ik hem of haar nodig heb',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v3_b,
    type: :range,
    hidden: true,
    title: 'Ik kan mooie én verdrietige dingen delen met mijn vriend/vriendin',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v3_c,
    type: :range,
    hidden: true,
    title: 'Mijn vriend/vriendin steunt mij echt',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v3_d,
    type: :range,
    hidden: true,
    title: 'Mijn vriend/vriendin geeft om mijn gevoelens',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over hoeveel steun je krijgt van de mensen in je omgeving, zoals je ouders, vrienden en klasgenoten. Verschuif de slider om aan te geven hoeveel je het eens of oneens bent met elke zin.
    </p>'
  }, {
    id: :v4,
    type: :range,
    title: 'Mijn ouders proberen mij echt te helpen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v5,
    type: :range,
    title: 'Ik krijg de emotionele hulp en steun die ik nodig heb van mijn ouders',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v6,
    type: :range,
    title: 'Mijn vrienden proberen mij echt te helpen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v7,
    type: :range,
    title: 'Ik kan op mijn vrienden rekenen als er dingen misgaan',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v8,
    type: :range,
    title: 'Ik kan met mijn ouders praten over mijn problemen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v9,
    type: :range,
    title: 'Ik heb vrienden met wie ik mooie én verdrietige dingen kan delen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v10,
    type: :range,
    title: 'Mijn ouders willen mij wel helpen om beslissingen te maken',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v11,
    type: :range,
    title: 'Ik kan met mijn vrienden over mijn problemen praten',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v12,
    type: :range,
    title: 'Mijn klasgenoten vragen mij om mee te doen aan activiteiten',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v13,
    type: :range,
    title: 'Mijn klasgenoten doen aardige dingen voor mij',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v14,
    type: :range,
    title: 'Mijn klasgenoten doen dingen samen met mij',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v15,
    type: :range,
    title: 'Mijn klasgenoten behandelen mij met respect',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over pesten. Pesten is dat één of meer kinderen een ander kind keer op keer lastig vallen. Pesten is dus, dat je steeds opnieuw vervelend doet tegen iemand anders. Voor degene die gepest wordt is het moeilijk om zich te verdedigen. <br><br>

    Pesten is dus niet een ruzie tussen één of meer kinderen die ongeveer even sterk zijn. Pesten is ook niet plagen om een geintje. Pesten is als je steeds opnieuw vervelend doet tegen iemand anders.
    </p>'
  }, {
    id: :v16,
    type: :radio,
    show_otherwise: false,
    title: 'Nu je weet wat pesten is, kun je dan ook zeggen hoe vaak je de afgelopen twee maanden gepest bent?',
    options: [
      { title: 'Ik ben niet gepest' },
      { title: 'Ik ben één of twee keer gepest', shows_questions: %i[v17 v18_a v18_b v19 v20_a v20_b v21 v22 v23] },
      { title: 'Ik ben twee of drie keer per maand gepest', shows_questions: %i[v17 v18_a v18_b v19 v20_a v20_b v21 v22 v23] },
      { title: 'Ik ben ongeveer één keer per week gepest', shows_questions: %i[v17 v18_a v18_b v19 v20_a v20_b v21 v22 v23] },
      { title: 'Ik ben meerdere keren per week gepest', shows_questions: %i[v17 v18_a v18_b v19 v20_a v20_b v21 v22 v23] }
    ]
  }, {
    id: :v17,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Hoe erg vond je het om gepest te worden?',
    options: ['Helemaal niet erg', 'Niet zo erg', 'Een beetje erg', 'Best erg', 'Heel erg']
  }, {
    id: :v18_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Is degene die je gepest heeft sterker dan jij?',
    options: [
      { title: 'Ik ben veel sterker' },
      { title: 'Ik ben iets sterker' },
      { title: 'We zijn allebei even sterk' },
      { title: 'Degene die me gepest heeft is iets sterker' },
      { title: 'Degene die me gepest heeft is veel sterker' }
    ]
  }, {
    id: :v18_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Is degene die je gepest heeft populairder dan jij?',
    options: [
      { title: 'Ik ben veel populairder' },
      { title: 'Ik ben iets populairder' },
      { title: 'We zijn allebei even populair' },
      { title: 'Degene die me gepest heeft is iets populairder' },
      { title: 'Degene die me gepest heeft is veel populairder' }
    ]
  }, {
    id: :v19,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Weet je zeker dat degene die je gepest heeft het expres deed?',
    options: ['Helemaal niet zeker', 'Niet zo zeker', 'Een beetje zeker', 'Zeker', 'Heel zeker']
  }, {
    id: :v20_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Deed degene die je gepest heeft het om cool te zijn?',
    options: ['Helemaal niet waar', 'Niet waar', 'Een beetje waar', 'Waar', 'Helemaal waar']
  }, {
    id: :v20_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Deed degene die je gepest heeft het om wraak te nemen?',
    options: ['Helemaal niet waar', 'Niet waar', 'Een beetje waar', 'Waar', 'Helemaal waar']
  }, {
    id: :v21,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Hoe lang gebeurt het pesten al?',
    options: ['Eén of twee weken', 'Ongeveer een maand', 'Ongeveer een half jaar', 'Ongeveer een jaar', 'Meer dan een jaar']
  }, {
    id: :v22,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Heb je aan iemand verteld dat je in de afgelopen maanden gepest bent?',
    options: [
      { title: 'Ja', shows_questions: %i[v22_b] },
      { title: 'Nee' }
    ]
  }, {
    id: :v22_b,
    type: :checkbox,
    show_otherwise: false,
    hidden: true,
    required: true,
    title: 'Aan wie heb je het verteld? Je kunt meerdere mensen aankruisen.',
    options: ['Mijn mentor', 'Een andere volwassene op school (bijvoorbeeld de jeugdverpleegkundige)', 'Mijn ouder(s) of verzorger(s)', 'Een broer of zus', 'Een vriend of vriendin', 'Iemand anders']
  }, {
    id: :v23,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Heb je in de afgelopen maanden aan je ouders gevraagd of je thuis kon blijven van school vanwege het pesten?',
    options: %w[Ja Nee]
  }, {
    id: :v24,
    type: :radio,
    show_otherwise: false,
    title: 'Hoe vaak heb jij de afgelopen twee maanden meegedaan aan het pesten van een andere leerling?',
    options: [
      { title: 'Ik heb niemand gepest' },
      { title: 'Maar één of twee keer', shows_questions: %i[v25] },
      { title: 'Ongeveer twee of drie keer per maand', shows_questions: %i[v25] },
      { title: 'Ongeveer één keer per week', shows_questions: %i[v25] },
      { title: 'Een paar keer per week', shows_questions: %i[v25] }
    ]
  }, {
    id: :v25,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Heeft je mentor of een andere leraar wel eens met jou gepraat over het pesten van andere leerlingen in de afgelopen maanden?',
    options: [
      { title: 'Nee, mijn leraren hebben daar niet met mij over gepraat' },
      { title: 'Ja, mijn leraren hebben daar één keer met mij over gepraat' },
      { title: 'Ja, mijn leraren hebben daar meerdere keren met mij over gepraat' }
    ]
  }, {
    id: :v26,
    type: :radio,
    show_otherwise: false,
    title: 'Hoe vaak proberen leraren of andere volwassenen op school het pesten te stoppen als een leerling gepest wordt op school?',
    options: ['Bijna nooit', 'Zo nu en dan', 'Soms', 'Meestal', 'Bijna altijd']
  }, {
    id: :v27,
    type: :radio,
    show_otherwise: false,
    title: 'Hoe vaak proberen andere leerlingen het pesten te stoppen als een leerling gepest wordt op school?',
    options: ['Bijna nooit', 'Zo nu en dan', 'Soms', 'Meestal', 'Bijna altijd']
  }, {
    id: :v28,
    type: :radio,
    show_otherwise: false,
    title: 'Hoeveel denk je dat je mentor de afgelopen maanden heeft gedaan om pesten tegen te gaan?',
    options: ['Niets of zo goed als niets', 'Weinig', 'Een beetje', 'Behoorlijk veel', 'Heel veel']
  }
]


dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
