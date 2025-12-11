# frozen_string_literal: true

db_title = ''
db_name1 = 'informed_consent'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

ic_content = {
  nl: <<~'END',
    <div class='informed-consent'>
      <h4>Welkom bij de eerste UMO vragenlijst</h4>
      <p>In deze vragenlijst stellen we enkele vragen over kenmerken van uzelf en uw huishouden en over uw beschikbare vervoersopties. Het doel hiervan is om verschillen in reisgedrag en transportmogelijkheden van verschillende groepen mensen te kunnen onderzoeken.</p>
      <p>Deze gegevens kunnen in de toekomst beschikbaar gesteld worden aan derden voor wetenschappelijk onderzoek. Gegevens die het mogelijk zouden maken om u te identificeren (zoals uw adres) zullen echter nooit worden gedeeld, en worden gescheiden van de overige gegevens opgeslagen.</p>
    </div>
END
  en: <<~'END'
    <div class='informed-consent'>
      <h4>Welcome to the first UMO questionnaire</h4>
      <p>In this questionnaire we will ask you some questions about yourself and your household, and your available mobility options. This is so we can look at the travel behaviour and mobility opportunities of diverse groups of people.</p>
      <p>The data from these questionnaires may be made available to third parties for scientific research. Data that would possibly identify you (such as your address), however, will never be shared and will be stored separately from any other data.</p>
    </div>
END
}

dagboek_content = [
  {
    type: :raw,
    content: ic_content
  }, {
    id: :v0_a,
    type: :checkbox,
    required: true,
    title: {
      nl: 'Ik ga akkoord met de volgende:',
      en: 'I agree to the following:'
    },
    options: [
      {
        nl: 'Ik begrijp de bovenstaande uitleg en stem ermee in om deel te nemen aan deze vragenlijst, zoals hierboven en op de <a href="https://umo-nwo.nl/umo-panel/" target="_blank" rel="noopener noreferrer">informatiepagina</a> uitgelegd.',
        en: 'I understand the information listed above and consent to participating in this questionnaire. You may find more information at our <a href="https://umo-nwo.nl/umo-panel/" target="_blank" rel="noopener noreferrer">information page</a>.'
      }
    ],
    show_otherwise: false
  }, {
    id: :v0_b,
    type: :checkbox,
    required: false,
    title: {
      nl: '',
      en: ''
    },
    options: [
      {
        nl: 'Ik geef toestemming om mijn antwoorden op de vragenlijst te delen met andere onderzoekers, zoals hierboven en op de <a href="https://umo-nwo.nl/umo-panel/" target="_blank" rel="noopener noreferrer">informatiepagina</a> uitgelegd.',
        en: 'I give permission to share my answers with other researchers, as described above and on the <a href="https://umo-nwo.nl/umo-panel/" target="_blank" rel="noopener noreferrer">information page</a>.'
      }
    ],
    show_otherwise: false
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
