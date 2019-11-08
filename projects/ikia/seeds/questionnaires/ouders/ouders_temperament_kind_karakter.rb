# frozen_string_literal: true

db_title = 'Karakter van uw kind'

db_name1 = 'Persoonlijkheid_Kinderen_10plus_Ouderrapportage'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> De volgende vragenlijst gaat over het karakter van uw kind. Er volgen nu 104 zinnen over eigenschappen van mensen. Geef bij elke zin aan in hoeverre u het hiermee eens. Doe dit voor elke zin, ook als u niet helemaal zeker bent van uw antwoord. Het invullen duurt ongeveer 20 minuten.'
  }, {
    section_start: 'Mijn kind…',
    id: :v1,
    type: :likert,
    title: '…kan lang naar een schilderij kijken.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens'],
    section_end: false
  }, {
    id: :v2,
    type: :likert,
    title: '…ruimt zijn/haar kleren netjes op.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v3,
    type: :likert,
    title: '…blijft onaardig tegen iemand die gemeen was.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v4,
    type: :likert,
    title: '…gelooft dat mensen hem/haar graag mogen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v5,
    type: :likert,
    title: '…vermijdt situaties waarin hij/zij gewond kan raken.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v6,
    type: :likert,
    title: '…doet zich soms beter voor dan hij/zij werkelijk is.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v7,
    type: :likert,
    title: '…leest graag over nieuwe ontdekkingen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v8,
    type: :likert,
    title: '…werkt harder dan anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v9,
    type: :likert,
    title: '…geeft vaak kritiek.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v10,
    type: :likert,
    title: '…houdt zich in een groep op de achtergrond.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v11,
    type: :likert,
    title: '…is bezorgd over onbelangrijke dingen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v12,
    type: :likert,
    title: '…verzwijgt het als hij/zij te weinig heeft betaald.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v13,
    type: :likert,
    title: '…heeft veel fantasie.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v14,
    type: :likert,
    title: '…kijkt zijn/haar werk zorgvuldig na.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v15,
    type: :likert,
    title: '…past zijn/haar mening aan die van anderen aan.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v16,
    type: :likert,
    title: '…werkt liever alleen dan met anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v17,
    type: :likert,
    title: '…kan persoonlijke problemen helemaal alleen aan.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v18,
    type: :likert,
    title: '…wil dat anderen hem/haar belangrijk vinden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v19,
    type: :likert,
    title: '…houdt van mensen met rare ideeën.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v20,
    type: :likert,
    title: '…denkt goed na voordat hij/zij iets onveiligs doet.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v21,
    type: :likert,
    title: '…reageert soms erg vel als iets tegenzit.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v22,
    type: :likert,
    title: '…heeft altijd zin in het leven.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v23,
    type: :likert,
    title: '…leeft heel erg mee met het verdriet van anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v24,
    type: :likert,
    title: '…vindt zichzelf een gewoon persoon; alles behalve bijzonder.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v25,
    type: :likert,
    title: '…vindt de meeste kunst dom.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v26,
    type: :likert,
    title: '…kan door zijn/haar eigen troep soms moeilijk iets vinden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v27,
    type: :likert,
    title: '…vertrouwt anderen weer snel nadat ze hem/haar bedrogen hebben.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v28,
    type: :likert,
    title: '…gelooft dat niemand hem/haar leuk vindt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v29,
    type: :likert,
    title: '…kan goed tegen lichamelijke pijn.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v30,
    type: :likert,
    title: '…vertelt weleens een leugentje om zijn/haar zin te krijgen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v31,
    type: :likert,
    title: '…vindt wetenschap saai.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v32,
    type: :likert,
    title: 'Als iets moeilijk is, geeft hij/zij het snel op.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens'],
    section_end: true
  }, {
    section_start: 'Mijn kind…',
    id: :v33,
    type: :likert,
    title: '…is zacht tegenover anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens'],
    section_end: false
  }, {
    id: :v34,
    type: :likert,
    title: '…legt gemakkelijk contact met vreemden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v35,
    type: :likert,
    title: '…is vaak ongerust dat er iets misgaat.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v36,
    type: :likert,
    title: '…is benieuwd hoe je op een oneerlijke manier veel geld kunt verdienen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v37,
    type: :likert,
    title: '…houdt ervan om nieuwe manieren te verzinnen om dingen te doen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v38,
    type: :likert,
    title: '…vindt het zonde van de tijd om zijn/haar werk op fouten na te kijken.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v39,
    type: :likert,
    title: '…geeft gemakkelijk anderen gelijk.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v40,
    type: :likert,
    title: '…is het liefst in zijn/haar eentje.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v41,
    type: :likert,
    title: '…heeft zelden steun van anderen nodig.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v42,
    type: :likert,
    title: '…wil graag kostbare spullen bezitten.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v43,
    type: :likert,
    title: '…zou het vervelend vinden als mensen hem/haar raar zouden vinden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v44,
    type: :likert,
    title: '…doet wat in hem/haar opkomt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v45,
    type: :likert,
    title: '…is zelden kwaad op iemand.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v46,
    type: :likert,
    title: '…is vaak somber.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v47,
    type: :likert,
    title: '…voelt soms tranen in hem/haar opkomen als hij/zij afscheid neemt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v48,
    type: :likert,
    title: '…vindt dat hij/zij de regels mag overtreden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v49,
    type: :likert,
    title: '…houdt van gedichten.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v50,
    type: :likert,
    title: 'Zijn/haar kamer is altijd opgeruimd.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v51,
    type: :likert,
    title: '…is lang op zijn/haar hoede bij mensen die hem/haar kwaad hebben gedaan.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v52,
    type: :likert,
    title: '…gelooft dat niemand graag met hem/haar wil praten.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v53,
    type: :likert,
    title: '…is bang om pijn te lijden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v54,
    type: :likert,
    title: '…is slecht in het "doen alsof".',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v55,
    type: :likert,
    title: '…verveelt zich bij natuurprogramma′s op de tv.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v56,
    type: :likert,
    title: '…stelt ingewikkelde taken zo lang mogelijk uit.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v57,
    type: :likert,
    title: '…reageert negatief als iemand fouten maakt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v58,
    type: :likert,
    title: '…is vaak de woordvoerder van een groep.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v59,
    type: :likert,
    title: '…maakt zich minder zorgen dan anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v60,
    type: :likert,
    title: '…gaat liever dood dan dat hij/zij iets steelt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v61,
    type: :likert,
    title: '…houdt er van om gekke dingen te maken.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v62,
    type: :likert,
    title: '…werkt erg nauwkeurig.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v63,
    type: :likert,
    title: 'Het is moeilijk zijn/haar ideeën te veranderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens'],
    section_end: true
  }, {
    section_start: 'Mijn kind…',
    id: :v64,
    type: :likert,
    title: '…gaat het liefst met veel mensen om.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens'],
    section_end: false
  }, {
    id: :v65,
    type: :likert,
    title: '…heeft anderen nodig om hem/haar te troosten.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v66,
    type: :likert,
    title: '…draagt liever oude vodden dan nieuwe kleren.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v67,
    type: :likert,
    title: 'Anderen vinden dat hij/zij vreemde ideeën heeft.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v68,
    type: :likert,
    title: '…kan zichzelf goed beheersen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v69,
    type: :likert,
    title: 'Zelfs als hij/zij slecht behandeld word, blijf hij/zij kalm.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v70,
    type: :likert,
    title: '…is over het algemeen vrolijk.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v71,
    type: :likert,
    title: '…wordt verdrietig als een hele goede vriend(in) lang weggaat.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v72,
    type: :likert,
    title: '…vindt dat hij/zij boven de wet staat.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v73,
    type: :likert,
    title: '…verbaast zich dat mensen geld willen besteden aan kunst.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v74,
    type: :likert,
    title: '…zorgt dat dingen altijd op de juiste plek liggen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v75,
    type: :likert,
    title: '…is goed van vertrouwen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v76,
    type: :likert,
    title: '…denkt dat veel mensen hem/haar onaardig vinden.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v77,
    type: :likert,
    title: '…durft meer dan anderen in gevaarlijke situaties.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v78,
    type: :likert,
    title: '…vindt het moeilijk om te liegen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v79,
    type: :likert,
    title: '…zou graag een boek over uitvindingen willen lezen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v80,
    type: :likert,
    title: '…luiert liever dan dat hij/zij hard werkt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v81,
    type: :likert,
    title: '…laat het direct merken als hij/zij iets stom vindt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v82,
    type: :likert,
    title: '…voelt zich slecht op zijn gemak in een onbekende groep.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v83,
    type: :likert,
    title: 'Zelfs onder spanning slaapt hij/zij goed.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v84,
    type: :likert,
    title: '…verzwijgt dat hij/zij iets kapot heeft gemaakt als het geheim kan blijven.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v85,
    type: :likert,
    title: 'Zijn/haar werk is vaak origineel.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens'],
    section_end: true
  }, {
    section_start: 'Mijn kind…',
    id: :v86,
    type: :likert,
    title: '…herleest wat hij/zij schrijft om te zorgen dat het foutloos is.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens'],
    section_end: false
  }, {
    id: :v87,
    type: :likert,
    title: '…is het snel met anderen eens.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v88,
    type: :likert,
    title: '…praat graag met anderen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v89,
    type: :likert,
    title: '…kan prima in zijn/haar eentje moeilijkheden overwinnen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v90,
    type: :likert,
    title: '…wil graag beroemd zijn.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v91,
    type: :likert,
    title: 'Mensen zijn verrast door zijn/haar opvattingen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v92,
    type: :likert,
    title: '…doet vaak dingen zonder echt na te denken.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v93,
    type: :likert,
    title: 'Mensen hebben hem/haar wel eens woedend gezien.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v94,
    type: :likert,
    title: '…is zelden opgewekt.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v95,
    type: :likert,
    title: '…moet huilen bij trieste of romantische films.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v96,
    type: :likert,
    title: '…vindt dat hij/zij recht heeft op een speciale behandeling.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v97,
    type: :likert,
    title: '…zou zich erg naar voelen als hij/zij iemand pijn zou doen.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v98,
    type: :likert,
    title: '…heeft uitgewerkte plannen om dingen te verbeteren.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v99,
    type: :likert,
    title: 'leeft mee met mensen die minder geluk hebben dan hem/haar.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v100,
    type: :likert,
    title: '…gaat mogelijkheden om zijn/haar omgeving te veranderen uit de weg.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v101,
    type: :likert,
    title: 'Het idee dat alleen de sterksten zullen overleven trekt hem/haar aan.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v102,
    type: :likert,
    title: 'Wanneer er een probleem is, pakt hij/zij het meteen aan.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v103,
    type: :likert,
    title: 'Mensen vinden hem/haar hardvochtig.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens']
  }, {
    id: :v104,
    type: :likert,
    title: '…organiseert in detail allerlei veranderingen die hij/zij wil doorvoeren.',
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens'],
    section_end: true
  }
]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
