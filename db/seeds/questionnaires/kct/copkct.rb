# frozen_string_literal: true

title = 'Q-COP-KCT' 

name = 'KCT Q-COP'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]
content = [
  {
    type: :raw,
    content: '<p class="flow-text section-explanation"> Iedereen heeft in zijn leven wel eens te maken met problemen en tegenslagen. Hieronder volgen een
    aantal voorbeelden:</p>
    <ul class="collection">
    <li class="collection-item"> ruzie thuis </li>
    <li class="collection-item"> problemen op school, werk, of in je sport</li>
    <li class="collection-item"> gezondheidsproblemen van jezelf of van mensen in je directe leefomgeving</li>
    <li class="collection-item"> teleurstellende resultaten op school of werk</li>
    <li class="collection-item"> een relatie is verbroken</li>
    <li class="collection-item"> ontslag</li>
    </ul>
    Wat doe jij normaal gesproken bij zo’n probleem of tegenslag?'
  }, {
    id: :v1,
    type: :radio,
    title: 'Ik maak een plan van aanpak en voer dat uit.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v2,
    type: :radio,
    title: 'Ik zoek vrienden op waarmee je kunt lachen.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v3,
    type: :radio,
    title: 'Ik probeer het te vergeten door me op andere dingen te richten.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v4,
    type: :radio,
    title: 'Ik probeer afstand te nemen van de situatie door iets anders te gaan doen.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v5,
    type: :radio,
    title: 'Ik pak het probleem doelgericht aan.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v6,
    type: :radio,
    title: 'Ik bespreek het met iemand om de situatie beter te leren begrijpen.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v7,
    type: :radio,
    title: 'Ik probeer me te ontspannen en het probleem te vergeten.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v8,
    type: :radio,
    title: 'Ik ga werken aan een oplossing voor het probleem.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v9,
    type: :radio,
    title: 'Ik praat erover met iemand die dicht bij me staat.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v10,
    type: :radio,
    title: 'Ik probeer de spanning te verminderen door bijvoorbeeld te gaan roken, drinken, eten of sporten.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v11,
    type: :radio,
    title: 'Ik verander iets waardoor het probleem wordt opgelost.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v12,
    type: :radio,
    title: 'Ik zoek anderen op voor de afleiding.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v13,
    type: :radio,
    title: 'Ik denk aan andere dingen die niets met de tegenslag te maken hebben.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v14,
    type: :radio,
    title: 'Ik zet de zaken op een rij en los het probleem op.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ]
  }, {
    id: :v15,
    type: :radio,
    title: 'Ik praat erover met iemand die iets soortgelijks heeft meegemaakt.',
    options: [
      'Nooit',
      'Bijna nooit',
      'Soms',
      'Vaak',
      'Altijd'
    ],
    section_end: true
  }
]
questionnaire.content = content
questionnaire.title = title
questionnaire.save!
