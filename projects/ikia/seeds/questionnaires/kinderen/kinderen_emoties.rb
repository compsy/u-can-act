# frozen_string_literal: true

db_title = 'Gevoelens'
db_name1 = 'Emoties_Kinderen'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> Welkom! Deze vragenlijst gaat over gevoelens. Het invullen duurt ongeveer 10 minuten. Daarna kun je je resultaten bekijken en krijg je uitleg over wat alles betekent.'
  }, {
    section_start: 'Denk terug aan hoe je je de <i>afgelopen twee weken</i> voelde. Geef bij elk gevoel hieronder aan of je je zo gevoeld hebt. Verschuif het bolletje naar het antwoord dat het beste bij jou past:',
    id: :v1,
    type: :range,
    title: 'Gelukkig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: false
  }, {
    id: :v2,
    type: :range,
    title: 'Zenuwachtig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v3,
    type: :range,
    title: 'Kalm',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v4,
    type: :range,
    title: 'Boos',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v5,
    type: :range,
    title: 'Vrolijk',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v6,
    type: :range,
    title: 'Geliefd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    tooltip: 'Dit is het gevoel dat andere mensen van je houden',
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Eenzaam',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'Trots',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v9,
    type: :range,
    title: 'Verdrietig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v10,
    type: :range,
    title: 'Bang',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v11,
    type: :range,
    title: 'Vol energie',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Gestrest',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Geïnteresseerd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Sterk',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v15,
    type: :range,
    title: 'Ontspannen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v16,
    type: :range,
    title: 'Beschaamd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    tooltip: 'Dit is het gevoel dat je je ergens voor schaamt',
    required: true
  }, {
    id: :v17,
    type: :range,
    title: 'Moe',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v18,
    type: :range,
    title: 'Geïrriteerd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v19,
    type: :range,
    title: 'Tevreden',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
  }, {
    id: :v20,
    type: :range,
    title: 'Somber',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over hoe je je zou <b>willen</b> voelen. Stel je het allerbeste en fijnste leven voor dat je kunt hebben. <br><br>
Geef aan in hoeverre je de volgende gevoelens zou willen hebben in dit allerbeste leven. Verschuif het bolletje naar het antwoord dat het beste bij jou past.',
    id: :v21,
    type: :range,
    title: 'Gelukkig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true,
    section_end: false
  }, {
    id: :v22,
    type: :range,
    title: 'Zenuwachtig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v23,
    type: :range,
    title: 'Kalm',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v24,
    type: :range,
    title: 'Boos',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v25,
    type: :range,
    title: 'Vrolijk',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v26,
    type: :range,
    title: 'Geliefd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    tooltip: 'Dit is het gevoel dat andere mensen van je houden',
    required: true
  }, {
    id: :v27,
    type: :range,
    title: 'Eenzaam',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v28,
    type: :range,
    title: 'Trots',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v29,
    type: :range,
    title: 'Verdrietig',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v30,
    type: :range,
    title: 'Bang',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v31,
    type: :range,
    title: 'Vol energie',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v32,
    type: :range,
    title: 'Gestrest',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v33,
    type: :range,
    title: 'Geïnteresseerd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v34,
    type: :range,
    title: 'Sterk',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v35,
    type: :range,
    title: 'Ontspannen',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v36,
    type: :range,
    title: 'Beschaamd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    tooltip: 'Dit is het gevoel dat je je ergens voor schaamt',
    required: true
  }, {
    id: :v37,
    type: :range,
    title: 'Moe',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v38,
    type: :range,
    title: 'Geïrriteerd',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v39,
    type: :range,
    title: 'Tevreden',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    required: true
  }, {
    id: :v40,
    type: :range,
    required: true,
    title: 'Somber',
    labels: ['Helemaal niet', 'Een beetje', 'Heel erg'],
    section_end: true
  }, {
    section_start: 'Er volgen nu een aantal zinnen over gevoelens en gedachten. Bedenk bij elke zin hoe vaak de zin waar is voor jou. Verschuif het bolletje naar het antwoord dat het beste bij jou past:',
    id: :v41,
    type: :range,
    title: 'Ik ben vaak in de war over hoe ik me voel.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true,
    section_end: false
  }, {
    id: :v42,
    type: :range,
    title: 'Ik vind het moeilijk om een vriend of vriendin uit te leggen hoe ik me voel.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v43,
    type: :range,
    title: 'Andere mensen hoeven niet te weten hoe ik me voel.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v44,
    type: :range,
    title: 'Als ik bang of zenuwachtig ben, dan voel ik iets in mijn buik.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v45,
    type: :range,
    title: 'Het is belangrijk dat ik weet hoe mijn vrienden zich voelen.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v46,
    type: :range,
    title: 'Als ik mij rot voel of boos ben, probeer ik te begrijpen waarom.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v47,
    type: :range,
    title: 'Het is moeilijk om te weten of ik me boos voel, verdrietig, of iets anders.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v48,
    type: :range,
    title: 'Ik vind het moeilijk om aan anderen te vertellen hoe ik me voel.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v49,
    type: :range,
    title: 'Als ik me over iets rot voel, houd ik dat vaak voor mezelf.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v50,
    type: :range,
    title: 'Als ik me rot voel, kan ik dat ook in mijn lichaam voelen.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v51,
    type: :range,
    title: 'Ik wil niet weten hoe mijn vrienden zich voelen.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v52,
    type: :range,
    title: 'Mijn gevoelens helpen mij te begrijpen wat er gebeurd is.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v53,
    type: :range,
    title: 'Ik weet nooit precies wat voor gevoel ik heb.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v54,
    type: :range,
    title: 'Ik kan makkelijk aan een vriend of vriendin uitleggen hoe ik me van binnen voel.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v55,
    type: :range,
    title: 'Als ik boos of verdrietig ben, probeer ik dat te verbergen.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v56,
    type: :range,
    title: 'Ik voel niks in mijn lichaam als ik bang ben of zenuwachtig.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v57,
    type: :range,
    title: 'Als een vriend of vriendin zich rot voelt, probeer ik te begrijpen waarom.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v58,
    type: :range,
    title: 'Als ik een probleem heb, helpt het mij als ik weet hoe ik mij daarover voel.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v59,
    type: :range,
    title: 'Als ik me rot voel, weet ik niet of boos, bang of verdrietig ben.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v60,
    type: :range,
    title: 'Als ik me rot voel, probeer ik dat niet te laten merken.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v61,
    type: :range,
    title: 'Mijn lichaam voelt anders als ik mij rot voel over iets.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v62,
    type: :range,
    title: 'Het maakt mij niet uit hoe mijn vrienden zich van binnen voelen.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v63,
    type: :range,
    title: 'Ik vind het belangrijk dat ik begrijp hoe ik me voel.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v64,
    type: :range,
    title: 'Soms voel ik me rot zonder dat ik begrijp waarom.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v65,
    type: :range,
    title: 'Andere mensen hebben er niets mee te maken als ik me rot voel.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v66,
    type: :range,
    title: 'Als ik verdrietig ben, voelt mijn lichaam slap.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v67,
    type: :range,
    title: 'Ik weet meestal hoe mijn vrienden zich voelen.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v68,
    type: :range,
    title: 'Ik wil altijd weten waarom ik me slecht voel over iets.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v69,
    type: :range,
    title: 'Ik weet vaak niet waarom ik boos ben.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true
  }, {
    id: :v70,
    type: :range,
    title: 'Ik weet niet wanneer iets mij verdrietig maakt.',
    labels: ['Niet waar', 'Soms waar', 'Vaak waar'],
    required: true,
    section_end: true
  }
]
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Positieve emoties',
      ids: %i[v1 v3 v5 v6 v8 v11 v13 v14 v15 v19],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Negatieve emoties',
      ids: %i[v2 v4 v7 v9 v10 v12 v16 v17 v18 v20],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
