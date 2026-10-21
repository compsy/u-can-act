# frozen_string_literal: true

db_title = ''

questionnaire_key = File.basename(__FILE__)[0...-3]
db_name1 = questionnaire_key
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = questionnaire_key if questionnaire.key.blank?

def ipaq_days_question(id, title, none_label, time_question_id)
  {
    id: id,
    type: :radio,
    show_otherwise: false,
    title: title,
    options: (1..7).map do |days|
      { title: days.to_s, value: days.to_s, numeric_value: days,
        shows_questions: %I[#{time_question_id}_hours #{time_question_id}_minutes #{time_question_id}] }
    end + [{ title: none_label, value: '0', numeric_value: 0 }]
  }
end

def ipaq_time_questions(id, title, hidden:)
  [
    { id: :"#{id}_hours", type: :number, hidden: hidden, title: title,
      placeholder: { nl: 'uren per dag', de: 'Stunden pro Tag', en: 'hours per day', fi: 'tuntia päivässä',
                     es: 'horas por día', pt: 'horas' },
      min: 0, max: 24, maxlength: 2 },
    { id: :"#{id}_minutes", type: :number, hidden: hidden, title: '',
      placeholder: { nl: 'minuten per dag', de: 'Minuten pro Tag', en: 'minutes per day', fi: 'minuuttia päivässä',
                     es: 'minutos por día', pt: 'minutos' },
      min: 0, max: 59, maxlength: 2 },
    { id: id, type: :checkbox, hidden: hidden, title: '', show_otherwise: false,
      options: [{ title: { nl: 'Weet niet / niet zeker', de: 'Ich weiß nicht / bin nicht sicher',
                           en: 'Don’t know / Not sure', fi: 'En osaa sanoa', es: 'No sabe / No está seguro',
                           pt: 'Não sabe / não tem a certeza' },
                  value: 'dont_know' }] }
  ]
end

dagboek_content = [
  {
    type: :raw,
    content: { nl: '<h4>Internationale Lichamelijke Activiteiten Vragenlijst, korte versie</h4>',
               de: '<h4>International Physical Activity Questionnaire, Short Last 7 Days Self-Administered Format, ' \
                   'German Version</h4>',
               en: '<h4>International Physical Activity Questionnaire (short, last 7 days, self-administered)</h4>',
               fi: '<h4>Kansainvälinen liikuntakysely (lyhyt IPAQ)</h4>',
               es: '<h4>Cuestionario Internacional de Actividad Física (versión corta)</h4>',
               pt: '<h4>Questionário Internacional de Actividade Física (IPAQ, versão curta)</h4>' }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Wij zijn geïnteresseerd welke vorm(en) van lichamelijke activiteit mensen ' \
                   'verrichten in hun dagelijkse leven. De vragen gaan over uw lichamelijke activiteit gedurende ' \
                   'de afgelopen 7 dagen. Beantwoordt u alstublieft alle vragen, ook al beschouwt u uzelf als niet ' \
                   'lichamelijk actief.</p>',
               de: '<p class="flow-text">Wir sind daran interessiert herauszufinden, welche Arten von körperlichen ' \
                   'Aktivitäten Menschen in ihrem alltäglichen Leben vollziehen. Die Befragung bezieht sich auf ' \
                   'die Zeit die Sie während der letzten 7 Tage in körperlicher Aktivität verbracht haben. Bitte ' \
                   'beantworten Sie alle Fragen (auch wenn Sie sich selbst nicht als aktive Person ansehen). Bitte ' \
                   'berücksichtigen Sie die Aktivitäten im Rahmen Ihrer Arbeit, in Haus und Garten, um von einem ' \
                   'Ort zum anderen zu kommen und in Ihrer Freizeit für Erholung, Leibesübungen und Sport.</p>',
               en: '<p class="flow-text">We are interested in finding out about the kinds of physical activities ' \
                   'that people do as part of their everyday lives. The questions will ask you about the time you ' \
                   'spent being physically active in the last 7 days. Please answer each question even if you do ' \
                   'not consider yourself to be an active person. Please think about the activities you do at ' \
                   'work, as part of your house and yard work, to get from place to place, and in your spare time ' \
                   'for recreation, exercise or sport.</p>',
               fi: '<p class="flow-text">Olemme kiinnostuneita tietämään, minkälaista liikkumista kuuluu ihmisten ' \
                   'jokapäiväiseen elämään. Kyselyssä tiedustellaan liikkumiseen käyttämääsi aikaa viimeisten 7 ' \
                   'päivän aikana. Vastaathan jokaiseen kysymykseen, vaikka et pitäisikään itseäsi liikunnallisena ' \
                   'ihmisenä. Ajattele liikkumistasi töissä, osana koti- ja pihatöitä, paikasta toiseen sekä ' \
                   'vapaa-aikana virkistyksen, liikuntaharjoittelun tai urheilun vuoksi.</p>',
               es: '<p class="flow-text">Estamos interesados en averiguar acerca de los tipos de actividad física ' \
                   'que hace la gente en su vida cotidiana. Las preguntas se referirán al tiempo que usted destinó ' \
                   'a estar físicamente activo en los últimos 7 días.</p>',
               pt: '<p class="flow-text">As questões que lhe vamos colocar de seguida referem-se à semana ' \
                   'imediatamente anterior, considerando o tempo em que esteve fisicamente activo(a).</p>' }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Denkt u aan alle zware lichamelijke activiteiten die u deed in de ' \
                   'afgelopen 7 dagen. Zware lichamelijke activiteiten zijn activiteiten die veel lichamelijke ' \
                   'inspanning kosten en voor een veel snellere ademhaling zorgen. Denk alleen aan de activiteiten ' \
                   'die u ten minste 10 minuten per keer heeft verricht.</p>',
               de: '<p class="flow-text">Denken Sie an all Ihre anstrengenden und moderaten Aktivitäten in den ' \
                   'vergangenen 7 Tagen. Anstrengende Aktivitäten bezeichnen Aktivitäten, die starke körperliche ' \
                   'Anstrengungen erfordern und bei denen Sie deutlich stärker atmen als normal. Moderate ' \
                   'Aktivitäten bezeichnen Aktivitäten mit moderater körperlicher Anstrengung bei denen Sie ein ' \
                   'wenig stärker atmen als normal.</p>',
               en: '<p class="flow-text">Think about all the vigorous activities that you did in the last 7 days. ' \
                   'Vigorous physical activities refer to activities that take hard physical effort and make you ' \
                   'breathe much harder than normal. Think only about those physical activities that you did for ' \
                   'at least 10 minutes at a time.</p>',
               fi: '',
               es: '<p class="flow-text">Piense en todas las actividades intensas que usted realizó en los últimos ' \
                   '7 días. Las actividades físicas intensas se refieren a aquellas que implican un esfuerzo ' \
                   'físico intenso y que lo hacen respirar mucho más intensamente que lo normal. Piense sólo en ' \
                   'aquellas actividades físicas que realizó durante por lo menos 10 minutos seguidos.</p>',
               pt: '' }
  },
  ipaq_days_question(
    :ipaq_1,
    { nl: 'Als u denkt aan de afgelopen 7 dagen, op hoeveel van deze dagen heeft u zware lichamelijke activiteiten ' \
          'verricht zoals zware lasten tillen, spitten, aerobics of wielrennen?<br><em>dagen per week</em>',
      de: 'Denken sie nur an die körperlichen Aktivitäten die Sie für mindestens 10 Minuten ohne Unterbrechung ' \
          'verrichtet haben. An wie vielen der vergangenen 7 Tage haben Sie anstrengende körperliche Aktivitäten ' \
          'wie Aerobic, Laufen, schnelles Fahrradfahren oder schnelles Schwimmen verrichtet?<br><em>Tage pro ' \
          'Woche</em>',
      en: 'During the last 7 days, on how many days did you do vigorous physical activities like heavy lifting, ' \
          'digging, aerobics, or fast bicycling?<br><em>days per week</em>',
      fi: 'Viimeisten 7 päivän aikana, kuinka monena päivänä sinulle kertyi rasittavaa liikkumista, kuten ' \
          'raskaiden taakkojen nostamista, kaivamista, aerobicia tai vauhdikasta pyöräilyä?<br><em>päivänä ' \
          'viikossa</em>',
      es: 'Durante los últimos 7 días, ¿en cuántos realizó actividades físicas intensas tales como levantar pesos ' \
          'pesados, cavar, hacer ejercicios aeróbicos o andar rápido en bicicleta?<br><em>días por semana</em>',
      pt: 'Diga-nos por favor, nos últimos 7 dias, em quantos dias fez actividades físicas vigorosas, como por ' \
          'exemplo, levantar objectos pesados, cavar, ginástica aeróbica, nadar, jogar futebol, andar de bicicleta ' \
          'a um ritmo rápido?<br><em>dias</em>' },
    { nl: 'geen zware lichamelijke activiteiten',
      de: 'Keine anstrengende Aktivität',
      en: 'No vigorous physical activities',
      fi: 'Ei rasittavaa liikkumista',
      es: 'Ninguna actividad física intensa',
      pt: 'Nenhuma' },
    :ipaq_2
  ),
  *ipaq_time_questions(
    :ipaq_2,
    { nl: 'Op de dagen dat u zwaar lichamelijk actief was, hoeveel tijd heeft u daar dan gewoonlijk aan besteed?',
      de: 'Wie viel Zeit haben Sie für gewöhnlich an einem dieser Tage mit anstrengender körperlicher Aktivität ' \
          'verbracht?',
      en: 'How much time did you usually spend doing vigorous physical activities on one of those days?',
      fi: 'Kuinka paljon käytit tavallisesti aikaa rasittavaan liikkumiseen tuollaisena päivänä?',
      es: 'Habitualmente, ¿cuánto tiempo en total dedicó a una actividad física intensa en uno de esos días?',
      pt: 'Nos dias em que pratica actividades físicas vigorosas, quanto tempo em média dedica normalmente a essas ' \
          'actividades?' },
    hidden: true
  ),
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Denkt u aan activiteiten die matige lichamelijke inspanning kosten en die ' \
                   'u in de afgelopen 7 dagen heeft verricht. Matig intensieve lichamelijke activiteit laat u iets ' \
                   'sneller ademen dan normaal. Denkt u weer alleen aan activiteiten die u ten minste 10 minuten ' \
                   'per keer heeft verricht.</p>',
               de: '',
               en: '<p class="flow-text">Think about all the moderate activities that you did in the last 7 days. ' \
                   'Moderate activities refer to activities that take moderate physical effort and make you ' \
                   'breathe somewhat harder than normal. Think only about those physical activities that you did ' \
                   'for at least 10 minutes at a time.</p>',
               fi: '',
               es: '<p class="flow-text">Piense en todas las actividades moderadas que usted realizó en los ' \
                   'últimos 7 días. Las actividades moderadas son aquellas que requieren un esfuerzo físico ' \
                   'moderado que lo hace respirar algo más intensamente que lo normal. Piense sólo en aquellas ' \
                   'actividades físicas que realizó durante por lo menos 10 minutos seguidos.</p>',
               pt: '' }
  },
  ipaq_days_question(
    :ipaq_3,
    { nl: 'Als u denkt aan de afgelopen 7 dagen, op hoeveel van deze dagen heeft u matig intensieve lichamelijke ' \
          'activiteit verricht, zoals het dragen van lichte lasten, fietsen in een normaal tempo of ' \
          'dubbeltennis?<br><em>dagen per week</em>',
      de: 'Denken Sie erneut nur an die körperlichen Aktivitäten die Sie für mindestens 10 Minuten ohne ' \
          'Unterbrechung verrichtet haben. An wie vielen der vergangenen 7 Tage haben sie moderate körperliche ' \
          'Aktivitäten, wie das Tragen leichter Lasten, Fahrradfahren bei gewöhnlicher Geschwindigkeit oder ' \
          'Schwimmen bei gewöhnlicher Geschwindigkeit verrichtet? Hierzu zählt nicht zu Fuß gehen.<br><em>Tage pro ' \
          'Woche</em>',
      en: 'During the last 7 days, on how many days did you do moderate physical activities like carrying light ' \
          'loads, bicycling at a regular pace, or doubles tennis? Do not include walking.<br><em>days per week</em>',
      fi: 'Viimeisten 7 päivän aikana, kuinka monena päivänä sinulle kertyi reipasta liikkumista, kuten kevyiden ' \
          'taakkojen kantamista, kohtuullisella vauhdilla pyöräilyä tai tenniksen nelinpeliä?<br><em>päivänä ' \
          'viikossa</em>',
      es: 'Durante los últimos 7 días, ¿en cuántos días hizo actividades físicas moderadas como transportar pesos ' \
          'livianos, andar en bicicleta a velocidad regular o jugar dobles de tenis? No incluya ' \
          'caminar.<br><em>días por semana</em>',
      pt: 'Diga-nos por favor, nos últimos 7 dias, em quantos dias fez actividades físicas moderadas como por ' \
          'exemplo, carregar objectos leves, esfregar/limpar o chão, caçar, trabalhos de carpintaria, andar de ' \
          'bicicleta a um ritmo normal ou ténis de pares?<br><em>dias</em>' },
    { nl: 'geen matig lichamelijke activiteiten',
      de: 'Keine moderate Aktivität',
      en: 'No moderate physical activities',
      fi: 'Ei reipasta liikkumista',
      es: 'Ninguna actividad física moderada',
      pt: 'Nenhuma' },
    :ipaq_4
  ),
  *ipaq_time_questions(
    :ipaq_4,
    { nl: 'Op de dagen dat u matig intensief lichamelijk actief was, hoeveel tijd heeft u daar dan gewoonlijk aan ' \
          'besteed?',
      de: 'Wie viel Zeit haben Sie für gewöhnlich an einem dieser Tage mit moderater körperlicher Aktivität ' \
          'verbracht?',
      en: 'How much time did you usually spend doing moderate physical activities on one of those days?',
      fi: 'Kuinka paljon käytit tavallisesti aikaa reippaaseen liikkumiseen tuollaisena päivänä?',
      es: 'Habitualmente, ¿cuánto tiempo en total dedicó a una actividad física moderada en uno de esos días?',
      pt: 'Nos dias em que faz actividades físicas moderadas, quanto tempo em média dedica normalmente a essas ' \
          'actividades?' },
    hidden: true
  ),
  {
    type: :raw,
    content: { nl: '',
               de: '',
               en: '<p class="flow-text">Think about the time you spent walking in the last 7 days. This includes ' \
                   'at work and at home, walking to travel from place to place, and any other walking that you ' \
                   'have done solely for recreation, sport, exercise, or leisure.</p>',
               fi: '<p class="flow-text">Ajattele aikaa, jonka käytit kävelemiseen viimeisten 7 päivän aikana. ' \
                   'Tähän sisältyy kävely töissä ja kotona, kävely paikasta toiseen ja kaikki vapaa-ajan kävely, ' \
                   'joka liittyy urheiluun, liikuntaharjoitteluun tai virkistykseen.</p>',
               es: '<p class="flow-text">Piense en el tiempo que usted dedicó a caminar en los últimos 7 días. ' \
                   'Esto incluye caminar en el trabajo o en la casa, para trasladarse de un lugar a otro, o ' \
                   'cualquier otra caminata que usted podría hacer solamente para la recreación, el deporte, el ' \
                   'ejercicio o el ocio.</p>',
               pt: '' }
  },
  ipaq_days_question(
    :ipaq_5,
    { nl: 'Als u denkt aan de afgelopen 7 dagen, op hoeveel dagen heeft u tenminste 10 minuten per keer ' \
          'gewandeld?<br><em>dagen per week</em>',
      de: 'An wie vielen der vergangenen 7 Tage sind Sie mindestens 10 Minuten ohne Unterbrechung zu Fuß gegangen? ' \
          'Dieses beinhaltet Gehstrecken daheim oder in der Arbeit, gehen um von einem Ort zu einem anderen zu ' \
          'gelangen, sowie alles andere Gehen zur Erholung, Bewegung oder Freizeit.<br><em>Tage pro Woche</em>',
      en: 'During the last 7 days, on how many days did you walk for at least 10 minutes at a time?<br><em>days ' \
          'per week</em>',
      fi: 'Viimeisten 7 päivän aikana kuinka monena päivänä kävelit vähintään 10 minuuttia ' \
          'kerrallaan?<br><em>päivänä viikossa</em>',
      es: 'Durante los últimos 7 días, ¿en cuántos caminó por lo menos 10 minutos seguidos?<br><em>días por ' \
          'semana</em>',
      pt: 'Diga-nos por favor, nos últimos 7 dias, em quantos dias andou pelo menos 10 minutos ' \
          'seguidos?<br><em>dias</em>' },
    { nl: 'geen wandelen',
      de: 'Keine entsprechenden Wege zu Fuß',
      en: 'No walking',
      fi: 'Ei kävelyä',
      es: 'Ninguna caminata',
      pt: 'Nenhum' },
    :ipaq_6
  ),
  *ipaq_time_questions(
    :ipaq_6,
    { nl: 'Op de dagen dat u ten minste 10 minuten per keer wandelde, hoeveel tijd heeft u daar dan gewoonlijk aan ' \
          'besteed?',
      de: 'Wie viel Zeit haben Sie für gewöhnlich an einem dieser Tage mit Gehen verbracht?',
      en: 'How much time did you usually spend walking on one of those days?',
      fi: 'Kuinka kauan tavallisesti kävelit tuollaisena päivänä?',
      es: 'Habitualmente, ¿cuánto tiempo en total dedicó a caminar en uno de esos días?',
      pt: 'Quanto tempo no total, despendeu num desses dias, a andar/caminhar?' },
    hidden: true
  ),
  {
    type: :raw,
    content: { nl: '',
               de: '',
               en: '<p class="flow-text">The last question is about the time you spent sitting on weekdays during ' \
                   'the last 7 days. Include time spent at work, at home, while doing course work and during ' \
                   'leisure time. This may include time spent sitting at a desk, visiting friends, reading, or ' \
                   'sitting or lying down to watch television.</p>',
               fi: '<p class="flow-text">Viimeinen kysymys koskee istumistasi arkipäivinä viimeisten 7 päivän ' \
                   'aikana. Ota huomioon aika töissä, kotona, opiskellessasi ja vapaa-aikanasi.</p>',
               es: '',
               pt: '' }
  },
  *ipaq_time_questions(
    :ipaq_7,
    { nl: 'Hoeveel tijd bracht u gewoonlijk zittend door gedurende een doordeweekse dag in de afgelopen 7 dagen?',
      de: 'Wie viel Zeit haben Sie in den vergangenen 7 Tagen an einem Wochentag mit Sitzen verbracht? Dies kann ' \
          'Zeit beinhalten wie Sitzen am Schreibtisch, Besuchen von Freunden, vor dem Fernseher sitzen oder liegen ' \
          'und auch sitzen in einem öffentlichen Verkehrsmittel.',
      en: 'During the last 7 days, how much time did you spend sitting on a week day?',
      fi: 'Viimeisten 7 päivän aikana, kuinka kauan istuit tavallisena arkipäivänä?',
      es: 'Durante los últimos 7 días, ¿cuánto tiempo pasó sentado durante un día hábil?',
      pt: 'Diga-me por favor, num dia normal quanto tempo passa sentado? Isto pode incluir o tempo que passa a uma ' \
          'secretária, a visitar amigos, a ler, a estudar ou a ver televisão.' },
    hidden: false
  ),
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Dit is het einde van de vragenlijst. Dank voor uw medewerking.</p>',
               de: '<p class="flow-text">Das ist das Ende der Befragung, danke für Ihre Teilnahme.</p>',
               en: '<p class="flow-text">This is the end of the questionnaire, thank you for participating.</p>',
               fi: '',
               es: '',
               pt: '' }
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
