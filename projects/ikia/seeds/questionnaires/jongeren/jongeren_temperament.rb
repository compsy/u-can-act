# frozen_string_literal: true

db_title = 'Mijn karakter'

db_name1 = 'Persoonlijkheid_Jongeren_zelf'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">De volgende vragenlijst gaat over je karakter. Er volgen nu 104 zinnen over eigenschappen van mensen. Geef bij elke zin aan of je het hiermee eens bent. Doe dit voor elke zin, ook als je niet helemaal zeker bent van je antwoord. Het invullen duurt ongeveer 20 minuten.'
  }, {
    id: :v1,
    type: :likert,
    title: 'Ik kan lang naar een schilderij kijken.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v2,
    type: :likert,
    title: 'Ik ruim mijn kleren netjes op.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v3,
    type: :likert,
    title: 'Ik blijf onaardig tegen iemand die gemeen was.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v4,
    type: :likert,
    title: 'Mensen mogen mij graag.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v5,
    type: :likert,
    title: 'Ik vermijd situaties waarin ik gewond kan raken.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v6,
    type: :likert,
    title: 'Ik doe mij soms beter voor dan ik werkelijk ben.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v7,
    type: :likert,
    title: 'Ik lees graag over nieuwe ontdekkingen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v8,
    type: :likert,
    title: 'Ik werk harder dan anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v9,
    type: :likert,
    title: 'Ik geef vaak kritiek.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v10,
    type: :likert,
    title: 'Ik houd me in een groep op de achtergrond.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v11,
    type: :likert,
    title: 'Ik ben bezorgd over onbelangrijke dingen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v12,
    type: :likert,
    title: 'Ik verzwijg het als ik te weinig heb betaald.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v13,
    type: :likert,
    title: 'Ik heb veel fantasie.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v14,
    type: :likert,
    title: 'Ik kijk mijn werk zorgvuldig na.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v15,
    type: :likert,
    title: 'Ik pas mijn mening aan die van anderen aan.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v16,
    type: :likert,
    title: 'Ik werk liever alleen dan met anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v17,
    type: :likert,
    title: 'Ik kan mijn persoonlijke problemen helemaal alleen aan.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v18,
    type: :likert,
    title: 'Ik wil dat anderen mij belangrijk vinden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v19,
    type: :likert,
    title: 'Ik houd van mensen met rare ideeën.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v20,
    type: :likert,
    title: 'Ik denk goed na voordat ik iets onveiligs doe.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v21,
    type: :likert,
    title: 'Ik reageer soms erg vel als iets tegenzit.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v22,
    type: :likert,
    title: 'Ik heb altijd zin in het leven.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v23,
    type: :likert,
    title: 'Ik leef heel erg mee met het verdriet van anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v24,
    type: :likert,
    title: 'Ik ben een gewoon persoon; alles behalve bijzonder.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v25,
    type: :likert,
    title: 'Ik vind de meeste kunst dom.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v26,
    type: :likert,
    title: 'Ik kan door mijn eigen troep soms moeilijk iets vinden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v27,
    type: :likert,
    title: 'Ik vertrouw anderen weer snel nadat ze mij bedrogen hebben.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v28,
    type: :likert,
    title: 'Niemand vindt mij leuk.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v29,
    type: :likert,
    title: 'Ik kan goed tegen lichamelijke pijn.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v30,
    type: :likert,
    title: 'Ik vertel weleens een leugentje om mijn zin te krijgen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v31,
    type: :likert,
    title: 'Ik vind wetenschap saai.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v32,
    type: :likert,
    title: 'Als iets moeilijk is, geef ik het snel op.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v33,
    type: :likert,
    title: 'Ik ben zacht tegenover anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v34,
    type: :likert,
    title: 'Ik leg gemakkelijk contact met vreemden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v35,
    type: :likert,
    title: 'Ik ben vaak ongerust dat er iets misgaat.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v36,
    type: :likert,
    title: 'Ik ben benieuwd hoe je op een oneerlijke manier veel geld kunt verdienen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v37,
    type: :likert,
    title: 'Ik houd ervan om nieuwe manieren te verzinnen om dingen te doen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v38,
    type: :likert,
    title: 'Ik vind het zonde van de tijd om mijn werk op fouten na te kijken.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v39,
    type: :likert,
    title: 'Ik geef gemakkelijk anderen gelijk.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v40,
    type: :likert,
    title: 'Ik ben het liefst in mijn eentje.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v41,
    type: :likert,
    title: 'Ik heb zelden steun van anderen nodig.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v42,
    type: :likert,
    title: 'Ik wil graag kostbare spullen bezitten.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v43,
    type: :likert,
    title: 'Ik zou het vervelend vinden als mensen mij raar zouden vinden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v44,
    type: :likert,
    title: 'Ik doe wat in mij opkomt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v45,
    type: :likert,
    title: 'Ik ben zelden kwaad op iemand.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v46,
    type: :likert,
    title: 'Ik ben vaak somber.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v47,
    type: :likert,
    title: 'Ik voel soms tranen in mij opkomen als ik afscheid neem.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v48,
    type: :likert,
    title: 'Ik vind dat ik de regels mag overtreden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v49,
    type: :likert,
    title: 'Ik houd van gedichten.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v50,
    type: :likert,
    title: 'Mijn kamer is altijd opgeruimd.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v51,
    type: :likert,
    title: 'Ik ben lang op mijn hoede bij mensen die mij kwaad hebben gedaan.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v52,
    type: :likert,
    title: 'Niemand wil graag met mij praten.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v53,
    type: :likert,
    title: 'Ik ben bang om pijn te lijden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v54,
    type: :likert,
    title: 'Ik ben slecht in het "doen alsof".',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v55,
    type: :likert,
    title: 'Ik verveel me bij natuurprogramma′s op de tv.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v56,
    type: :likert,
    title: 'Ik stel ingewikkelde taken zo lang mogelijk uit.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v57,
    type: :likert,
    title: 'Ik reageer negatief als iemand fouten maakt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v58,
    type: :likert,
    title: 'Ik ben vaak de woordvoerder van een groep.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v59,
    type: :likert,
    title: 'Ik maak me minder zorgen dan anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v60,
    type: :likert,
    title: 'Ik ga liever dood dan dat ik iets steel.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v61,
    type: :likert,
    title: 'Ik houd er van om gekke dingen te maken.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v62,
    type: :likert,
    title: 'Ik werk erg nauwkeurig.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v63,
    type: :likert,
    title: 'Het is moeilijk mijn ideeën te veranderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v64,
    type: :likert,
    title: 'Ik ga het liefst met veel mensen om.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v65,
    type: :likert,
    title: 'Ik heb anderen nodig om mij te troosten.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v66,
    type: :likert,
    title: 'Ik draag liever oude vodden dan nieuwe kleren.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v67,
    type: :likert,
    title: 'Anderen vinden dat ik vreemde ideeën heb.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v68,
    type: :likert,
    title: 'Ik kan mijzelf goed beheersen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v69,
    type: :likert,
    title: 'Zelfs als ik slecht behandeld word, blijf ik kalm.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v70,
    type: :likert,
    title: 'Ik ben over het algemeen vrolijk.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v71,
    type: :likert,
    title: 'Ik word verdrietig als een hele goede vriend(in) lang weggaat.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v72,
    type: :likert,
    title: 'Ik sta boven de wet.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v73,
    type: :likert,
    title: 'Het verbaast me dat mensen geld willen besteden aan kunst.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v74,
    type: :likert,
    title: 'Ik zorg dat dingen altijd op de juiste plek liggen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v75,
    type: :likert,
    title: 'Ik ben goed van vertrouwen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v76,
    type: :likert,
    title: 'Ik denk dat veel mensen mij onaardig vinden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v77,
    type: :likert,
    title: 'Ik durf meer dan anderen in gevaarlijke situaties.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v78,
    type: :likert,
    title: 'Ik vind het moeilijk om te liegen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v79,
    type: :likert,
    title: 'Ik zou graag een boek over uitvindingen willen lezen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v80,
    type: :likert,
    title: 'Ik luier liever dan dat ik hard werk.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v81,
    type: :likert,
    title: 'Ik laat het direct merken als ik iets stom vind.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v82,
    type: :likert,
    title: 'Ik voel me slecht op mijn gemak in een onbekende groep.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v83,
    type: :likert,
    title: 'Zelfs onder spanning slaap ik goed.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v84,
    type: :likert,
    title: 'Ik verzwijg dat ik iets kapot heb gemaakt als het geheim kan blijven.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v85,
    type: :likert,
    title: 'Mijn werk is vaak origineel.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v86,
    type: :likert,
    title: 'Ik herlees wat ik schrijf om te zorgen dat het foutloos is.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v87,
    type: :likert,
    title: 'Ik ben het snel met anderen eens.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v88,
    type: :likert,
    title: 'Ik praat graag met anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v89,
    type: :likert,
    title: 'Ik kan prima in mijn eentje moeilijkheden overwinnen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v90,
    type: :likert,
    title: 'Ik wil graag beroemd zijn.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v91,
    type: :likert,
    title: 'Mensen zijn verrast door mijn opvattingen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v92,
    type: :likert,
    title: 'Ik doe vaak dingen zonder echt na te denken.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v93,
    type: :likert,
    title: 'Mensen hebben mij wel eens woedend gezien.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v94,
    type: :likert,
    title: 'Ik ben zelden opgewekt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v95,
    type: :likert,
    title: 'Ik moet huilen bij trieste of romantische films.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v96,
    type: :likert,
    title: 'Ik heb recht op een speciale behandeling.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v97,
    type: :likert,
    title: 'Ik zou mij erg naar voelen als ik iemand pijn zou doen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v98,
    type: :likert,
    title: 'Ik heb uitgewerkte plannen om dingen te verbeteren.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v99,
    type: :likert,
    title: 'Ik leef mee met mensen die minder geluk hebben dan ik.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v100,
    type: :likert,
    title: 'Ik ga mogelijkheden om mijn omgeving te veranderen uit de weg.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v101,
    type: :likert,
    title: 'Het idee dat alleen de sterksten zullen overleven trekt mij aan.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v102,
    type: :likert,
    title: 'Wanneer er een probleem is, pak ik het meteen aan.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v103,
    type: :likert,
    title: 'Mensen vinden mij hardvochtig.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v104,
    type: :likert,
    title: 'Ik organiseer in detail allerlei veranderingen die ik wil doorvoeren.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }
]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
