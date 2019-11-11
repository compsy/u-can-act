# frozen_string_literal: true

db_title = 'Omgaan met gevoelens (zelf)'

db_name1 = 'Emotieregulatie_Ouders_Zelfrapportage'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
likert_options = ['Bijna nooit', 'Zelden', 'Af en toe', 'Vaak', 'Bijna altijd']
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom bij de vragenlijst! Alle mensen kennen gevoelens van boosheid, angst en verdriet. Toch gaat iedereen verschillend om met deze emoties. Wat doet of denkt u als u boos, bang of verdrietig bent? <br> <br> Er volgen nu verschillende uitspraken over hoe mensen reageren op boosheid, angst en verdriet. Geef bij elke uitspraak aan wat u doet of denkt als u deze emoties ervaart. Plaats het bolletje naar het antwoord dat het best beschrijft hoe u zou reageren. <br> <br> Als u het gevoel heeft dat een vraag niet helemaal op u van toepassing is, geef dan toch het best passende antwoord. </p>'
  }, {
    section_start: 'Wanneer ik boos ben…',
    id: :v1a,
    type: :likert,
    title: 'Probeer ik dat wat me boos maakt te veranderen.',
    options: likert_options,
    section_end: false
  }, {
    id: :v2a,
    type: :likert,
    title: 'Maak ik er het beste van.',
    options: likert_options
  }, {
    id: :v3a,
    type: :likert,
    title: 'Wil ik niemand zien.',
    options: likert_options
  }, {
    id: :v4a,
    type: :likert,
    title: 'Denk ik dat het mijn eigen probleem is.',
    options: likert_options
  }, {
    id: :v5a,
    type: :likert,
    title: 'Wil ik niets meer doen.',
    options: likert_options
  }, {
    id: :v6a,
    type: :likert,
    title: 'Vraag ik me altijd af waarom ik boos ben.',
    options: likert_options
  }, {
    id: :v7a,
    type: :likert,
    title: 'Denk ik erover na wat ik zou kunnen doen.',
    options: likert_options
  }, {
    id: :v8a,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het probleem niet zo erg is.',
    options: likert_options
  }, {
    id: :v9a,
    type: :likert,
    title: 'Denk ik aan dingen die me gelukkig maken.',
    options: likert_options
  }, {
    id: :v10a,
    type: :likert,
    title: 'Probeer ik te vergeten wat me boos maakt.',
    options: likert_options
  }, {
    id: :v11a,
    type: :likert,
    title: 'Zoek ik de fout bij mezelf.',
    options: likert_options
  }, {
    id: :v12a,
    type: :likert,
    title: 'Denk ik dat wat ik meegemaakt heb, erger is dan wat andere mensen meemaken.',
    options: likert_options
  }, {
    id: :v13a,
    type: :likert,
    title: 'Probeer ik er zelf het beste van te maken.',
    options: likert_options
  }, {
    id: :v14a,
    type: :likert,
    title: 'Denk ik dat het wel voorbij zal gaan.',
    options: likert_options
  }, {
    id: :v15a,
    type: :likert,
    title: 'Denk ik dat anderen verantwoordelijk zijn voor wat er is gebeurd.',
    options: likert_options
  }, {
    id: :v16a,
    type: :likert,
    title: 'Accepteer ik wat me boos maakt.',
    options: likert_options
  }, {
    id: :v17a,
    type: :likert,
    title: 'Krijg ik het maar niet uit mijn hoofd.',
    options: likert_options
  }, {
    id: :v18a,
    type: :likert,
    title: 'Trek ik me terug.',
    options: likert_options
  }, {
    id: :v19a,
    type: :likert,
    title: 'Doe ik iets dat me blij maakt.',
    options: likert_options
  }, {
    id: :v20a,
    type: :likert,
    title: 'Denk ik na over hoe ik het probleem zou kunnen oplossen.',
    options: likert_options
  }, {
    id: :v21a,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het niets belangrijks is.',
    options: likert_options
  }, {
    id: :v22a,
    type: :likert,
    title: 'Denk ik dat het probleem voornamelijk bij de ander ligt.',
    options: likert_options
  }, {
    id: :v23a,
    type: :likert,
    title: 'Kan ik sowieso niets tegen mijn boosheid doen.',
    options: likert_options
  }, {
    id: :v24a,
    type: :likert,
    title: 'Denk ik dat wat ik heb meegemaakt het ergste is dat iemand kan overkomen.',
    options: likert_options,
    section_end: true
  }, {
    section_start: 'Wanneer ik bang ben…',
    id: :v1b,
    type: :likert,
    title: 'Probeer ik dat wat me bang maakt te veranderen.',
    options: likert_options,
    section_end: false
  }, {
    id: :v2b,
    type: :likert,
    title: 'Maak ik er het beste van.',
    options: likert_options
  }, {
    id: :v3b,
    type: :likert,
    title: 'Wil ik niemand zien.',
    options: likert_options
  }, {
    id: :v4b,
    type: :likert,
    title: 'Denk ik dat het mijn eigen probleem is.',
    options: likert_options
  }, {
    id: :v5b,
    type: :likert,
    title: 'Wil ik niets meer doen.',
    options: likert_options
  }, {
    id: :v6b,
    type: :likert,
    title: 'Vraag ik me altijd af waarom ik bang ben.',
    options: likert_options
  }, {
    id: :v7b,
    type: :likert,
    title: 'Denk ik erover na wat ik zou kunnen doen.',
    options: likert_options
  }, {
    id: :v8b,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het probleem niet zo erg is.',
    options: likert_options
  }, {
    id: :v9b,
    type: :likert,
    title: 'Denk ik aan dingen die me gelukkig maken.',
    options: likert_options
  }, {
    id: :v10b,
    type: :likert,
    title: 'Probeer ik te vergeten wat me bang maakt.',
    options: likert_options
  }, {
    id: :v11b,
    type: :likert,
    title: 'Zoek ik de fout bij mezelf.',
    options: likert_options
  }, {
    id: :v12b,
    type: :likert,
    title: 'Denk ik dat wat ik meegemaakt heb, erger is dan wat andere mensen meemaken.',
    options: likert_options
  }, {
    id: :v13b,
    type: :likert,
    title: 'Probeer ik er zelf het beste van te maken.',
    options: likert_options
  }, {
    id: :v14b,
    type: :likert,
    title: 'Denk ik dat het wel voorbij zal gaan.',
    options: likert_options
  }, {
    id: :v15b,
    type: :likert,
    title: 'Denk ik dat anderen verantwoordelijk zijn voor wat er is gebeurd.',
    options: likert_options
  }, {
    id: :v16b,
    type: :likert,
    title: 'Accepteer ik wat me bang maakt.',
    options: likert_options
  }, {
    id: :v17b,
    type: :likert,
    title: 'Krijg ik het maar niet uit mijn hoofd.',
    options: likert_options
  }, {
    id: :v18b,
    type: :likert,
    title: 'Trek ik me terug.',
    options: likert_options
  }, {
    id: :v19b,
    type: :likert,
    title: 'Doe ik iets dat me blij maakt.',
    options: likert_options
  }, {
    id: :v20b,
    type: :likert,
    title: 'Denk ik na over hoe ik het probleem zou kunnen oplossen.',
    options: likert_options
  }, {
    id: :v21b,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het niets belangrijks is.',
    options: likert_options
  }, {
    id: :v22b,
    type: :likert,
    title: 'Denk ik dat het probleem voornamelijk bij de ander ligt.',
    options: likert_options
  }, {
    id: :v23b,
    type: :likert,
    title: 'Kan ik sowieso niets tegen mijn angst doen.',
    options: likert_options
  }, {
    id: :v24b,
    type: :likert,
    title: 'Denk ik dat wat ik heb meegemaakt het ergste is dat iemand kan overkomen.',
    options: likert_options,
    section_end: true
  }, {
    section_start: 'Wanneer ik verdrietig ben…',
    id: :v1c,
    type: :likert,
    title: 'Probeer ik dat wat me verdrietig maakt te veranderen.',
    options: likert_options,
    section_end: false
  }, {
    id: :v2c,
    type: :likert,
    title: 'Maak ik er het beste van.',
    options: likert_options
  }, {
    id: :v3c,
    type: :likert,
    title: 'Wil ik niemand zien.',
    options: likert_options
  }, {
    id: :v4c,
    type: :likert,
    title: 'Denk ik dat het mijn eigen probleem is.',
    options: likert_options
  }, {
    id: :v5c,
    type: :likert,
    title: 'Wil ik niets meer doen.',
    options: likert_options
  }, {
    id: :v6c,
    type: :likert,
    title: 'Vraag ik me altijd af waarom ik verdrietig ben.',
    options: likert_options
  }, {
    id: :v7c,
    type: :likert,
    title: 'Denk ik erover na wat ik zou kunnen doen.',
    options: likert_options
  }, {
    id: :v8c,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het probleem niet zo erg is.',
    options: likert_options
  }, {
    id: :v9c,
    type: :likert,
    title: 'Denk ik aan dingen die me gelukkig maken.',
    options: likert_options
  }, {
    id: :v10c,
    type: :likert,
    title: 'Probeer ik te vergeten wat me verdrietig maakt.',
    options: likert_options
  }, {
    id: :v11c,
    type: :likert,
    title: 'Zoek ik de fout bij mezelf.',
    options: likert_options
  }, {
    id: :v12c,
    type: :likert,
    title: 'Denk ik dat wat ik meegemaakt heb, erger is dan wat andere mensen meemaken.',
    options: likert_options
  }, {
    id: :v13c,
    type: :likert,
    title: 'Probeer ik er zelf het beste van te maken.',
    options: likert_options
  }, {
    id: :v14c,
    type: :likert,
    title: 'Denk ik dat het wel voorbij zal gaan.',
    options: likert_options
  }, {
    id: :v15c,
    type: :likert,
    title: 'Denk ik dat anderen verantwoordelijk zijn voor wat er is gebeurd.',
    options: likert_options
  }, {
    id: :v16c,
    type: :likert,
    title: 'Accepteer ik wat me verdrietig maakt.',
    options: likert_options
  }, {
    id: :v17c,
    type: :likert,
    title: 'Krijg ik het maar niet uit mijn hoofd.',
    options: likert_options
  }, {
    id: :v18c,
    type: :likert,
    title: 'Trek ik me terug.',
    options: likert_options
  }, {
    id: :v19c,
    type: :likert,
    title: 'Doe ik iets dat me blij maakt.',
    options: likert_options
  }, {
    id: :v20c,
    type: :likert,
    title: 'Denk ik na over hoe ik het probleem zou kunnen oplossen.',
    options: likert_options
  }, {
    id: :v21c,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het niets belangrijks is.',
    options: likert_options
  }, {
    id: :v22c,
    type: :likert,
    title: 'Denk ik dat het probleem voornamelijk bij de ander ligt.',
    options: likert_options
  }, {
    id: :v23c,
    type: :likert,
    title: 'Kan ik sowieso niets tegen mijn verdriet doen.',
    options: likert_options
  }, {
    id: :v24c,
    type: :likert,
    title: 'Denk ik dat wat ik heb meegemaakt het ergste is dat iemand kan overkomen.',
    options: likert_options,
    section_end: true
  }
]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
