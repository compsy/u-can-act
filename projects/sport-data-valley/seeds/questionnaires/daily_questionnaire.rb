# frozen_string_literal: true

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Selecteer de optie die het beste aansluit bij uw huidige welbevinden. Wanneer u niet helemaal zeker bent van uw antwoord, probeer dan zo goed als mogelijk een antwoord te geven.</p>'
  },
  {
    id: :v1,
    title: 'Slaapkwaliteit',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    section_start: 'Welzijn',
    labels: ['Slapeloosheid',
             'Onrustige slaap',
             'Moeite om in slaap te komen',
             'Goed',
             'Erg uitgerust']
  },
  {
    id: :v2,
    type: :time,
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    title: 'Slaapduur',
  },
  {
    id: :v3,
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
    id: :v6,
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
  },
  {
    id: :v7,
    title: 'Readiness-to train',
    type: :range,
    min: 1,
    max: 5,
    section_start: 'Gezondheid',
    step: 0.5,
    labels: [
      'Onmogelijk te trainen',
      'Niet ready om te trainen',
      'Normaal',
      'Ready om te trainen',
      'Helemaal ready om te trainen'
    ]
  },
  {
    id: :v8,
    title: 'Rusthartslag (slagen per minuut)',
    type: :number,
    maxlength: 3,
    min: 0,
    max: 400
  },
  {
    id: :v9,
    title: 'Ziek?',
    type: :radio,
    show_otherwise: false,
    options: ['ja', 'nee']
  },
  {
    id: :v10,
    title: 'Geblesseerd?',
    type: :radio,
    show_otherwise: false,
    options: ['ja', 'nee']
  },
  {
    id: :v11,
    section_start: 'Overig',
    title: 'Opmerkingen',
    type: :textarea
  }

]

days = %w(maandag dinsdag woensdag donderdag vrijdag zaterdag zondag)
days.each do |day|
  db_title = "Dagelijkse vragenlijst #{day}"

  db_name1 = "daily_questionnaire_#{day}"
  questionnaire = Questionnaire.find_by(name: db_name1)
  questionnaire ||= Questionnaire.new(name: db_name1)
  questionnaire.key = "#{File.basename(__FILE__)[0...-3]}_#{day}"

  questionnaire.content = dagboek_content
  questionnaire.title = db_title
  questionnaire.save!
end
