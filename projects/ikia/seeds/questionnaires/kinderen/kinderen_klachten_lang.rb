# frozen_string_literal: true

db_title = 'Klachten'
db_name1 = 'Klachten_Lang_Kinderen_11plus'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
likert_options = [
  { title: 'Helemaal niet', numeric_value: 0 },
  { title: 'Een beetje of soms', numeric_value: 50 },
  { title: 'Duidelijk of vaak', numeric_value: 100 }
]
dagboek_content = [
  {
    type: :raw,
    content: '<blockquote>Copyright T.M. Achenbach. Reproduced by permission under License Number 1060-0719.<br>Copyright vertaling F.C. Verhulst en J. van der Ende, Erasmus MC Rotterdam</blockquote><p class="flow-text">Welkom bij de vragenlijst <b> klachten</b>. Er volgt nu een lijst met vragen over jongens en meisjes. Alle vragen gaan over hoe je nu bent of in de afgelopen zes maanden bent geweest. Geef bij elke vraag aan in hoeverre deze bij jou past. Beantwoord de vragen zoals jij de dingen ziet, ook al zijn anderen het daar misschien niet mee eens.</p>'
  }, {
    id: :v1,
    type: :likert,
    title: 'Ik doe te jong voor mijn leeftijd',
    options: likert_options,
    section_end: false
  }, {
    id: :v2_1,
    type: :likert,
    title: 'Ik drink alcohol zonder dat mijn ouders dat goed vinden',
    options: likert_options
  }, {
    id: :v2_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v3,
    type: :likert,
    title: 'Ik maak veel ruzie',
    options: likert_options
  }, {
    id: :v4,
    type: :likert,
    title: 'Ik maak dingen waar ik aan begin niet af',
    options: likert_options
  }, {
    id: :v5,
    type: :likert,
    title: 'Er is heel weinig wat ik leuk vind',
    options: likert_options
  }, {
    id: :v6,
    type: :likert,
    title: 'Ik hou van dieren',
    options: likert_options
  }, {
    id: :v7,
    type: :likert,
    title: 'Ik schep op',
    options: likert_options
  }, {
    id: :v8,
    type: :likert,
    title: 'Ik vind het moeilijk om me te concentreren of om mijn aandacht ergens bij houden',
    options: likert_options
  }, {
    id: :v9_1,
    type: :likert,
    title: 'Ik kan bepaalde gedachten niet uit mijn hoofd zetten',
    options: likert_options
  }, {
    id: :v9_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v10,
    type: :likert,
    title: 'Ik heb moeite met stilzitten',
    options: likert_options
  }, {
    id: :v11,
    type: :likert,
    title: 'Ik ben te afhankelijk van volwassenen',
    options: likert_options
  }, {
    id: :v12,
    type: :likert,
    title: 'Ik voel me eenzaam',
    options: likert_options
  }, {
    id: :v13,
    type: :likert,
    title: 'Ik voel me in de war',
    options: likert_options
  }, {
    id: :v14,
    type: :likert,
    title: 'Ik huil veel',
    options: likert_options
  }, {
    id: :v15,
    type: :likert,
    title: 'Ik ben best eerlijk',
    options: likert_options
  }, {
    id: :v16,
    type: :likert,
    title: 'Ik ben gemeen tegen anderen',
    options: likert_options
  }, {
    id: :v17,
    type: :likert,
    title: 'Ik zit vaak overdag te dagdromen',
    options: likert_options
  }, {
    id: :v18,
    type: :likert,
    title: 'Ik probeer mijzelf met opzet te verwonden of te doden',
    options: likert_options
  }, {
    id: :v19,
    type: :likert,
    title: 'Ik probeer veel aandacht te krijgen',
    options: likert_options
  }, {
    id: :v20,
    type: :likert,
    title: 'Ik verniel mijn eigen spullen',
    options: likert_options
  }, {
    id: :v21,
    type: :likert,
    title: 'Ik verniel de spullen van anderen',
    options: likert_options
  }, {
    id: :v22,
    type: :likert,
    title: 'Ik gehoorzaam mijn ouders niet',
    options: likert_options
  }, {
    id: :v23,
    type: :likert,
    title: 'Ik ben ongehoorzaam op school',
    options: likert_options
  }, {
    id: :v24,
    type: :likert,
    title: 'Ik eet niet zo goed als zou moeten',
    options: likert_options
  }, {
    id: :v25,
    type: :likert,
    title: 'Ik kan niet met andere jongens of meisjes opschieten',
    options: likert_options
  }, {
    id: :v26,
    type: :likert,
    title: 'Ik voel mij niet schuldig als ik iets gedaan heb wat ik niet had moeten doen',
    options: likert_options
  }, {
    id: :v27,
    type: :likert,
    title: 'Ik ben jaloers op anderen',
    options: likert_options
  }, {
    id: :v28,
    type: :likert,
    title: 'Ik hou me niet aan de regels thuis, op school of ergens anders',
    options: likert_options
  }, {
    id: :v29_1,
    type: :likert,
    title: 'Ik ben bang voor bepaalde dieren, situaties, of plaatsen anders dan school',
    options: likert_options
  }, {
    id: :v29_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v30,
    type: :likert,
    title: 'Ik ben bang om naar school te gaan',
    options: likert_options
  }, {
    id: :v31,
    type: :likert,
    title: 'Ik ben bang dat ik iets slechts zou kunnen doen of denken',
    options: likert_options
  }, {
    id: :v32,
    type: :likert,
    title: 'Ik heb het gevoel dat ik perfect moet zijn',
    options: likert_options
  }, {
    id: :v33,
    type: :likert,
    title: 'Ik heb het gevoel dat niemand van mij houdt',
    options: likert_options
  }, {
    id: :v34,
    type: :likert,
    title: 'Ik heb het gevoel dat anderen mij te pakken willen nemen',
    options: likert_options
  }, {
    id: :v35,
    type: :likert,
    title: 'Ik voel me waardeloos of minderwaardig',
    options: likert_options
  }, {
    id: :v36,
    type: :likert,
    title: 'Ik raak vaak per ongeluk gewond',
    options: likert_options
  }, {
    id: :v37,
    type: :likert,
    title: 'Ik vecht veel',
    options: likert_options
  }, {
    id: :v38,
    type: :likert,
    title: 'Ik word veel gepest',
    options: likert_options
  }, {
    id: :v39,
    type: :likert,
    title: 'Ik ga om met jongens of meisjes die in moeilijkheden raken',
    options: likert_options
  }, {
    id: :v40_1,
    type: :likert,
    title: 'Ik hoor geluiden of stemmen die er niet zijn',
    options: likert_options
  }, {
    id: :v40_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v41,
    type: :likert,
    title: 'Ik doe dingen zonder er bij na te denken',
    options: likert_options
  }, {
    id: :v42,
    type: :likert,
    title: 'Ik ben liever alleen dan met anderen',
    options: likert_options
  }, {
    id: :v43,
    type: :likert,
    title: 'Lieg of bedrieg',
    options: likert_options
  }, {
    id: :v44,
    type: :likert,
    title: 'Ik bijt nagels',
    options: likert_options
  }, {
    id: :v45,
    type: :likert,
    title: 'Ik ben nerveus, zenuwachtig of gespannen',
    options: likert_options
  }, {
    id: :v46_1,
    type: :likert,
    title: 'Ik heb zenuwachtige bewegingen of zenuwtrekken',
    options: likert_options
  }, {
    id: :v46_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v47,
    type: :likert,
    title: 'Ik heb nachtmerries',
    options: likert_options
  }, {
    id: :v48,
    type: :likert,
    title: 'Andere jongens of meisjes mogen mij niet',
    options: likert_options
  }, {
    id: :v49,
    type: :likert,
    title: 'Ik doe sommige dingen beter dan de meeste van anderen van mijn leeftijd',
    options: likert_options
  }, {
    id: :v50,
    type: :likert,
    title: 'Ik ben te angstig of te bang',
    options: likert_options
  }, {
    id: :v51,
    type: :likert,
    title: 'Ik voel me duizelig of licht in mijn hoofd',
    options: likert_options
  }, {
    id: :v52,
    type: :likert,
    title: 'Ik voel me erg schuldig',
    options: likert_options
  }, {
    id: :v53,
    type: :likert,
    title: 'Ik eet te veel',
    options: likert_options
  }, {
    id: :v54,
    type: :likert,
    title: 'Ik voel me erg moe zonder dat ik weet waarom',
    options: likert_options
  }, {
    id: :v55,
    type: :likert,
    title: 'Ik ben te dik',
    options: likert_options,
    section_end: true
  }, {
    section_start: 'Lichamelijke problemen zonder bekende medische oorzaak',
    id: :v56_1,
    type: :likert,
    title: 'Pijnen (geen buikpijn of hoofdpijn)',
    options: likert_options
  }, {
    id: :v56_2,
    type: :likert,
    title: 'Hoofdpijn',
    options: likert_options
  }, {
    id: :v56_3,
    type: :likert,
    title: 'Misselijk',
    options: likert_options
  }, {
    id: :v56_4_1,
    type: :likert,
    title: 'Oogproblemen (waarvoor een bril of lenzen niet helpen)',
    options: likert_options
  }, {
    id: :v56_4_2,
    type: :textfield,
    title: 'Zo ja, wat voor oogproblemen?'
  }, {
    id: :v56_5,
    type: :likert,
    title: 'Huiduitslag of andere huidproblemen',
    options: likert_options
  }, {
    id: :v56_6,
    type: :likert,
    title: 'Buikpijn',
    options: likert_options
  }, {
    id: :v56_7,
    type: :likert,
    title: 'Overgeven',
    options: likert_options
  }, {
    id: :v56_8,
    type: :textfield,
    title: 'Heb je nog andere lichamelijke problemen?',
    section_end: true
  }, {
    id: :v57,
    type: :likert,
    title: 'Ik val mensen lichamelijk aan',
    options: likert_options
  }, {
    id: :v58_1,
    type: :likert,
    title: 'Ik pulk aan mijn huid of aan iets anders van mijn lichaam',
    options: likert_options
  }, {
    id: :v58_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v59,
    type: :likert,
    title: 'Ik kan best aardig zijn',
    options: likert_options
  }, {
    id: :v60,
    type: :likert,
    title: 'Ik vind het leuk om nieuwe dingen te proberen',
    options: likert_options
  }, {
    id: :v61,
    type: :likert,
    title: 'Mijn schoolwerk is slecht',
    options: likert_options
  }, {
    id: :v62,
    type: :likert,
    title: 'Ik ben onhandig of stuntelig',
    options: likert_options
  }, {
    id: :v63,
    type: :likert,
    title: 'Ik ga liever om met oudere jongens of meisjes dan met jongens of meisjes van mijn eigen leeftijd',
    options: likert_options
  }, {
    id: :v64,
    type: :likert,
    title: 'Ik ga liever om met jongere jongens of meisjes dan met jongens of meisjes van mijn eigen leeftijd',
    options: likert_options
  }, {
    id: :v65,
    type: :likert,
    title: 'Ik weiger om te praten',
    options: likert_options
  }, {
    id: :v66_1,
    type: :likert,
    title: 'Ik herhaal bepaalde handelingen steeds maar weer',
    options: likert_options
  }, {
    id: :v66_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v67,
    type: :likert,
    title: 'Ik loop weg van huis',
    options: likert_options
  }, {
    id: :v68,
    type: :likert,
    title: 'Ik schreeuw veel',
    options: likert_options
  }, {
    id: :v69,
    type: :likert,
    title: 'Ik ben gesloten of hou dingen voor mezelf',
    options: likert_options
  }, {
    id: :v70_1,
    type: :likert,
    title: 'Ik zie dingen waarvan andere mensen denken dat ze er niet zijn',
    options: likert_options
  }, {
    id: :v70_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v71,
    type: :likert,
    title: 'Ik schaam me gauw of voel me niet op mijn gemak',
    options: likert_options
  }, {
    id: :v72,
    type: :likert,
    title: 'Ik sticht brandjes',
    options: likert_options
  }, {
    id: :v73,
    type: :likert,
    title: 'Ik ben handig',
    options: likert_options
  }, {
    id: :v74,
    type: :likert,
    title: 'Ik sloof me uit of doe gek om op te vallen',
    options: likert_options
  }, {
    id: :v75,
    type: :likert,
    title: 'Ik ben te verlegen',
    options: likert_options
  }, {
    id: :v76,
    type: :likert,
    title: 'Ik slaap minder dan de meeste jongens en meisjes',
    options: likert_options
  }, {
    id: :v77_1,
    type: :likert,
    title: 'Ik slaap overdag en/of \'s nachts meer dan de meeste jongens en meisjes',
    options: likert_options
  }, {
    id: :v77_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v78,
    type: :likert,
    title: 'Ik let niet goed op of ben snel afgeleid',
    options: likert_options
  }, {
    id: :v79_1,
    type: :likert,
    title: 'Ik heb een spraakprobleem',
    options: likert_options
  }, {
    id: :v79_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v80,
    type: :likert,
    title: 'Ik kom voor mijzelf op',
    options: likert_options
  }, {
    id: :v81,
    type: :likert,
    title: 'Ik steel thuis',
    options: likert_options
  }, {
    id: :v82,
    type: :likert,
    title: 'Ik steel buitenshuis',
    options: likert_options
  }, {
    id: :v83_1,
    type: :likert,
    title: 'Ik spaar te veel dingen op die ik niet nodig heb',
    options: likert_options
  }, {
    id: :v83_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v84_1,
    type: :likert,
    title: 'Ik doe dingen die andere mensen vreemd vinden',
    options: likert_options
  }, {
    id: :v84_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v85_1,
    type: :likert,
    title: 'Ik heb gedachten die andere mensen vreemd zouden vinden',
    options: likert_options
  }, {
    id: :v85_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v86,
    type: :likert,
    title: 'Ik ben koppig',
    options: likert_options
  }, {
    id: :v87,
    type: :likert,
    title: 'Mijn stemming of gevoelens veranderen plotseling',
    options: likert_options
  }, {
    id: :v88,
    type: :likert,
    title: 'Ik vind het leuk om bij mensen te zijn',
    options: likert_options
  }, {
    id: :v89,
    type: :likert,
    title: 'Ik ben achterdochtig',
    options: likert_options
  }, {
    id: :v90,
    type: :likert,
    title: 'Ik vloek of gebruik vieze woorden',
    options: likert_options
  }, {
    id: :v91,
    type: :likert,
    title: 'Ik denk erover mijzelf te doden',
    options: likert_options
  }, {
    id: :v92,
    type: :likert,
    title: 'Ik vind het leuk om anderen aan het lachen te maken',
    options: likert_options
  }, {
    id: :v93,
    type: :likert,
    title: 'Ik praat te veel',
    options: likert_options
  }, {
    id: :v94,
    type: :likert,
    title: 'Ik pest anderen veel',
    options: likert_options
  }, {
    id: :v95,
    type: :likert,
    title: 'Ik ben snel driftig',
    options: likert_options
  }, {
    id: :v96,
    type: :likert,
    title: 'Ik denk te veel aan seks',
    options: likert_options
  }, {
    id: :v97,
    type: :likert,
    title: 'Ik dreig mensen om hen pijn te doen',
    options: likert_options
  }, {
    id: :v98,
    type: :likert,
    title: 'Ik vind het fijn om anderen te helpen',
    options: likert_options
  }, {
    id: :v99,
    type: :likert,
    title: 'Ik rook tabak',
    options: likert_options
  }, {
    id: :v100_1,
    type: :likert,
    title: 'Ik heb problemen met slapen',
    options: likert_options
  }, {
    id: :v100_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v101,
    type: :likert,
    title: 'Ik sla lessen over of spijbel van school',
    options: likert_options
  }, {
    id: :v102,
    type: :likert,
    title: 'Ik heb niet veel energie',
    options: likert_options
  }, {
    id: :v103,
    type: :likert,
    title: 'Ik ben ongelukkig, verdrietig of depressief',
    options: likert_options
  }, {
    id: :v104,
    type: :likert,
    title: 'Ik ben luidruchtiger dan andere jongens of meisjes',
    options: likert_options
  }, {
    id: :v105_1,
    type: :likert,
    title: 'Ik gebruik drugs',
    options: likert_options
  }, {
    id: :v105_2,
    type: :textfield,
    title: 'Leg je antwoord op de vorige vraag uit:'
  }, {
    id: :v106,
    type: :likert,
    title: 'Ik probeer eerlijk te zijn tegen anderen',
    options: likert_options
  }, {
    id: :v107,
    type: :likert,
    title: 'Ik hou van een goede grap',
    options: likert_options
  }, {
    id: :v108,
    type: :likert,
    title: 'Ik hou ervan om het rustig aan te doen',
    options: likert_options
  }, {
    id: :v109,
    type: :likert,
    title: 'Ik probeer andere mensen te helpen als ik dat kan',
    options: likert_options
  }, {
    id: :v110,
    type: :likert,
    title: 'Ik wou dat ik van het andere geslacht was',
    options: likert_options
  }, {
    id: :v111,
    type: :likert,
    title: 'Ik probeer met anderen weinig te maken te hebben',
    options: likert_options
  }, {
    id: :v112,
    type: :likert,
    title: 'Ik maak me vaak zorgen',
    options: likert_options
  }, {
    id: :v113,
    type: :textarea,
    title: 'Schrijf hier alle andere dingen op die te maken hebben met je gevoelens, gedrag, manier van doen of belangstelling',
    options: likert_options
  }
]
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Somberheid',
      ids: %i[v14 v29_1 v30 v31 v32 v33 v35 v45 v50 v52 v71 v91 v112],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Aandacht',
      ids: %i[v1 v4 v8 v10 v13 v17 v41 v61 v78],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Regels overtreden',
      ids: %i[v2_1 v26 v28 v39 v43 v63 v67 v72 v81 v82 v90 v96 v99 v101 v105_1],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s4,
      label: 'Problemen met anderen',
      ids: %i[v11 v12 v25 v27 v34 v36 v38 v48 v62 v64 v79_1],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
