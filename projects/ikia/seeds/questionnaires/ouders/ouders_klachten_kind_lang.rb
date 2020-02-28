# frozen_string_literal: true

db_title = 'Klachten van mijn kind'
db_name1 = 'Klachten_Kinderen_Lang_Ouderrapportage_6plus'
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
    content: '<blockquote>Copyright T.M. Achenbach. Reproduced by permission under License Number 1060-0719.<br>Copyright vertaling F.C. Verhulst en J. van der Ende, Erasmus MC Rotterdam</blockquote><p class="flow-text">Er volgt nu een lijst met vragen over kinderen. Alle vragen gaan over hoe uw kind nu is of in de afgelopen zes maanden is geweest. Geef bij elke vraag aan in hoeverre deze bij uw kind past. Beantwoord alle vragen zo goed als u kunt, ook al lijken sommige vragen niet bij uw kind te passen.</p>'
  }, {
    id: :v1,
    type: :likert,
    title: 'Doet te jong voor zijn/haar leeftijd',
    options: likert_options,
    section_end: false
  }, {
    id: :v2_1,
    type: :likert,
    title: 'Drinkt alcohol zonder dat zijn/haar ouders dat goed vinden',
    options: likert_options
  }, {
    id: :v2_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v3,
    type: :likert,
    title: 'Maakt veel ruzie',
    options: likert_options
  }, {
    id: :v4,
    type: :likert,
    title: 'Maakt dingen waar hij/zij mee begint niet af',
    options: likert_options
  }, {
    id: :v5,
    type: :likert,
    title: 'Er is heel weinig wat hij/zij leuk vindt',
    options: likert_options
  }, {
    id: :v6,
    type: :likert,
    title: 'Doet ontlasting (poept) buiten de wc of in de broek',
    options: likert_options
  }, {
    id: :v7,
    type: :likert,
    title: 'Schept op, doet stoer',
    options: likert_options
  }, {
    id: :v8,
    type: :likert,
    title: 'Kan zich niet concentreren, kan niet lang de aandacht ergens bij houden',
    options: likert_options
  }, {
    id: :v9_1,
    type: :likert,
    title: 'Kan bepaalde gedachten niet uit zijn/haar hoofd zetten, obsessies',
    options: likert_options
  }, {
    id: :v9_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v10,
    type: :likert,
    title: 'Kan niet stilzitten, is onrustig of hyperactief',
    options: likert_options
  }, {
    id: :v11,
    type: :likert,
    title: 'Klampt zich vast aan volwassenen of is te afhankelijk',
    options: likert_options
  }, {
    id: :v12,
    type: :likert,
    title: 'Klaagt over zich eenzaam voelen',
    options: likert_options
  }, {
    id: :v13,
    type: :likert,
    title: 'In de war of wazig denken',
    options: likert_options
  }, {
    id: :v14,
    type: :likert,
    title: 'Huilt veel',
    options: likert_options
  }, {
    id: :v15,
    type: :likert,
    title: 'Wreed tegen dieren',
    options: likert_options
  }, {
    id: :v16,
    type: :likert,
    title: 'Wreed, pesterig of gemeen tegen anderen',
    options: likert_options
  }, {
    id: :v17,
    type: :likert,
    title: 'Dagdromen of gaat op in zijn/haar gedachten',
    options: likert_options
  }, {
    id: :v18,
    type: :likert,
    title: 'Verwondt zichzelf opzettelijk of doet zelfmoordpogingen',
    options: likert_options
  }, {
    id: :v19,
    type: :likert,
    title: 'Eist veel aandacht op',
    options: likert_options
  }, {
    id: :v20,
    type: :likert,
    title: 'Vernielt eigen spullen',
    options: likert_options
  }, {
    id: :v21,
    type: :likert,
    title: 'Vernielt spullen van gezinsleden of van anderen',
    options: likert_options
  }, {
    id: :v22,
    type: :likert,
    title: 'Is thuis ongehoorzaam',
    options: likert_options
  }, {
    id: :v23,
    type: :likert,
    title: 'Is ongehoorzaam op school',
    options: likert_options
  }, {
    id: :v24,
    type: :likert,
    title: 'Eet niet goed',
    options: likert_options
  }, {
    id: :v25,
    type: :likert,
    title: 'Kan niet goed opschieten met andere jongens of meisjes',
    options: likert_options
  }, {
    id: :v26,
    type: :likert,
    title: 'Lijkt zich niet schuldig te voelen na zich misdragen te hebben',
    options: likert_options
  }, {
    id: :v27,
    type: :likert,
    title: 'Snel jaloers',
    options: likert_options
  }, {
    id: :v28,
    type: :likert,
    title: 'Houdt zich niet aan de regels thuis, op school of ergens anders',
    options: likert_options
  }, {
    id: :v29_1,
    type: :likert,
    title: 'Is bang voor bepaalde dieren, situaties, of plaatsen anders dan school',
    options: likert_options
  }, {
    id: :v29_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v30,
    type: :likert,
    title: 'Is bang om naar school te gaan',
    options: likert_options
  }, {
    id: :v31,
    type: :likert,
    title: 'Is bang dat hij/zij iets slechts zou kunnen doen of denken',
    options: likert_options
  }, {
    id: :v32,
    type: :likert,
    title: 'Heeft het gevoel dat hij/zij perfect moet zijn',
    options: likert_options
  }, {
    id: :v33,
    type: :likert,
    title: 'Heeft het gevoel of klaagt erover dat niemand van hem/haar houdt',
    options: likert_options
  }, {
    id: :v34,
    type: :likert,
    title: 'Heeft het gevoel dat anderen hem/haar te pakken willen nemen',
    options: likert_options
  }, {
    id: :v35,
    type: :likert,
    title: 'Voelt zich waardeloos of minderwaardig',
    options: likert_options
  }, {
    id: :v36,
    type: :likert,
    title: 'Bezeert zich vaak, krijgt vaak ongelukken',
    options: likert_options
  }, {
    id: :v37,
    type: :likert,
    title: 'Vecht veel',
    options: likert_options
  }, {
    id: :v38,
    type: :likert,
    title: 'Wordt veel gepest',
    options: likert_options
  }, {
    id: :v39,
    type: :likert,
    title: 'Gaat om met jongens of meisjes die in moeilijkheden raken',
    options: likert_options
  }, {
    id: :v40_1,
    type: :likert,
    title: 'Hoort geluiden of stemmen die er niet zijn',
    options: likert_options
  }, {
    id: :v40_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v41,
    type: :likert,
    title: 'Impulsief of doet dingen zonder er bij na te denken',
    options: likert_options
  }, {
    id: :v42,
    type: :likert,
    title: 'Is liever alleen dan met anderen',
    options: likert_options
  }, {
    id: :v43,
    type: :likert,
    title: 'Liegt of bedriegt',
    options: likert_options
  }, {
    id: :v44,
    type: :likert,
    title: 'Bijt nagels',
    options: likert_options
  }, {
    id: :v45,
    type: :likert,
    title: 'Nerveus, zenuwachtig of gespannen',
    options: likert_options
  }, {
    id: :v46_1,
    type: :likert,
    title: 'Zenuwachtige bewegingen of zenuwtrekken',
    options: likert_options
  }, {
    id: :v46_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v47,
    type: :likert,
    title: 'Nachtmerries',
    options: likert_options
  }, {
    id: :v48,
    type: :likert,
    title: 'Andere jongens of meisjes mogen hem/haar niet',
    options: likert_options
  }, {
    id: :v49,
    type: :likert,
    title: 'Obstipatie, last van verstopping',
    options: likert_options
  }, {
    id: :v50,
    type: :likert,
    title: 'Is te angstig of te bang',
    options: likert_options
  }, {
    id: :v51,
    type: :likert,
    title: 'Voelt zich duizelig of licht in het hoofd',
    options: likert_options
  }, {
    id: :v52,
    type: :likert,
    title: 'Voelt zich erg schuldig',
    options: likert_options
  }, {
    id: :v53,
    type: :likert,
    title: 'Eet te veel',
    options: likert_options
  }, {
    id: :v54,
    type: :likert,
    title: 'Is erg moe zonder reden',
    options: likert_options
  }, {
    id: :v55,
    type: :likert,
    title: 'Te dik',
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
    type: :likert,
    title: 'Heeft uw kind nog andere lichamelijke problemen?',
    options: likert_options
  }, {
    id: :v56_9,
    type: :textfield,
    title: 'Zo ja, wat voor problemen?',
    section_end: true
  }, {
    id: :v57,
    type: :likert,
    title: 'Valt mensen lichamelijk aan',
    options: likert_options
  }, {
    id: :v58_1,
    type: :likert,
    title: 'Pulkt aan neus, huid of aan iets anders van het lichaam',
    options: likert_options
  }, {
    id: :v58_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v59,
    type: :likert,
    title: 'Speelt met eigen geslachtsdelen in het openbaar',
    options: likert_options
  }, {
    id: :v60,
    type: :likert,
    title: 'Speelt te veel met eigen geslachtsdelen',
    options: likert_options
  }, {
    id: :v61,
    type: :likert,
    title: 'Schoolwerk is slecht',
    options: likert_options
  }, {
    id: :v62,
    type: :likert,
    title: 'Onhandig of stuntelig',
    options: likert_options
  }, {
    id: :v63,
    type: :likert,
    title: 'Gaat liever om met oudere jongens of meisjes',
    options: likert_options
  }, {
    id: :v64,
    type: :likert,
    title: 'Gaat liever om met jongere jongens of meisjes',
    options: likert_options
  }, {
    id: :v65,
    type: :likert,
    title: 'Weigert om te praten',
    options: likert_options
  }, {
    id: :v66_1,
    type: :likert,
    title: 'Herhaalt bepaalde handelingen steeds maar weer, dwanghandelingen',
    options: likert_options
  }, {
    id: :v66_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v67,
    type: :likert,
    title: 'Loopt weg van huis',
    options: likert_options
  }, {
    id: :v68,
    type: :likert,
    title: 'Schreeuwt veel',
    options: likert_options
  }, {
    id: :v69,
    type: :likert,
    title: 'Gesloten, houdt dingen voor zichzelf',
    options: likert_options
  }, {
    id: :v70_1,
    type: :likert,
    title: 'Ziet dingen die er niet zijn',
    options: likert_options
  }, {
    id: :v70_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v71,
    type: :likert,
    title: 'Schaamt zich gauw of voelt zich niet op zijn/haar gemak',
    options: likert_options
  }, {
    id: :v72,
    type: :likert,
    title: 'Sticht branden',
    options: likert_options
  }, {
    id: :v73_1,
    type: :likert,
    title: 'Seksuele problemen',
    options: likert_options
  }, {
    id: :v73_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v74,
    type: :likert,
    title: 'Slooft zich uit of doet gek om op te vallen',
    options: likert_options
  }, {
    id: :v75,
    type: :likert,
    title: 'Te verlegen of timide',
    options: likert_options
  }, {
    id: :v76,
    type: :likert,
    title: 'Slaapt minder dan de meeste jongens en meisjes',
    options: likert_options
  }, {
    id: :v77_1,
    type: :likert,
    title: 'Slaap overdag en/of \'s nachts meer dan de meeste jongens en meisjes',
    options: likert_options
  }, {
    id: :v77_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v78,
    type: :likert,
    title: 'Let niet goed op of is snel afgeleid',
    options: likert_options
  }, {
    id: :v79_1,
    type: :likert,
    title: 'Spraakprobleem',
    options: likert_options
  }, {
    id: :v79_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v80,
    type: :likert,
    title: 'Kijkt met een lege blik',
    options: likert_options
  }, {
    id: :v81,
    type: :likert,
    title: 'Steelt van huis',
    options: likert_options
  }, {
    id: :v82,
    type: :likert,
    title: 'Steelt buitenshuis',
    options: likert_options
  }, {
    id: :v83_1,
    type: :likert,
    title: 'Spaart te veel dingen op die hij/zij niet nodig heeft',
    options: likert_options
  }, {
    id: :v83_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v84_1,
    type: :likert,
    title: 'Vreemd gedrag',
    options: likert_options
  }, {
    id: :v84_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v85_1,
    type: :likert,
    title: 'Vreemde gedachten',
    options: likert_options
  }, {
    id: :v85_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v86,
    type: :likert,
    title: 'Koppig, stuurs of prikkelbaar',
    options: likert_options
  }, {
    id: :v87,
    type: :likert,
    title: 'Stemming en gevoelens veranderen plotseling',
    options: likert_options
  }, {
    id: :v88,
    type: :likert,
    title: 'Mokt veel',
    options: likert_options
  }, {
    id: :v89,
    type: :likert,
    title: 'Achterdochtig',
    options: likert_options
  }, {
    id: :v90,
    type: :likert,
    title: 'Vloekt of gebruikt vieze woorden',
    options: likert_options
  }, {
    id: :v91,
    type: :likert,
    title: 'Praat erover dat hij/zij zichzelf zou willen doden',
    options: likert_options
  }, {
    id: :v92_1,
    type: :likert,
    title: 'Praat tijdens slaap of slaapwandelt',
    options: likert_options
  }, {
    id: :v92_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v93,
    type: :likert,
    title: 'Praat te veel',
    options: likert_options
  }, {
    id: :v94,
    type: :likert,
    title: 'Pest veel',
    options: likert_options
  }, {
    id: :v95,
    type: :likert,
    title: 'Driftbuien of snel driftig',
    options: likert_options
  }, {
    id: :v96,
    type: :likert,
    title: 'Denkt te veel aan seks',
    options: likert_options
  }, {
    id: :v97,
    type: :likert,
    title: 'Bedreigt mensen',
    options: likert_options
  }, {
    id: :v98,
    type: :likert,
    title: 'Duimzuigen',
    options: likert_options
  }, {
    id: :v99,
    type: :likert,
    title: 'Rookt tabak',
    options: likert_options
  }, {
    id: :v100,
    type: :likert,
    title: 'Problemen met slapen',
    options: likert_options
  }, {
    id: :v100_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v101,
    type: :likert,
    title: 'Spijbelt, blijft weg van school',
    options: likert_options
  }, {
    id: :v102,
    type: :likert,
    title: 'Weinig actief, beweegt zich langzaam of te weinig energie',
    options: likert_options
  }, {
    id: :v103,
    type: :likert,
    title: 'Ongelukkig, verdrietig of depressief',
    options: likert_options
  }, {
    id: :v104,
    type: :likert,
    title: 'Meer dan gewoon luidruchtig',
    options: likert_options
  }, {
    id: :v105_1,
    type: :likert,
    title: 'Gebruikt drugs',
    options: likert_options
  }, {
    id: :v105_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v106,
    type: :likert,
    title: 'Vandalisme',
    options: likert_options
  }, {
    id: :v107,
    type: :likert,
    title: 'Plast overdag in zijn/haar broek',
    options: likert_options
  }, {
    id: :v108,
    type: :likert,
    title: 'Plast in bed',
    options: likert_options
  }, {
    id: :v109,
    type: :likert,
    title: 'Zeuren',
    options: likert_options
  }, {
    id: :v110,
    type: :likert,
    title: 'Wil dat hij/zij van het andere geslacht is',
    options: likert_options
  }, {
    id: :v111,
    type: :likert,
    title: 'Teruggetrokken, gaat niet met anderen om',
    options: likert_options
  }, {
    id: :v112,
    type: :likert,
    title: 'Maakt zich zorgen',
    options: likert_options
  }, {
    id: :v113,
    type: :expandable,
    default_expansions: 1,
    max_expansions: 10,
    title: 'Schrijf hier ieder ander probleem op dat uw kind heeft en dat hierboven nog niet genoemd is:',
    remove_button_label: 'Verwijderen',
    add_button_label: 'Toevoegen',
    content: [
      { id: :v113_1,
        type: :textfield,
        required: true,
        title: 'Probleem' },
      { id: :v113_2,
        type: :likert,
        title: 'Hoeveel last heeft uw kind hiervan?',
        options: likert_options
      }
    ]
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
      label: 'Gedragsproblemen',
      ids: %i[v2_1 v26 v28 v39 v43 v63 v67 v72 v73_1 v81 v82 v90 v96 v99 v101 v105_1 v106],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Problemen met anderen',
      ids: %i[v11 v12 v25 v27 v34 v36 v38 v48 v62 v64 v79_1],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s4,
      label: 'Aandacht',
      ids: %i[v1 v4 v8 v10 v13 v17 v41 v61 v78 v80],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
