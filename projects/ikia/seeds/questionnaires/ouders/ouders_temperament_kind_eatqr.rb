# frozen_string_literal: true

db_title = 'EATQ-R ouder kind'

db_name1 = 'EATQ-R_ouder_kind'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Op de volgende bladzijden staan 62 uitspraken die u kunt gebruiken om uw kind te beschrijven. <br>
<br>
We willen graag dat u voor elke uitspraak invult in hoeverre deze waar is voor uw kind.
Lees iedere beschrijving goed en kies dan het antwoord dat het beste <u> bij uw kind </u> past. Er zijn geen goede of foute antwoorden. Wilt u het antwoord kiezen dat het eerst bij u opkomt? <br>
<br>
U kunt de slider naar links of naar rechts verschuiven. <br>
Wilt u bij elke beschrijving aangeven hoe waar elke uitspraak is voor uw kind?</p>'
  }, {
    id: :v1,
    type: :range,
    title: 'Mijn kind maakt zich zorgen dat hij/zij in moeilijkheden zal raken.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v2,
    type: :range,
    title: 'Als mijn kind kwaad is op iemand, zegt hij/zij dingen waarvan hij/zij weet dat ze diegene pijn doen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v3,
    type: :range,
    title: 'Het kost mijn kind veel moeite om dingen op tijd af te krijgen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v4,
    type: :range,
    title: 'Mijn kind zou het spannend en leuk vinden om naar Afrika of India te reizen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v5,
    type: :range,
    title: 'Als mijn kind een probleem met iemand heeft, probeert hij/zij dat meteen op te lossen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v6,
    type: :range,
    title: 'Als mijn kind opgewonden is, vindt hij/zij het moeilijk om op zijn/haar beurt te wachten met iets te zeggen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v7,
    type: :range,
    title: 'Mijn kind lijkt minder plezier aan dingen te beleven dan zijn/haar vrienden of vriendinnen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v8,
    type: :range,
    title: 'Mijn kind pakt een cadeautje eerder uit dan de bedoeling is.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v9,
    type: :range,
    title: 'Mijn kind zou angstig zijn bij de gedachte om snel van een steile berghelling naar beneden te skiën.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v10,
    type: :range,
    title: 'Mijn kind heeft dagen dat het huilen hem/haar nader staat dan het lachen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v11,
    type: :range,
    title: 'Als mijn kind erg kwaad wordt, zou hij/zij iemand kunnen slaan.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v12,
    type: :range,
    title: 'Mijn kind zorgt graag voor anderen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v13,
    type: :range,
    title: 'Mijn kind vindt het fijn om met iemand anders te kunnen praten over alles wat hij/zij denkt.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v14,
    type: :range,
    title: 'Mijn kind doet eerst een tijdje iets leuks voordat hij/zij aan klusjes of schoolwerk begint, zelfs als niet de bedoeling is.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v15,
    type: :range,
    title: 'Mijn kind vindt het makkelijk om zich goed op een taak te concentreren.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v16,
    type: :range,
    title: 'Mijn kind zou het spannend vinden om naar een nieuwe woonplaats te verhuizen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v17,
    type: :range,
    title: 'Als mijn kind gevraagd wordt om iets te doen, doet hij/zij dat meteen, zelfs als hij/zij er weinig zin in heeft.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v18,
    type: :range,
    title: 'Mijn kind zou graag elke dag een tijdje met een goede vriend of vriendin door brengen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v19,
    type: :range,
    title: 'Mijn kind heeft de neiging onbeleefd te zijn tegen mensen die hij/zij niet aardig vindt.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v20,
    type: :range,
    title: 'Mijn kind ergert zich aan kleine dingen die andere kinderen doen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v21,
    type: :range,
    title: 'Mijn kind raakt erg geïrriteerd als iemand kritiek op hem/haar heeft.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v22,
    type: :range,
    title: 'Als mijn kind afgeleid of gestoord wordt, is hij/zij vergeten wat hij/zij wilde zeggen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v23,
    type: :range,
    title: 'Hoe meer mijn kind zijn/haar best doet om geen verkeerde dingen te doen, hoe groter de kans dat hij/zij die dingen toch doet.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v24,
    type: :range,
    title: 'Mijn kind vindt het fijn om mensen die hij/zij aardig vindt te knuffelen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v25,
    type: :range,
    title: 'Mijn kind heeft de neiging om anderen de schuld te geven van zijn/haar eigen fouten.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v26,
    type: :range,
    title: 'Mijn kind is vaker verdrietig dan andere mensen zich realiseren.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v27,
    type: :range,
    title: 'Mijn kind weet wel iets te zeggen in gezelschap, ook bij onbekenden.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v28,
    type: :range,
    title: 'Mijn kind zou best een gevaarlijke sport durven proberen, zoals diepzeeduiken.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v29,
    type: :range,
    title: 'Als mijn kind over exotische plekken in de wereld hoort, zegt hij/zij daar ook graag naar toe te willen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v30,
    type: :range,
    title: 'Mijn kind maakt zich zorgen over ons gezin als hij/zij niet bij ons is.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v31,
    type: :range,
    title: 'Mijn kind raakt geïrriteerd als ik hem/haar niet meeneem naar waar hij/zij naar toe wil.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v32,
    type: :range,
    title: 'Mijn kind slaat met de deur als hij/zij boos is.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v33,
    type: :range,
    title: 'Mijn kind is zelden of nooit verdrietig, zelfs niet als er veel dingen tegenzitten.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v34,
    type: :range,
    title: 'Mijn kind zou het leuk vinden om in een racewagen te rijden.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v35,
    type: :range,
    title: 'Mijn kind vindt het moeilijk om achtergrondgeluiden te negeren als hij/zij iets doet wat concentratie vereist.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v36,
    type: :range,
    title: 'Mijn kind heeft een opdracht voor school eerder af dan nodig is.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v37,
    type: :range,
    title: 'Mijn kind vindt het leuk als er iets spannends of iets nieuws op school gebeurt.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v38,
    type: :range,
    title: 'Als mijn kind een moeilijke taak moet doen begint hij/zij er meestal gelijk aan.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v39,
    type: :range,
    title: 'Mijn kind kan goed verschillende dingen die om hem/haar heen gebeuren in de gaten houden.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v40,
    type: :range,
    title: 'Mijn kind leeft helemaal op als hij/zij zich tussen een grote hoeveelheid mensen bevindt.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v41,
    type: :range,
    title: 'Mijn kind maakt grappen over hoe andere mensen eruit zien.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v42,
    type: :range,
    title: 'Mijn kind uit zich zelden negatief over andere mensen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v43,
    type: :range,
    title: 'Mijn kind vindt het belangrijk om een goede band met anderen te hebben.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v44,
    type: :range,
    title: 'Mijn kind is verlegen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v45,
    type: :range,
    title: 'Mijn kind raakt geïrriteerd als hij/zij moet stoppen met iets wat hij/zij leuk vindt.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v46,
    type: :range,
    title: 'Mijn kind stelt dingen die hij/zij moet doen meestal uit tot het laatste moment.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v47,
    type: :range,
    title: 'Mijn kind kan zijn/haar lachen inhouden op momenten dat lachen ongepast is.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v48,
    type: :range,
    title: 'Mijn kind wordt bang van de gedachte dat ik dood ga of dat ik hem/haar verlaat.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v49,
    type: :range,
    title: 'Mijn kind gaat al iets anders doen voordat datgene waar hij/zij mee bezig is af is.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v50,
    type: :range,
    title: 'Mijn kind is niet verlegen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v51,
    type: :range,
    title: 'Mijn kind is een hartelijk en vriendelijk persoon.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v52,
    type: :range,
    title: 'Mijn kind lijkt soms verdrietig wanneer hij/zij juist plezier zou moeten hebben, zoals met kerst of tijdens een uitje.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v53,
    type: :range,
    title: 'Mijn kind heeft een hekel aan balspelen (bijvoorbeeld handbal of basketbal) omdat hij/zij bang is voor de bal.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v54,
    type: :range,
    title: 'Mijn kind vindt het leuk om nieuwe mensen te ontmoeten.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v55,
    type: :range,
    title: 'Mijn kind voelt zich bang als hij/zij ‘s avonds een donkere kamer in gaat.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v56,
    type: :range,
    title: 'Mijn kind zou de enge attracties op de kermis overslaan.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v57,
    type: :range,
    title: 'Mijn kind haat het als anderen het niet met hem/haar eens zijn.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v58,
    type: :range,
    title: 'Mijn kind raakt erg gefrustreerd als hij/zij een fout maakt in zijn/haar schoolwerk.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v59,
    type: :range,
    title: 'Als mijn kind een plan heeft lukt het hem/haar meestal wel om vol te houden tot hij/zij het doel heeft bereikt.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v60,
    type: :range,
    title: 'Mijn kind let goed op als iemand uitlegt hoe hij/zij iets moet doen.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v61,
    type: :range,
    title: 'Mijn kind vindt het eng om alleen thuis te zijn.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }, {
    id: :v62,
    type: :range,
    title: 'Mijn kind is verlegen als hij/zij nieuwe mensen ontmoet.',
    labels: ['Bijna nooit waar', 'Soms waar, soms niet waar', 'Bijna altijd waar']
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
