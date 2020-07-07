# frozen_string_literal: true

dagboek_content = [
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Selecteer de optie die het beste aansluit bij uw huidige welbevinden. Wanneer u niet helemaal zeker bent van uw antwoord, probeer dan zo goed als mogelijk een antwoord te geven.</p><br><img src="/sport-data-valley/daily_log_header.jpg" class="questionnaire-image" />',
               en: '<p class="flow-text">Select the option that best suits your current well-being. If you are not entirely sure about your answer, try to give an answer as best as possible.</p><br><img src="/sport-data-valley/daily_log_header.jpg" class="questionnaire-image" />' }
  },
  {
    id: :v1,
    title: { nl: 'Slaapkwaliteit', en: 'Sleep quality' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    section_start: { nl: 'Welzijn', en: 'Well-being' },
    labels: [{ nl: 'Slapeloosheid', en: 'Insomnia' },
             { nl: 'Onrustige slaap', en: 'Restless sleep' },
             { nl: 'Moeite om in slaap te komen', en: 'Difficulty falling asleep' },
             { nl: 'Goed', en: 'Good' },
             { nl: 'Erg uitgerust', en: 'Very rested' }]
  },
  {
    id: :v2,
    type: :time,
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: { nl: 'Uren', en: 'Hours' },
    minutes_label: { nl: 'Minuten', en: 'Minutes' },
    title: { nl: 'Slaapduur', en: 'Sleep duration' },
  },
  {
    id: :v3,
    title: { nl: 'Vermoeidheid', en: 'Fatigue' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: [{ nl: 'Altijd vermoeid', en: 'Always tired' },
             { nl: 'Meer vermoeid dan normaal', en: 'More tired than usual' },
             { nl: 'Normaal', en: 'Normal' },
             { nl: 'Fit', en: 'Fit' },
             { nl: 'Erg fit', en: 'Very fit' }]
  },
  {
    id: :v4,
    title: 'Stress',
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: [{ nl: 'Erg gestresst', en: 'Very stressed' },
             { nl: 'Gestresst', en: 'Stressed' },
             { nl: 'Normaal', en: 'Normal' },
             { nl: 'Relaxed', en: 'Relaxed' },
             { nl: 'Erg relaxed', en: 'Very relaxed' }]
  },
  {
    id: :v5,
    title: { nl: 'Algemene spierpijn', en: 'General muscle pain' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: [{ nl: 'Erg veel spierpijn', en: 'A lot of muscle pain' },
             { nl: 'Verhoogde spierspanning / spierpijn', en: 'Increased muscle tension / muscle pain' },
             { nl: 'Normaal', en: 'Normal' },
             { nl: 'Voelt goed', en: 'Feels good' },
             { nl: 'Voelt geweldig', en: 'Feels great' }]
  },
  {
    id: :v6,
    title: { nl: 'Gemoedstoestand', en: 'Mood' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    labels: [{ nl: 'Erg prikkelbaar / down', en: 'Very irritable / down' },
             { nl: 'Kortaf tegen teamgenoten, familie en collega’s', en: 'Curtly to teammates, family and colleagues' },
             { nl: 'Minder geïnteresseerd in anderen en/of activiteiten dan normaal', en: 'Less interested in others and/or activities than usual' },
             { nl: 'Een overwegend goede gemoedstoestand', en: 'A predominantly good mood' },
             { nl: 'Een erg positieve gemoedstoestand', en: 'A very positive mood' }]
  },
  {
    id: :v7,
    title: 'Readiness-to-train',
    type: :range,
    min: 1,
    max: 5,
    section_start: { nl: 'Gezondheid', en: 'Health' },
    step: 0.5,
    labels: [
      { nl: 'Onmogelijk te trainen', en: 'Impossible to train' },
      { nl: 'Niet ready om te trainen', en: 'Not ready to train' },
      { nl: 'Normaal', en: 'Normal' },
      { nl: 'Ready om te trainen', en: 'Ready to train' },
      { nl: 'Helemaal ready om te trainen', en: 'Completely ready to train' }
    ]
  },
  {
    id: :v8,
    title: { nl: 'Rusthartslag (slagen per minuut)', en: 'Resting heart rate (beats per minute)' },
    placeholder: { nl: 'Vul een getal in', en: 'Enter a number' },
    type: :number,
    maxlength: 3,
    min: 0,
    max: 400
  },
  {
    id: :v9,
    title: { nl: 'Ziek?', en: 'Sick?' },
    type: :radio,
    show_otherwise: false,
    options: [{ nl: 'ja', en: 'yes'}, { nl: 'nee', en: 'no' }]
  },
  {
    id: :v10,
    title: { nl: 'Geblesseerd?', en: 'Injured?' },
    type: :radio,
    show_otherwise: false,
    options: [{ nl: 'ja', en: 'yes' }, { nl: 'nee', en: 'no' }]
  },
  {
    id: :v11,
    section_start: { nl: 'Overig', en: 'Other' },
    title: { nl: 'Opmerkingen', en: 'Comments' },
    placeholder: { nl: 'Vul iets in (optioneel)', en: 'Enter some text (optional)' },
    type: :textarea
  }
]

days = %w(maandag dinsdag woensdag donderdag vrijdag zaterdag zondag)
english_days = %w(monday tuesday wednesday thursday friday saturday sunday)
days.each_with_index do |day, idx|
  english_day = english_days[idx]
  current_dagboek_content = dagboek_content.dup
  current_dagboek_content.unshift({
                                    type: :raw,
                                    content: { nl: "<h4 class=\"header\">Dagelijkse vragenlijst #{day}</h4>",
                                               en: "<h4 class=\"header\">Daily questionnaire #{english_day}</h4>" }
                                  })
  db_name1 = "daily_questionnaire_#{day}"
  questionnaire = Questionnaire.find_by(name: db_name1)
  questionnaire ||= Questionnaire.new(name: db_name1)
  questionnaire.key = "#{File.basename(__FILE__)[0...-3]}_#{day}"

  questionnaire.content = { questions: current_dagboek_content, scores: [] }
  questionnaire.title = "#{day.capitalize} vragenlijst"
  questionnaire.save!
end
