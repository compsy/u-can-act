# frozen_string_literal: true

db_title = 'Karakter'

db_name1 = 'Persoonlijkheid_Ouders_zelf'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
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
    content: '<p class="flow-text">De volgende vragenlijst gaat over uw karakter. Er volgen nu 104 zinnen over eigenschappen van mensen. Geef bij elke zin aan in hoeverre u het hiermee eens bent. Doe dit voor elke zin, ook als u niet helemaal zeker bent van uw antwoord. Het invullen duurt ongeveer 20 minuten.'
  }, {
    id: :v1,
    type: :likert,
    title: 'Ik kan lang naar een schilderij kijken.',
    options: likert_options
  }, {
    id: :v2,
    type: :likert,
    title: 'Ik ruim mijn kleren netjes op.',
    options: likert_options
  }, {
    id: :v3,
    type: :likert,
    title: 'Ik blijf onaardig tegen iemand die gemeen was.',
    options: likert_options
  }, {
    id: :v4,
    type: :likert,
    title: 'Mensen mogen mij graag.',
    options: likert_options
  }, {
    id: :v5,
    type: :likert,
    title: 'Ik vermijd situaties waarin ik gewond kan raken.',
    options: likert_options
  }, {
    id: :v6,
    type: :likert,
    title: 'Ik doe mij soms beter voor dan ik werkelijk ben.',
    options: likert_options
  }, {
    id: :v7,
    type: :likert,
    title: 'Ik lees graag over nieuwe ontdekkingen.',
    options: likert_options
  }, {
    id: :v8,
    type: :likert,
    title: 'Ik werk harder dan anderen.',
    options: likert_options
  }, {
    id: :v9,
    type: :likert,
    title: 'Ik geef vaak kritiek.',
    options: likert_options
  }, {
    id: :v10,
    type: :likert,
    title: 'Ik houd me in een groep op de achtergrond.',
    options: likert_options
  }, {
    id: :v11,
    type: :likert,
    title: 'Ik ben bezorgd over onbelangrijke dingen.',
    options: likert_options
  }, {
    id: :v12,
    type: :likert,
    title: 'Ik verzwijg het als ik te weinig heb betaald.',
    options: likert_options
  }, {
    id: :v13,
    type: :likert,
    title: 'Ik heb veel fantasie.',
    options: likert_options
  }, {
    id: :v14,
    type: :likert,
    title: 'Ik kijk mijn werk zorgvuldig na.',
    options: likert_options
  }, {
    id: :v15,
    type: :likert,
    title: 'Ik pas mijn mening aan die van anderen aan.',
    options: likert_options
  }, {
    id: :v16,
    type: :likert,
    title: 'Ik werk liever alleen dan met anderen.',
    options: likert_options
  }, {
    id: :v17,
    type: :likert,
    title: 'Ik kan mijn persoonlijke problemen helemaal alleen aan.',
    options: likert_options
  }, {
    id: :v18,
    type: :likert,
    title: 'Ik wil dat anderen mij belangrijk vinden.',
    options: likert_options
  }, {
    id: :v19,
    type: :likert,
    title: 'Ik houd van mensen met rare ideeën.',
    options: likert_options
  }, {
    id: :v20,
    type: :likert,
    title: 'Ik denk goed na voordat ik iets onveiligs doe.',
    options: likert_options
  }, {
    id: :v21,
    type: :likert,
    title: 'Ik reageer soms erg vel als iets tegenzit.',
    options: likert_options
  }, {
    id: :v22,
    type: :likert,
    title: 'Ik heb altijd zin in het leven.',
    options: likert_options
  }, {
    id: :v23,
    type: :likert,
    title: 'Ik leef heel erg mee met het verdriet van anderen.',
    options: likert_options
  }, {
    id: :v24,
    type: :likert,
    title: 'Ik ben een gewoon persoon; alles behalve bijzonder.',
    options: likert_options
  }, {
    id: :v25,
    type: :likert,
    title: 'Ik vind de meeste kunst dom.',
    options: likert_options
  }, {
    id: :v26,
    type: :likert,
    title: 'Ik kan door mijn eigen troep soms moeilijk iets vinden.',
    options: likert_options
  }, {
    id: :v27,
    type: :likert,
    title: 'Ik vertrouw anderen weer snel nadat ze mij bedrogen hebben.',
    options: likert_options
  }, {
    id: :v28,
    type: :likert,
    title: 'Niemand vindt mij leuk.',
    options: likert_options
  }, {
    id: :v29,
    type: :likert,
    title: 'Ik kan goed tegen lichamelijke pijn.',
    options: likert_options
  }, {
    id: :v30,
    type: :likert,
    title: 'Ik vertel weleens een leugentje om mijn zin te krijgen.',
    options: likert_options
  }, {
    id: :v31,
    type: :likert,
    title: 'Ik vind wetenschap saai.',
    options: likert_options
  }, {
    id: :v32,
    type: :likert,
    title: 'Als iets moeilijk is, geef ik het snel op.',
    options: likert_options
  }, {
    id: :v33,
    type: :likert,
    title: 'Ik ben zacht tegenover anderen.',
    options: likert_options
  }, {
    id: :v34,
    type: :likert,
    title: 'Ik leg gemakkelijk contact met vreemden.',
    options: likert_options
  }, {
    id: :v35,
    type: :likert,
    title: 'Ik ben vaak ongerust dat er iets misgaat.',
    options: likert_options
  }, {
    id: :v36,
    type: :likert,
    title: 'Ik ben benieuwd hoe je op een oneerlijke manier veel geld kunt verdienen.',
    options: likert_options
  }, {
    id: :v37,
    type: :likert,
    title: 'Ik houd ervan om nieuwe manieren te verzinnen om dingen te doen.',
    options: likert_options
  }, {
    id: :v38,
    type: :likert,
    title: 'Ik vind het zonde van de tijd om mijn werk op fouten na te kijken.',
    options: likert_options
  }, {
    id: :v39,
    type: :likert,
    title: 'Ik geef gemakkelijk anderen gelijk.',
    options: likert_options
  }, {
    id: :v40,
    type: :likert,
    title: 'Ik ben het liefst in mijn eentje.',
    options: likert_options
  }, {
    id: :v41,
    type: :likert,
    title: 'Ik heb zelden steun van anderen nodig.',
    options: likert_options
  }, {
    id: :v42,
    type: :likert,
    title: 'Ik wil graag kostbare spullen bezitten.',
    options: likert_options
  }, {
    id: :v43,
    type: :likert,
    title: 'Ik zou het vervelend vinden als mensen mij raar zouden vinden.',
    options: likert_options
  }, {
    id: :v44,
    type: :likert,
    title: 'Ik doe wat in mij opkomt.',
    options: likert_options
  }, {
    id: :v45,
    type: :likert,
    title: 'Ik ben zelden kwaad op iemand.',
    options: likert_options
  }, {
    id: :v46,
    type: :likert,
    title: 'Ik ben vaak somber.',
    options: likert_options
  }, {
    id: :v47,
    type: :likert,
    title: 'Ik voel soms tranen in mij opkomen als ik afscheid neem.',
    options: likert_options
  }, {
    id: :v48,
    type: :likert,
    title: 'Ik vind dat ik de regels mag overtreden.',
    options: likert_options
  }, {
    id: :v49,
    type: :likert,
    title: 'Ik houd van gedichten.',
    options: likert_options
  }, {
    id: :v50,
    type: :likert,
    title: 'Mijn kamer is altijd opgeruimd.',
    options: likert_options
  }, {
    id: :v51,
    type: :likert,
    title: 'Ik ben lang op mijn hoede bij mensen die mij kwaad hebben gedaan.',
    options: likert_options
  }, {
    id: :v52,
    type: :likert,
    title: 'Niemand wil graag met mij praten.',
    options: likert_options
  }, {
    id: :v53,
    type: :likert,
    title: 'Ik ben bang om pijn te lijden.',
    options: likert_options
  }, {
    id: :v54,
    type: :likert,
    title: 'Ik ben slecht in het "doen alsof".',
    options: likert_options
  }, {
    id: :v55,
    type: :likert,
    title: 'Ik verveel me bij natuurprogramma′s op de tv.',
    options: likert_options
  }, {
    id: :v56,
    type: :likert,
    title: 'Ik stel ingewikkelde taken zo lang mogelijk uit.',
    options: likert_options
  }, {
    id: :v57,
    type: :likert,
    title: 'Ik reageer negatief als iemand fouten maakt.',
    options: likert_options
  }, {
    id: :v58,
    type: :likert,
    title: 'Ik ben vaak de woordvoerder van een groep.',
    options: likert_options
  }, {
    id: :v59,
    type: :likert,
    title: 'Ik maak me minder zorgen dan anderen.',
    options: likert_options
  }, {
    id: :v60,
    type: :likert,
    title: 'Ik ga liever dood dan dat ik iets steel.',
    options: likert_options
  }, {
    id: :v61,
    type: :likert,
    title: 'Ik houd er van om gekke dingen te maken.',
    options: likert_options
  }, {
    id: :v62,
    type: :likert,
    title: 'Ik werk erg nauwkeurig.',
    options: likert_options
  }, {
    id: :v63,
    type: :likert,
    title: 'Het is moeilijk mijn ideeën te veranderen.',
    options: likert_options
  }, {
    id: :v64,
    type: :likert,
    title: 'Ik ga het liefst met veel mensen om.',
    options: likert_options
  }, {
    id: :v65,
    type: :likert,
    title: 'Ik heb anderen nodig om mij te troosten.',
    options: likert_options
  }, {
    id: :v66,
    type: :likert,
    title: 'Ik draag liever oude vodden dan nieuwe kleren.',
    options: likert_options
  }, {
    id: :v67,
    type: :likert,
    title: 'Anderen vinden dat ik vreemde ideeën heb.',
    options: likert_options
  }, {
    id: :v68,
    type: :likert,
    title: 'Ik kan mijzelf goed beheersen.',
    options: likert_options
  }, {
    id: :v69,
    type: :likert,
    title: 'Zelfs als ik slecht behandeld word, blijf ik kalm.',
    options: likert_options
  }, {
    id: :v70,
    type: :likert,
    title: 'Ik ben over het algemeen vrolijk.',
    options: likert_options
  }, {
    id: :v71,
    type: :likert,
    title: 'Ik word verdrietig als een hele goede vriend(in) lang weggaat.',
    options: likert_options
  }, {
    id: :v72,
    type: :likert,
    title: 'Ik sta boven de wet.',
    options: likert_options
  }, {
    id: :v73,
    type: :likert,
    title: 'Het verbaast me dat mensen geld willen besteden aan kunst.',
    options: likert_options
  }, {
    id: :v74,
    type: :likert,
    title: 'Ik zorg dat dingen altijd op de juiste plek liggen.',
    options: likert_options
  }, {
    id: :v75,
    type: :likert,
    title: 'Ik ben goed van vertrouwen.',
    options: likert_options
  }, {
    id: :v76,
    type: :likert,
    title: 'Ik denk dat veel mensen mij onaardig vinden.',
    options: likert_options
  }, {
    id: :v77,
    type: :likert,
    title: 'Ik durf meer dan anderen in gevaarlijke situaties.',
    options: likert_options
  }, {
    id: :v78,
    type: :likert,
    title: 'Ik vind het moeilijk om te liegen.',
    options: likert_options
  }, {
    id: :v79,
    type: :likert,
    title: 'Ik zou graag een boek over uitvindingen willen lezen.',
    options: likert_options
  }, {
    id: :v80,
    type: :likert,
    title: 'Ik luier liever dan dat ik hard werk.',
    options: likert_options
  }, {
    id: :v81,
    type: :likert,
    title: 'Ik laat het direct merken als ik iets stom vind.',
    options: likert_options
  }, {
    id: :v82,
    type: :likert,
    title: 'Ik voel me slecht op mijn gemak in een onbekende groep.',
    options: likert_options
  }, {
    id: :v83,
    type: :likert,
    title: 'Zelfs onder spanning slaap ik goed.',
    options: likert_options
  }, {
    id: :v84,
    type: :likert,
    title: 'Ik verzwijg dat ik iets kapot heb gemaakt als het geheim kan blijven.',
    options: likert_options
  }, {
    id: :v85,
    type: :likert,
    title: 'Mijn werk is vaak origineel.',
    options: likert_options
  }, {
    id: :v86,
    type: :likert,
    title: 'Ik herlees wat ik schrijf om te zorgen dat het foutloos is.',
    options: likert_options
  }, {
    id: :v87,
    type: :likert,
    title: 'Ik ben het snel met anderen eens.',
    options: likert_options
  }, {
    id: :v88,
    type: :likert,
    title: 'Ik praat graag met anderen.',
    options: likert_options
  }, {
    id: :v89,
    type: :likert,
    title: 'Ik kan prima in mijn eentje moeilijkheden overwinnen.',
    options: likert_options
  }, {
    id: :v90,
    type: :likert,
    title: 'Ik wil graag beroemd zijn.',
    options: likert_options
  }, {
    id: :v91,
    type: :likert,
    title: 'Mensen zijn verrast door mijn opvattingen.',
    options: likert_options
  }, {
    id: :v92,
    type: :likert,
    title: 'Ik doe vaak dingen zonder echt na te denken.',
    options: likert_options
  }, {
    id: :v93,
    type: :likert,
    title: 'Mensen hebben mij wel eens woedend gezien.',
    options: likert_options
  }, {
    id: :v94,
    type: :likert,
    title: 'Ik ben zelden opgewekt.',
    options: likert_options
  }, {
    id: :v95,
    type: :likert,
    title: 'Ik moet huilen bij trieste of romantische films.',
    options: likert_options
  }, {
    id: :v96,
    type: :likert,
    title: 'Ik heb recht op een speciale behandeling.',
    options: likert_options
  }, {
    id: :v97,
    type: :likert,
    title: 'Ik zou mij erg naar voelen als ik iemand pijn zou doen.',
    options: likert_options
  }, {
    id: :v98,
    type: :likert,
    title: 'Ik heb uitgewerkte plannen om dingen te verbeteren.',
    options: likert_options
  }, {
    id: :v99,
    type: :likert,
    title: 'Ik leef mee met mensen die minder geluk hebben dan ik.',
    options: likert_options
  }, {
    id: :v100,
    type: :likert,
    title: 'Ik ga mogelijkheden om mijn omgeving te veranderen uit de weg.',
    options: likert_options
  }, {
    id: :v101,
    type: :likert,
    title: 'Het idee dat alleen de sterksten zullen overleven trekt mij aan.',
    options: likert_options
  }, {
    id: :v102,
    type: :likert,
    title: 'Wanneer er een probleem is, pak ik het meteen aan.',
    options: likert_options
  }, {
    id: :v103,
    type: :likert,
    title: 'Mensen vinden mij hardvochtig.',
    options: likert_options
  }, {
    id: :v104,
    type: :likert,
    title: 'Ik organiseer in detail allerlei veranderingen die ik wil doorvoeren.',
    options: likert_options
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
