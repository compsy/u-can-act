# frozen_string_literal: true

db_title = 'Over je gevoelens'
db_name1 = 'wellbeing'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
rcads_options = %w[Nooit Soms Vaak Altijd]
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over hoe je je voelt. Het is voor het onderzoek heel belangrijk om te weten hoe je je echt voelt. We vragen je daarom om de vragen eerlijk te beantwoorden. Zoals je je echt voelt dus, en niet zoals je denkt dat je je zou moeten voelen. Er zijn geen ‘goede’ of ‘foute’ antwoorden. Je antwoorden worden vertrouwelijk behandeld. We geven je antwoorden NOOIT door aan je ouders of aan je school.
    </p>'
  }, {
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'Voel je je in het algemeen gelukkig?',
    options: ['0 (Helemaal niet gelukkig)', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10 (Heel gelukkig)']
  }, {
    type: :raw,
    content: '<p class="flow-text">Denk even na over hoe je leven geweest is in de afgelopen twee weken. Verschuif de slider om aan te geven hoeveel je het eens of oneens bent met elke zin.
    </p>'
  }, {
    id: :v2,
    type: :range,
    title: 'Het gaat goed met mijn leven',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v3,
    type: :range,
    title: 'Mijn leven is precies goed',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v4,
    type: :range,
    title: 'Ik zou veel dingen in mijn leven willen veranderen als dat kon',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v5,
    type: :range,
    title: 'Ik wou dat ik een ander soort leven had',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v6,
    type: :range,
    title: 'Ik heb een goed leven',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v7,
    type: :range,
    title: 'Ik heb wat ik wil in het leven',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    id: :v8,
    type: :range,
    title: 'Ik heb een beter leven dan de meeste kinderen',
    labels: ['Helemaal oneens', 'Helemaal eens']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over vervelende gevoelens, waar je weleens last van kunt hebben. Klik het knopje om aan te geven hoe vaak jij in de afgelopen twee weken last hebt gehad van zulke gevoelens.
    </p>'
  }, {
    id: :v9,
    type: :radio,
    show_otherwise: false,
    title: 'Ik voel me verdrietig of leeg',
    options: rcads_options
  }, {
    id: :v10,
    type: :radio,
    show_otherwise: false,
    title: 'Ik pieker erover wanneer ik denk dat ik iets niet goed heb gedaan',
    options: rcads_options
  }, {
    id: :v11,
    type: :radio,
    show_otherwise: false,
    title: 'Ik zou het eng vinden om alleen thuis te zijn',
    options: rcads_options
  }, {
    id: :v12,
    type: :radio,
    show_otherwise: false,
    title: 'Ik vind niets meer echt leuk',
    options: rcads_options
  }, {
    id: :v13,
    type: :radio,
    show_otherwise: false,
    title: 'Ik maak me zorgen dat er iets ergs gaat gebeuren met iemand uit mijn gezin',
    options: rcads_options
  }, {
    id: :v14,
    type: :radio,
    show_otherwise: false,
    title: 'Ik ben bang om op plaatsen te zijn waar veel mensen zijn, zoals een winkelcentrum, de bioscoop, bussen of drukke speeltuinen',
    options: rcads_options
  }, {
    id: :v15,
    type: :radio,
    show_otherwise: false,
    title: 'Ik pieker over wat andere mensen van me denken',
    options: rcads_options
  }, {
    id: :v16,
    type: :radio,
    show_otherwise: false,
    title: 'Ik heb problemen met slapen',
    options: rcads_options
  }, {
    id: :v17,
    type: :radio,
    show_otherwise: false,
    title: 'Ik ben bang als ik alleen moet slapen',
    options: rcads_options
  }, {
    id: :v18,
    type: :radio,
    show_otherwise: false,
    title: 'Ik heb geen zin in eten',
    options: rcads_options
  }, {
    id: :v19,
    type: :radio,
    show_otherwise: false,
    title: 'Ik word plotseling duizelig of slap terwijl er geen reden voor is',
    options: rcads_options
  }, {
    id: :v20,
    type: :radio,
    show_otherwise: false,
    title: 'Ik moet sommige dingen steeds opnieuw doen (zoals handen wassen, dingen schoonmaken of op een bepaalde manier neerleggen)',
    options: rcads_options
  }, {
    id: :v21,
    type: :radio,
    show_otherwise: false,
    title: 'Ik heb geen energie om dingen te doen',
    options: rcads_options
  }, {
    id: :v22,
    type: :radio,
    show_otherwise: false,
    title: 'Ik begin plotseling te beven of te trillen, terwijl daar geen reden voor is',
    options: rcads_options
  }, {
    id: :v23,
    type: :radio,
    show_otherwise: false,
    title: 'Ik kan niet helder nadenken',
    options: rcads_options
  }, {
    id: :v24,
    type: :radio,
    show_otherwise: false,
    title: 'Ik heb het gevoel dat ik niets waard ben',
    options: rcads_options
  }, {
    id: :v25,
    type: :radio,
    show_otherwise: false,
    title: 'Ik moet bepaalde gedachten denken (zoals getallen of woorden) om te zorgen dat er geen nare dingen gebeuren',
    options: rcads_options
  }, {
    id: :v26,
    type: :radio,
    show_otherwise: false,
    title: 'Ik denk aan de dood',
    options: rcads_options
  }, {
    id: :v27,
    type: :radio,
    show_otherwise: false,
    title: 'Ik heb een gevoel alsof ik niet wil bewegen',
    options: rcads_options
  }, {
    id: :v28,
    type: :radio,
    show_otherwise: false,
    title: 'Ik pieker dat ik plotseling bang zal worden terwijl er niets is om bang voor te zijn',
    options: rcads_options
  }, {
    id: :v29,
    type: :radio,
    show_otherwise: false,
    title: 'Ik ben erg moe',
    options: rcads_options
  }, {
    id: :v30,
    type: :radio,
    show_otherwise: false,
    title: 'Ik ben bang dat ik mezelf voor gek zal zetten tegenover andere mensen',
    options: rcads_options
  }, {
    id: :v31,
    type: :radio,
    show_otherwise: false,
    title: 'Ik moet sommige dingen precies op de goede manier doen om ervoor te zorgen dat er geen nare dingen gebeuren',
    options: rcads_options
  }, {
    id: :v32,
    type: :radio,
    show_otherwise: false,
    title: 'Ik voel me onrustig',
    options: rcads_options
  }, {
    id: :v33,
    type: :radio,
    show_otherwise: false,
    title: 'Ik maak me zorgen dat me iets ergs gaat overkomen',
    options: rcads_options
  },  {
    type: :raw,
    content: '<p class="flow-text">In het afgelopen jaar is er vanwege het uitbreken van het coronavirus veel gebeurd. Sommige mensen voelen zich daardoor misschien vaker zenuwachtig of somber. Anderen hebben hier geen last van of voelen zich juist rustiger, bijvoorbeeld omdat ze vaker thuis kunnen zijn. We zijn benieuwd hoe dit voor jou is. <br> <br>
    Vergeleken met vóór de coronacrisis, voelde je je in de afgelopen 2 weken vaker of juist minder vaak ...
  </p>'
  }, {
    id: :v34_a,
    type: :range,
    title: 'Zenuwachtig',
    labels: ['Veel minder vaak', 'Veel vaker']
  }, {
    id: :v34_b,
    type: :range,
    title: 'Hopeloos?',
    labels: ['Veel minder vaak', 'Veel vaker']
  }, {
    id: :v34_c,
    type: :range,
    title: 'Rusteloos of ongedurig?',
    labels: ['Veel minder vaak', 'Veel vaker']
  }, {
    id: :v34_d,
    type: :range,
    title: 'Zo somber dat niets je kon opvrolijken?',
    labels: ['Veel minder vaak', 'Veel vaker']
  }, {
    id: :v34_e,
    type: :range,
    title: 'Dat alles veel moeite kostte?',
    labels: ['Veel minder vaak', 'Veel vaker']
  }, {
    id: :v34_f,
    type: :range,
    title: 'Waardeloos?',
    labels: ['Veel minder vaak', 'Veel vaker']
  },{
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over angsten voor bepaalde dingen, zoals voor dieren, onweer of bloed, waar sommige mensen last van hebben.
    </p>'
  }, {
    id: :v35,
    type: :checkbox,
    required: true,
    show_otherwise: false,
    title: 'Ben je ooit veel banger dan de meeste andere kinderen geweest voor één van de volgende dingen of situaties? Je kunt meerdere dingen aanklikken.',
    options: [
      { title: 'Insecten, slangen, honden of andere dieren', shows_questions: %i[v35_a v35_b v41_a v41_b v41_c v42] },
      { title: 'Stilstaand water (bijvoorbeeld een zwembad of meer)', shows_questions: %i[v36_a v36_b v41_a v41_b v41_c v42] },
      { title: 'Zwaar weer (bijvoorbeeld stormen, onweer of bliksem)', shows_questions: %i[v36_a v36_b v41_a v41_b v41_c v42] },
      { title: 'Naar de tandarts of dokter gaan', shows_questions: %i[v37_a v37_b v41_a v41_b v41_c v42] },
      { title: 'Een prik of vaccinatie krijgen', shows_questions: %i[v37_a v37_b v41_a v41_b v41_c v42] },
      { title: 'Bloed of een wond zien', shows_questions: %i[v37_a v37_b v41_a v41_b v41_c v42] },
      { title: 'In een ziekenhuis zijn', shows_questions: %i[v37_a v37_b v41_a v41_b v41_c v42] },
      { title: 'Besloten ruimtes, zoals grotten, tunnels, kasten of liften', shows_questions: %i[v38_a v38_b v41_a v41_b v41_c v42] },
      { title: 'Hoogtes, zoals een dak, een balkon, een brug of een trap', shows_questions: %i[v39_a v39_b v41_a v41_b v41_c v42] },
      { title: 'Vliegen of vliegtuigen', shows_questions: %i[v40_a v40_b v41_a v41_b v41_c v42] },
      { title: 'Geen van deze dingen' }
    ]
  }, {
    id: :v35_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Je zei dat je ooit wel eens heel bang geweest bent voor een dier. De volgende vragen gaan over deze angst. <br><br> Heb je wel eens een periode gehad waarin je bijna altijd heel bang of overstuur werd als je in de buurt kwam van het dier waar je bang voor was?',
    options: %w[Ja Nee]
  }, {
    id: :v35_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Ben je ooit zoveel mogelijk situaties uit de weg gegaan waarin je dit dier tegen zou kunnen komen?',
    options: %w[Ja Nee]
  }, {
    id: :v36_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: "Je zei dat je ooit wel eens heel bang geweest bent voor stilstaand water (bijvoorbeeld een meer) of zwaar weer (bijvoorbeeld onweer). De volgende vragen gaan over deze angst. <br><br> Heb je wel eens een periode gehad waarin je bijna altijd heel bang of overstuur werd als je in zo'n situatie terecht kwam?",
    options: %w[Ja Nee]
  }, {
    id: :v36_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Ben je ooit zoveel mogelijk situaties uit de weg gegaan waarin je in zwaar weer of stilstaand water terecht zou kunnen komen?',
    options: %w[Ja Nee]
  }, {
    id: :v37_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Je zei dat je ooit wel eens heel bang geweest bent voor de tandarts of dokter, bloed, prikken of ziekenhuizen. De volgende vragen gaan over deze angst. <br><br> Heb je wel eens een periode gehad waarin je bijna altijd heel bang of overstuur werd als je dit soort situaties tegen kwam?',
    options: %w[Ja Nee]
  }, {
    id: :v37_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Ben je ooit dit soort situaties zoveel mogelijk uit de weg gegaan?',
    options: %w[Ja Nee]
  }, {
    id: :v38_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Je zei dat je ooit wel eens heel bang geweest bent voor besloten ruimtes, zoals grotten of tunnels. De volgende vragen gaan over deze angst. <br><br> Heb je wel eens een periode gehad waarin je bijna altijd heel bang of overstuur werd als je in een besloten ruimte terecht kwam?',
    options: %w[Ja Nee]
  }, {
    id: :v38_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Ben je ooit dit soort besloten ruimtes zoveel mogelijk uit de weg gegaan?',
    options: %w[Ja Nee]
  }, {
    id: :v39_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Je zei dat je ooit wel eens heel bang geweest bent voor hoogtes, zoals daken of balkons. De volgende vragen gaan over deze angst. <br><br> Heb je wel eens een periode gehad waarin je bijna altijd heel bang of overstuur werd als je op een hoge plek terecht kwam?',
    options: %w[Ja Nee]
  }, {
    id: :v39_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Ben je ooit dit soort hoge plekken zoveel mogelijk uit de weg gegaan?',
    options: %w[Ja Nee]
  }, {
    id: :v40_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Je zei dat je ooit wel eens heel bang geweest bent voor vliegen of vliegtuigen. De volgende vragen gaan over deze angst. <br><br> Heb je wel eens een periode gehad waarin je bijna altijd heel bang of overstuur werd als je zou moeten vliegen?',
    options: %w[Ja Nee]
  }, {
    id: :v40_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Ben je ooit zoveel mogelijk situaties waarin je zou moeten vliegen uit de weg gegaan?',
    options: %w[Ja Nee]
  }, {
    id: :v41_a,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'De volgende vragen gaan over je angst voor alle dingen die je hebt aangekruist. Hoeveel moeilijker heeft je angst voor dit soort dingen het je gemaakt om gewoon je leven te leiden? Bijvoorbeeld om je schoolwerk goed te doen, met vrienden af te spreken of goed op te schieten met je familie',
    options: ['Helemaal niet', 'Een beetje', 'Matig', 'Veel', 'Heel veel']
  }, {
    id: :v41_b,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Heb je ooit een periode gehad waarin je erg van streek, bezorgd of teleurgesteld in jezelf was omdat je zo bang was voor dit soort dingen?',
    options: %w[Ja Nee]
  }, {
    id: :v41_c,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Weet je nog hoe oud je was de allereerste keer dat je zo bang werd door dit soort dingen?',
    options: [
      { title: 'Ja, dat weet ik nog', shows_questions: %i[v41_d] },
      { title: 'Nee, dat weet ik niet meer', shows_questions: %i[v41_e] }
    ]
  }, {
    id: :v41_d,
    type: :dropdown,
    show_otherwise: false,
    hidden: true,
    title: 'Hoe oud was je de allereerste keer dat je zo bang werd door dit soort dingen?',
    options: (0..20).to_a.map(&:to_s)
  }, {
    id: :v41_e,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Weet je nog hoe oud je ongeveer was toen je de eerste keer zo bang werd door dit soort dingen?',
    options: ['Voor de basisschool', 'Voor de middelbare school', 'Tijdens de middelbare school', 'Dat weet ik niet meer']
  }, {
    id: :v42,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Wanneer was de laatste keer dat je erg bang was voor één van die dingen?',
    options: ['In de afgelopen maand', '1 tot 12 maanden geleden', 'Meer dan een jaar geleden']
  }
  
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
