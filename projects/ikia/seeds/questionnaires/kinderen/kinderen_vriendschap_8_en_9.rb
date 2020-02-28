db_title = 'Vriendschap'
db_name1 = 'Vriendschap_Kinderen_8en9'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! De volgende vragen gaan over vriendschap, en hoe jij daarover denkt. </p>'
  }, {
    section_start: 'Bedenk bij elke zin hoe waar deze voor jou is. Verplaats het bolletje naar het antwoord dat het beste past.',
    id: :v1_1,
    type: :range,
    title: 'Ik heb één of meerdere vrienden of vriendinnen',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true,
    section_end: false
  }, {
    id: :v1_2,
    type: :range,
    title: 'Ik vind dat ik minder vriend(inn)en heb dan anderen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true,
  }, {
    id: :v1_6,
    type: :range,
    title: 'Vriend(inn)en maken is moeilijk voor mij.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_7,
    type: :range,
    title: 'Ik ben bang dat anderen me niet laten meedoen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_8,
    type: :range,
    title: 'Op school voel ik me alleen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_9,
    type: :range,
    title: 'Ik denk: er is geen enkele vriend(in) aan wie ik alles kan vertellen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_12,
    type: :range,
    title: 'Ik ben verdrietig omdat niemand met me mee wil doen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v1_13,
    type: :range,
    title: 'Ik ben verdrietig omdat ik geen vriend(inn)en heb.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true,
    section_end: true
  }, {
    id: :v2_1,
    type: :radio,
    title: 'Ik heb een <b>beste</b> vriend(in).',
    show_otherwise: false,
    options: [
      { title: 'Ja', shows_questions: %i[v2_2 v2_3 v2_4 v2_5 v2_6 v2_7 v2_8 v2_9 v2_10
v2_11 v2_12 v2_13 v2_14 v2_15 v2_16 v2_17 v2_18 v2_19 v2_20
v2_21 v2_22 v2_23 v2_24 v2_25 v2_26 v2_27 v2_28 v2_29 v2_30
v2_31 v2_32 v2_33 v2_34 v2_35 v2_36 v2_37 v2_38 v2_39 v2_40
v2_41 v2_42 v2_43 v2_44 v2_45 v2_46 v2_47] },
      { title: 'Nee', shows_questions: %i[v2_48] }]
  }, {
    section_start: 'De volgende vragen gaan over jou en je <b>beste vriend(in)</b>. Verplaats het bolletje naar het antwoord dat het beste past.',
    id: :v2_2,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik spelen altijd met elkaar in de pauze.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true,
    section_end: false
  }, {
    id: :v2_3,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik zijn vaak boos op elkaar.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_4,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) vindt dat ik dingen goed kan.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_5,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) neemt het voor me op, als andere kinderen over mij roddelen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_6,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik geven elkaar het gevoel dat we belangrijk en bijzonder zijn.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_7,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik kiezen elkaar uit als we samen iets moeten doen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_8,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) zegt sorry als hij of zij mij verdrietig heeft gemaakt.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_9,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) zegt soms wel eens gemene dingen over mij tegen andere kinderen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_10,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) heeft goede ideeën over spelletjes die we kunnen doen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_11,
    type: :range,
    hidden: true,
    title: 'Als mijn beste vriend(in) en ik kwaad op elkaar zijn, praten wij er samen over hoe we het weer goed kunnen maken.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_12,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) zou mij ook nog aardig vinden als alle andere kinderen mij niet aardig zouden vinden.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_13,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) vindt mij nogal slim.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_14,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik vertellen elkaar altijd onze problemen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_15,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) geeft mij een goed gevoel over de dingen die ik bedenk.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_16,
    type: :range,
    hidden: true,
    title: 'Als ik boos ben over iets wat me overkomen is, kan ik er met mijn beste vriend(in) over praten.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_17,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik helpen elkaar vaak met karweitjes en andere dingen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_18,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik doen dingen voor elkaar die we voor anderen niet zouden doen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_19,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik doen vaak leuke dingen samen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_20,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik kibbelen veel.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_21,
    type: :range,
    hidden: true,
    title: 'Ik kan erop rekenen dat mijn beste vriend(in) doet wat hij/zij beloofd heeft.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_22,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik komen bij elkaar thuis.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_23,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik spelen vaak samen tijdens de schoolvakanties.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_24,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) geeft mij advies als ik dingen moet oplossen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_25,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik praten samen over dingen die ons verdrietig maken.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_26,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik maken het gemakkelijk weer goed, als we ruzie hebben.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_27,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik maken vaak ruzie.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_28,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik delen dingen met elkaar.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_29,
    type: :range,
    hidden: true,
    title: 'Als mijn beste vriend(in) en ik boos zijn op elkaar, bespreken we samen hoe we ons weer beter kunnen voelen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_30,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) vertelt mijn geheimen niet door aan anderen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_31,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik plagen elkaar veel.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_32,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik hebben goede ideeën over hoe je dingen kunt doen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_33,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik lenen vaak dingen aan elkaar.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_34,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) helpt mij weleens zodat ik sneller klaar ben.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_35,
    type: :range,
    hidden: true,
    title: 'Als mijn beste vriend(in) en ik ergens ruzie over hebben dan is dat heel snel weer over.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_36,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik rekenen erop dat de ander goede ideeën heeft om iets voor elkaar te krijgen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_37,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) luistert niet naar mij.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_38,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik vertellen elkaar persoonlijke dingen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_39,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik helpen elkaar vaak met schoolwerk.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_40,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik vertellen elkaar geheimen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_41,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) vindt het belangrijk hoe ik me voel.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_42,
    type: :range,
    hidden: true,
    title: 'Ik ben wel eens jaloers op  mijn beste vriend(in).',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_43,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) en ik maken samen veel lol.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_44,
    type: :range,
    hidden: true,
    title: 'Ik ben er trots op om samen met mijn beste vriend(in) gezien te worden.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_45,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) probeert vaak van mij te winnen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_46,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) vrolijkt me op als ik verdrietig ben.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_47,
    type: :range,
    hidden: true,
    title: 'Mijn beste vriend(in) vindt het goed als ik dingen in mijn eentje wil doen.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v2_48,
    type: :range,
    hidden: true,
    title: 'Ik zou graag een beste vriend(in) willen hebben.',
    labels: ['Helemaal niet waar', 'Soms waar', 'Altijd waar'],
    required: true,
    section_end: true
  }]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Samen leuke dingen doen',
      ids: %i[v2_2 v2_7 v2_19 v2_22 v2_23],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Elkaar helpen',
      ids: %i[v2_17 v2_18 v2_24 v2_28 v2_32 v2_33 v2_34 v2_36 v2_39],
      operation: :average,
      round_to_decimals: 0 },
    { id: s3,
      label: 'Over problemen en zorgen praten',
      ids: %i[v2_14 v2_16 v2_25 v2_29 v2_38 v2_40],
      operation: :average,
      round_to_decimals: 0 },
    { id: s4,
      label: 'Ruzies en irritaties',
      ids: %i[v2_3 v2_9 v2_20 v2_21 v2_27 v2_31 v2_37],
       preprocessing: {
        v2_3: invert,
        v2_9: invert,
        v2_20: invert,
        v2_27: invert,
        v2_31: invert,
        v2_37: invert},
      operation: :average,
      round_to_decimals: 0},
    { id: s5,
      label: 'Ruzies goedmaken',
      ids: %i[v2_11 v2_26 v2_35],
      operation: :average,
      round_to_decimals: 0}
]}
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
