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
    section_start: 'De volgende vragen gaan over uw gezin. Met gezin bedoelen we personen die permanent of regelmatig bij u wonen. Bijvoorbeeld in het weekend, tijdens de week, om de week.',
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
    title: 'Zou u voor elk van deze personen de volgende vragen willen beantwoorden?',
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
        title: 'Wat is uw relatie tot dit gezinslid?<br><br>Ik ben:',
        options: [
          'Biologische ouder',
          'Stiefouder/ partner van ouder',
          'Adoptie-ouder of pleegouder)',
          'Oom of tante',
          'Opa of oma',
          'Partner'],
        show_otherwise: true,
        otherwise_label: 'Anders, namelijk:'
      }, {
        id: :v4_2,
        type: :dropdown,
        title: 'Wanneer is hij/zij geboren?<br><br>Maand:',
        options: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december']
      }, {
        id: :v4_3,
        type: :number,
        title: 'Jaar:',
        tooltip: 'Vul het geboortejaar in van deze persoon, bijvoorbeeld: 1986.',
        maxlength: 4,
        placeholder: 'Vul hier een getal in',
        min: 1940,
        max: 2030,
        required: true
      }, {
        id: :v4_4,
        type: :radio,
        show_otherwise: false,
        title: 'Geslacht',
        options: [
          {title: 'Jongen/ Man'},
          {title: 'Meisje/ Vrouw'},
          {title: 'Anders'}]
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
    type: :likert,
    title: 'Heeft u huisdieren?',
    options: [
      {title: 'Nee'},
      {title: 'Ja', shows_questions: %i[v5_a]}
    ]
  }, {
    id: :v5_a,
    hidden: true,
    type: :radio,
    show_otherwise: true,
    title: 'Wat voor huisdier(en) heeft u?',
    options: [
      {title: 'Hond(en)'},
      {title: 'Kat(ten)'},
      {title: 'Vogels'},
      {title: 'Knaagdieren (Cavia, konijn, muizen, ratten)'},
      {title: 'Reptielen'},
      {title: 'Vissen'}
    ]
  }, {
    id: :v6,
    type: :radio,
    show_otherwise: true,
    title: 'Waaruit bestaat uw huidige huisvesting?',
    options: [
      {title: 'Koopwoning'},
      {title: 'Huurwoning'},
      {title: 'Woongroep'},
      {title: 'Inwonend bij ouders of ouders van uw partner'},
      {title: 'Beschermd wonen project'},
    ]
  }, {
    id: :v7,
    type: :radio,
    show_otherwise: false,
    title: 'Wat is het netto maandinkomen van uw huishouden? (Netto is het bedrag dat u maandelijks op uw rekening krijgt. Als u het huishouden met iemand deelt, tel dan ook de inkomsten van uw partner mee.)',
    options: [
      {title: 'Minder dan € 750'},
      {title: '€ 751 - € 1000'},
      {title: '€ 1001 - € 1500'},
      {title: '€ 1501 - € 2000'},
      {title: '€ 2001 - € 2500'},
      {title: '€ 2501 - € 3000'},
      {title: '€ 3001 - € 3500'},
      {title: 'Meer dan € 3500'},
      {title: 'Ik weet het niet'},
      {title: 'Wil ik liever niet zeggen'}
    ]
  }, {
    section_start: 'De volgende vragen gaan over de zwangerschap en de geboorte van uw kind.',
    id: :v8,
    type: :number,
    title: 'Wat was de zwangerschapsduur in weken bij de geboorte?',
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
    title: 'Is er bij uw kind een aangeboren afwijking of aandoening geconstateerd?',
    options: [
      {title: 'Nee'},
      {title: 'Ja', shows_questions: %i[v9_a ]}
    ]
  }, {
    id: :v9_a,
    hidden: true,
    type: :radio,
    show_otherwise: true,
    title: 'Om welke aangeboren afwijking of aandoening gaat het?',
    options: [
      {title: 'Schisis (gespleten lip, kaak of gehemelte)'},
      {title: 'Cerebrale parese (hersenverlamming)'},
      {title: 'Spina bifida (open rugje)'},
      {title: 'Hartafwijking'},
      {title: 'Maagdarmkanaal afwijking'},
      {title: 'Cystic Fibrosis (taaislijmziekte)'},
      {title: 'Chromosoomafwijking (bijvoorbeeld Syndroom van Down)'},
      {title: 'Stofwisselingsziekte'}
    ],
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over lichamelijke en psychologische ziektes en aandoeningen.',
    id: :v10,
    type: :radio,
    show_otherwise: false,
    title: 'Is er bij uw kind een levensbedreigende of chronische ziekte geconstateerd waarvoor hij of zij onder behandeling is (geweest) van een arts?',
    options: [
      {title: 'Nee'},
      {title: 'Ja', shows_questions: %i[v10_a ]}
    ],
    section_end: false
  }, {
    id: :v10_a,
    hidden: true,
    type: :radio,
    show_otherwise: true,
    title: 'Om welke ziekte gaat het?',
    options: [
      {title: 'Astma'},
      {title: 'Chronisch eczeem'},
      {title: 'Darmstoornis'},
      {title: 'Lichamelijke aandoeningen'},
      {title: 'Diabetes mellitus'},
      {title: 'Migraine/ ernstige hoofdpijn'},
      {title: 'Chronische gewrichtsontsteking'},
      {title: 'Kanker'}
    ]
  }, {
    id: :v11,
    type: :radio,
    show_otherwise: false,
    title: 'Is er bij uw kind sprake van een psychologische aandoening of ziekte?',
    options: [
      {title: 'Nee'},
      {title: 'Ja', shows_questions: %i[v11_a, v11_b, v11_c ]}
    ]
  }, {
    id: :v11_a,
    hidden: true,
    type: :radio,
    show_otherwise: true,
    title: 'Om welke psychologische aandoening of ziekte gaat het?',
    options: [
      {title: 'AD(H)D'},
      {title: 'Autisme'},
      {title: 'Angststoornis of fobie'},
      {title: 'Depressie'},
      {title: 'Syndroom van Tourette'},
      {title: 'Dwangstoornis of OCS'},
      {title: 'Hechtingsstoornis'},
      {title: 'Gedragsstoornis (bv. ODD of CD)'},
      {title: 'Eetstoornis'},
      {title: 'Traumagerelateerde stoornis'}
    ]
  }, {
    id: :v11_b,
    hidden: true,
    type: :radio,
    show_otherwise: true,
    title: 'Door wie is deze aandoening of ziekte vastgesteld?',
    options: [
      {title: 'Psychiater of psycholoog'},
      {title: 'Huisarts'},
    ]
  }, {
    id: :v11_c,
    hidden: true,
    type: :likert,
    title: 'Is uw kind hiervoor in behandeling (geweest)?',
    options: [
      {title: 'Nee', shows_questions: %i[v12]},
      {title: 'Ja, op dit moment', shows_questions: %i[v11_c1, v11_c2]},
      {title: 'Ja, maar op dit moment niet meer', shows_questions: %i[v11_a, v11_b, v11_c ]}
    ]
  }, {
    id: :v11_c1,
    hidden: true,
    type: :radio,
    show_otherwise: true,
    title: 'Om welke behandeling of behandelingen gaat het?',
    options: [
      {title: 'Psychotherapie Behandeling (gesprekken met een psycholoog)'},
      {title: 'Sociale Vaardigheidstraining'},
      {title: 'Medicatie'},
      {title: 'Kindercoach'},
      {title: 'Creatieve therapie'}
    ]
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
    title: 'In hoeverre denkt u dat er bij uw kind toch sprake is van psychologische aandoening of ziekte?',
    labels: ['Heel onwaarschijnlijk', 'Misschien/ ik weet het niet', 'Heel waarschijnlijk'],
    required: true
  }, {
    id: :v13,
    type: :radio,
    title: 'Is er bij uw kind sprake van een leerstoornis?',
    options: [
      {title: 'Nee'},
      {title: 'Ja', shows_questions: %i[v13_a ]}
    ]
  }, {
    id: :v13_a,
    hidden: true,
    type: :radio,
    show_otherwise: true,
    title: 'Om welke leerstoornis gaat het?',
    options: [
      {title: 'Dyslexie'},
      {title: 'Dyscalculie'},
      {title: 'Dysgrafie'},
      {title: 'Dyspraxie'},
      {title: 'Auditieve verwerkingsstoornis'},
      {title: 'Visuele verwerkingsstoornis'}
    ]
  }, {
    id: :v14,
    type: :radio,
    title: 'Is er bij uw kind sprake van een (aangeboren of door ziekte of ongeval opgelopen) handicap?',
    options: [
      {title: 'Nee'},
      {title: 'Ja', shows_questions: %i[v14_a ]}
    ]
  }, {
    id: :v14_a,
    hidden: true,
    type: :radio,
    show_otherwise: true,
    title: 'Om welke handicap gaat het?',
    options: [
      {title: 'Doofheid'},
      {title: 'Blindheid'},
      {title: 'Spasticiteit'},
      {title: 'Motorische beperking'},
      {title: 'Verstandelijke beperking'},
      {title: 'Meervoudige beperking'}
    ],
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over de ontwikkeling van uw kind tijdens zijn/haar eerste vier levensjaren. ',
    id: :v15,
    type: :range,
    title: 'Hoe verliep de motorische ontwikkeling van uw kind (leren staan, leren lopen, leren
traplopen, leren fietsen)?',
    labels: ['Veel langzamer dan gemiddeld', 'Ongeveer gemiddeld', 'Veel sneller dan gemiddeld'],
    required: true,
    section_end: false
  }, {
    id: :v16,
    type: :range,
    title: 'Hoe verliep de taalontwikkeling van uw kind (eerste woordjes, eerste zinnetjes,
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
    title: 'Zijn er momenten in de eerste vier levensjaren geweest waarin u zich zorgen maakte
over de ontwikkeling of het gedrag van uw kind?',
    labels: ['Geen', 'Soms', 'Heel vaak'],
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
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
