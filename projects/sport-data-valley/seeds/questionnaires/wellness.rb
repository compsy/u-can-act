# frozen_string_literal: true

db_title = 'Wellness vragenlijst'

db_name1 = 'wellness'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Selecteer de optie die het beste aansluit bij uw huidige welbevinden. Wanneer u niet helemaal zeker bent van uw antwoord, probeer dan zo goed als mogelijk een antwoord te geven.</p>'
  },
  {
    id: :v1,
    title: 'Vermoeidheid',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: ['Altijd vermoeid',
             'Meer vermoeid dan normaal',
             'Normaal',
             'Fit',
             'Erg fit']
  },
  {
    id: :v2,
    title: 'Slaapkwaliteit',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: ['Slapeloosheid',
             'Onrustige slaap',
             'Moeite om in slaap te komen',
             'Goed',
             'Erg uitgerust']
  },
  {
    id: :v3,
    title: 'Algemene spierpijn',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: ['Erg veel spierpijn',
             'Verhoogde spierspanning / spierpijn',
             'Normaal',
             'Voelt goed',
             'Voelt geweldig']
  },
  {
    id: :v4,
    title: 'Stress',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: ['Erg gestresst',
             'Gestresst',
             'Normaal',
             'Relaxed',
             'Erg relaxed']
  },
  {
    id: :v5,
    title: 'Gemoedstoestand',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: ['Erg prikkelbaar / down',
             'Kortaf tegen teamgenoten, familie en collega’s',
             'Minder geïnteresseerd in anderen en/of activiteiten dan normaal',
             'Een overwegend goede gemoedstoestand',
             'Een erg positieve gemoedstoestand']
  }
]

questionnaire.content = dagboek_content
questionnaire.title = db_title
questionnaire.save!
