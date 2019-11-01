#frozen_string_literal: true

db_title = 'Klachten' 
db_name1 = 'Klachten_Kinderen_Jongeren_Lang_Zelfrapportage'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content=[
{type: :raw, 
content: '<p class="flow-text">Welkom bij de vragenlijst <b> klachten</b>. Er volgt nu een lijst met vragen over jongens en meisjes. Alle vragen gaan over hoe je nu bent of in de afgelopen zes maanden bent geweest. Geef bij elke vraag aan in hoeverre deze bij jou past. Beantwoord de vragen zoals jij de dingen ziet, ook al zijn anderen het daar misschien niet mee eens.</p>'
},{
id: :v1,
type: :likert,
title: 'Ik doe te jong voor mijn leeftijd',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ],
section_end: false
},{
id: :v2_1,
type: :likert,
title: 'Ik drink alcohol zonder dat mijn ouders dat goed vinden',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v2_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v3,
type: :likert,
title: 'Ik maak veel ruzie',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v4,
type: :likert,
title: 'Ik maak dingen waar ik aan begin niet af',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v5,
type: :likert,
title: 'Er is heel weinig wat ik leuk vind',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v6,
type: :likert,
title: 'Ik hou van dieren',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v7,
type: :likert,
title: 'Ik schep op',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v8,
type: :likert,
title: 'Ik vind het moeilijk om me te concentreren of om mijn aandacht ergens bij houden',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v9_1,
type: :likert,
title: 'Ik kan bepaalde gedachten niet uit mijn hoofd zetten',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v9_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v10,
type: :likert,
title: 'Ik heb moeite met stilzitten',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v11,
type: :likert,
title: 'Ik ben te afhankelijk van volwassenen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v12,
type: :likert,
title: 'Ik voel me eenzaam',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v13,
type: :likert,
title: 'Ik voel me in de war',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v14,
type: :likert,
title: 'Ik huil veel',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v15,
type: :likert,
title: 'Ik ben best eerlijk',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v16,
type: :likert,
title: 'Ik ben gemeen tegen anderen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v17,
type: :likert,
title: 'Ik zit vaak overdag te dromen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v18,
type: :likert,
title: 'Ik probeer mijzelf met opzet te verwonden of te doden',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v19,
type: :likert,
title: 'Ik probeer veel aandacht te krijgen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v20,
type: :likert,
title: 'Ik verniel mijn eigen spullen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v21,
type: :likert,
title: 'Ik verniel de spullen van anderen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v22,
type: :likert,
title: 'Ik gehoorzaam mijn ouders niet',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v23,
type: :likert,
title: 'Ik ben ongehoorzaam op school',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v24,
type: :likert,
title: 'Ik eet niet zo goed als zou moeten',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v25,
type: :likert,
title: 'Ik kan niet met andere jongens of meisjes opschieten',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v26,
type: :likert,
title: 'Ik voel mij niet schuldig als ik iets gedaan heb wat ik niet had moeten doen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v27,
type: :likert,
title: 'Ik ben jaloers op anderen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
type: :likert,
title: 'Ik hou me niet aan de regels thuis, op school of ergens anders',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v29_1,
type: :likert,
title: 'Ik ben bang voor bepaalde dieren, situaties, of plaatsen anders dan school',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v29_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v30,
type: :likert,
title: 'Ik ben bang om naar school te gaan',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v31,
type: :likert,
title: 'Ik ben bang dat ik iets slechts zou kunnen doen of denken',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v32,
type: :likert,
title: 'Ik heb het gevoel dat ik perfect moet zijn',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v33,
type: :likert,
title: 'Ik heb het gevoel dat niemand van mij houdt',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v34,
type: :likert,
title: 'Ik heb het gevoel dat anderen mij te pakken willen nemen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v35,
type: :likert,
title: 'Ik voel me waardeloos of minderwaardig',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v36,
type: :likert,
title: 'Ik raak vaak per ongeluk gewond',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v37,
type: :likert,
title: 'Ik vecht veel',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v38,
type: :likert,
title: 'Ik word veel gepest',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v39,
type: :likert,
title: 'Ik ga om met jongens of meisjes die in moeilijkheden raken',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v40_1,
type: :likert,
title: 'Ik hoor geluiden of stemmen die er niet zijn',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v40_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v41,
type: :likert,
title: 'Ik doe dingen zonder er bij na te denken',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v42,
type: :likert,
title: 'Ik ben liever alleen dan met anderen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v43,
type: :likert,
title: 'Ik lieg of bedrieg',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v44,
type: :likert,
title: 'Ik bijt nagels',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v45,
type: :likert,
title: 'Ik ben nerveus, zenuwachtig of gespannen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v46_1,
type: :likert,
title: 'Ik heb zenuwachtige bewegingen of zenuwtrekken',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v46_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v47,
type: :likert,
title: 'Ik heb nachtmerries',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v48,
type: :likert,
title: 'Andere jongens of meisjes mogen mij niet',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v49,
type: :likert,
title: 'Ik doe sommige dingen beter dan de meeste van anderen van mijn leeftijd',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v50,
type: :likert,
title: 'Ik ben te angstig of te bang',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v51,
type: :likert,
title: 'Ik voel me duizelig of licht in mijn hoofd',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v52,
type: :likert,
title: 'Ik voel me erg schuldig',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v53,
type: :likert,
title: 'Ik eet te veel',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v54,
type: :likert,
title: 'Ik voel me erg moe zonder dat ik weet waarom',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v55,
type: :likert,
title: 'Ik ben te dik',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ],
section_end: true
},{
section_start: 'Lichamelijke problemen zonder bekende medische oorzaak',
id: :v56_1,
type: :likert,
title: 'Pijnen (geen buikpijn of hoofdpijn)',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v56_2,
type: :likert,
title: 'Hoofdpijn',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v56_3,
type: :likert,
title: 'Misselijk',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v56_4_1,
type: :likert,
title: 'Oogproblemen (waarvoor een bril of lenzen niet helpen)',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v56_4_2,
type: :textfield,
title: 'Zo ja, wat voor oogproblemen?'
},{
id: :v56_5,
type: :likert,
title: 'Huiduitslag of andere huidproblemen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v56_6,
type: :likert,
title: 'Buikpijn',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v56_7,
type: :likert,
title: 'Overgeven',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v56_8,
type: :likert,
title: 'Heb je nog andere lichamelijke problemen?',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v56_9,
type: :textfield,
title: 'Zo ja, wat voor problemen?',
section_end: true
},{
id: :v57,
type: :likert,
title: 'Ik val mensen lichamelijk aan',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v58_1,
type: :likert,
title: 'Ik pulk aan mijn huid of aan iets anders van mijn lichaam',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v58_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v59,
type: :likert,
title: 'Ik kan best aardig zijn',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v60,
type: :likert,
title: 'Ik vind het leuk om nieuwe dingen te proberen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v61,
type: :likert,
title: 'Mijn schoolwerk is slecht',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v62,
type: :likert,
title: 'Ik ben onhandig of stuntelig',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v63,
type: :likert,
title: 'Ik ga liever om met oudere jongens of meisjes dan met jongens of meisjes van mijn eigen leeftijd',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v64,
type: :likert,
title: 'Ik ga liever om met jongere jongens of meisjes dan met jongens of meisjes van mijn eigen leeftijd',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v65,
type: :likert,
title: 'Ik weiger om te praten',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v66_1,
type: :likert,
title: 'Ik herhaal bepaalde handelingen steeds maar weer',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v66_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v67,
type: :likert,
title: 'Ik loop weg van huis',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v68,
type: :likert,
title: 'Ik schreeuw veel',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v69,
type: :likert,
title: 'Ik ben gesloten of hou dingen voor mezelf',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v70_1,
type: :likert,
title: 'Ik zie dingen waarvan andere mensen denken dat ze er niet zijn',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v70_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v71,
type: :likert,
title: 'Ik schaam me gauw of voel me niet op mijn gemak',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v72,
type: :likert,
title: 'Ik sticht brandjes',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v73,
type: :likert,
title: 'Ik ben handig',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v74,
type: :likert,
title: 'Ik sloof me uit of doe gek om op te vallen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v75,
type: :likert,
title: 'Ik ben te verlegen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v76,
type: :likert,
title: 'Ik slaap minder dan de meeste jongens en meisjes',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v77_1,
type: :likert,
title: 'Ik slaap overdag en/of Ôs nachts meer dan de meeste jongens en meisjes', 
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v77_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v78,
type: :likert,
title: 'Ik let niet goed op of ben snel afgeleid',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v79_1,
type: :likert,
title: 'Ik heb een spraakprobleem',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v79_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v80,
type: :likert,
title: 'Ik kom voor mijzelf op',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v81,
type: :likert,
title: 'Ik steel thuis',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v82,
type: :likert,
title: 'Ik steel buitenshuis',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v83_1,
type: :likert,
title: 'Ik spaar te veel dingen op die ik niet nodig heb',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v83_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v84_1,
type: :likert,
title: 'Ik doe dingen die andere mensen vreemd vinden',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v84_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v85_1,
type: :likert,
title: 'Ik heb gedachten die andere mensen vreemd zouden vinden',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v85_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v86,
type: :likert,
title: 'Ik ben koppig',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v87,
type: :likert,
title: 'Mijn stemming of gevoelens veranderen plotseling',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v88,
type: :likert,
title: 'Ik vind het leuk om bij mensen te zijn',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v89,
type: :likert,
title: 'Ik ben achterdochtig',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v90,
type: :likert,
title: 'Ik vloek of gebruik vieze woorden',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v91,
type: :likert,
title: 'Ik denk erover mijzelf te doden',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v92,
type: :likert,
title: 'Ik vind het leuk om anderen aan het lachen te maken',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v93, 
type: :likert,
title: 'Ik praat te veel',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v94,
type: :likert,
title: 'Ik pest anderen veel',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v95,
type: :likert,
title: 'Ik ben snel driftig',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v96,
type: :likert,
title: 'Ik denk te veel aan seks',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v97,
type: :likert,
title: 'Ik dreig mensen om hen pijn te doen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v98,
type: :likert,
title: 'Ik vind het fijn om anderen te helpen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v99,
type: :likert,
title: 'Ik rook tabak',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v100_1,
type: :likert,
title: 'Ik heb problemen met slapen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v100_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v101,
type: :likert,
title: 'Ik sla lessen over of spijbel van school',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v102,
type: :likert,
title: 'Ik heb niet veel energie',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v103,
type: :likert,
title: 'Ik ben ongelukkig, verdrietig of depressief',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v104,
type: :likert,
title: 'Ik ben luidruchtiger dan andere jongens of meisjes',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v105_1,
type: :likert,
title: 'Ik gebruik drugs',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v105_2,
type: :textfield,
title: 'Leg je antwoord op de vorige vraag uit:'
},{
id: :v106,
type: :likert,
title: 'Ik probeer eerlijk te zijn tegen anderen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v107,
type: :likert,
title: 'Ik hou van een goede grap',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v108,
type: :likert,
title: 'Ik hou ervan om het rustig aan te doen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v109,
type: :likert,
title: 'Ik probeer andere mensen te helpen als ik dat kan',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v110,
type: :likert,
title: 'Ik wou dat ik van het andere geslacht was',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v111,
type: :likert,
title: 'Ik probeer met anderen weinig te maken te hebben',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v112,
type: :likert,
title: 'Ik maak me vaak zorgen',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
},{
id: :v113,
type: :textarea,
title: 'Schrijf hier alle andere dingen op die te maken hebben met je gevoelens, gedrag, manier van doen of belangstelling',
options: [ 'Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak' ]
}]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!










