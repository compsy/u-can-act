# frozen_string_literal: true
db_title = 'Opvoeding'
db_name1 = 'Opvoeding_Ouderrapportage'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
likert_options = [
  { title: 'Nooit', numeric_value: 0 },
  { title: 'Bijna nooit', numeric_value: 25 },
  { title: 'Soms', numeric_value: 50 },
  { title: 'Vaak', numeric_value: 75 },
  { title: 'Altijd', numeric_value: 100 }
]
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> Iedere ouder heeft een eigen aanpak als het om opvoeden gaat. In deze vragenlijst onderzoekt u uw opvoedingsstijl. Er zijn in totaal 46 vragen. Hier bent u ongeveer X minuten mee bezig. Kies het antwoord dat het beste bij u past. </p>'
  }, {
    id: :v1,
    type: :likert,
    title: 'Ik toon genegenheid door mijn kind te knuffelen, te zoenen en vast te houden ',
    options: likert_options
  }, {
    id: :v2,
    type: :likert,
    title: 'Als mijn kind zeurt omdat hij/zij iets niet mag, geef ik toe',
    options: likert_options
  }, {
    id: :v3,
    type: :likert,
    title: 'Ik ben bang dat mijn kind mij niet meer leuk vindt als ik hem/haar corrigeer voor slecht gedrag. ',
    options: likert_options
  }, {
    id: :v4,
    type: :likert,
    title: 'Ik kibbel met mijn kind.',
    options: likert_options
  }, {
    id: :v5,
    type: :likert,
    title: 'Ik dreig met straf zonder hier een duidelijke reden voor te geven. ',
    options: likert_options
  }, {
    id: :v6,
    type: :likert,
    title: 'De straf die ik mijn kind geef hangt af van mijn stemming. ',
    options: likert_options
  }, {
    id: :v7,
    type: :likert,
    title: 'Ik deel warme en intieme momenten met mijn kind.',
    options: likert_options
  }, {
    id: :v8,
    type: :likert,
    title: 'Ik gil of schreeuw wanneer mijn kind zich misdraagt. ',
    options: likert_options
  }, {
    id: :v9,
    type: :likert,
    title: 'Wanneer ik mijn kind wil straffen als hij/zij zich misdraagt, kan hij/zij mij overhalen om dit niet te doen. ',
    options: likert_options
  }, {
    id: :v10,
    type: :likert,
    title: 'Ik toon respect voor de mening van mijn kind door hem/haar aan te moedigen deze te uiten.',
    options: likert_options
  }, {
    id: :v11,
    type: :likert,
    title: 'Als mijn kind zijn/haar taken doet laat ik zien dat ik zijn/haar gedrag opmerk. ',
    options: likert_options
  }, {
    id: :v12,
    type: :likert,
    title: 'Ik beëindig de straf van mijn kind vroegtijdig (bijvoorbeeld eerder dan ik had gezegd). ',
    options: likert_options
  }, {
    id: :v13,
    type: :likert,
    title: 'Ik barst in woede uit tegen mijn kind. ',
    options: likert_options
  }, {
    id: :v14,
    type: :likert,
    title: 'Ik geef mijn kind een tik wanneer hij/zij iets verkeerd heeft gedaan.',
    options: likert_options
  }, {
    id: :v15,
    type: :likert,
    title: 'Als ik iets van mijn kind vraag, geef ik hier een reden voor (bijvoorbeeld: “We gaan over vijf minuten weg dus het is tijd om op te ruimen”).',
    options: likert_options
  }, {
    id: :v16,
    type: :likert,
    title: 'Ik verlies mijn kalmte wanneer mijn kind niet doet wat ik hem/haar gevraagd heb.',
    options: likert_options
  }, {
    id: :v17,
    type: :likert,
    title: 'Ik moedig mijn kind aan om over zijn/haar problemen te praten.',
    options: likert_options
  }, {
    id: :v18,
    type: :likert,
    title: 'Als mijn kind doet wat ik hem/haar gevraagd heb geef ik hem/haar een compliment voor het luisteren.',
    options: likert_options
  }, {
    id: :v19,
    type: :likert,
    title: 'Ik geef mijn kind van tevoren een seintje als we iets anders gaan doen (bijvoorbeeld een waarschuwing dat we over vijf minuten van huis vertrekken).',
    options: likert_options,
    required: true
  }, {
    id: :v20,
    type: :likert,
    title: 'Als mijn kind overstuur raakt wanneer ik hem/haar iets weiger, krabbel ik terug en geef ik toch toe.',
    options: likert_options
  }, {
    id: :v21,
    type: :likert,
    title: 'Mijn kind en ik knuffelen elkaar en/of geven elkaar zoenen.',
    options: likert_options
  }, {
    id: :v22,
    type: :likert,
    title: 'Ik luister naar de ideeën en meningen van mijn kind.',
    options: likert_options
  }, {
    id: :v23,
    type: :likert,
    title: 'Het is voor mijn gevoel te veel gedoe om mijn kind zover te krijgen dat hij/zij naar mij luistert.',
    options: likert_options
  }, {
    id: :v24,
    type: :likert,
    title: 'Ik geef mijn kind een tik wanneer ik heel erg boos ben.',
    options: likert_options
  }, {
    id: :v25,
    type: :likert,
    title: 'Ik gebruik lichamelijke straffen (zoals een tik geven) om mijn kind te corrigeren.',
    options: likert_options
  }, {
    id: :v26,
    type: :likert,
    title: 'Als mijn kind zijn/haar kamer opruimt laat ik hem/haar weten hoe trots ik ben.',
    options: likert_options
  }, {
    id: :v27,
    type: :likert,
    title: 'Ik geef toe aan mijn kind als hij/zij ergens heisa over maakt.',
    options: likert_options
  }, {
    id: :v28,
    type: :likert,
    title: 'Ik vertel mijn kind hoe ik verwacht dat hij/zij zich zal gedragen voordat hij/zij ergens mee bezig gaat.',
    options: likert_options
  }, {
    id: :v29,
    type: :likert,
    title: 'Wanneer ik overstuur ben of last heb van stress, word ik kritisch en streng tegen mijn kind.',
    options: likert_options
  }, {
    id: :v30,
    type: :likert,
    title: 'Ik laat mijn kind weten dat ik het fijn vind wanneer hij/zij meehelpt in huis.',
    options: likert_options
  }, {
    id: :v31,
    type: :likert,
    title: 'Ik gebruik lichamelijke straffen (zoals een tik geven) omdat andere dingen die ik heb geprobeerd niet hebben gewerkt.',
    options: likert_options
  }, {
    id: :v32,
    type: :likert,
    title: 'Wanneer ik mijn kind corrigeer voor zijn/haar gedrag leg ik kort uit waarom.',
    options: likert_options
  }, {
    id: :v33,
    type: :likert,
    title: 'Ik vermijd strijd met mijn kind door hem/haar duidelijke keuzes te geven.',
    options: likert_options
  }, {
    id: :v34,
    type: :likert,
    title: 'Wanneer mijn kind zich misdraagt, laat ik hem/haar weten wat er zal gebeuren als hij/zij zich niet gaat gedragen.',
    options: likert_options
  }, {
    section_start: 'De volgende vragen gaan over hoe u de opvoeding en de relatie met uw kind ervaart. Geef voor elke uitspraak aan in hoeverre deze voor u geldt door het bolletje te verplaatsen.',
    id: :v35,
    type: :range,
    title: 'Ik voel me gelukkig met mijn kind.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true,
    section_end: false
  }, {
    id: :v36,
    type: :range,
    title: 'Door de opvoeding van mijn kind kom ik te weinig aan mezelf toe.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v37,
    type: :range,
    title: 'Ik voel me vrolijk als mijn kind bij mij is.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v38,
    type: :range,
    title: 'Door mijn kind kom ik weinig toe aan andere dingen.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v39,
    type: :range,
    title: 'Ik heb een tevreden gevoel over mijn kind.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v40,
    type: :range,
    title: 'Ik zou vaker vrienden en kennissen willen bezoeken maar dat gaat niet
vanwege mijn kind.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v41,
    type: :range,
    title: 'Met mijn kind voel ik me prettig.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v42,
    type: :range,
    title: 'Ik heb vanwege mijn kind minder contact met mijn vrienden dan vroeger.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v43,
    type: :range,
    title: 'Als mijn kind bij mij is voel ik me rustig.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v44,
    type: :range,
    title: 'Ik kan door mijn kind heel weinig van huis weg.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v45,
    type: :range,
    title: 'Ik geniet van mijn kind.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v46,
    type: :range,
    title: 'Ik heb door mijn kind weinig contacten met andere mensen.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true,
    section_end: true
  }
]
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Warmte',
      ids: %i[v1 v7 v21],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Loslaten',
      ids: %i[v2 v3 v9 v12 v20 v23 v27],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Positieve bekrachtiging',
      ids: %i[v11 v18 v26 v30],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
