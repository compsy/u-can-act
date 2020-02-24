# frozen_string_literal: true

db_title = 'Creativiteit'

db_name1 = 'Creativiteit_Jongeren_16tot18'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! Deze vragenlijst gaat over je krachten. Er volgen X vragen. Hier ben je ongeveer X minuten mee bezig.</p>'
  }, {
    id: :v1_1,
    type: :range,
    title: 'In vergelijking met anderen van jouw leeftijd, hoe creatief bent je?',
    labels: ['Helemaal niet creatief', 'Net zo creatief', 'Heel erg creatief'],
    required: true
  }, {
    section_start: 'In hoeverre passen de volgende uitspraken bij jou? Verplaats het bolletje naar het antwoord dat het beste bij je past.',
    id: :v1_2,
    type: :range,
    title: 'Ik bedenk verschillende manieren om opdrachten uit te werken',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: false
  }, {
    id: :v1_3,
    type: :range,
    title: 'Ik bedenk nieuwe dingen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v1_4,
    type: :range,
    title: 'Ik heb altijd veel ideeën als ik een opdracht krijg',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v1_5,
    type: :range,
    title: 'Ik maak nieuwe dingen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v1_6,
    type: :range,
    title: 'Ik probeer meer manieren uit',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v1_7,
    type: :range,
    title: 'Ik maak dingen die voor mij nieuw zijn',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v1_8,
    type: :range,
    title: 'Ik kom zomaar op ideeën',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: true
  }, {
    section_start: 'In de volgende vragen zie je telkens drie woorden. Deze drie woorden hangen samen met één ander woord. De bedoeling is dat je bedenkt welk woord dit is. <br><br>
Bijvoorbeeld: de woorden <i>tijd / hard / zand</i> kunnen met elkaar verbonden worden door het woord <i>steen: steentijd / hardsteen / zandsteen</i>. Het oplossingswoord is hier dus <i>steen</i>.<br><br>
Vul het woord in bij het daarvoor bedoelde tekstvak. Als je het antwoord niet weet, vul dan in "Weet ik niet".<br>',
    id: :v2_1,
    type: :textfield,
    title: 'man / lijm / ster',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true,
    section_end: false
  }, {
    id: :v2_2,
    type: :textfield,
    title: 'hond / druk / band',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_3,
    type: :textfield,
    title: 'palm / familie / huis',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_4,
    type: :textfield,
    title: 'kamer / masker / explosie',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_5,
    type: :textfield,
    title: 'strijkijzer / schip / trein',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_6,
    type: :textfield,
    title: 'kop / boon / pause',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_7,
    type: :textfield,
    title: 'controle / plaats / gewicht',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_8,
    type: :textfield,
    title: 'bar / jurk / glas',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_9,
    type: :textfield,
    title: 'kolen / land / schacht',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_10,
    type: :textfield,
    title: 'kaas / land / huis',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_11,
    type: :textfield,
    title: 'achter / kruk / mat',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_12,
    type: :textfield,
    title: 'schommel / klap / rol',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_13,
    type: :textfield,
    title: 'vlokken / ketting / pet',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_14,
    type: :textfield,
    title: 'riet / klontje / hart',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_15,
    type: :textfield,
    title: 'licht / dromen / maan',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_16,
    type: :textfield,
    title: 'vis / mijn / geel',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_17,
    type: :textfield,
    title: 'worm / kast / legger',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_18,
    type: :textfield,
    title: 'bed / zee / school',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_19,
    type: :textfield,
    title: 'grond / vis / geld',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_20,
    type: :textfield,
    title: 'olie / pak / meester',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_21,
    type: :textfield,
    title: 'room / vloot / koek',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_22,
    type: :textfield,
    title: 'trommel / beleg /mes',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_23,
    type: :textfield,
    title: 'ga / daar / dag',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_24,
    type: :textfield,
    title: 'water / schoorsteen / lucht',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_25,
    type: :textfield,
    title: 'goot / kool / bak',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_26,
    type: :textfield,
    title: 'deur / werk / kamer',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_27,
    type: :textfield,
    title: 'nacht / vet / licht',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_28,
    type: :textfield,
    title: 'arm / veld / stil',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_29,
    type: :textfield,
    title: 'val / meloen / lelie',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true
  }, {
    id: :v2_30,
    type: :textfield,
    title: 'school / ontbijt / spel',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    required: true,
    section_end: true
  }, {
    section_start: 'Er volgen nu  een aantal uitspraken over gedachten en gevoelens die je in verschillende situaties kan hebben. Geef voor elke uitspraak aan in hoeverre deze bij jou past.',
    id: :v3_1,
    type: :range,
    required: true,
    title: 'Ik heb vaak tedere, bezorgde gevoelens voor mensen die minder gelukkig zijn dan ik.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij'],
    section_end: false
  }, {
    id: :v3_2,
    type: :range,
    required: true,
    title: 'Ik vind het soms moeilijk om dingen te zien vanuit het gezichtspunt van een ander.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_3,
    type: :range,
    required: true,
    title: 'Soms heb ik niet veel medelijden met andere mensen wanneer ze problemen hebben.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_4,
    type: :range,
    required: true,
    title: 'In noodsituaties voel ik me ongerust en slecht op mijn gemak.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_5,
    type: :range,
    required: true,
    title: 'Ik probeer naar ieders kant van een meningsverschil te kijken voordat ik een beslissing neem.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_6,
    type: :range,
    required: true,
    title: 'Wanneer ik iemand zie waarvan wordt geprofiteerd, voel ik me nogal beschermend tegenover die persoon.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_7,
    type: :range,
    required: true,
    title: 'Ik voel me soms hulpeloos als ik middenin een zeer emotionele situatie zit.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_8,
    type: :range,
    required: true,
    title: 'Ik probeer mijn vrienden soms beter te begrijpen door me in te beelden hoe de dingen eruit zien vanuit hun perspectief.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_9,
    type: :range,
    required: true,
    title: 'Als ik zie dat iemand zich bezeert blijf ik meestal kalm.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_10,
    type: :range,
    required: true,
    title: 'Andermans ongelukken doen me meestal niet zo veel.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_11,
    type: :range,
    required: true,
    title: 'Als ik zeker ben dat ik over iets gelijk heb, verspil ik niet veel tijd aan het luisteren naar de argumenten van een ander.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_12,
    type: :range,
    required: true,
    title: 'Ik houd er niet van om in een gespannen emotionele situatie te zijn.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_13,
    type: :range,
    required: true,
    title: 'Als ik zie dat iemand oneerlijk wordt behandeld, voel ik soms weinig medelijden met die persoon.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_14,
    type: :range,
    required: true,
    title: 'Ik ben meestal behoorlijk goed in het omgaan met noodsituaties.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_15,
    type: :range,
    required: true,
    title: 'Ik ben vaak nogal geraakt door dingen die ik zie gebeuren.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_16,
    type: :range,
    required: true,
    title: 'Ik geloof dat er twee kanten zijn aan elke vraag en probeer naar allebei de kanten te kijken.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_17,
    type: :range,
    required: true,
    title: 'Ik zou mijzelf beschrijven als een persoon met een goed hart.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_18,
    type: :range,
    required: true,
    title: 'Ik verlies vaak de controle tijdens noodsituaties.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_19,
    type: :range,
    required: true,
    title: 'Als ik boos ben op iemand, probeer ik mijzelf meestal voor een tijdje in die ander te verplaatsen.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_20,
    type: :range,
    required: true,
    title: 'Als ik iemand zie die zeer hard hulp nodig heeft in een noodsituatie, heb ik mezelf niet meer in de hand.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij']
  }, {
    id: :v3_21,
    type: :range,
    required: true,
    title: 'Voordat ik kritiek op iemand geef, probeer ik mij voor te stellen hoe ik mij zou voelen in zijn of haar plaats.',
    labels: ['Past helemaal niet bij mij', 'Past een beetje bij mij', 'Past heel erg bij mij'],
    section_end: true
  },{
    section_start: 'Er volgen nu nog 10 zinnen. Verschuif het bolletje naar het antwoord dat het beste bij jou past.',
    id: :v4_1,
    type: :range,
    required: true,
    title: 'Ik raak van streek als ik gevoelens heb die nergens op slaan.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar'],
    section_end: false
  }, {
    id: :v4_2,
    type: :range,
    required: true,
    title: 'Op school loop ik van de ene activiteit naar de volgende zonder dat ik door heb wat ik aan het doen ben.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar']
  }, {
    id: :v4_3,
    required: true,
    type: :range,
    title: 'Ik houd mezelf bezig zodat ik mijn gedachten of gevoelens niet op merk.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar']
  }, {
    id: :v4_4,
    type: :range,
    required: true,
    title: 'Ik zeg tegen mezelf dat ik me niet zo zou moeten voelen zoals ik me voel.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar']
  }, {
    id: :v4_5,
    type: :range,
    required: true,
    title: 'Ik druk gedachten weg die ik niet prettig vind.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar']
  }, {
    id: :v4_6,
    type: :range,
    required: true,
    title: 'Het is moeilijk voor mij om mijn aandacht op één ding tegelijk te richten.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar']
  }, {
    id: :v4_7,
    type: :range,
    required: true,
    title: 'Ik denk aan dingen die in het verleden gebeurd zijn, in plaats van aan dingen die in het hier en nu plaatsvinden.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar']
  }, {
    id: :v4_8,
    type: :range,
    required: true,
    title: 'Ik word boos op mezelf over het hebben van bepaalde gedachten.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar']
  }, {
    id: :v4_9,
    type: :range,
    required: true,
    title: 'Ik denk dat sommige van mijn gevoelens (bijvoorbeeld blij, boos, bang of verdrietig zijn) slecht zijn en dat ik ze niet zou moeten hebben.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar']
  }, {
    id: :v4_10,
    type: :range,
    required: true,
    title: 'Ik hou mezelf tegen in het hebben van gevoelens die ik niet prettig vind.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar'],
    section_end: true
  }, {
    section_start: 'Tot slot...',
    id: :v5,
    type: :expandable,
    title: 'Schrijf alle dingen op die je kunt doen met een melkpak',
    default_expansions: 1,
    max_expansions: 30,
    content: [{
                id: :v5_1,
                type: :textarea,
                required: true,
                title: 'Wat kun je doen met een melkpak?',
                tooltip: 'Schrijf zoveel mogelijk dingen op. Bijvoorbeeld: een pennenhouder van maken. Druk op het plusje als je nog een ander idee hebt over wat je met een melkpak kan doen.'}],
    section_end: true
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
