# frozen_string_literal: true

db_title = 'Omgaan met gevoelens'
db_name1 = 'Emotieregulatie_kinderen'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
likert_options = [
  { title: 'Bijna nooit', numeric_value: 0 },
  { title: 'Zelden', numeric_value: 25 },
  { title: 'Af en toe', numeric_value: 50 },
  { title: 'Vaak', numeric_value: 75 },
  { title: 'Bijna altijd', numeric_value: 100 }
]
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> Deze vragenlijst gaat over wat je doet en denkt wanneer je boos, bang of verdrietig bent. Er zijn in totaal 90 vragen. Het invullen duurt ongeveer 15 minuten. Ook al heb je misschien het gevoel dat een vraag niet helemaal op jou van toepassing is, geef dan toch het best passende antwoord.</p>'
  }, {
    section_start: 'Wat doe jij als je boos bent? Kies bij elke zin het antwoord dat het beste bij je past: <br><br> <b>Wanneer ik boos ben…</b>',
    id: :v1a,
    type: :likert,
    title: 'Probeer ik dat wat me boos maakt te veranderen.',
    options: likert_options,
    section_end: false
  }, {
    id: :v2a,
    type: :likert,
    title: 'Vertel ik aan iemand hoe het met me gaat.',
    options: likert_options
  }, {
    id: :v3a,
    type: :likert,
    title: 'Denk ik aan dingen die me gelukkig maken.',
    options: likert_options
  }, {
    id: :v4a,
    type: :likert,
    title: 'Doe ik iets wat ik leuk vind.',
    options: likert_options
  }, {
    id: :v5a,
    type: :likert,
    title: 'Houd ik mijn gevoelens voor mezelf.',
    options: likert_options
  }, {
    id: :v6a,
    type: :likert,
    title: 'Maak ik er het beste van.',
    options: likert_options
  }, {
    id: :v7a,
    type: :likert,
    title: 'Wil ik niemand zien.',
    options: likert_options
  }, {
    id: :v8a,
    type: :likert,
    title: 'Denk ik dat het mijn eigen probleem is.',
    options: likert_options
  }, {
    id: :v9a,
    type: :likert,
    title: 'Wil ik niets meer doen.',
    options: likert_options
  }, {
    id: :v10a,
    type: :likert,
    title: 'Vraag ik me altijd af waarom ik boos ben.',
    options: likert_options
  }, {
    id: :v11a,
    type: :likert,
    title: 'Denk ik erover na wat ik zou kunnen doen.',
    options: likert_options
  }, {
    id: :v12a,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het probleem niet zo erg is.',
    options: likert_options
  }, {
    id: :v13a,
    type: :likert,
    title: 'Maak ik ruzie met andere mensen.',
    options: likert_options
  }, {
    id: :v14a,
    type: :likert,
    title: 'Uit ik mijn boosheid.',
    options: likert_options
  }, {
    id: :v15a,
    type: :likert,
    title: 'Probeer ik te vergeten wat me boos maakt.',
    options: likert_options
  }, {
    id: :v16a,
    type: :likert,
    title: 'Zoek ik de fout bij mezelf.',
    options: likert_options
  }, {
    id: :v17a,
    type: :likert,
    title: 'Denk ik terug aan vrolijke dingen.',
    options: likert_options
  }, {
    id: :v18a,
    type: :likert,
    title: 'Probeer ik er zelf het beste van te maken.',
    options: likert_options
  }, {
    id: :v19a,
    type: :likert,
    title: 'Ga ik naar iemand die me misschien kan helpen.',
    options: likert_options
  }, {
    id: :v20a,
    type: :likert,
    title: 'Denk ik dat het wel voorbij zal gaan.',
    options: likert_options
  }, {
    id: :v21a,
    type: :likert,
    title: 'Accepteer ik wat me boos maakt.',
    options: likert_options
  }, {
    id: :v22a,
    type: :likert,
    title: 'Laat ik openlijk zien dat ik boos ben.',
    options: likert_options
  }, {
    id: :v23a,
    type: :likert,
    title: 'Reageer ik mijn gevoelens af op anderen.',
    options: likert_options
  }, {
    id: :v24a,
    type: :likert,
    title: 'Krijg ik het maar niet uit mijn hoofd.',
    options: likert_options
  }, {
    id: :v25a,
    type: :likert,
    title: 'Trek ik me terug.',
    options: likert_options
  }, {
    id: :v26a,
    type: :likert,
    title: 'Laat ik niet merken dat ik boos ben.',
    options: likert_options
  }, {
    id: :v27a,
    type: :likert,
    title: 'Doe ik iets leuks.',
    options: likert_options
  }, {
    id: :v28a,
    type: :likert,
    title: 'Denk ik na over hoe ik het probleem zou kunnen oplossen.',
    options: likert_options
  }, {
    id: :v29a,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het niets belangrijks is.',
    options: likert_options
  }, {
    id: :v30a,
    type: :likert,
    title: 'Kan ik sowieso niets tegen mijn boosheid doen.',
    options: likert_options,
    section_end: true
  }, {
    section_start: 'Wat doe jij als je bang bent? Kies bij elke zin het antwoord dat het beste bij je past: <br><br>
<b>Wanneer ik bang ben…</b>',
    id: :v1b,
    type: :likert,
    title: 'Probeer ik dat wat me bang maakt te veranderen.',
    options: likert_options,
    section_end: false
  }, {
    id: :v2b,
    type: :likert,
    title: 'Vertel ik aan iemand hoe het met me gaat.',
    options: likert_options
  }, {
    id: :v3b,
    type: :likert,
    title: 'Denk ik aan dingen die me gelukkig maken.',
    options: likert_options
  }, {
    id: :v4b,
    type: :likert,
    title: 'Doe ik iets wat ik leuk vind.',
    options: likert_options
  }, {
    id: :v5b,
    type: :likert,
    title: 'Houd ik mijn gevoelens voor mezelf.',
    options: likert_options
  }, {
    id: :v6b,
    type: :likert,
    title: 'Maak ik er het beste van.',
    options: likert_options
  }, {
    id: :v7b,
    type: :likert,
    title: 'Wil ik niemand zien.',
    options: likert_options
  }, {
    id: :v8b,
    type: :likert,
    title: 'Denk ik dat het mijn eigen probleem is.',
    options: likert_options
  }, {
    id: :v9b,
    type: :likert,
    title: 'Wil ik niets meer doen.',
    options: likert_options
  }, {
    id: :v10b,
    type: :likert,
    title: 'Vraag ik me altijd af waarom ik bang ben.',
    options: likert_options
  }, {
    id: :v11b,
    type: :likert,
    title: 'Denk ik erover na wat ik zou kunnen doen.',
    options: likert_options
  }, {
    id: :v12b,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het probleem niet zo erg is.',
    options: likert_options
  }, {
    id: :v13b,
    type: :likert,
    title: 'Maak ik ruzie met andere mensen.',
    options: likert_options
  }, {
    id: :v14b,
    type: :likert,
    title: 'Uit ik mijn angst.',
    options: likert_options
  }, {
    id: :v15b,
    type: :likert,
    title: 'Probeer ik te vergeten wat me bang maakt.',
    options: likert_options
  }, {
    id: :v16b,
    type: :likert,
    title: 'Zoek ik de fout bij mezelf.',
    options: likert_options
  }, {
    id: :v17b,
    type: :likert,
    title: 'Denk ik terug aan vrolijke dingen.',
    options: likert_options
  }, {
    id: :v18b,
    type: :likert,
    title: 'Probeer ik er zelf het beste van te maken.',
    options: likert_options
  }, {
    id: :v19b,
    type: :likert,
    title: 'Ga ik naar iemand die me misschien kan helpen.',
    options: likert_options
  }, {
    id: :v20b,
    type: :likert,
    title: 'Denk ik dat het wel voorbij zal gaan.',
    options: likert_options
  }, {
    id: :v21b,
    type: :likert,
    title: 'Accepteer ik wat me bang maakt.',
    options: likert_options
  }, {
    id: :v22b,
    type: :likert,
    title: 'Laat ik openlijk zien dat ik bang ben.',
    options: likert_options
  }, {
    id: :v23b,
    type: :likert,
    title: 'Reageer ik mijn gevoelens af op anderen.',
    options: likert_options
  }, {
    id: :v24b,
    type: :likert,
    title: 'Krijg ik het maar niet uit mijn hoofd.',
    options: likert_options
  }, {
    id: :v25b,
    type: :likert,
    title: 'Trek ik me terug.',
    options: likert_options
  }, {
    id: :v26b,
    type: :likert,
    title: 'Laat ik niet merken dat ik bang ben.',
    options: likert_options
  }, {
    id: :v27b,
    type: :likert,
    title: 'Doe ik iets leuks.',
    options: likert_options
  }, {
    id: :v28b,
    type: :likert,
    title: 'Denk ik na hoe ik het probleem zou kunnen oplossen.',
    options: likert_options
  }, {
    id: :v29b,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het niets belangrijks is.',
    options: likert_options
  }, {
    id: :v30b,
    type: :likert,
    title: 'Kan ik sowieso niets tegen mijn angst doen.',
    options: likert_options,
    section_end: true
  }, {
    section_start: 'Wat doe jij als je verdrietig bent? Kies bij elke zin het antwoord dat het beste bij je past: <br><br>
<b>Wanneer ik verdrietig ben…</b>',
    id: :v1c,
    type: :likert,
    title: 'Probeer ik dat wat me verdrietig maakt te veranderen.',
    options: likert_options,
    section_end: false
  }, {
    id: :v2c,
    type: :likert,
    title: 'Vertel ik aan iemand hoe het met me gaat.',
    options: likert_options
  }, {
    id: :v3c,
    type: :likert,
    title: 'Denk ik aan dingen die me gelukkig maken.',
    options: likert_options
  }, {
    id: :v4c,
    type: :likert,
    title: 'Doe ik iets wat ik leuk vind.',
    options: likert_options
  }, {
    id: :v5c,
    type: :likert,
    title: 'Houd ik mijn gevoelens voor mezelf.',
    options: likert_options
  }, {
    id: :v6c,
    type: :likert,
    title: 'Maak ik er het beste van.',
    options: likert_options
  }, {
    id: :v7c,
    type: :likert,
    title: 'Wil ik niemand zien.',
    options: likert_options
  }, {
    id: :v8c,
    type: :likert,
    title: 'Denk ik dat het mijn eigen probleem is.',
    options: likert_options
  }, {
    id: :v9c,
    type: :likert,
    title: 'Wil ik niets meer doen.',
    options: likert_options
  }, {
    id: :v10c,
    type: :likert,
    title: 'Vraag ik me altijd af waarom ik verdietig ben.',
    options: likert_options
  }, {
    id: :v11c,
    type: :likert,
    title: 'Denk ik erover na wat ik zou kunnen doen.',
    options: likert_options
  }, {
    id: :v12c,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het probleem niet zo erg is.',
    options: likert_options
  }, {
    id: :v13c,
    type: :likert,
    title: 'Maak ik ruzie met andere mensen.',
    options: likert_options
  }, {
    id: :v14c,
    type: :likert,
    title: 'Uit ik mijn verdriet.',
    options: likert_options
  }, {
    id: :v15c,
    type: :likert,
    title: 'Probeer ik te vergeten wat me verdrietig maakt.',
    options: likert_options
  }, {
    id: :v16c,
    type: :likert,
    title: 'Zoek ik de fout bij mezelf.',
    options: likert_options
  }, {
    id: :v17c,
    type: :likert,
    title: 'Denk ik terug aan vrolijke dingen.',
    options: likert_options
  }, {
    id: :v18c,
    type: :likert,
    title: 'Probeer ik er zelf het beste van te maken.',
    options: likert_options
  }, {
    id: :v19c,
    type: :likert,
    title: 'Ga ik naar iemand die me misschien kan helpen.',
    options: likert_options
  }, {
    id: :v20c,
    type: :likert,
    title: 'Denk ik dat het wel voorbij zal gaan.',
    options: likert_options
  }, {
    id: :v21c,
    type: :likert,
    title: 'Accepteer ik wat me verdrietig maakt.',
    options: likert_options
  }, {
    id: :v22c,
    type: :likert,
    title: 'Laat ik openlijk zien dat ik verdrietig ben.',
    options: likert_options
  }, {
    id: :v23c,
    type: :likert,
    title: 'Reageer ik mijn gevoelens af op anderen.',
    options: likert_options
  }, {
    id: :v24c,
    type: :likert,
    title: 'Krijg ik het maar niet uit mijn hoofd.',
    options: likert_options
  }, {
    id: :v25c,
    type: :likert,
    title: 'Trek ik me terug.',
    options: likert_options
  }, {
    id: :v26c,
    type: :likert,
    title: 'Laat ik niet merken dat ik verdrietig ben.',
    options: likert_options
  }, {
    id: :v27c,
    type: :likert,
    title: 'Doe ik iets leuks.',
    options: likert_options
  }, {
    id: :v28c,
    type: :likert,
    title: 'Denk ik na hoe ik het probleem zou kunnen oplossen.',
    options: likert_options
  }, {
    id: :v29c,
    type: :likert,
    title: 'Zeg ik tegen mezelf dat het niets belangrijks is.',
    options: likert_options
  }, {
    id: :v30c,
    type: :likert,
    title: 'Kan ik sowieso niets tegen mijn verdriet doen.',
    options: likert_options,
    section_end: true
  }
]
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Afleiding zoeken',
      ids: %i[v4a v27a v4b v27b v4c v27c],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Jezelf opvrolijken',
      ids: %i[v3a v17a v3b v17b v3c v17c],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Piekeren',
      ids: %i[v10a v24a v10b v24b v10c v24c],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s4,
      label: 'Terugtrekken',
      ids: %i[v7a v25a v7b v25b v7c v25c],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s5,
      label: 'Om hulp vragen',
      ids: %i[v2a v19a v2b v19b v2c v19c],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
