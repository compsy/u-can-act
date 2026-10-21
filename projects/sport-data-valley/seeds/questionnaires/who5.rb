# frozen_string_literal: true

db_title = ''

questionnaire_key = File.basename(__FILE__)[0...-3]
db_name1 = questionnaire_key
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = questionnaire_key if questionnaire.key.blank?

who5_options = [
  { title: { nl: 'Constant', de: 'Die ganze Zeit', en: 'All of the time', fi: 'kaiken aikaa',
             es: 'Todo el tiempo', pt: 'Todo o tempo' },
    value: '5', numeric_value: 5 },
  { title: { nl: 'Meestal', de: 'Meistens', en: 'Most of the time', fi: 'enimmän osan aikaa',
             es: 'La mayor parte del tiempo', pt: 'A maior parte do tempo' },
    value: '4', numeric_value: 4 },
  { title: { nl: 'Meer dan de helft van de tijd', de: 'Etwas mehr als die Hälfte der Zeit',
             en: 'More than half of the time', fi: 'yli puolet ajasta',
             es: 'Más de la mitad del tiempo', pt: 'Mais de metade do tempo' },
    value: '3', numeric_value: 3 },
  { title: { nl: 'Minder dan de helft van de tijd', de: 'Etwas weniger als die Hälfte der Zeit',
             en: 'Less than half of the time', fi: 'alle puolet ajasta',
             es: 'Menos de la mitad del tiempo', pt: 'Menos de metade do tempo' },
    value: '2', numeric_value: 2 },
  { title: { nl: 'Soms', de: 'Ab und zu', en: 'Some of the time', fi: 'pienen osan ajasta',
             es: 'De vez en cuando', pt: 'Algumas vezes' },
    value: '1', numeric_value: 1 },
  { title: { nl: 'Helemaal niet', de: 'Zu keinem Zeitpunkt', en: 'At no time', fi: 'en lainkaan',
             es: 'Nunca', pt: 'Nunca' },
    value: '0', numeric_value: 0 }
]

dagboek_content = [
  {
    type: :raw,
    content: {
      nl: '<h4>WHO (vijf) Welzijnsindex (1999 versie)</h4>',
      de: '<h4>WHO (Fünf) Fragebogen zum Wohlbefinden (Version 1998)</h4>',
      en: '<h4>The World Health Organization-Five Well-Being Index (WHO-5)</h4>',
      fi: '<h4>Maailman terveysjärjestön viiden kysymyksen hyvinvointiasteikko (WHO-5)</h4>',
      es: '<h4>OMS (cinco) Índice de Bienestar (versión 1998)</h4>',
      pt: '<h4>Índice de bem-estar OMS (cinco) (WHO-5), versão de 1998</h4>'
    }
  },
  {
    type: :raw,
    content: {
      nl: '<p class="flow-text">U wordt verzocht voor ieder van de vijf uitdrukkingen aan te geven welke het best ' \
          'weergeeft hoe U zich heeft gevoeld tijdens de laatste twee weken. Hogere scores betekenen zich beter ' \
          'voelen.</p>',
      de: '<p class="flow-text">Die folgenden Aussagen betreffen Ihr Wohlbefinden in den letzten zwei Wochen. ' \
          'Bitte markieren Sie bei jeder Aussage die Rubrik, die Ihrer Meinung nach am besten beschreibt, wie Sie ' \
          'sich in den letzten zwei Wochen gefühlt haben.</p>' \
          '<p class="flow-text">In den letzten zwei Wochen …</p>',
      en: '<p class="flow-text">Please indicate for each of the five statements which is closest to how you have ' \
          'been feeling over the last two weeks. Notice that higher numbers mean better well-being.</p>' \
          '<p class="flow-text">Over the last two weeks …</p>',
      fi: '<p class="flow-text">Olkaa hyvä ja valitkaa kustakin viidestä väittämästä se, joka kuvaa parhaiten ' \
          'tuntemuksianne viimeisen kahden viikon ajalta. Huomatkaa, että korkeammat numerot merkitsevät parempaa ' \
          'hyvinvointia.</p>',
      es: '<p class="flow-text">Por favor, indique para cada una de las cinco afirmaciones cuál define mejor cómo ' \
          'se ha sentido usted durante las últimas dos semanas.</p>' \
          '<p class="flow-text">En las últimas dos semanas …</p>',
      pt: '<p class="flow-text">Indique, por favor, para cada uma das cinco afirmações, a que se aproxima mais do ' \
          'modo como se tem sentido nas últimas duas semanas.</p>' \
          '<p class="flow-text">Nas últimas duas semanas …</p>'
    }
  },
  {
    id: :who5_1,
    type: :likert,
    title: { nl: 'Ik voelde me vrolijk en in een opperbeste stemming',
             de: '… war ich froh und guter Laune',
             en: 'I have felt cheerful and in good spirits',
             fi: 'Olen ollut iloinen ja hyväntuulinen',
             es: 'Me he sentido alegre y de buen humor',
             pt: 'Senti-me alegre e bem disposto/a' },
    options: who5_options
  },
  {
    id: :who5_2,
    type: :likert,
    title: { nl: 'Ik voelde me rustig en ontspannen',
             de: '… habe ich mich ruhig und entspannt gefühlt',
             en: 'I have felt calm and relaxed',
             fi: 'Olen ollut levollinen ja rentoutunut',
             es: 'Me he sentido tranquilo y relajado',
             pt: 'Senti-me calmo/a e tranquilo/a' },
    options: who5_options
  },
  {
    id: :who5_3,
    type: :likert,
    title: { nl: 'Ik voelde me actief en doelbewust',
             de: '… habe ich mich energisch und aktiv gefühlt',
             en: 'I have felt active and vigorous',
             fi: 'Olen ollut toimelias ja tarmokas',
             es: 'Me he sentido activo y enérgico',
             pt: 'Senti-me activo/a e enérgico/a' },
    options: who5_options
  },
  {
    id: :who5_4,
    type: :likert,
    title: { nl: 'Ik voelde me fris en uitgerust wanneer ik wakker werd',
             de: '… habe ich mich beim Aufwachen frisch und ausgeruht gefühlt',
             en: 'I woke up feeling fresh and rested',
             fi: 'Herätessäni olen tuntenut itseni virkeäksi ja levänneeksi',
             es: 'Me he despertado fresco y descansado',
             pt: 'Acordei a sentir-me fresco/a e repousado/a' },
    options: who5_options
  },
  {
    id: :who5_5,
    type: :likert,
    title: { nl: 'Mijn dagelijkse leven was gevuld met dingen die me interesseren',
             de: '… war mein Alltag voller Dinge, die mich interessieren',
             en: 'My daily life has been filled with things that interest me',
             fi: 'Jokapäiväiseen elämääni on kuulunut paljon asioita, jotka kiinnostavat minua',
             es: 'Mi vida cotidiana ha estado llena de cosas que me interesan',
             pt: 'O meu dia-a-dia tem sido preenchido com coisas que me interessam' },
    options: who5_options
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
