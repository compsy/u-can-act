# frozen_string_literal: true

slider_min = 0
slider_max = 100
slider_start = (slider_min + slider_max) / 2

db_title = ''

db_name1 = 'affective_slider'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    id: :v1,
    type: :affective_slider,
    variant: :pleasure,
    required: true,
    min: slider_min,
    max: slider_max,
    value: slider_start,
    title: { nl: 'Verplaats de slider om aan te geven hoe prettig je je voelt.',
             de: 'Bewege den Schieberegler, um anzugeben wie du dich gerade fühlst.',
             en: 'Move the slider to rate your level of Pleasure.',
             fi: 'Arvioi liukusäätimellä, kuinka miellyttävältä olosi tuntuu.',
             es: 'Mueve la barra para valorar tu nivel de satisfacción.',
             pt: 'Mova o cursor para indicar o seu nível de satisfação.' },
    labels: [{ nl: 'Ongelukkig', de: 'Unglücklich', en: 'Unhappy', fi: 'Tyytymätön', es: 'Infeliz', pt: 'Infeliz' },
             { nl: 'Gelukkig', de: 'Glücklich', en: 'Happy', fi: 'Tyytyväinen', es: 'Feliz', pt: 'Feliz' }]
  },
  {
    id: :v2,
    type: :affective_slider,
    variant: :activation,
    required: true,
    min: slider_min,
    max: slider_max,
    value: slider_start,
    title: { nl: 'Verplaats de slider om aan te geven hoe actief of geactiveerd je lichaam zich op dit moment voelt.',
             de: 'Bewege den Schieberegler, um anzugeben, wie aktiviert sich dein Körper anfühlt.',
             en: 'Move the slider to rate how Activated your body feels right now.',
             fi: 'Arvioi liukusäätimellä vireystasoasi juuri tällä hetkellä.',
             es: 'Mueve la barra para calificar cómo de activado se siente tu cuerpo ahora mismo.',
             pt: 'Mova o cursor para indicar o nível de ativação do seu corpo neste momento.' },
    labels: [{ nl: 'Kalm / in rust', de: 'Im Ruhezustand', en: 'Calm / resting', fi: 'Rauhallinen / levossa',
               es: 'Calmado, relajado', pt: 'Calmo/em repouso' },
             { nl: 'Opgejaagd / zeer geactiveerd', de: 'Sehr aktiviert', en: 'Racing / highly activated',
               fi: 'Kiihtynyt / hyvin aktivoitunut', es: 'Acelerado, muy activado', pt: 'Acelerado/muito ativado' }]
  },
  {
    type: :next_questionnaire_notice
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
