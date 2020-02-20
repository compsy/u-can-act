#frozen_string_literal: true

db_title = 'Klachten van mijn kind'
db_name1 = 'Klachten_Kinderen_Lang_Ouderrapportage_6plus'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<blockquote>Copyright T.M. Achenbach. Reproduced by permission under License Number 1060-0719.<br>Copyright vertaling F.C. Verhulst en J. van der Ende, Erasmus MC Rotterdam</blockquote><p class="flow-tekst">Er volgt nu een lijst met vragen over kinderen. Alle vragen gaan over hoe uw kind nu is of in de afgelopen zes maanden is geweest. Geef bij elke vraag aan in hoeverre deze bij uw kind past. Beantwoord alle vragen zo goed als u kunt, ook al lijken sommige vragen niet bij uw kind te passen.</p>'
  }, {
    id: :v1,
    type: :likert,
    title: 'Doet te jong voor zijn/haar leeftijd',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak'],
    section_end: false
  }, {
    id: :v2_1,
    type: :likert,
    title: 'Drinkt alcohol zonder dat zijn/haar ouders dat goed vinden',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v2_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v3,
    type: :likert,
    title: 'Maakt veel ruzie',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v4,
    type: :likert,
    title: 'Maakt dingen waar hij/zij mee begint niet af',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v5,
    type: :likert,
    title: 'Er is heel weinig wat hij/zij leuk vindt',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v6,
    type: :likert,
    title: 'Doet ontlasting (poept) buiten de wc of in de broek',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v7,
    type: :likert,
    title: 'Schept op, doet stoer',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v8,
    type: :likert,
    title: 'Kan zich niet concentreren, kan niet lang de aandacht ergens bij houden',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v9_1,
    type: :likert,
    title: 'Kan bepaalde gedachten niet uit zijn/haar hoofd zetten, obsessies',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v9_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v10,
    type: :likert,
    title: 'Kan niet stilzitten, is onrustig of hyperactief',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v11,
    type: :likert,
    title: 'Klampt zich vast aan volwassenen of is te afhankelijk',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v12,
    type: :likert,
    title: 'Klaagt over zich eenzaam voelen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v13,
    type: :likert,
    title: 'In de war of wazig denken',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v14,
    type: :likert,
    title: 'Huilt veel',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v15,
    type: :likert,
    title: 'Wreed tegen dieren',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v16,
    type: :likert,
    title: 'Wreed, pesterig of gemeen tegen anderen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v17,
    type: :likert,
    title: 'Dagdromen of gaat op in zijn/haar gedachten',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v18,
    type: :likert,
    title: 'Verwondt zichzelf opzettelijk of doet zelfmoordpogingen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v19,
    type: :likert,
    title: 'Eist veel aandacht op',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v20,
    type: :likert,
    title: 'Vernielt eigen spullen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v21,
    type: :likert,
    title: 'Vernielt spullen van gezinsleden of van anderen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v22,
    type: :likert,
    title: 'Is thuis ongehoorzaam',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v23,
    type: :likert,
    title: 'Is ongehoorzaam op school',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v24,
    type: :likert,
    title: 'Eet niet goed',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v25,
    type: :likert,
    title: 'Kan niet goed opschieten met andere jongens of meisjes',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v26,
    type: :likert,
    title: 'Lijkt zich niet schuldig te voelen na zich misdragen te hebben',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v27,
    type: :likert,
    title: 'Snel jaloers',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v28,
    type: :likert,
    title: 'Houdt zich niet aan de regels thuis, op school of ergens anders',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v29_1,
    type: :likert,
    title: 'Is bang voor bepaalde dieren, situaties, of plaatsen anders dan school',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v29_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v30,
    type: :likert,
    title: 'Is bang om naar school te gaan',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v31,
    type: :likert,
    title: 'Is bang dat hij/zij iets slechts zou kunnen doen of denken',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v32,
    type: :likert,
    title: 'Heeft het gevoel dat hij/zij perfect moet zijn',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v33,
    type: :likert,
    title: 'Heeft het gevoel of klaagt erover dat niemand van hem/haar houdt',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v34,
    type: :likert,
    title: 'Heeft het gevoel dat anderen hem/haar te pakken willen nemen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v35,
    type: :likert,
    title: 'Voelt zich waardeloos of minderwaardig',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v36,
    type: :likert,
    title: 'Bezeert zich vaak, krijgt vaak ongelukken',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v37,
    type: :likert,
    title: 'Vecht veel',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v38,
    type: :likert,
    title: 'Wordt veel gepest',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v39,
    type: :likert,
    title: 'Gaat om met jongens of meisjes die in moeilijkheden raken',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v40_1,
    type: :likert,
    title: 'Hoort geluiden of stemmen die er niet zijn',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v40_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v41,
    type: :likert,
    title: 'Impulsief of doet dingen zonder er bij na te denken',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v42,
    type: :likert,
    title: 'Is liever alleen dan met anderen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v43,
    type: :likert,
    title: 'Liegt of bedriegt',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v44,
    type: :likert,
    title: 'Bijt nagels',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v45,
    type: :likert,
    title: 'Nerveus, zenuwachtig of gespannen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v46_1,
    type: :likert,
    title: 'Zenuwachtige bewegingen of zenuwtrekken',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v46_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v47,
    type: :likert,
    title: 'Nachtmerries',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v48,
    type: :likert,
    title: 'Andere jongens of meisjes mogen hem/haar niet',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v49,
    type: :likert,
    title: 'Obstipatie, last van verstopping',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v50,
    type: :likert,
    title: 'Is te angstig of te bang',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v51,
    type: :likert,
    title: 'Voelt zich duizelig of licht in het hoofd',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v52,
    type: :likert,
    title: 'Voelt zich erg schuldig',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v53,
    type: :likert,
    title: 'Eet te veel',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v54,
    type: :likert,
    title: 'Is erg moe zonder reden',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v55,
    type: :likert,
    title: 'Te dik',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak'],
    section_end: true
  }, {
    section_start: 'Lichamelijke problemen zonder bekende medische oorzaak',
    id: :v56_1,
    type: :likert,
    title: 'Pijnen (geen buikpijn of hoofdpijn)',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v56_2,
    type: :likert,
    title: 'Hoofdpijn',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v56_3,
    type: :likert,
    title: 'Misselijk',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v56_4_1,
    type: :likert,
    title: 'Oogproblemen (waarvoor een bril of lenzen niet helpen)',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v56_4_2,
    type: :textfield,
    title: 'Zo ja, wat voor oogproblemen?'
  }, {
    id: :v56_5,
    type: :likert,
    title: 'Huiduitslag of andere huidproblemen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v56_6,
    type: :likert,
    title: 'Buikpijn',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v56_7,
    type: :likert,
    title: 'Overgeven',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v56_8,
    type: :likert,
    title: 'Heeft uw kind nog andere lichamelijke problemen?',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v56_9,
    type: :textfield,
    title: 'Zo ja, wat voor problemen?',
    section_end: true
  }, {
    id: :v57,
    type: :likert,
    title: 'Valt mensen lichamelijk aan',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v58_1,
    type: :likert,
    title: 'Pulkt aan neus, huid of aan iets anders van het lichaam',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v58_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v59,
    type: :likert,
    title: 'Speelt met eigen geslachtsdelen in het openbaar',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v60,
    type: :likert,
    title: 'Speelt te veel met eigen geslachtsdelen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v61,
    type: :likert,
    title: 'Schoolwerk is slecht',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v62,
    type: :likert,
    title: 'Onhandig of stuntelig',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v63,
    type: :likert,
    title: 'Gaat liever om met oudere jongens of meisjes',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v64,
    type: :likert,
    title: 'Gaat liever om met jongere jongens of meisjes',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v65,
    type: :likert,
    title: 'Weigert om te praten',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v66_1,
    type: :likert,
    title: 'Herhaalt bepaalde handelingen steeds maar weer, dwanghandelingen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v66_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v67,
    type: :likert,
    title: 'Loopt weg van huis',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v68,
    type: :likert,
    title: 'Schreeuwt veel',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v69,
    type: :likert,
    title: 'Gesloten, houdt dingen voor zichzelf',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v70_1,
    type: :likert,
    title: 'Ziet dingen die er niet zijn',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v70_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v71,
    type: :likert,
    title: 'Schaamt zich gauw of voelt zich niet op zijn/haar gemak',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v72,
    type: :likert,
    title: 'Sticht branden',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v73_1,
    type: :likert,
    title: 'Seksuele problemen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v73_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v74,
    type: :likert,
    title: 'Slooft zich uit of doet gek om op te vallen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v75,
    type: :likert,
    title: 'Te verlegen of timide',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v76,
    type: :likert,
    title: 'Slaapt minder dan de meeste jongens en meisjes',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v77_1,
    type: :likert,
    title: 'Slaap overdag en/of \'s nachts meer dan de meeste jongens en meisjes',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v77_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v78,
    type: :likert,
    title: 'Let niet goed op of is snel afgeleid',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v79_1,
    type: :likert,
    title: 'Spraakprobleem',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v79_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v80,
    type: :likert,
    title: 'Kijkt met een lege blik',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v81,
    type: :likert,
    title: 'Steelt van huis',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v82,
    type: :likert,
    title: 'Steelt buitenshuis',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v83_1,
    type: :likert,
    title: 'Spaart te veel dingen op die hij/zij niet nodig heeft',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v83_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v84_1,
    type: :likert,
    title: 'Vreemd gedrag',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v84_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v85_1,
    type: :likert,
    title: 'Vreemde gedachten',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v85_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v86,
    type: :likert,
    title: 'Koppig, stuurs of prikkelbaar',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v87,
    type: :likert,
    title: 'Stemming en gevoelens veranderen plotseling',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v88,
    type: :likert,
    title: 'Mokt veel',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v89,
    type: :likert,
    title: 'Achterdochtig',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v90,
    type: :likert,
    title: 'Vloekt of gebruikt vieze woorden',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v91,
    type: :likert,
    title: 'Praat erover dat hij/zij zichzelf zou willen doden',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v92_1,
    type: :likert,
    title: 'Praat tijdens slaap of slaapwandelt',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v92_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v93,
    type: :likert,
    title: 'Praat te veel',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v94,
    type: :likert,
    title: 'Pest veel',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v95,
    type: :likert,
    title: 'Driftbuien of snel driftig',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v96,
    type: :likert,
    title: 'Denkt te veel aan seks',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v97,
    type: :likert,
    title: 'Bedreigt mensen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v98,
    type: :likert,
    title: 'Duimzuigen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v99,
    type: :likert,
    title: 'Rookt tabak',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v100,
    type: :likert,
    title: 'Problemen met slapen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v100_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v101,
    type: :likert,
    title: 'Spijbelt, blijft weg van school',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v102,
    type: :likert,
    title: 'Weinig actief, beweegt zich langzaam of te weinig energie',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v103,
    type: :likert,
    title: 'Ongelukkig, verdrietig of depressief',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v104,
    type: :likert,
    title: 'Meer dan gewoon luidruchtig',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v105_1,
    type: :likert,
    title: 'Gebruikt drugs',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v105_2,
    type: :textfield,
    title: 'Licht uw antwoord op de vorige vraag toe:'
  }, {
    id: :v106,
    type: :likert,
    title: 'Vandalisme',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v107,
    type: :likert,
    title: 'Plast overdag in zijn/haar broek',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v108,
    type: :likert,
    title: 'Plast in bed',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v109,
    type: :likert,
    title: 'Zeuren',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v110,
    type: :likert,
    title: 'Wil dat hij/zij van het andere geslacht is',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v111,
    type: :likert,
    title: 'Teruggetrokken, gaat niet met anderen om',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v112,
    type: :likert,
    title: 'Maakt zich zorgen',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }, {
    id: :v113,
    type: :expandable,
    default_expansions: 3,
    max_expansions: 10,
    title: 'Schrijf hier ieder ander probleem op dat uw kind heeft en dat hierboven nog niet genoemd is:',
    remove_button_label: 'Verwijderen',
    add_button_label: 'Toevoegen',
    content: [
      {id: :v113_1,
       type: :textfield,
       title: 'Probleem'}]
  }, {
    id: :v113_2,
    type: :likert,
    title: 'Hoeveel last heeft uw kind hiervan?',
    options: ['Helemaal niet', 'Een beetje of soms', 'Duidelijk of vaak']
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
