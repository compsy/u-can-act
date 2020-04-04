# frozen_string_literal: true

db_title = 'Mijn kind en gezin'
db_name1 = 'Mijn_gezin_ouders'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
style = 'style="max-height: 200px; vertical-align: middle; max-width: 100%"'
betrokkenheid1 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Betrokkenheid5.png\" #{style}>"
betrokkenheid2 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Betrokkenheid4.png\" #{style}>"
betrokkenheid3 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Betrokkenheid3.png\" #{style}>"
betrokkenheid4 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Betrokkenheid2.png\" #{style}>"
betrokkenheid5 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Betrokkenheid1.png\" #{style}>"
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> Welkom bij de vragenlijst! In deze vragenlijst onderzoeken we uw gezinssamenstelling en de vroege ontwikkeling van uw kind. </p>'
  }, {
    section_start: 'De volgende vragen gaan over uw gezin. Met gezin bedoelen we personen die voor lange tijd of regelmatig bij u wonen. Bijvoorbeeld in het weekend, tijdens de week, om de week.',
    id: :v1,
    type: :number,
    title: 'Uit hoeveel personen bestaat uw gezin? Reken uzelf <b>niet</b> mee.',
    maxlength: 2,
    placeholder: 'Bijvoorbeeld: 4',
    links_to_expandable: :v2,
    min: 0,
    max: 20,
    required: true,
    section_end: false
  }, {
    id: :v2,
    title: 'Hieronder ziet u voor elke persoon die bij u in huis woont een blokje met vijf vragen. Zou u voor elk persoon één blokje met vragen willen invullen?',
    remove_button_label: 'Verwijder persoon',
    add_button_label: 'Voeg nog een persoon toe',
    type: :expandable,
    default_expansions: 1,
    max_expansions: 20,
    content: [
      {
        type: :raw,
        content: '<p class="flow-text">Persoon</p>'
      }, {
        id: :v4_1,
        type: :radio,
        title: 'Wat is uw relatie tot dit gezinslid?<br><br>Ik ben zijn/haar:',
        options: [
          'Biologische ouder',
          'Stiefouder/ partner van ouder',
          'Adoptie-ouder of pleegouder',
          'Oom of tante',
          'Opa of oma',
          'Partner'],
        show_otherwise: true,
        otherwise_label: 'Anders, namelijk:'
      }, {
        id: :v4_2,
        type: :dropdown,
        title: 'Wanneer is hij/zij geboren?<br><br>Maand:',
        options: %w[januari februari maart april mei juni juli augustus september oktober november december]
      }, {
        id: :v4_3,
        type: :number,
        title: 'Jaar:',
        tooltip: 'Vul het geboortejaar in van deze persoon, bijvoorbeeld: 1986.',
        maxlength: 4,
        placeholder: 'Vul hier een getal in',
        min: 1920,
        max: 2020,
        required: true
      }, {
        id: :v4_4,
        type: :radio,
        show_otherwise: false,
        title: 'Geslacht',
        options: [
          { title: 'Man/jongen' },
          { title: 'Vrouw/meisje' },
          { title: 'Anders' }]
      }, {
        id: :v4_5,
        type: :radio,
        title: 'Hoe voelt u zich bij deze persoon? Kies 1 van onderstaande plaatjes.',
        options: [betrokkenheid1, betrokkenheid2, betrokkenheid3, betrokkenheid4, betrokkenheid5],
        show_otherwise: false
      }],
    section_end: true
  }, {
    id: :v5,
    type: :radio,
    title: 'Heeft u huisdieren?',
    options: [
      { title: 'Ja', shows_questions: %i[v5_a] },
      { title: 'Nee' }
    ],
    show_otherwise: false
  }, {
    id: :v5_a,
    hidden: true,
    type: :checkbox,
    show_otherwise: true,
    title: 'Wat voor huisdier(en) heeft u?',
    options: [
      { title: 'Hond(en)' },
      { title: 'Kat(ten)' },
      { title: 'Vogels' },
      { title: 'Knaagdieren (Cavia, konijn, muizen, ratten)' },
      { title: 'Reptielen' },
      { title: 'Vissen' }
    ]
  }, {
    id: :v6,
    type: :radio,
    show_otherwise: true,
    title: 'Waaruit bestaat uw huidige huisvesting?',
    options: [
      { title: 'Koopwoning' },
      { title: 'Huurwoning' },
      { title: 'Woongroep' },
      { title: 'Inwonend bij ouders of ouders van uw partner' },
      { title: 'Beschermd wonen project' },
    ]
  }, {
    id: :v7,
    type: :radio,
    show_otherwise: false,
    title: 'Wat is het netto maandinkomen van uw huishouden? (Netto is het bedrag dat u maandelijks op uw rekening krijgt. Als u het huishouden met iemand deelt, tel dan ook de inkomsten van uw partner mee.)',
    options: [
      { title: 'Minder dan € 750' },
      { title: '€ 751 - € 1000' },
      { title: '€ 1001 - € 1500' },
      { title: '€ 1501 - € 2000' },
      { title: '€ 2001 - € 2500' },
      { title: '€ 2501 - € 3000' },
      { title: '€ 3001 - € 3500' },
      { title: 'Meer dan € 3500' },
      { title: 'Ik weet het niet' },
      { title: 'Wil ik liever niet zeggen' }
    ]
  }, {
    section_start: 'De volgende vragen gaan over uw zwangerschap en de geboorte van uw kind.',
    id: :v8,
    type: :number,
    title: 'Wat was de zwangerschapsduur bij de geboorte (in weken)?',
    maxlength: 2,
    placeholder: 'Bijvoorbeeld: 38',
    min: 20,
    max: 44,
    required: true,
    section_end: false
  }, {
    id: :v9,
    type: :radio,
    show_otherwise: false,
    title: 'Is er bij uw kind een <i>aangeboren</i> lichamelijke aandoening geconstateerd?',
    options: [
      { title: 'Ja', shows_questions: %i[v9_a ] },
      { title: 'Nee' }
    ]
  }, {
    id: :v9_a,
    hidden: true,
    type: :checkbox,
    show_otherwise: true,
    title: 'Om welke aangeboren aandoening(en) gaat het?',
    options: [
      { title: 'Schisis (gespleten lip, kaak of gehemelte)' },
      { title: 'Cerebrale parese (hersenverlamming)' },
      { title: 'Spina bifida (open rugje)' },
      { title: 'Hartafwijking' },
      { title: 'Maagdarmkanaal afwijking' },
      { title: 'Cystic Fibrosis (taaislijmziekte)' },
      { title: 'Chromosoomafwijking (bijvoorbeeld Syndroom van Down)' },
      { title: 'Stofwisselingsziekte' }
    ],
    tooltip: 'Meerdere antwoorden zijn mogelijk.',
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over lichamelijke en psychologische aandoeningen.',
    id: :v10,
    type: :radio,
    show_otherwise: false,
    title: 'Is er bij uw kind een <i>lichamelijke</i> ziekte vastgesteld?',
    options: [
      { title: 'Ja', shows_questions: %i[v10_a ] },
      { title: 'Nee' }
    ],
    section_end: false
  }, {
    id: :v10_a,
    hidden: true,
    type: :checkbox,
    show_otherwise: true,
    title: 'Om welke ziekte(s) gaat het?',
    options: [
      { title: 'Astma' },
      { title: 'Chronisch eczeem' },
      { title: 'Darmstoornis' },
      { title: 'Diabetes mellitus' },
      { title: 'Migraine/ ernstige hoofdpijn' },
      { title: 'Chronische gewrichtsontsteking' },
      { title: 'Kanker' },
      { title: 'Auto-immuunziekte' },
      { title: 'Waterpokken, mazelen of een andere vlekjesziekte' },
      { title: 'Allergie' }
    ],
    tooltip: 'Meerdere antwoorden zijn mogelijk'
  }, {
    id: :v11,
    type: :radio,
    show_otherwise: false,
    title: 'Is er bij uw kind een <i>psychologische</i> aandoening vastgesteld?',
    options: [
      { title: 'Ja', shows_questions: %i[v11_a v11_b v11_c] },
      { title: 'Nee', shows_questions: %i[v12] }
    ]
  }, {
    id: :v11_a,
    hidden: true,
    type: :checkbox,
    show_otherwise: true,
    title: 'Om welke psychologische aandoening(en) gaat het?',
    options: [
      { title: 'AD(H)D' },
      { title: 'Autisme (Spectrum Stoornis)' },
      { title: 'Angststoornis of fobie' },
      { title: 'Depressie' },
      { title: 'Syndroom van Tourette' },
      { title: 'Dwangstoornis of OCS' },
      { title: 'Hechtingsstoornis' },
      { title: 'Gedragsstoornis (bv. ODD of CD)' },
      { title: 'Eetstoornis' },
      { title: 'Traumagerelateerde stoornis' }
    ],
    tooltip: 'Meerdere antwoorden mogelijk'
  }, {
    id: :v11_b,
    hidden: true,
    type: :checkbox,
    show_otherwise: true,
    title: 'Door wie is/zijn deze aandoening(en) vastgesteld?',
    options: [
      { title: 'Psychiater of psycholoog' },
      { title: 'Huisarts' }
    ]
  }, {
    id: :v11_c,
    hidden: true,
    type: :radio,
    title: 'Is uw kind hiervoor in behandeling (geweest)?',
    options: [
      { title: 'Ja, op dit moment', shows_questions: %i[v11_c1 v11_c2] },
      { title: 'Ja, maar op dit moment niet meer', shows_questions: %i[v11_c1 v11_c2] },
      { title: 'Nee', shows_questions: %i[v12] }
    ],
    show_otherwise: false
  }, {
    id: :v11_c1,
    hidden: true,
    type: :checkbox,
    show_otherwise: true,
    title: 'Om welke behandeling(en) gaat het?',
    options: [
      { title: 'Psychotherapie (gesprekken met een psycholoog)' },
      { title: 'Sociale Vaardigheidstraining' },
      { title: 'Medicatie' },
      { title: 'Kindercoach' },
      { title: 'Creatieve therapie' }
    ],
    tooltip: 'Meerdere antwoorden mogelijk'
  }, {
    id: :v11_c2,
    hidden: true,
    type: :range,
    title: 'Twijfelt u wel eens aan deze diagnose?',
    labels: ['Nooit', 'Soms', 'Heel vaak'],
    required: true
  }, {
    id: :v12,
    hidden: true,
    type: :range,
    title: 'In hoeverre denkt u dat er bij uw kind <i>toch</i> sprake is van psychologische aandoening of ziekte?',
    labels: ['Heel onwaarschijnlijk', 'Misschien/ ik weet het niet', 'Heel waarschijnlijk'],
    required: true
  }, {
    id: :v13,
    type: :radio,
    title: 'Is er bij uw kind een leerstoornis vastgesteld?',
    options: [
      { title: 'Ja', shows_questions: %i[v13_a ] },
      { title: 'Nee' }
    ]
  }, {
    id: :v13_a,
    hidden: true,
    type: :checkbox,
    show_otherwise: true,
    title: 'Om welke leerstoornis(sen) gaat het?',
    options: [
      { title: 'Dyslexie' },
      { title: 'Dyscalculie' },
      { title: 'Dysgrafie' },
      { title: 'Dyspraxie' },
      { title: 'Auditieve verwerkingsstoornis' },
      { title: 'Visuele verwerkingsstoornis' }
    ],
    tooltip: 'Meerdere antwoorden mogelijk'
  }, {
    id: :v14,
    type: :radio,
    title: 'Is er bij uw kind sprake van een aangeboren of opgelopen handicap?',
    options: [
      { title: 'Ja', shows_questions: %i[v14_a ] },
      { title: 'Nee' }
    ]
  }, {
    id: :v14_a,
    hidden: true,
    type: :checkbox,
    show_otherwise: true,
    title: 'Om welke handicap(s) gaat het?',
    options: [
      { title: 'Doofheid' },
      { title: 'Blindheid' },
      { title: 'Spasticiteit' },
      { title: 'Motorische beperking' },
      { title: 'Verstandelijke beperking' },
      { title: 'Meervoudige beperking' }
    ],
    tooltip: 'Meerdere antwoorden mogelijk',
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over de ontwikkeling van uw kind tijdens zijn/haar eerste vier levensjaren. ',
    id: :v15,
    type: :range,
    title: 'Hoe verliep de motorische ontwikkeling van uw kind (leren staan, (trap)lopen, fietsen)?',
    labels: ['Veel langzamer dan gemiddeld', 'Ongeveer gemiddeld', 'Veel sneller dan gemiddeld'],
    required: true,
    section_end: false
  }, {
    id: :v16,
    type: :range,
    title: 'Hoe verliep de taalontwikkeling van uw kind (eerste woordjes en zinnetjes,
begrip van taal)?',
    labels: ['Veel langzamer dan gemiddeld', 'Ongeveer gemiddeld', 'Veel sneller dan gemiddeld'],
    required: true
  }, {
    id: :v17,
    type: :range,
    title: 'Hoe verliep de verstandelijke ontwikkeling van uw kind (puzzels maken, oorzaak en
gevolg begrijpen)?',
    labels: ['Veel langzamer dan gemiddeld', 'Ongeveer gemiddeld', 'Veel sneller dan gemiddeld'],
    required: true
  }, {
    id: :v18,
    type: :range,
    title: 'Heeft u zich in de eerste vier levensjaren zorgen gemaakt
over de ontwikkeling of het gedrag van uw kind?',
    labels: ['Nooit', 'Soms', 'Heel vaak'],
    required: true
  }, {
    id: :v19,
    type: :range,
    title: 'Is er bij uw kind, in het algemeen, sprake van een achterstand of voorsprong op school?',
    labels: ['Grote achterstand', 'Geen achterstand/voorsprong', 'Grote voorsprong'],
    required: true,
    section_end: true
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
