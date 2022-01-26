# frozen_string_literal: true

db_title = ''
db_name1 = 'daily_questionnaire_rheumatism'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

class RheumatismMethods
  class << self
    def category_title(category, title)
      "<strong>#{category}</strong>: #{title}"
    end
  end
end

dagboek_content = [
  {
    id: :v1,
    type: :range,
    title: RheumatismMethods.category_title('Vermoeidheid', 'Hoe hevig was uw vermoeidheid gemiddeld vandaag?'),
    min: 0,
    max: 10,
    step: 0.1,
    required: true,
    no_initial_thumb: true,
    labels: ['geen vermoeidheid', 'meest voorstelbare vermoeidheid']
  }, {
    id: :v2,
    type: :radio,
    title: RheumatismMethods.category_title('Vermoeidheid', 'Was er vandaag sprake van een ernstige piek in vermoeidheid?'),
    options: ['Nee'],
    show_otherwise: true,
    otherwise_label: 'Ja<br />Zo ja, waar denkt u dat dit door kwam?',
    otherwise_placeholder: 'Vul iets in'
  }, {
    id: :v3,
    type: :range,
    title: RheumatismMethods.category_title('Pijn', 'Hoe hevig was uw pijn gemiddeld vandaag?'),
    min: 0,
    max: 10,
    step: 0.1,
    required: true,
    no_initial_thumb: true,
    labels: ['geen pijn', 'meest voorstelbare pijn']
  }, {
    id: :v4,
    type: :range,
    title: RheumatismMethods.category_title('Stress', 'Hoe gestrest voelde u zich gemiddeld vandaag?'),
    min: 0,
    max: 10,
    step: 0.1,
    required: true,
    no_initial_thumb: true,
    labels: ['geen stress', 'meest voorstelbare stress']
  }, {
    id: :v5,
    type: :time,
    title: RheumatismMethods.category_title('Activiteit', 'Hoeveel uur van de afgelopen 24 uur heeft u besteed aan fysieke activiteiten?'),
    tooltip: 'Benoem hier het aantal uren waarin u lichamelijk actief was. Denk hierbij aan fietsen, wandelen, het huishouden, etc.<br /><br />Als u tegelijkertijd fysiek en cognitief actief was (bijvoorbeeld een intensief gesprek voeren tijdens een wandeling), mag deze bij beide categorieën meetellen.',
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: { nl: 'Uren', en: 'Hours' },
    minutes_label: { nl: 'Minuten', en: 'Minutes' },
    required: true
  }, {
    id: :v6,
    type: :time,
    title: RheumatismMethods.category_title('Activiteit', 'Hoeveel uur van de afgelopen 24 uur heeft u besteed aan cognitieve activiteiten?'),
    tooltip: 'Benoem hier het aantal uren waarin u cognitief actief was. Denk hierbij aan vergaderingen of taken voor school/werk waarbij u veel moet nadenken, lezen of puzzelen, etc.<br /><br />Als u tegelijkertijd fysiek en cognitief actief was (bijvoorbeeld een intensief gesprek voeren tijdens een wandeling), mag deze bij beide categorieën meetellen.',
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: { nl: 'Uren', en: 'Hours' },
    minutes_label: { nl: 'Minuten', en: 'Minutes' },
    required: true
  }, {
    id: :v7,
    type: :time,
    title: RheumatismMethods.category_title('Activiteit', 'Hoeveel uur van de afgelopen 24 uur heeft u besteed aan rust?'),
    tooltip: 'Benoem hier het aantal uren dat u heeft gerust. Dit zijn alle uren waarin u niet fysiek of cognitief actief was, maar ook niet geslapen heeft.',
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: { nl: 'Uren', en: 'Hours' },
    minutes_label: { nl: 'Minuten', en: 'Minutes' },
    required: true
  }, {
    id: :v8,
    type: :time,
    title: RheumatismMethods.category_title('Activiteit', 'Hoeveel uur van de afgelopen 24 uur heeft u besteed aan slaap?'),
    tooltip: 'Schat hier het aantal uren dat u heeft geslapen. Onder slaap verstaan wij alle uren die u echt geslapen heeft, dus niet de hoeveelheid tijd die u in bed heeft doorgebracht.',
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: { nl: 'Uren', en: 'Hours' },
    minutes_label: { nl: 'Minuten', en: 'Minutes' },
    required: true
  }, {
    id: :v9,
    type: :textarea,
    title: RheumatismMethods.category_title('Opmerkingen', 'Was er vandaag iets aan de hand (bv ziekte) wat invloed had op één van bovenstaande antwoorden? Zo ja, wat? Of wil je verder nog iets benoemen?')
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
