# frozen_string_literal: true

db_title = 'Mijn gezin en gewoontes'

db_name1 = 'Mijn_gezin_Kinderen'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
style = 'style="max-height: 200px; vertical-align: middle; max-width: 100%"'
betrokkenheid1 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Betrokkenheid5.png\" #{style}>"
betrokkenheid2 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Betrokkenheid4.png\" #{style}>"
betrokkenheid3 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Betrokkenheid3.png\" #{style}>"
betrokkenheid4 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Betrokkenheid2.png\" #{style}>"
betrokkenheid5 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Betrokkenheid1.png\" #{style}>"
natuur1 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Closeness_Nature_1.png\" #{style}>"
natuur2 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Closeness_Nature_2.png\" #{style}>"
natuur3 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Closeness_Nature_3.png\" #{style}>"
natuur4 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Closeness_Nature_4.png\" #{style}>"
natuur5 = "<img src=\"https://u-can-act.nl/wp-content/uploads/2019/10/Closeness_Nature_6.png\" #{style}>"
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> Welkom bij de vragenlijst! Deze vragenlijst gaat over de mensen in jouw gezin.
Ook zijn er vragen over de gewoontes van je gezin, en over je eigen gewoontes. Je bent hier ongeveer 10 minuten mee bezig.</p>'
  }, {
    section_start: 'De volgende vragen gaan over je thuis. Hiermee bedoelen we het huis waarin je woont. In dit huis woont ook een volwassene die voor je zorgt.
Sommige kinderen hebben meer dan 1 thuis.',
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'In hoeveel verschillende huizen woon je?',
    options: [
      { title: '1 huis', shows_questions: %i[v2 v3 v4] },
      { title: '2 of meer huizen', shows_questions: %i[v5 v6 v7 v8 v9 v10 v11 v12] }],
    section_end: false
  }, {
    id: :v2,
    hidden: true,
    type: :radio,
    title: 'Heb je in dit huis een eigen kamer?',
    options: [
      { title: 'Ja' },
      { title: 'Nee' }]
  }, {
    id: :v3,
    hidden: true,
    type: :number,
    title: 'Met hoeveel <i>andere</i> mensen woon je samen in dit huis? Dit zijn personen die altijd of meestal in hetzelfde huis wonen als jij, zoals ouders, (half-) broers, (half-) zussen. Tel jezelf <i>niet</i> mee.',
    maxlength: 2,
    links_to_expandable: :v4,
    placeholder: 'Bijvoorbeeld: 4',
    min: 0,
    max: 20,
    required: true
  }, {
    id: :v4,
    hidden: true,
    title: 'We willen graag wat meer informatie over deze personen. Hieronder zie je voor elk van deze personen een blokje getiteld "Persoon" met vijf vragen. Beantwoord voor elke persoon met wie in je huis woont een blokje met vragen.',
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
        title: 'Wie is deze persoon? <br>
<br>
Deze persoon is mijn:',
        options: [
          'Ouder',
          'Stiefouder',
          'Broer(tje) of zus(je)',
          'Opa of oma',
          'Oom of tante',
          'Pleegouder'],
        show_otherwise: true,
        otherwise_label: 'Anders, namelijk:',
      }, {
        id: :v4_2,
        type: :number,
        title: 'Hoe oud is hij/zij in jaren?',
        tooltip: 'Bijvoorbeeld: als je moeder 33 jaar is vul je 33 in.',
        maxlength: 2,
        placeholder: 'Vul hier een getal in',
        min: 0,
        max: 99,
        required: true
      }, {
        id: :v4_3,
        type: :dropdown,
        title: 'In welke maand is hij/zij jarig?',
        options: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december', 'weet ik niet']
      }, {
        id: :v4_4,
        type: :radio,
        show_otherwise: false,
        title: 'Is deze persoon een man/jongen of een vrouw/meisje?',
        options: [
          { title: 'Man/jongen' },
          { title: 'Vrouw/meisje' },
          { title: 'Anders' }]
      }, {
        id: :v4_5,
        type: :radio,
        title: 'Hoe voel je je bij deze persoon? <br>
<br>
Kies 1 van de 5 plaatjes',
        options: [betrokkenheid1, betrokkenheid2, betrokkenheid3, betrokkenheid4, betrokkenheid5],
        show_otherwise: false
      }
    ],
    section_end: true
  }, {
    id: :v5,
    hidden: true,
    type: :radio,
    show_otherwise: true,
    section_start: 'De volgende vragen gaan over het huis waar je het grootste deel van de tijd woont.',
    title: 'Hoeveel nachten per week slaap je in dit huis?',
    options: [
      { title: 'Minder dan 1 nacht per week' },
      { title: '1 nacht per week' },
      { title: '2 nachten per week' },
      { title: '3 nachten per week' },
      { title: '4 nachten per week' },
      { title: '5 nachten per week' },
      { title: '6 nachten per week' },
      { title: '7 nachten per week' }],
    section_end: false
  }, {
    id: :v6,
    hidden: true,
    type: :radio,
    show_otherwise: false,
    title: 'Heb je in dit huis een eigen kamer?',
    options: [
      { title: 'Ja' },
      { title: 'Nee' }]
  }, {
    id: :v7,
    hidden: true,
    type: :number,
    title: 'Met hoeveel <i>andere</i> mensen woon je samen in dit huis? Dit zijn personen die altijd of meestal in hetzelfde huis wonen als jij, zoals ouders, (half-) broers, (half-) zussen. Tel jezelf <i>niet</i> mee.',
    maxlength: 2,
    placeholder: 'Bijvoorbeeld: 4',
    links_to_expandable: :v8,
    min: 0,
    max: 20,
    required: true
  }, {
    id: :v8,
    hidden: true,
    title: 'We willen graag wat meer informatie over deze personen. Hieronder zie je voor elk van deze personen een blokje getiteld "Persoon" met vijf vragen. Beantwoord voor elke persoon met wie in je huis woont een blokje met vragen.',
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
        id: :v8_1,
        type: :radio,
        title: 'Wie is deze persoon? <br>
<br>
Deze persoon is mijn:',
        options: [
          'Ouder',
          'Stiefouder',
          'Broer(tje) of zus(je)',
          'Opa of oma',
          'Oom of tante',
          'Pleegouder'],
        show_otherwise: true,
        otherwise_label: 'Anders, namelijk:'
      }, {
        id: :v8_2,
        type: :number,
        title: 'Hoe oud is deze persoon in jaren?',
        tooltip: 'Bijvoorbeeld: als je moeder 33 jaar is vul je 33 in.',
        maxlength: 2,
        placeholder: 'Vul hier een getal in',
        min: 0,
        max: 99,
        required: true
      }, {
        id: :v8_3,
        type: :dropdown,
        title: 'In welke maand is deze persoon jarig?',
        options: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december', 'weet ik niet']
      }, {
        id: :v8_4,
        type: :radio,
        required: true,
        show_otherwise: false,
        title: 'Is dit een man/jongen of een vrouw/meisje?',
        options: [
          { title: 'Man/jongen' },
          { title: 'Vrouw/meisje' },
          { title: 'Anders' }]
      }, {
        id: :v8_5,
        type: :radio,
        show_otherwise: false,
        title: 'Hoe voel je je bij deze persoon? <br>
<br>
Kies 1 van de 5 plaatjes',
        options: [betrokkenheid1, betrokkenheid2, betrokkenheid3, betrokkenheid4, betrokkenheid5]
      }
    ],
    section_end: true
  }, {
    id: :v9,
    section_start: 'De volgende vragen gaan over het andere huis waar je woont.',
    hidden: true,
    type: :radio,
    show_otherwise: true,
    title: 'Hoeveel nachten per week slaap je in dit huis?',
    options: [
      { title: 'Minder dan 1 nacht per week' },
      { title: '1 nacht per week' },
      { title: '2 nachten per week' },
      { title: '3 nachten per week' },
      { title: '4 nachten per week' },
      { title: '5 nachten per week' },
      { title: '6 nachten per week' },
      { title: '7 nachten per week' }],
    section_end: false
  }, {
    id: :v10,
    hidden: true,
    type: :radio,
    show_otherwise: false,
    title: 'Heb je in dit huis een eigen kamer?',
    options: [
      { title: 'Ja' },
      { title: 'Nee' }]
  }, {
    id: :v11,
    hidden: true,
    type: :number,
    title: 'Met hoeveel <i>andere</i> mensen woon je samen in dit huis? Dit zijn personen die altijd of meestal in hetzelfde huis wonen als jij, zoals ouders, (half-) broers, (half-) zussen. Tel jezelf <i>niet</i> mee.',
    maxlength: 2,
    placeholder: 'Bijvoorbeeld: 4',
    links_to_expandable: :v12,
    min: 0,
    max: 20,
    required: true
  }, {
    id: :v12,
    hidden: true,
    title: 'We willen graag wat meer informatie over deze personen. Hieronder zie je voor elk van deze personen een blokje getiteld "Persoon" met vijf vragen. Beantwoord voor elke persoon met wie in je huis woont een blokje met vragen.',
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
        id: :v12_1,
        type: :radio,
        title: 'Wie is deze persoon? <br>
<br>
Deze persoon is mijn:',
        options: [
          'Ouder',
          'Stiefouder',
          'Broer(tje) of zus(je)',
          'Opa of oma',
          'Oom of tante',
          'Pleegouder'],
        show_otherwise: true,
        otherwise_label: 'Anders, namelijk:'
      }, {
        id: :v12_2,
        type: :number,
        title: 'Hoe oud is deze persoon in jaren?',
        tooltip: 'Bijvoorbeeld: als je moeder 33 jaar is vul je 33 in.',
        maxlength: 2,
        placeholder: 'Vul hier een getal in',
        min: 0,
        max: 99,
        required: true
      }, {
        id: :v12_3,
        type: :dropdown,
        title: 'In welke maand is deze persoon jarig?',
        options: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december', 'weet ik niet']
      }, {
        id: :v12_4,
        type: :radio,
        show_otherwise: false,
        title: 'Is dit een man/jongen of een vrouw/meisje?',
        options: [
          { title: 'Man/jongen' },
          { title: 'Vrouw/meisje' },
          { title: 'Anders' }]
      }, {
        id: :v12_5,
        type: :radio,
        show_otherwise: false,
        title: 'Hoe voel je je bij deze persoon? <br>
<br>
Kies 1 van de 5 plaatjes',
        options: [betrokkenheid1, betrokkenheid2, betrokkenheid3, betrokkenheid4, betrokkenheid5]
      }
    ]
  }, {
    id: :v13,
    type: :radio,
    show_otherwise: false,
    title: 'Heb je een huisdier?',
    options: [{ title: 'Ja', shows_questions: %i[v13_1] }, { title: 'Nee' }]
  }, {
    id: :v13_1,
    hidden: true,
    type: :checkbox,
    title: 'Wat voor huisdier(en) heb je?',
    options: [
      { title: 'Hond(en)' },
      { title: 'Kat(ten)' },
      { title: 'Vogel(s)' },
      { title: 'Knaagdier(en) (Cavia, konijn, muizen, ratten)' },
      { title: 'Reptiel(en)' },
      { title: 'Vis(sen)' }],
    tooltip: 'Je mag meerdere antwoorden kiezen',
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over je gewoontes:',
    id: :v14_1,
    type: :checkbox,
    required: true,
    title: 'Wat vind je leuk om te doen? Waar word je blij van?',
    options: [{ title: 'Tekenen' }, { title: 'Lezen' }, { title: 'Gamen' }, { title: 'Met vrienden of vriendinnen zijn' }, { title: 'Sporten' }, { title: 'Muziek maken' }, { title: 'Films, videos of series kijken (op tv of via internet)' }, { title: 'Winkelen' }, { title: 'Sociale media (bijvoorbeeld Facebook, Instagram, SnapChat)' }, { title: 'Buiten zijn of spelen' }],
    tooltip: 'Je mag meerdere antwoorden kiezen',
    section_end: false
  }, {
    id: :v14_2,
    type: :textfield,
    title: 'Welke van de bovenstaande dingen vind je het allerleukste om te doen?',
    required: true
  }, {
    id: :v14_3,
    type: :range,
    title: 'Zou je iets willen veranderen aan <i>hoe vaak</i> je hiermee bezig bent?',
    labels: ['Ik zou het veel minder vaak doen', 'Ik zou niks veranderen', 'Ik zou het veel vaker doen'],
    required: true
  }, {
    id: :v14_4,
    type: :textfield,
    title: 'Wat doe je als je je down voelt of slecht in je vel zit? Dit kan iets zijn wat je hierboven genoemd hebt, of iets wat je nog niet genoemd hebt.',
    required: true
  }, {
    id: :v15,
    type: :radio,
    title: 'Doe je één of meerdere sport(en)?',
    options: [{ title: 'Ja', shows_questions: %i[v15_1 v15_2] }, { title: 'Nee' }],
    show_otherwise: false
  }, {
    id: :v15_1,
    type: :likert,
    title: 'Doe je deze sport alleen of in een team?',
    options: ['Alleen', 'In een team', 'Beide'],
    hidden: true
  }, {
    id: :v15_2,
    type: :range,
    hidden: true,
    title: 'Zou je iets willen veranderen aan <i>hoe vaak</i> je sport?',
    labels: ['Ik zou veel minder vaak sporten', 'Ik zou niks veranderen', 'Ik zou veel vaker sporten'],
    required: true
  }, {
    id: :v16,
    type: :range,
    title: 'Bedenk welke dingen je meestal doet in een gewone week (bijvoorbeeld: naar school gaan, sporten, hobbies). Hoe druk heb je het met deze dingen?',
    labels: ['Helemaal niet druk', 'Een beetje druk', 'Heel erg druk'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over je vriend(en) en vriendin(nen):',
    id: :v17,
    type: :radio,
    title: 'Heb je één of meerdere vriend(en) of vriendin(nen)?',
    options: [{ title: 'Ja', shows_questions: %i[v17_2 v17_3] }, { title: 'Nee' }],
    show_otherwise: false,
    section_end: false
  }, {
    id: :v17_1,
    type: :range,
    title: 'Zou je iets willen veranderen aan <i>hoeveel</i> vrienden je hebt?',
    labels: ['Ik zou veel minder vrienden willen', 'Ik zou niks veranderen', 'Ik zou veel meer vrienden willen'],
    required: true
  }, {
    id: :v17_2,
    type: :range,
    hidden: true,
    title: 'Zou je iets willen veranderen aan <i>hoe vaak</i> je je vriend(en) of vriendin(nen) ziet?',
    labels: ['Ik zou ze veel minder vaak zien', 'Ik zou niks veranderen', 'Ik zou ze veel vaker zien']
  }, {
    id: :v17_3,
    type: :range,
    hidden: true,
    title: 'Zou je iets willen veranderen aan <i>hoe vaak</i> je je vriend(en) of vriendin(nen) spreekt? Hiermee bedoelen we ook praten via WhatsApp en andere sociale media.',
    labels: ['Ik zou ze veel minder vaak spreken', 'Ik zou niks veranderen', 'Ik zou ze veel vaker spreken'],
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over de gewoontes van je gezin:',
    id: :v18,
    type: :radio,
    title: 'Doe je weleens iets leuks met je ouder(s) of opvoeder(s)?',
    options: [{ title: 'Ja', shows_questions: %i[v18_1] }, { title: 'Nee' }],
    show_otherwise: false,
    section_end: false
  }, {
    id: :v18_1,
    type: :textfield,
    hidden: true,
    title: 'Welke leuke dingen jullie doen samen?'
  }, {
    id: :v18_2,
    type: :range,
    required: true,
    title: 'Zou je iets willen veranderen aan <i>hoe vaak</i> je leuke dingen doet met je ouder(s) of opvoeder(s)?',
    labels: ['Ik wil veel minder vaak samen leuke dingen doen', 'Ik wil niks veranderen', 'Ik wil veel vaker samen leuke dingen doen']
  }, {
    id: :v18_3,
    type: :radio,
    title: 'Eten jullie weleens samen met het hele gezin?',
    options: %w[Ja Nee],
    show_otherwise: false
  }, {
    id: :v18_4,
    type: :range,
    title: 'Zou je iets willen veranderen aan <i>hoe vaak</i> jullie samen eten?',
    labels: ['Ik wil veel minder vaak samen eten', 'Ik wil niks veranderen', 'Ik wil vaker samen eten'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over de natuur en over buiten zijn:',
    id: :v19,
    type: :radio,
    title: 'Heeft jullie huis een tuin?',
    options: %w[Ja Nee],
    show_otherwise: false,
    section_end: false
  }, {
    id: :v19_1,
    type: :radio,
    title: 'Is er <i>in de buurt waar jij woont</i> een park, bos, strand of andere plek met natuur waar jij weleens naartoe gaat?',
    options: [{ title: 'Ja', shows_questions: %i[v19_2] }, { title: 'Nee' }],
    show_otherwise: false
  }, {
    id: :v19_2,
    type: :range,
    hidden: true,
    title: 'Zou je iets willen veranderen aan <i>hoe vaak</i> je hier naartoe gaat?',
    labels: ['Ik wil veel minder vaak gaan', 'Ik wil niks veranderen', 'Ik wil veel vaker gaan'],
    section_end: true
  }, {
    section_start: 'Er volgen nu een aantal zinnen over de natuur, en hoe jij daarover denkt. Hierbij gaat het om <i>alle</i> natuur en niet alleen om natuur in de buurt waar jij woont. Geef bij elke zin aan hoe waar deze is voor jou:',
    id: :v20,
    type: :range,
    title: 'Als ik verdrietig ben, ga ik het liefst naar buiten om in de natuur te zijn.',
    required: true,
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Heel erg waar'],
    section_end: false
  }, {
    id: :v20_1,
    type: :range,
    title: 'Ik voel me kalm als ik in de natuur ben.',
    required: true,
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Heel erg waar']
  }, {
    id: :v20_2,
    type: :range,
    title: 'Buiten zijn maakt me vrolijk.',
    required: true,
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Heel erg waar']
  }, {
    id: :v20_3,
    type: :range,
    title: 'Ik voel me verdrietig als mensen wilde dieren pijn doen.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v20_4,
    type: :range,
    title: 'Ik vind het fijn om dieren en planten aan te raken.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v20_5,
    type: :range,
    title: 'Voor dieren zorgen vind ik belangrijk.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v20_6,
    type: :range,
    title: 'Mensen horen bij de natuur.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v20_7,
    type: :range,
    title: 'Mensen kunnen niet leven zonder planten en dieren.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Heel erg waar'],
    required: true
  }, {
    id: :v20_8,
    type: :radio,
    title: 'Hoe erg hoort de natuur bij jou? Kies één van de plaatjes.',
    options: [natuur1, natuur2, natuur3, natuur4, natuur5],
    show_otherwise: false,
    section_end: true
  }, {
    section_start: 'Tot slot: Dit onderzoek gaat over geluk. Het coronavirus kan effect hebben op jouw geluk. Daarom stellen we soms een vraag over corona.',
    id: :v21,
    type: :checkbox,
    title: 'Ken je iemand die het coronavirus heeft of heeft gehad?',
    options: [
      { title: 'Ja, iemand die het nu heeft', shows_questions: %i[v21a] },
      { title: 'Ja, iemand die het gehad heeft', shows_questions: %i[v21a] },
      { title: 'Nee' }],
    show_otherwise: false,
    section_end: false
  }, {
    id: :v21a,
    hidden: true,
    type: :checkbox,
    title: 'Wie is deze persoon?',
    options: ['Mijn ouder(s)', 'Mijn broer(tje) of zus(je)', 'Mijn opa of oma', 'Een ander familielid', 'Een vriend(in)', 'Mijn leraar/lerares'],
    show_otherwise: true,
    section_end: true
  }
]
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Plezier van de natuur',
      ids: %i[v20 v20_1 v20_2],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Zorg voor de natuur',
      ids: %i[v20_3 v20_4 v20_5],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Gelijkheid',
      ids: %i[v20_6 v20_7],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
