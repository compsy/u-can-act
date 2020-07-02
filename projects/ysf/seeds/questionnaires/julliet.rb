# frozen_string_literal: true

title = 'Julliet'

name = 'KCT Julliet'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title, section_end)
  default_options = [
    'Nooit',
    'Bijna nooit',
    'Soms',
    'Vaak',
    'Altijd'
  ]

  res = {
    id: id,
    type: :likert,
    title: title,
    options: default_options,
    show_otherwise: false
  }
  res[:section_end] = true if section_end
  res
end

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
    <p class="flow-text section-explanation">Wat doe jij normaal gesproken bij zo’n probleem of tegenslag?</p>
    '
  },
  create_question(:v1, 'Ik maak een plan van aanpak en voer dat uit.', false),
  create_question(:v2, 'Ik zoek vrienden op waarmee je kunt lachen.', false),
  create_question(:v3, 'Ik probeer het te vergeten door me op andere dingen te richten.', false),
  create_question(:v4, 'Ik probeer afstand te nemen van de situatie door iets anders te gaan doen.', false),
  create_question(:v5, 'Ik pak het probleem doelgericht aan.', false),
  create_question(:v6, 'Ik bespreek het met iemand om de situatie beter te leren begrijpen.', false),
  create_question(:v7, 'Ik probeer me te ontspannen en het probleem te vergeten.', false),
  create_question(:v8, 'Ik ga werken aan een oplossing voor het probleem.', false),
  create_question(:v9, 'Ik praat erover met iemand die dicht bij me staat.', false),
  create_question(:v10, 'Ik probeer de spanning te verminderen door bijvoorbeeld te gaan roken, drinken, eten of sporten.', false),
  create_question(:v11, 'Ik verander iets waardoor het probleem wordt opgelost.', false),
  create_question(:v12, 'Ik zoek anderen op voor de afleiding.', false),
  create_question(:v13, 'Ik denk aan andere dingen die niets met de tegenslag te maken hebben.', false),
  create_question(:v14, 'Ik zet de zaken op een rij en los het probleem op.', false),
  create_question(:v15, 'Ik praat erover met iemand die iets soortgelijks heeft meegemaakt.', false)
]
questionnaire.content = { questionnaire: content, scores: [] }
questionnaire.title = title
questionnaire.save!
