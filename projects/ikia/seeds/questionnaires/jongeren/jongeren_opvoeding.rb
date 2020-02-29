# frozen_string_literal: true

db_title = 'Opvoeding'

db_name1 = 'Opvoeding_Jongeren'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class = "flow-text">Welkom bij de vragenlijst <i> Opvoeding</i>. In deze vragenlijst onderzoeken we hoe je opvoeder met jou omgaat. Met opvoeder bedoelen we een persoon die thuis voor je zorgt, bijvoorbeeld je vader of moeder.<br> <br>
<b>Let op!</b> De vragen gaan over je opvoeder die het grootste gedeelte van de tijd voor jou zorgt, of met wie je de meeste tijd doorbrengt.</p>'
  }, {
    id: :v1,
    type: :textfield,
    title: 'Wie zorgt er thuis het grootste deel van de tijd voor jou?',
    tooltip: 'Bijvoorbeeld je moeder, vader, opa, oma',
    required: true
  }, {
    type: :raw,
    content: '<p class="flow-text"> Er volgen nu zes situaties en een aantal zinnen die reacties van opvoeders beschrijven. Stel je bij elke situatie voor dat jij het meegemaakt. Hoe zou jouw opvoeder dan reageren? Verplaats het bolletje naar het antwoord dat het beste past.</p>'
  }, {
    section_start: 'Je wilt graag een spel doen op de computer maar dit mag niet van je opvoeder. Je besluit het spel toch op de computer te spelen.<br> <br>Hoe zou jouw opvoeder reageren? Hij/zij zou…',
    id: :v2a,
    type: :range,
    title: '…mij uitleggen waarom het niet mag',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true,
    section_end: false
  }, {
    id: :v2b,
    type: :range,
    title: '…tegen mij schreeuwen van boosheid',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v2c,
    type: :range,
    title: '…merken dat ik op de computer zit en er niks van zeggen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v2d,
    type: :range,
    title: '…het toch goed vinden als ik hem/haar probeer over te halen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v2e,
    type: :range,
    title: '…mij waarschuwen wat er gaat gebeuren als ik niet luister',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v2f,
    type: :range,
    title: '…zijn/haar geduld verliezen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v2g,
    type: :range,
    title: '…mij een tik geven of pijn doen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true,
    section_end: true
  }, {
    section_start: 'Je bent heel blij omdat je een toets op school goed gemaakt hebt.<br><br> Hoe zou je opvoeder reageren? Hij/zij zou…',
    id: :v3a,
    type: :range,
    title: '…de tijd nemen om naar mij te luisteren',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true,
    section_end: false
  }, {
    id: :v3b,
    type: :range,
    title: '…voorstellen om het te vieren, bijvoorbeeld door iets leuks te doen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v3c,
    type: :range,
    title: '…mij herinneren aan andere toetsen die ik minder goed deed',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v3d,
    type: :range,
    title: '…niet merken dat ik blij ben',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v3e,
    type: :range,
    title: '…zeggen dat ik slim ben of dat ik goed ben',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v3f,
    type: :range,
    title: '…vragen of er leerlingen zijn die het nog beter hebben gedaan',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v3g,
    type: :range,
    title: '…zeggen dat ik deze keer gewoon geluk heb gehad',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v3h,
    type: :range,
    title: '…zeggen dat hij/zij trots is dat ik zo hard werk',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v3i,
    type: :range,
    title: '…geen aandacht hebben voor mijn goede cijfer',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true,
    section_end: true
  }, {
    section_start: 'Je gaat iets leuks doen met vrienden waar je veel zin in hebt. <br> <br> Hoe zou je opvoeder reageren? Hij/zij zou…',
    id: :v4a,
    type: :range,
    title: '…vragen wat we gaan doen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v4b,
    type: :range,
    title: '…praten over wat er allemaal mis kan gaan',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v4c,
    type: :range,
    title: '…zeggen dat ik rustig moet worden',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v4d,
    type: :range,
    title: '…niet merken dat ik er zin in heb',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v4e,
    type: :range,
    title: '…me veel plezier wensen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v4f,
    type: :range,
    title: '…zeggen dat ik het niet echt verdien om iets leuks te doen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v4g,
    type: :range,
    title: '…vragen of hij/zij me kan helpen, bijvoorbeeld door me ergens heen te brengen met de auto',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v4h,
    type: :range,
    title: '…interesse hebben in wat we gaan doen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v4i,
    type: :range,
    title: '…zeggen dat hij/zij het leuk vindt dat ik iets met vrienden ga doen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true,
    section_end: true
  }, {
    section_start: 'Je bent verdrietig omdat je ruzie hebt met een vriend of vriendin. <br> <br> Hoe zou je opvoeder reageren? Hij/zij zou…',
    id: :v5a,
    type: :range,
    title: '…proberen om me op te vrolijken',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v5b,
    type: :range,
    title: '…vragen wat er is gebeurd',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v5c,
    type: :range,
    title: '…met mij praten over hoe ik de ruzie op kan lossen',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v5d,
    type: :range,
    title: '…zeggen dat het allemaal wel meevalt',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v5e,
    type: :range,
    title: '…niet merken dat ik verdrietig ben',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v5f,
    type: :range,
    title: '…er geen aandacht aan besteden',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v5g,
    type: :range,
    title: '…boos worden dat ik ruzie heb gemaakt',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v5h,
    type: :range,
    title: '…me troosten',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v5i,
    type: :range,
    title: '…zenuwachtig of ongemakkelijk worden van mijn verdriet',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true,
    section_end: true
  }, {
    section_start: 'Je bent zenuwachtig voor een belangrijke gebeurtenis, bijvoorbeeld voor een wedstrijd of optreden. <br> <br> Hij/zij zou…',
    id: :v6a,
    type: :range,
    title: '…proberen mijn gedachten af te leiden door het over andere dingen te hebben',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true,
    section_end: false
  }, {
    id: :v6b,
    type: :range,
    title: '…met me praten over waarom ik zenuwachtig ben',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v6c,
    type: :range,
    title: '…niet merken dat ik zenuwachtig ben',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v6d,
    type: :range,
    title: '…zeggen dat ik niet moet overdrijven',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v6e,
    type: :range,
    title: '…boos of geïrriteerd worden dat ik zenuwachtig ben',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v6f,
    type: :range,
    title: '…zeggen dat ik me geen zorgen hoef te maken',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v6g,
    type: :range,
    title: '…er geen aandacht voor hebben',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true,
  }, {
    id: :v6h,
    type: :range,
    title: '…zelf ook zenuwachtig worden.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v6i,
    type: :range,
    title: '…met me praten over hoe ik het zo goed mogelijk kan doen.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true,
    section_end: true
  }
]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Luisteren en vragen stellen',
      ids: %i[v5a v5b v5c v5h v6a v6f v6i],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Complimenten geven',
      ids: %i[v3e v3h],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Signalen opmerken',
      ids: %i[v3d v3i v4d v5e v5f v6c v6g],
      preprocessing: {
        v3d: invert,
        v3i: invert,
        v4d: invert,
        v5e: invert,
        v5f: invert,
        v6c: invert,
        v6g: invert
      },
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
