# frozen_string_literal: true

db_title = 'Omgaan met gevoelens'

db_name1 = 'Emotieregulatie_Kinderen_Ouderrapportage_6plus'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
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
    content: '<p class="flow-text"> Deze vragenlijst gaat over hoe uw kind omgaat met vervelende gevoelens. Alle kinderen zijn wel eens boos, bang of verdrietig. Hoe gaat uw kind met zulke gevoelens om? <br> <br> U krijgt zo verschillende uitspraken te zien over hoe kinderen en jongeren op hun gevoelens reageren. Geef bij elke uitspraak aan wat uw kind doet of denkt als hij/zij boos, bang of verdrietig is. Er bestaan geen goede of foute antwoorden. Kies bij elke vraag gewoon het antwoord dat het best beschrijft hoe uw kind zou reageren. Er volgen in totaal 90 vragen. Hier bent u ongeveer X minuten mee bezig. </p>'
  }, {
    type: :raw,
    content: '<p class="flow-text"> Iedereen is wel eens boos. Uw kind kan boos zijn omdat hij/zij iets niet mag. Uw kind kan boos zijn op andere kinderen, omdat zij hem/haar uitschelden of plagen. Hij/zij kan ook boos zijn op zichzelf. Er kunnen verschillende redenen zijn waarom iemand boos is. In de zinnen hieronder staat wat mensen kunnen doen als zij boos zijn. Wat doet of denkt uw kind als hij/zij boos is? Kies bij elke zin het antwoord dat het beste past. </p>'
  }, {
    section_start: 'Wanneer mijn kind boos is…',
    id: :v1a,
    type: :likert,
    title: 'Probeert hij/zij te veranderen wat hem/haar boos maakt.',
    options: likert_options,
    section_end: false
  }, {
    id: :v2a,
    type: :likert,
    title: 'Vertelt hij/zij aan iemand hoe het met hem/haar gaat.',
    options: likert_options
  }, {
    id: :v3a,
    type: :likert,
    title: 'Denkt hij/zij aan dingen die hem/haar gelukkig maken.',
    options: likert_options
  }, {
    id: :v4a,
    type: :likert,
    title: 'Doet hij/zij iets dat hij/zij leuk vindt.',
    options: likert_options
  }, {
    id: :v5a,
    type: :likert,
    title: 'Houdt hij/zij deze gevoelens voor zichzelf.',
    options: likert_options
  }, {
    id: :v6a,
    type: :likert,
    title: 'Maakt hij/zij er het beste van.',
    options: likert_options
  }, {
    id: :v7a,
    type: :likert,
    title: 'Wilt hij/zij niemand zien.',
    options: likert_options
  }, {
    id: :v8a,
    type: :likert,
    title: 'Denkt hij/zij dat het zijn/haar eigen probleem is.',
    options: likert_options
  }, {
    id: :v9a,
    type: :likert,
    title: 'Wil hij/zij niets meer doen.',
    options: likert_options
  }, {
    id: :v10a,
    type: :likert,
    title: 'Vraagt hij/zij zich altijd af waarom hij/zij boos is. ',
    options: likert_options
  }, {
    id: :v11a,
    type: :likert,
    title: 'Denkt hij/zij erover na wat hij/zij zou kunnen doen.',
    options: likert_options
  }, {
    id: :v12a,
    type: :likert,
    title: 'Zegt hij/zij in zichzelf dat het probleem niet zo erg is.',
    options: likert_options
  }, {
    id: :v13a,
    type: :likert,
    title: 'Maakt hij/zij ruzie met andere mensen.',
    options: likert_options
  }, {
    id: :v14a,
    type: :likert,
    title: 'Uit hij/zij deze woede.',
    options: likert_options
  }, {
    id: :v15a,
    type: :likert,
    title: 'Probeert hij/zij te vergeten wat hem/haar boos maakt.',
    options: likert_options
  }, {
    id: :v16a,
    type: :likert,
    title: 'Zoekt hij/zij de fout bij zichzelf.',
    options: likert_options
  }, {
    id: :v17a,
    type: :likert,
    title: 'Denkt hij/zij zich terug aan vrolijke dingen.',
    options: likert_options
  }, {
    id: :v18a,
    type: :likert,
    title: 'Probeert hij/zij er zelf het beste van te maken.',
    options: likert_options
  }, {
    id: :v19a,
    type: :likert,
    title: 'Gaat hij/zij naar iemand die hem/haar misschien kan helpen.',
    options: likert_options
  }, {
    id: :v20a,
    type: :likert,
    title: 'Denkt hij/zij dat het wel voorbij zal gaan.',
    options: likert_options
  }, {
    id: :v21a,
    type: :likert,
    title: 'Accepteert hij/zij wat hem/haar boos maakt.',
    options: likert_options
  }, {
    id: :v22a,
    type: :likert,
    title: 'Laat hij/zij openlijk zien dat hij/zij boos is.',
    options: likert_options
  }, {
    id: :v23a,
    type: :likert,
    title: 'Reageert hij/zij deze gevoelens af op anderen.',
    options: likert_options
  }, {
    id: :v24a,
    type: :likert,
    title: 'Krijgt hij/zij het maar niet uit zijn/haar hoofd. ',
    options: likert_options
  }, {
    id: :v25a,
    type: :likert,
    title: 'Trekt hij/zij zich terug.',
    options: likert_options
  }, {
    id: :v26a,
    type: :likert,
    title: 'Laat hij/zij niet merken dat hij/zij boos is.',
    options: likert_options
  }, {
    id: :v27a,
    type: :likert,
    title: 'Doet hij/zij iets leuks.',
    options: likert_options
  }, {
    id: :v28a,
    type: :likert,
    title: 'Denkt hij/zij na over hoe hij/zij het probleem zou kunnen oplossen.',
    options: likert_options
  }, {
    id: :v29a,
    type: :likert,
    title: 'Zegt hij/zij tegen zichzelf dat het niets belangrijks is.',
    options: likert_options
  }, {
    id: :v30a,
    type: :likert,
    title: 'Kan hij/zij sowieso niets tegen zijn/haar boosheid doen.',
    options: likert_options,
    section_end: true
  }, {
    type: :raw,
    content: '<p class="flow-text">Iedereen is wel eens bang. Uw kind kan bang zijn wanneer hij/zij alleen is. Uw kind kan bang zijn wanneer hij/zij in bed ligt. Hij/zij kan bang zijn voor een dier of voor andere mensen.<br> <br>
Er kunnen verschillende redenen zijn waarom iemand bang is. In de zinnen hierna staat wat mensen kunnen doen als ze bang zijn. Wat doet of denkt uw kind als hij/zij bang is? Kies bij elke zin het antwoord dat het beste past. </p>'
  }, {
    section_start: 'Wanneer mijn kind bang is…',
    id: :v1b,
    type: :likert,
    title: 'Probeert hij/zij te veranderen wat hem/haar bang maakt.',
    options: likert_options,
    section_end: false
  }, {
    id: :v2b,
    type: :likert,
    title: 'Vertelt hij/zij aan iemand hoe het met hem/haar gaat.',
    options: likert_options
  }, {
    id: :v3b,
    type: :likert,
    title: 'Denkt hij/zij aan dingen die hem/haar gelukkig maken.',
    options: likert_options
  }, {
    id: :v4b,
    type: :likert,
    title: 'Doet hij/zij iets dat hij/zij leuk vindt.',
    options: likert_options
  }, {
    id: :v5b,
    type: :likert,
    title: 'Houdt hij/zij deze gevoelens voor zichzelf.',
    options: likert_options
  }, {
    id: :v6b,
    type: :likert,
    title: 'Maakt hij/zij er het beste van.',
    options: likert_options
  }, {
    id: :v7b,
    type: :likert,
    title: 'Wil hij/zij niemand zien.',
    options: likert_options
  }, {
    id: :v8b,
    type: :likert,
    title: 'Denkt hij/zij dat het zijn/haar eigen probleem is.',
    options: likert_options
  }, {
    id: :v9b,
    type: :likert,
    title: 'Wilt hij/zij niets meer doen.',
    options: likert_options
  }, {
    id: :v10b,
    type: :likert,
    title: 'Vraagt hij/zij zich altijd af waarom hij/zij bang is. ',
    options: likert_options
  }, {
    id: :v11b,
    type: :likert,
    title: 'Denkt hij/zij erover na wat hij/zij zou kunnen doen.',
    options: likert_options
  }, {
    id: :v12b,
    type: :likert,
    title: 'Zegt hij/zij tegen zichzelf dat het probleem niet zo erg is.',
    options: likert_options
  }, {
    id: :v13b,
    type: :likert,
    title: 'Maakt hij/zij ruzie met andere mensen.',
    options: likert_options
  }, {
    id: :v14b,
    type: :likert,
    title: 'Uit hij/zij deze angst.',
    options: likert_options
  }, {
    id: :v15b,
    type: :likert,
    title: 'Probeert hij/zij te vergeten wat hem/haar bang maakt.',
    options: likert_options
  }, {
    id: :v16b,
    type: :likert,
    title: 'Zoekt hij/zij de fout bij zichzelf.',
    options: likert_options
  }, {
    id: :v17b,
    type: :likert,
    title: 'Denkt hij/zij terug aan vrolijke dingen.',
    options: likert_options
  }, {
    id: :v18b,
    type: :likert,
    title: 'Probeert hij/zij er zelf het beste van te maken.',
    options: likert_options
  }, {
    id: :v19b,
    type: :likert,
    title: 'Gaat hij/zij naar iemand die hem/haar misschien kan helpen.',
    options: likert_options
  }, {
    id: :v20b,
    type: :likert,
    title: 'Denkt hij/zij dat het wel voorbij zal gaan.',
    options: likert_options
  }, {
    id: :v21b,
    type: :likert,
    title: 'Accepteert hij/zij wat hem/haar bang maakt.',
    options: likert_options
  }, {
    id: :v22b,
    type: :likert,
    title: 'Laat hij/zij openlijk zien dat hij/zij bang is.',
    options: likert_options
  }, {
    id: :v23b,
    type: :likert,
    title: 'Reageert hij/zij deze gevoelens af op anderen.',
    options: likert_options
  }, {
    id: :v24b,
    type: :likert,
    title: 'Krijgt hij/zij het maar niet uit zijn/haar hoofd. ',
    options: likert_options
  }, {
    id: :v25b,
    type: :likert,
    title: 'Trekt hij/zij zich terug.',
    options: likert_options
  }, {
    id: :v26b,
    type: :likert,
    title: 'Laat hij/zij niet merken dat hij/zij bang is.',
    options: likert_options
  }, {
    id: :v27b,
    type: :likert,
    title: 'Doet hij/zij iets leuks.',
    options: likert_options
  }, {
    id: :v28b,
    type: :likert,
    title: 'Denkt hij/zij na over hoe hij/zij het probleem zou kunnen oplossen.',
    options: likert_options
  }, {
    id: :v29b,
    type: :likert,
    title: 'Zegt hij/zij tegen zichzelf dat het niets belangrijks is.',
    options: likert_options
  }, {
    id: :v30b,
    type: :likert,
    title: 'Kan hij/zij sowieso niets tegen zijn/haar angst doen.',
    options: likert_options,
    section_end: true
  }, {
    type: :raw,
    content: '<p class="flow-text">Iedereen is wel eens verdrietig. Uw kind kan verdrietig zijn wanneer een dier doodgaat. Uw kind kan verdrietig zijn wanneer een toets mislukt. Hij/zij kan verdrietig zijn wanneer andere mensen gemeen doen tegen hem/haar.<br> <br>
Er kunnen verschillende redenen zijn waarom iemand verdrietig is. In de zinnen hierna staat wat mensen kunnen doen als zij verdrietig zijn. <br> <br> Wat doet of denkt uw kind als hij/zij verdrietig is? Kies bij elke zin het antwoord dat het beste past. </p>'
  }, {
    section_start: 'Wanneer mijn kind verdrietig is…',
    id: :v1c,
    type: :likert,
    title: 'Probeert hij/zij te veranderen wat hem/haar verdrietig maakt.',
    options: likert_options,
    section_end: false
  }, {
    id: :v2c,
    type: :likert,
    title: 'Vertelt hij/zij aan iemand hoe het met hem/haar gaat.',
    options: likert_options
  }, {
    id: :v3c,
    type: :likert,
    title: 'Denkt hij/zij aan dingen die hem/haar gelukkig maken.',
    options: likert_options
  }, {
    id: :v4c,
    type: :likert,
    title: 'Doet hij/zij iets dat hij/zij leuk vindt.',
    options: likert_options
  }, {
    id: :v5c,
    type: :likert,
    title: 'Houdt hij/zij deze gevoelens voor zichzelf.',
    options: likert_options
  }, {
    id: :v6c,
    type: :likert,
    title: 'Maakt hij/zij er het beste van.',
    options: likert_options
  }, {
    id: :v7c,
    type: :likert,
    title: 'Wilt hij/zij niemand zien.',
    options: likert_options
  }, {
    id: :v8c,
    type: :likert,
    title: 'Denkt hij/zij dat het zijn eigen probleem is.',
    options: likert_options
  }, {
    id: :v9c,
    type: :likert,
    title: 'Wil hij/zij niets meer doen.',
    options: likert_options
  }, {
    id: :v10c,
    type: :likert,
    title: 'Vraagt hij/zij zich altijd af waarom hij/zij verdrietig is. ',
    options: likert_options
  }, {
    id: :v11c,
    type: :likert,
    title: 'Denkt hij/zij erover na wat hij/zij zou kunnen doen.',
    options: likert_options
  }, {
    id: :v12c,
    type: :likert,
    title: 'Zegt hij/zij tegen zichzelf dat het probleem niet zo erg is.',
    options: likert_options
  }, {
    id: :v13c,
    type: :likert,
    title: 'Maakt hij/zij ruzie met andere mensen.',
    options: likert_options
  }, {
    id: :v14c,
    type: :likert,
    title: 'Uit hij/zij dit verdriet.',
    options: likert_options
  }, {
    id: :v15c,
    type: :likert,
    title: 'Probeert hij/zij te vergeten wat hem/haar verdrietig maakt.',
    options: likert_options
  }, {
    id: :v16c,
    type: :likert,
    title: 'Zoekt hij/zij de fout bij zichzelf.',
    options: likert_options
  }, {
    id: :v17c,
    type: :likert,
    title: 'Denkt hij/zij terug aan vrolijke dingen.',
    options: likert_options
  }, {
    id: :v18c,
    type: :likert,
    title: 'Probeert hij/zij er zelf het beste van te maken.',
    options: likert_options
  }, {
    id: :v19c,
    type: :likert,
    title: 'Gaat hij/zij naar iemand die hem/haar misschien kan helpen.',
    options: likert_options
  }, {
    id: :v20c,
    type: :likert,
    title: 'Denkt hij/zij dat het wel voorbij zal gaan.',
    options: likert_options
  }, {
    id: :v21c,
    type: :likert,
    title: 'Accepteert hij/zij wat hem/haar verdrietig maakt.',
    options: likert_options
  }, {
    id: :v22c,
    type: :likert,
    title: 'Laat hij/zij openlijk zien dat hij/zij verdrietig is.',
    options: likert_options
  }, {
    id: :v23c,
    type: :likert,
    title: 'Reageert hij/zij deze gevoelens af op anderen.',
    options: likert_options
  }, {
    id: :v24c,
    type: :likert,
    title: 'Krijgt hij/zij het maar niet uit zijn/haar hoofd. ',
    options: likert_options
  }, {
    id: :v25c,
    type: :likert,
    title: 'Trekt hij/zij zich terug.',
    options: likert_options
  }, {
    id: :v26c,
    type: :likert,
    title: 'Laat hij/zij niet merken dat hij/zij verdrietig is.',
    options: likert_options
  }, {
    id: :v27c,
    type: :likert,
    title: 'Doet hij/zij iets leuks.',
    options: likert_options
  }, {
    id: :v28c,
    type: :likert,
    title: 'Denkt hij/zij na over hoe hij/zij het probleem zou kunnen oplossen.',
    options: likert_options
  }, {
    id: :v29c,
    type: :likert,
    title: 'Zegt hij/zij tegen zichzelf dat het niets belangrijks is.',
    options: likert_options
  }, {
    id: :v30c,
    type: :likert,
    title: 'Kan hij/zij sowieso niets tegen zijn/haar verdriet doen.',
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
      label: 'Positieve stemming oproepen',
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
      label: 'Sociale steun',
      ids: %i[v2a v19a v2b v19b v2c v19c],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
