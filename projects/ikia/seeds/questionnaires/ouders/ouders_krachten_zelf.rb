# frozen_string_literal: true

db_title = 'Krachten'

db_name1 = 'Creativiteit_Ouders_Zelfrapportage'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! Deze vragenlijst gaat over uw krachten. Het invullen duurt ongeveer 15 minuten.</p>'
  }, {
    id: :v1_1,
    type: :range,
    title: 'In vergelijking met anderen van uw leeftijd, hoe creatief bent u?',
    labels: ['Helemaal niet creatief', 'Net zo creatief', 'Heel erg creatief'],
    required: true
  }, {
    section_start: 'In hoeverre passen de volgende uitspraken bij u? Verplaats het bolletje naar het antwoord dat het beste bij u past:',
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
    section_start: 'In de volgende vragen ziet u telkens drie woorden. Deze woorden zijn alledrie gerelateerd aan één ander woord. De bedoeling is dat u bedenkt welk woord dit is. <br><br>

Bijvoorbeeld: de woorden <i>tijd / hard / zand</i> kunnen met elkaar verbonden worden door het woord <i>steen: steentijd / hardsteen / zandsteen</i>. Het oplossingswoord is hier dus <i>steen</i>.<br><br>
Vul het woord in in het daarvoor bedoelde tekstvak. Als u het antwoord niet weet, kies dan voor "Weet ik niet".<br>',
    id: :v2_1,
    type: :radio,
    title: 'man / lijm / ster',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:',
    section_end: false
  }, {
    id: :v2_2,
    type: :radio,
    title: 'hond / druk / band',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_3,
    type: :radio,
    title: 'palm / familie / huis',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_4,
    type: :radio,
    title: 'kamer / masker / explosie',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_5,
    type: :radio,
    title: 'strijkijzer / schip / trein',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_6,
    type: :radio,
    title: 'kop / boon / pause',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_7,
    type: :radio,
    title: 'controle / plaats / gewicht',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_8,
    type: :radio,
    title: 'bar / jurk / glas',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_9,
    type: :radio,
    title: 'kolen / land / schacht',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_10,
    type: :radio,
    title: 'kaas / land / huis',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_11,
    type: :radio,
    title: 'achter / kruk / mat',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_12,
    type: :radio,
    title: 'schommel / klap / rol',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_13,
    type: :radio,
    title: 'vlokken / ketting / pet',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_14,
    type: :radio,
    title: 'riet / klontje / hart',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_15,
    type: :radio,
    title: 'licht / dromen / maan',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_16,
    type: :radio,
    title: 'vis / mijn / geel',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_17,
    type: :radio,
    title: 'worm / kast / legger',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_18,
    type: :radio,
    title: 'bed / zee / school',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_19,
    type: :radio,
    title: 'grond / vis / geld',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_20,
    type: :radio,
    title: 'olie / pak / meester',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_21,
    type: :radio,
    title: 'room / vloot / koek',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_22,
    type: :radio,
    title: 'trommel / beleg /mes',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_23,
    type: :radio,
    title: 'ga / daar / dag',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_24,
    type: :radio,
    title: 'water / schoorsteen / lucht',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_25,
    type: :radio,
    title: 'goot / kool / bak',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_26,
    type: :radio,
    title: 'deur / werk / kamer',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_27,
    type: :radio,
    title: 'nacht / vet / licht',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_28,
    type: :radio,
    title: 'arm / veld / stil',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_29,
    type: :radio,
    title: 'val / meloen / lelie',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:'
  }, {
    id: :v2_30,
    type: :radio,
    title: 'school / ontbijt / spel',
    tooltip: 'Het oplossingswoord verbindt de drie woorden.',
    options: ['Weet ik niet'],
    show_otherwise: true,
    otherwise_label: 'Oplossingswoord:',
    section_end: true
  }, {
    section_start: 'Er volgen nu een aantal uitspraken over gedachten en gevoelens die u in verschillende situaties kan hebben. Geef voor elke uitspraak aan in hoeverre deze bij u past:',
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
  }, {
    section_start: 'Geef voor elk van de volgende uitspraken aan hoe vaak deze voor u <i>in het algemeen</i> waar is. Verplaats het bolletje naar het antwoord dat het beste past:',
    id: :v4_1,
    type: :range,
    required: true,
    title: 'Als ik loop let ik bewust op hoe de beweging van mijn lichaam voelt.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar'],
    section_end: false
  }, {
    id: :v4_2,
    type: :range,
    required: true,
    title: 'Ik ben goed in het vinden van woorden om mijn gevoelens te beschrijven.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_3,
    type: :range,
    required: true,
    title: 'Ik bekritiseer mezelf voor het hebben van onlogische of ongepaste emoties.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_4,
    type: :range,
    required: true,
    title: 'Ik neem mijn gevoelens en emoties waar zonder dat ik er iets mee hoef te doen.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_5,
    type: :range,
    required: true,
    title: 'Als ik iets aan het doen ben dwalen mijn gedachten af en ben ik in het algemeen snel afgeleid.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_6,
    type: :range,
    required: true,
    title: 'Als ik onder de douche sta of in bad lig blijf ik me bewust van het gevoel van water op mijn lichaam.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_7,
    type: :range,
    required: true,
    title: 'Ik kan makkelijk mijn overtuigingen, meningen en verwachtingen onder woorden brengen.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_8,
    type: :range,
    required: true,
    title: 'Ik let niet op wat ik doe omdat ik dagdroom, pieker of iets anders doe waardoor ik afgeleid ben.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_9,
    type: :range,
    required: true,
    title: 'Ik observeer mijn gevoelens zonder dat ik me er helemaal door laat meeslepen.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_10,
    type: :range,
    required: true,
    title: 'Ik zeg tegen mezelf dat ik me niet zo zou moeten voelen als ik me voel.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_11,
    type: :range,
    required: true,
    title: 'Het valt me op hoe voedsel en drinken mijn gedachten, lichamelijke gewaarwordingen en emoties beïnvloeden.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_12,
    type: :range,
    required: true,
    title: 'Het is moeilijk voor me om de woorden te vinden die mijn gedachten beschrijven.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_13,
    type: :range,
    required: true,
    title: 'Ik ben snel afgeleid.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_14,
    type: :range,
    required: true,
    title: 'Ik heb soms niet normale of slechte gedachten, die ik niet zo zou moeten denken.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_15,
    type: :range,
    required: true,
    title: 'Ik let op lichamelijke ervaringen, zoals de wind in mijn haar of de zon op mijn gezicht.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_16,
    type: :range,
    required: true,
    title: 'Ik heb moeite met het bedenken van de juiste woorden om uit te drukken wat ik van dingen vind.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_17,
    type: :range,
    required: true,
    title: 'Ik oordeel of mijn gedachten goed of fout zijn.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_18,
    type: :range,
    required: true,
    title: 'Ik vind het moeilijk om mijn aandacht te houden bij wat er op dit moment gebeurt.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_19,
    type: :range,
    required: true,
    title: 'Als ik verontrustende gedachten heb of beelden zie, dan laat ik me daar niet door meevoeren.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_20,
    type: :range,
    required: true,
    title: 'Ik let in het algemeen op geluiden zoals het tikken van een klok, het fluiten van de vogels of het voorbijrijden van een auto.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_21,
    type: :range,
    required: true,
    title: 'In moeilijke situaties kan ik me inhouden zonder onmiddellijk te reageren.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_22,
    type: :range,
    required: true,
    title: 'Als ik iets in mijn lichaam voel, kost het me moeite om de juiste woorden te vinden om het te beschrijven.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_23,
    type: :range,
    required: true,
    title: 'Het lijkt alsof ik op de ‘automatische piloot’ sta zonder dat ik me erg bewust ben van wat ik doe.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_24,
    type: :range,
    required: true,
    title: 'Als ik verontrustende gedachten heb of beelden zie, voel ik me kort daarna weer rustig.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_25,
    type: :range,
    required: true,
    title: 'Ik zeg tegen mezelf dat ik niet moet denken zoals ik denk.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_26,
    type: :range,
    required: true,
    title: 'Ik merk de geur en het aroma van dingen op.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_27,
    type: :range,
    required: true,
    title: 'Zelfs als ik heel erg overstuur ben kan ik dit op een of andere manier onder woorden brengen.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_28,
    type: :range,
    required: true,
    title: 'Ik doe activiteiten gehaast zonder dat ik er echt aandacht voor heb.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_29,
    type: :range,
    required: true,
    title: 'Als ik verontrustende gedachten heb of beelden zie, kan ik ze opmerken zonder iets te doen.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_30,
    type: :range,
    required: true,
    title: 'Ik denk dat mijn emoties soms slecht of ongepast zijn en dat ik ze niet zou moeten voelen.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_31,
    type: :range,
    required: true,
    title: 'Ik merk de visuele aspecten van kunst of de natuur op, zoals kleur, vorm, structuur of patronen van licht en donker.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_32,
    type: :range,
    required: true,
    title: 'Het is mijn natuurlijke neiging om mijn ervaringen in woorden te vatten.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_33,
    type: :range,
    required: true,
    title: 'Als ik verontrustende gedachten heb of beelden zie, merk ik ze op laat ze los.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_34,
    type: :range,
    required: true,
    title: 'Ik doe mijn werk of taken automatisch zonder dat ik me bewust ben van wat ik doe.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_35,
    type: :range,
    required: true,
    title: 'Als ik verontrustende gedachten heb of beelden zie, veroordeel ik mezelf.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_36,
    type: :range,
    required: true,
    title: 'Ik let op hoe mijn emoties mijn gedachten en gedrag beïnvloeden.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_37,
    type: :range,
    required: true,
    title: 'Over het algemeen kan ik in detail beschrijven hoe ik me op dat moment voel.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_38,
    type: :range,
    required: true,
    title: 'Ik merk dat ik vaak dingen doe zonder er aandacht aan te besteden.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar']
  }, {
    id: :v4_39,
    type: :range,
    required: true,
    title: 'Ik keur mezelf af als ik onlogische gedachtes heb.',
    labels: ['Nooit of bijna nooit waar', 'Soms waar', 'Heel vaak of altijd waar'],
    section_end: true
  }, {
    section_start: 'Tot slot...',
    id: :v5,
    type: :expandable,
    title: 'Schrijf alle dingen op die u zou kunnen doen met een melkpak',
    default_expansions: 1,
    max_expansions: 30,
    content: [{
                id: :v5_1,
                type: :textarea,
                required: true,
                title: 'Wat kun je doen met een melkpak?',
                tooltip: 'Bijvoorbeeld: een pennenhouder van maken' }],
    section_end: true
  }
]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Creativiteit',
      ids: %i[v1_2 v1_3 v1_4 v1_5 v1_6 v1_7 v1_8],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Empathie',
      ids: %i[v3_1 v3_3 v3_6 v3_10 v3_13 v3_15 v3_17 v3_2 v3_5 v3_8 v3_11 v3_16 v3_19 v3_21],
      preprocessing: {
        v3_3: invert,
        v3_13: invert,
        v3_2: invert,
        v3_11: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Observeren',
      ids: %i[v4_1 v4_6 v4_11 v4_15 v4_20 v4_26 v4_31 v4_36],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s4,
      label: 'Niet oordelen',
      ids: %i[v4_3 v4_10 v4_14 v4_17 v4_25 v4_30 v4_35 v4_39],
      preprocessing: {
        v4_3: invert,
        v4_10: invert,
        v4_14: invert,
        v4_17: invert,
        v4_25: invert,
        v4_30: invert,
        v4_35: invert,
        v4_39: invert
      },
      operation: :average,
      round_to_decimals: 0 },
  ]
}
dagboek1.title = db_title
dagboek1.save!
