# frozen_string_literal: true

db_title = ''

questionnaire_key = File.basename(__FILE__)[0...-3]
db_name1 = questionnaire_key
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = questionnaire_key if questionnaire.key.blank?

imi9_options = [
  { title: { nl: 'Helemaal niet waar',
             de: 'Gar nicht wahr',
             en: 'Not at all true',
             fi: 'Täysin eri mieltä (Ei lainkaan totta)',
             es: 'Totalmente en desacuerdo (Nada verdadero)',
             pt: 'Nada verdadeiro (Discordo totalmente)' },
    value: '1', numeric_value: 1 },
  { title: { nl: 'Niet waar',
             de: 'Weitgehend nicht wahr',
             en: 'Untrue',
             fi: 'Jokseenkin eri mieltä',
             es: 'En desacuerdo',
             pt: 'Não verdadeiro' },
    value: '2', numeric_value: 2 },
  { title: { nl: 'Eerder niet waar',
             de: 'Eher nicht wahr',
             en: 'Somewhat untrue',
             fi: 'Hieman eri mieltä',
             es: 'Algo en desacuerdo',
             pt: 'Ligeiramente não verdadeiro' },
    value: '3', numeric_value: 3 },
  { title: { nl: 'Neutraal / Enigszins waar',
             de: 'Teils / teils',
             en: 'Neutral / Somewhat true',
             fi: 'Ei samaa eikä eri mieltä',
             es: 'Neutral',
             pt: 'Neutro' },
    value: '4', numeric_value: 4 },
  { title: { nl: 'Eerder waar',
             de: 'Eher wahr',
             en: 'True',
             fi: 'Hieman samaa mieltä',
             es: 'Algo de acuerdo',
             pt: 'Ligeiramente verdadeiro' },
    value: '5', numeric_value: 5 },
  { title: { nl: 'Waar',
             de: 'Weitgehend wahr',
             en: 'Very true',
             fi: 'Jokseenkin samaa mieltä',
             es: 'De acuerdo',
             pt: 'Muito verdadeiro' },
    value: '6', numeric_value: 6 },
  { title: { nl: 'Helemaal waar',
             de: 'Völlig wahr',
             en: 'Completely true',
             fi: 'Täysin samaa mieltä (Täysin totta)',
             es: 'Totalmente de acuerdo (Muy verdadero)',
             pt: 'Totalmente verdadeiro (Concordo totalmente)' },
    value: '7', numeric_value: 7 }
]

dagboek_content = [
  {
    type: :raw,
    content: { nl: '<h4>9-Item Intrinsic Motivation Inventory (IMI)</h4>',
               de: '<h4>9-Item Kurzskala zur Erfassung der intrinsischen Motivation (KIM / IMI)</h4>',
               en: '<h4>9-Item Intrinsic Motivation Inventory (IMI)</h4>',
               fi: '<h4>Sisäisen Motivaation Kyselylomake (IMI - 9-Kohtainen Lyhytversio)</h4>',
               es: '<h4>Inventario de Motivación Intrínseca (IMI - Versión de 9 Ítems)</h4>',
               pt: '<h4>Inventário de Motivação Intrínseca (IMI - Versão de 9 Itens)</h4>' }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Geef voor elk van de onderstaande stellingen aan in hoeverre deze op jou ' \
                   'van toepassing is met betrekking tot de activiteit die je zojuist hebt uitgevoerd. Gebruik ' \
                   'hiervoor de 7-puntsschaal.</p>',
               de: '<p class="flow-text">Bitte geben Sie für jede der folgenden Aussagen an, inwieweit diese auf ' \
                   'Sie und Ihre Erfahrung bei der soeben bearbeiteten Aufgabe zutrifft. Verwenden Sie dazu die ' \
                   '7-stufige Skala.</p>',
               en: '<p class="flow-text">For each of the following statements, please indicate how true it is for ' \
                   'you regarding the activity you just performed, using the 7-point scale below.</p>',
               fi: '<p class="flow-text">Arvioi seuraavia väitteitä sen mukaan, kuinka hyvin ne kuvaavat omaa ' \
                   'kokemustasi juuri tekemästäsi tehtävästä tai aktiviteetista. Käytä alla olevaa 7-portaista ' \
                   'asteikkoa.</p>',
               es: '<p class="flow-text">Por favor, indique para cada una de las siguientes afirmaciones el grado ' \
                   'en que refleja su experiencia con respecto a la actividad que acaba de realizar, utilizando la ' \
                   'escala de 1 a 7.</p>',
               pt: '<p class="flow-text">Por favor, indique para cada uma das seguintes afirmações até que ponto ' \
                   'ela descreve com precisão a sua experiência na atividade que acabou de realizar, utilizando a ' \
                   'escala de 1 a 7.</p>' }
  },
  {
    id: :imi9_1,
    type: :likert,
    title: { nl: 'Ik vond het erg leuk om deze activiteit te doen.',
             de: 'Die Durchführung dieser Aktivität hat mir sehr viel Spaß gemacht.',
             en: 'I enjoyed doing this activity very much.',
             fi: 'Nautin tämän tehtävän tekemisestä erittäin paljon.',
             es: 'Disfruté muchísimo realizando esta actividad.',
             pt: 'Gostei muito de realizar esta atividade.' },
    options: imi9_options
  },
  {
    id: :imi9_2,
    type: :likert,
    title: { nl: 'Deze activiteit was leuk en plezierig om uit te voeren.',
             de: 'Diese Aktivität war unterhaltsam und hat mir Freude bereitet.',
             en: 'This activity was fun to do.',
             fi: 'Tämän tehtävän tekeminen oli hauskaa ja viihdyttävää.',
             es: 'Esta actividad fue muy divertida y agradable de hacer.',
             pt: 'Esta atividade foi divertida e agradável de realizar.' },
    options: imi9_options
  },
  {
    id: :imi9_3,
    type: :likert,
    title: { nl: 'Ik vond dit een zeer interessante activiteit.',
             de: 'Ich fand diese Aktivität sehr interessant.',
             en: 'I thought this was a very interesting activity.',
             fi: 'Mielestäni tämä tehtävä oli todella mielenkiintoinen.',
             es: 'Me pareció que esta era una actividad sumamente interesante.',
             pt: 'Achei esta atividade extremamente interessante.' },
    options: imi9_options
  },
  {
    id: :imi9_4,
    type: :likert,
    title: { nl: 'Ik denk dat ik vrij goed ben in deze activiteit.',
             de: 'Ich denke, dass ich bei dieser Aktivität ziemlich gut bin / war.',
             en: 'I think I am pretty good at this activity.',
             fi: 'Uskon olevani melko hyvä tässä tehtävässä.',
             es: 'Creo que soy bastante bueno/a realizando esta actividad.',
             pt: 'Acho que sou bastante bom/boa nesta atividade.' },
    options: imi9_options
  },
  {
    id: :imi9_5,
    type: :likert,
    title: { nl: 'Na een tijdje aan deze activiteit te hebben gewerkt, voelde ik me er behoorlijk bekwaam in.',
             de: 'Nachdem ich mich eine Weile mit dieser Aktivität beschäftigt hatte, fühlte ich mich ziemlich ' \
                 'kompetent.',
             en: 'After working at this activity for a while, I felt pretty competent.',
             fi: 'Tehtyäni tätä tehtävää jonkin aikaa koin olevani siinä varsin pätevä ja osaava.',
             es: 'Después de trabajar en esta actividad por un tiempo, me sentí muy competente.',
             pt: 'Depois de trabalhar nesta atividade durante algum tempo, senti-me bastante competente.' },
    options: imi9_options
  },
  {
    id: :imi9_6,
    type: :likert,
    title: { nl: 'Vergeleken met anderen denk ik dat ik het vrij goed heb gedaan bij deze activiteit.',
             de: 'Im Vergleich zu anderen denke ich, dass ich mich bei dieser Aktivität gut geschlagen habe.',
             en: 'Compared to other people, I think I did pretty well at this activity.',
             fi: 'Muihin ihmisiin verrattuna suoriuduin tästä tehtävästä mielestäni melko hyvin.',
             es: 'En comparación con otras personas, creo que lo hice bastante bien en esta actividad.',
             pt: 'Em comparação com outras pessoas, acho que me saí bastante bem nesta atividade.' },
    options: imi9_options
  },
  {
    id: :imi9_7,
    type: :likert,
    title: { nl: 'Ik had het gevoel dat het mijn eigen keuze was om deze activiteit te doen.',
             de: 'Ich hatte das Gefühl, dass es meine eigene freie Entscheidung war, diese Aktivität auszuführen.',
             en: 'I felt that it was my choice to do this activity.',
             fi: 'Koin, että tehtävän tekeminen oli oma valintani.',
             es: 'Sentí que fue mi propia elección participar en esta actividad.',
             pt: 'Senti que foi uma escolha minha realizar esta atividade.' },
    options: imi9_options
  },
  {
    id: :imi9_8,
    type: :likert,
    title: { nl: 'Ik deed deze activiteit omdat ik het zelf graag wilde.',
             de: 'Ich habe diese Aktivität ausgeführt, weil ich es selbst machen wollte.',
             en: 'I did this activity because I wanted to.',
             fi: 'Tein tämän tehtävän, koska halusin itse tehdä sen.',
             es: 'Realicé esta actividad porque yo mismo/a quería hacerla.',
             pt: 'Fiz esta atividade porque eu próprio/a quis fazê-la.' },
    options: imi9_options
  },
  {
    id: :imi9_9,
    type: :likert,
    title: { nl: 'Ik voelde dat ik tijdens de taak deed wat ik zelf wilde doen.',
             de: 'Ich fühlte mich während der Bearbeitung frei, das zu tun, was ich tun wollte.',
             en: 'I felt like I was doing what I wanted to do while I was working on the task.',
             fi: 'Koin tekeväni juuri sitä, mitä halusin tehdä tämän tehtävän aikana.',
             es: 'Sentí que estaba haciendo lo que realmente quería hacer mientras realizaba la tarea.',
             pt: 'Senti que estava a fazer aquilo que queria fazer durante a execução da tarefa.' },
    options: imi9_options
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
