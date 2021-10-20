# frozen_string_literal: true
db_title = 'De mensen om je heen'
db_name1 = 'socialnetworks_meting2'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
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
    required: true,
    title: 'De volgende 4 vragen gaan over degene met wie je verkering hebt. Verschuif de slider om aan te geven hoeveel je het eens of oneens bent met elke zin. <br><br> Mijn vriend/vriendin is er voor mij als ik hem of haar nodig heb',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v3_b,
    type: :range,
    hidden: true,
    required: true,
    title: 'Ik kan mooie én verdrietige dingen delen met mijn vriend/vriendin',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v3_c,
    type: :range,
    hidden: true,
    required: true,
    title: 'Mijn vriend/vriendin steunt mij echt',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v3_d,
    type: :range,
    hidden: true,
    required: true,
    title: 'Mijn vriend/vriendin geeft om mijn gevoelens',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over hoeveel steun je krijgt van de mensen in je omgeving, zoals je ouders, vrienden en klasgenoten. Verschuif de slider om aan te geven hoeveel je het eens of oneens bent met elke zin.
    </p>'
  }, {
    id: :v4,
    type: :range,
    required: true,
    title: 'Mijn ouders proberen mij echt te helpen als ik problemen heb',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v5,
    type: :range,
    required: true,
    title: 'Ik krijg de emotionele hulp en steun die ik nodig heb van mijn ouders',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v6,
    type: :range,
    required: true,
    title: 'Mijn vrienden proberen mij echt te helpen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v7,
    type: :range,
    required: true,
    title: 'Ik kan op mijn vrienden rekenen als er dingen misgaan',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v8,
    type: :range,
    required: true,
    title: 'Ik kan met mijn ouders praten over mijn problemen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v9,
    type: :range,
    required: true,
    title: 'Ik heb vrienden met wie ik mooie én verdrietige dingen kan delen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v10,
    type: :range,
    required: true,
    title: 'Mijn ouders willen mij wel helpen om beslissingen te maken',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v11,
    type: :range,
    required: true,
    title: 'Ik kan met mijn vrienden over mijn problemen praten',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v12,
    type: :range,
    required: true,
    title: 'Mijn klasgenoten vragen mij om mee te doen aan activiteiten',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v13,
    type: :range,
    required: true,
    title: 'Mijn klasgenoten doen aardige dingen voor mij',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v14,
    type: :range,
    required: true,
    title: 'Mijn klasgenoten doen dingen samen met mij',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v15,
    type: :range,
    required: true,
    title: 'Mijn klasgenoten behandelen mij met respect',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over pesten. Pesten is dat één of meer leerlingen een andere leerling keer op keer lastig vallen. Voor degene die gepest wordt is het moeilijk om zich te verdedigen. <br><br>

    Pesten is dus niet een ruzie tussen twee of meer jongeren die ongeveer even sterk zijn. Pesten is ook niet plagen om een geintje. Pesten is als je steeds opnieuw vervelend doet tegen iemand anders.
    </p>'
  }, {
    id: :v16_a,
    type: :radio,
    show_otherwise: false,
    title: 'Hoe vaak ben je de afgelopen twee maanden <u>"in het echt"</u> gepest? Bijvoorbeeld op school of op straat buiten school.',
    options: [
      { title: 'Ik ben niet gepest' },
      { title: 'Ik ben één of twee keer gepest', shows_questions: %i[v17 v21 v22 v23] },
      { title: 'Ik ben twee of drie keer per maand gepest', shows_questions: %i[v17 v21 v22 v23] },
      { title: 'Ik ben ongeveer één keer per week gepest', shows_questions: %i[v17 v21 v22 v23] },
      { title: 'Ik ben meerdere keren per week gepest', shows_questions: %i[v17 v21 v22 v23] }
    ]
  }, {
    id: :v16_b,
    type: :radio,
    show_otherwise: false,
    title: 'Hoe vaak ben je de afgelopen twee maanden <u>online</u> gepest? Bijvoorbeeld via social media.',
    options: [
      { title: 'Ik ben niet gepest' },
      { title: 'Ik ben één of twee keer gepest', shows_questions: %i[v17 v21 v22 v23] },
      { title: 'Ik ben twee of drie keer per maand gepest', shows_questions: %i[v17 v21 v22 v23] },
      { title: 'Ik ben ongeveer één keer per week gepest', shows_questions: %i[v17 v21 v22 v23] },
      { title: 'Ik ben meerdere keren per week gepest', shows_questions: %i[v17 v21 v22 v23] }
    ]
  }, {
    id: :v17,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Hoe erg vond of vind je het om gepest te worden?',
    options: ['Helemaal niet erg', 'Niet zo erg', 'Een beetje erg', 'Best erg', 'Heel erg']
  }, {
    id: :v21,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Wanneer is het pesten begonnen?',
    options: ['Eén of twee weken geleden', 'Ongeveer een maand geleden', 'Ongeveer een half jaar geleden', 'Ongeveer een jaar geleden', 'Meer dan een jaar geleden']
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
    options: ['Mijn mentor of een andere leraar', 'Een andere volwassene op school (bijvoorbeeld de jeugdverpleegkundige)', 'Mijn ouder(s) of verzorger(s)', 'Een broer of zus', 'Een vriend of vriendin', 'Iemand anders']
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
      { title: 'Eén of twee keer', shows_questions: %i[v25] },
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
    options: ['Niets of zo goed als niets', 'Heel weinig', 'Een beetje', 'Behoorlijk veel', 'Heel veel']
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
