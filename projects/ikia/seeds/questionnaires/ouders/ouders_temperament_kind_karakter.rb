# frozen_string_literal: true

db_title = 'Karakter'

db_name1 = 'Persoonlijkheid_Kinderen_10plus_Ouderrapportage'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
likert_options = [
  { title: 'Helemaal mee oneens', numeric_value: 0 },
  { title: 'Mee oneens', numeric_value: 25 },
  { title: 'Neutraal', numeric_value: 50 },
  { title: 'Mee eens', numeric_value: 75 },
  { title: 'Helemaal mee eens', numeric_value: 100 }
]
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> De volgende vragenlijst gaat over het karakter van uw kind. Er volgen nu 104 zinnen met mogelijke eigenschappen van uw kind. Geef bij elke zin aan in hoeverre u het hiermee eens bent. Doe dit voor elke zin, ook als u niet helemaal zeker bent van uw antwoord. Het invullen duurt ongeveer 20 minuten.'
  }, {
    section_start: 'Mijn kind…',
    id: :v1,
    type: :likert,
    title: '…kan lang naar een schilderij kijken.',
    options: likert_options,
    section_end: false
  }, {
    id: :v2,
    type: :likert,
    title: '…ruimt zijn/haar kleren netjes op.',
    options: likert_options
  }, {
    id: :v3,
    type: :likert,
    title: '…blijft onaardig tegen iemand die gemeen was.',
    options: likert_options
  }, {
    id: :v4,
    type: :likert,
    title: '…gelooft dat mensen hem/haar graag mogen.',
    options: likert_options
  }, {
    id: :v5,
    type: :likert,
    title: '…vermijdt situaties waarin hij/zij gewond kan raken.',
    options: likert_options
  }, {
    id: :v6,
    type: :likert,
    title: '…doet zich soms beter voor dan hij/zij werkelijk is.',
    options: likert_options
  }, {
    id: :v7,
    type: :likert,
    title: '…leest graag over nieuwe ontdekkingen.',
    options: likert_options
  }, {
    id: :v8,
    type: :likert,
    title: '…werkt harder dan anderen.',
    options: likert_options
  }, {
    id: :v9,
    type: :likert,
    title: '…geeft vaak kritiek.',
    options: likert_options
  }, {
    id: :v10,
    type: :likert,
    title: '…houdt zich in een groep op de achtergrond.',
    options: likert_options
  }, {
    id: :v11,
    type: :likert,
    title: '…is bezorgd over onbelangrijke dingen.',
    options: likert_options
  }, {
    id: :v12,
    type: :likert,
    title: '…verzwijgt het als hij/zij te weinig heeft betaald.',
    options: likert_options
  }, {
    id: :v13,
    type: :likert,
    title: '…heeft veel fantasie.',
    options: likert_options
  }, {
    id: :v14,
    type: :likert,
    title: '…kijkt zijn/haar werk zorgvuldig na.',
    options: likert_options
  }, {
    id: :v15,
    type: :likert,
    title: '…past zijn/haar mening aan die van anderen aan.',
    options: likert_options
  }, {
    id: :v16,
    type: :likert,
    title: '…werkt liever alleen dan met anderen.',
    options: likert_options
  }, {
    id: :v17,
    type: :likert,
    title: '…kan persoonlijke problemen helemaal alleen aan.',
    options: likert_options
  }, {
    id: :v18,
    type: :likert,
    title: '…wil dat anderen hem/haar belangrijk vinden.',
    options: likert_options
  }, {
    id: :v19,
    type: :likert,
    title: '…houdt van mensen met rare ideeën.',
    options: likert_options
  }, {
    id: :v20,
    type: :likert,
    title: '…denkt goed na voordat hij/zij iets onveiligs doet.',
    options: likert_options
  }, {
    id: :v21,
    type: :likert,
    title: '…reageert soms erg vel als iets tegenzit.',
    options: likert_options
  }, {
    id: :v22,
    type: :likert,
    title: '…heeft altijd zin in het leven.',
    options: likert_options
  }, {
    id: :v23,
    type: :likert,
    title: '…leeft heel erg mee met het verdriet van anderen.',
    options: likert_options
  }, {
    id: :v24,
    type: :likert,
    title: '…vindt zichzelf een gewoon persoon; alles behalve bijzonder.',
    options: likert_options
  }, {
    id: :v25,
    type: :likert,
    title: '…vindt de meeste kunst dom.',
    options: likert_options
  }, {
    id: :v26,
    type: :likert,
    title: '…kan door zijn/haar eigen troep soms moeilijk iets vinden.',
    options: likert_options
  }, {
    id: :v27,
    type: :likert,
    title: '…vertrouwt anderen weer snel nadat ze hem/haar bedrogen hebben.',
    options: likert_options
  }, {
    id: :v28,
    type: :likert,
    title: '…gelooft dat niemand hem/haar leuk vindt.',
    options: likert_options
  }, {
    id: :v29,
    type: :likert,
    title: '…kan goed tegen lichamelijke pijn.',
    options: likert_options
  }, {
    id: :v30,
    type: :likert,
    title: '…vertelt weleens een leugentje om zijn/haar zin te krijgen.',
    options: likert_options
  }, {
    id: :v31,
    type: :likert,
    title: '…vindt wetenschap saai.',
    options: likert_options
  }, {
    id: :v32,
    type: :likert,
    title: 'Als iets moeilijk is, geeft hij/zij het snel op.',
    options: likert_options,
    section_end: true
  }, {
    section_start: 'Mijn kind…',
    id: :v33,
    type: :likert,
    title: '…is zacht tegenover anderen.',
    options: likert_options,
    section_end: false
  }, {
    id: :v34,
    type: :likert,
    title: '…legt gemakkelijk contact met vreemden.',
    options: likert_options
  }, {
    id: :v35,
    type: :likert,
    title: '…is vaak ongerust dat er iets misgaat.',
    options: likert_options
  }, {
    id: :v36,
    type: :likert,
    title: '…is benieuwd hoe je op een oneerlijke manier veel geld kunt verdienen.',
    options: likert_options
  }, {
    id: :v37,
    type: :likert,
    title: '…houdt ervan om nieuwe manieren te verzinnen om dingen te doen.',
    options: likert_options
  }, {
    id: :v38,
    type: :likert,
    title: '…vindt het zonde van de tijd om zijn/haar werk op fouten na te kijken.',
    options: likert_options
  }, {
    id: :v39,
    type: :likert,
    title: '…geeft gemakkelijk anderen gelijk.',
    options: likert_options
  }, {
    id: :v40,
    type: :likert,
    title: '…is het liefst in zijn/haar eentje.',
    options: likert_options
  }, {
    id: :v41,
    type: :likert,
    title: '…heeft zelden steun van anderen nodig.',
    options: likert_options
  }, {
    id: :v42,
    type: :likert,
    title: '…wil graag kostbare spullen bezitten.',
    options: likert_options
  }, {
    id: :v43,
    type: :likert,
    title: '…zou het vervelend vinden als mensen hem/haar raar zouden vinden.',
    options: likert_options
  }, {
    id: :v44,
    type: :likert,
    title: '…doet wat in hem/haar opkomt.',
    options: likert_options
  }, {
    id: :v45,
    type: :likert,
    title: '…is zelden kwaad op iemand.',
    options: likert_options
  }, {
    id: :v46,
    type: :likert,
    title: '…is vaak somber.',
    options: likert_options
  }, {
    id: :v47,
    type: :likert,
    title: '…voelt soms tranen in hem/haar opkomen als hij/zij afscheid neemt.',
    options: likert_options
  }, {
    id: :v48,
    type: :likert,
    title: '…vindt dat hij/zij de regels mag overtreden.',
    options: likert_options
  }, {
    id: :v49,
    type: :likert,
    title: '…houdt van gedichten.',
    options: likert_options
  }, {
    id: :v50,
    type: :likert,
    title: 'Zijn/haar kamer is altijd opgeruimd.',
    options: likert_options
  }, {
    id: :v51,
    type: :likert,
    title: '…is lang op zijn/haar hoede bij mensen die hem/haar kwaad hebben gedaan.',
    options: likert_options
  }, {
    id: :v52,
    type: :likert,
    title: '…gelooft dat niemand graag met hem/haar wil praten.',
    options: likert_options
  }, {
    id: :v53,
    type: :likert,
    title: '…is bang om pijn te lijden.',
    options: likert_options
  }, {
    id: :v54,
    type: :likert,
    title: '…is slecht in het "doen alsof".',
    options: likert_options
  }, {
    id: :v55,
    type: :likert,
    title: '…verveelt zich bij natuurprogramma′s op de tv.',
    options: likert_options
  }, {
    id: :v56,
    type: :likert,
    title: '…stelt ingewikkelde taken zo lang mogelijk uit.',
    options: likert_options
  }, {
    id: :v57,
    type: :likert,
    title: '…reageert negatief als iemand fouten maakt.',
    options: likert_options
  }, {
    id: :v58,
    type: :likert,
    title: '…is vaak de woordvoerder van een groep.',
    options: likert_options
  }, {
    id: :v59,
    type: :likert,
    title: '…maakt zich minder zorgen dan anderen.',
    options: likert_options
  }, {
    id: :v60,
    type: :likert,
    title: '…gaat liever dood dan dat hij/zij iets steelt.',
    options: likert_options
  }, {
    id: :v61,
    type: :likert,
    title: '…houdt er van om gekke dingen te maken.',
    options: likert_options
  }, {
    id: :v62,
    type: :likert,
    title: '…werkt erg nauwkeurig.',
    options: likert_options
  }, {
    id: :v63,
    type: :likert,
    title: 'Het is moeilijk zijn/haar ideeën te veranderen.',
    options: likert_options,
    section_end: true
  }, {
    section_start: 'Mijn kind…',
    id: :v64,
    type: :likert,
    title: '…gaat het liefst met veel mensen om.',
    options: likert_options,
    section_end: false
  }, {
    id: :v65,
    type: :likert,
    title: '…heeft anderen nodig om hem/haar te troosten.',
    options: likert_options
  }, {
    id: :v66,
    type: :likert,
    title: '…draagt liever oude vodden dan nieuwe kleren.',
    options: likert_options
  }, {
    id: :v67,
    type: :likert,
    title: 'Anderen vinden dat hij/zij vreemde ideeën heeft.',
    options: likert_options
  }, {
    id: :v68,
    type: :likert,
    title: '…kan zichzelf goed beheersen.',
    options: likert_options
  }, {
    id: :v69,
    type: :likert,
    title: 'Zelfs als hij/zij slecht behandeld word, blijf hij/zij kalm.',
    options: likert_options
  }, {
    id: :v70,
    type: :likert,
    title: '…is over het algemeen vrolijk.',
    options: likert_options
  }, {
    id: :v71,
    type: :likert,
    title: '…wordt verdrietig als een hele goede vriend(in) lang weggaat.',
    options: likert_options
  }, {
    id: :v72,
    type: :likert,
    title: '…vindt dat hij/zij boven de wet staat.',
    options: likert_options
  }, {
    id: :v73,
    type: :likert,
    title: '…verbaast zich dat mensen geld willen besteden aan kunst.',
    options: likert_options
  }, {
    id: :v74,
    type: :likert,
    title: '…zorgt dat dingen altijd op de juiste plek liggen.',
    options: likert_options
  }, {
    id: :v75,
    type: :likert,
    title: '…is goed van vertrouwen.',
    options: likert_options
  }, {
    id: :v76,
    type: :likert,
    title: '…denkt dat veel mensen hem/haar onaardig vinden.',
    options: likert_options
  }, {
    id: :v77,
    type: :likert,
    title: '…durft meer dan anderen in gevaarlijke situaties.',
    options: likert_options
  }, {
    id: :v78,
    type: :likert,
    title: '…vindt het moeilijk om te liegen.',
    options: likert_options
  }, {
    id: :v79,
    type: :likert,
    title: '…zou graag een boek over uitvindingen willen lezen.',
    options: likert_options
  }, {
    id: :v80,
    type: :likert,
    title: '…luiert liever dan dat hij/zij hard werkt.',
    options: likert_options
  }, {
    id: :v81,
    type: :likert,
    title: '…laat het direct merken als hij/zij iets stom vindt.',
    options: likert_options
  }, {
    id: :v82,
    type: :likert,
    title: '…voelt zich slecht op zijn gemak in een onbekende groep.',
    options: likert_options
  }, {
    id: :v83,
    type: :likert,
    title: 'Zelfs onder spanning slaapt hij/zij goed.',
    options: likert_options
  }, {
    id: :v84,
    type: :likert,
    title: '…verzwijgt dat hij/zij iets kapot heeft gemaakt als het geheim kan blijven.',
    options: likert_options
  }, {
    id: :v85,
    type: :likert,
    title: 'Zijn/haar werk is vaak origineel.',
    options: likert_options,
    section_end: true
  }, {
    section_start: 'Mijn kind…',
    id: :v86,
    type: :likert,
    title: '…herleest wat hij/zij schrijft om te zorgen dat het foutloos is.',
    options: likert_options,
    section_end: false
  }, {
    id: :v87,
    type: :likert,
    title: '…is het snel met anderen eens.',
    options: likert_options
  }, {
    id: :v88,
    type: :likert,
    title: '…praat graag met anderen.',
    options: likert_options
  }, {
    id: :v89,
    type: :likert,
    title: '…kan prima in zijn/haar eentje moeilijkheden overwinnen.',
    options: likert_options
  }, {
    id: :v90,
    type: :likert,
    title: '…wil graag beroemd zijn.',
    options: likert_options
  }, {
    id: :v91,
    type: :likert,
    title: 'Mensen zijn verrast door zijn/haar opvattingen.',
    options: likert_options
  }, {
    id: :v92,
    type: :likert,
    title: '…doet vaak dingen zonder echt na te denken.',
    options: likert_options
  }, {
    id: :v93,
    type: :likert,
    title: 'Mensen hebben hem/haar wel eens woedend gezien.',
    options: likert_options
  }, {
    id: :v94,
    type: :likert,
    title: '…is zelden opgewekt.',
    options: likert_options
  }, {
    id: :v95,
    type: :likert,
    title: '…moet huilen bij trieste of romantische films.',
    options: likert_options
  }, {
    id: :v96,
    type: :likert,
    title: '…vindt dat hij/zij recht heeft op een speciale behandeling.',
    options: likert_options
  }, {
    id: :v97,
    type: :likert,
    title: '…zou zich erg naar voelen als hij/zij iemand pijn zou doen.',
    options: likert_options
  }, {
    id: :v98,
    type: :likert,
    title: '…heeft uitgewerkte plannen om dingen te verbeteren.',
    options: likert_options
  }, {
    id: :v99,
    type: :likert,
    title: 'leeft mee met mensen die minder geluk hebben dan hem/haar.',
    options: likert_options
  }, {
    id: :v100,
    type: :likert,
    title: '…gaat mogelijkheden om zijn/haar omgeving te veranderen uit de weg.',
    options: likert_options
  }, {
    id: :v101,
    type: :likert,
    title: 'Het idee dat alleen de sterksten zullen overleven trekt hem/haar aan.',
    options: likert_options
  }, {
    id: :v102,
    type: :likert,
    title: 'Wanneer er een probleem is, pakt hij/zij het meteen aan.',
    options: likert_options
  }, {
    id: :v103,
    type: :likert,
    title: 'Mensen vinden hem/haar hardvochtig.',
    options: likert_options
  }, {
    id: :v104,
    type: :likert,
    title: '…organiseert in detail allerlei veranderingen die hij/zij wil doorvoeren.',
    options: likert_options,
    section_end: true
  }
]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Integriteit',
      ids: %i[v6 v30 v54 v78 v12 v36 v60 v84 v18 v42 v66 v90 v24 v48 v72 v96],
      preprocessing: {
        v6: invert,
        v30: invert,
        v12: invert,
        v36: invert,
        v84: invert,
        v18: invert,
        v42: invert,
        v90: invert,
        v48: invert,
        v72: invert,
        v96: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Emotionaliteit',
      ids: %i[v5 v29 v53 v77 v11 v35 v59 v83 v17 v41 v65 v89 v23 v47 v71 v95],
      preprocessing: {
        v29: invert,
        v77: invert,
        v59: invert,
        v83: invert,
        v17: invert,
        v41: invert,
        v89: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Extraversie',
      ids: %i[v4 v28 v52 v76 v10 v34 v58 v82 v16 v40 v64 v88 v22 v46 v70 v94],
      preprocessing: {
        v28: invert,
        v52: invert,
        v76: invert,
        v10: invert,
        v82: invert,
        v16: invert,
        v40: invert,
        v46: invert,
        v94: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s4,
      label: 'Consciëntieusheid',
      ids: %i[v2 v26 v50 v74 v8 v32 v56 v80 v14 v38 v62 v86 v20 v44 v68 v92],
      preprocessing: {
        v26: invert,
        v32: invert,
        v56: invert,
        v80: invert,
        v38: invert,
        v44: invert,
        v92: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s5,
      label: 'Altruisme',
      ids: %i[v97 v99 v101 v103],
      preprocessing: {
        v101: invert,
        v103: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s6,
      label: 'Openheid',
      ids: %i[v1 v25 v49 v73 v7 v31 v55 v79 v13 v37 v61 v85 v19 v43 v67 v91],
      preprocessing: {
        v25: invert,
        v73: invert,
        v31: invert,
        v55: invert,
        v43: invert
      },
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
