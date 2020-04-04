# frozen_string_literal: true

db_title = 'Leefplezier'

db_name1 = 'Welbevinden_Ouders_Zelfrapportage'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> De volgende vragenlijst onderzoekt uw welbevinden en tevredenheid, gevoel van controle, en omgang met anderen. Het invullen van deze 70 vragen kost u ongeveer 15 minuten. U kunt het bolletje op de antwoordschaal naar de plek schuiven die volgens u het beste aansluit bij uw ervaringen. Er zijn geen goede of foute antwoorden.</p>'
  }, {
    section_start: 'De volgende vragen gaan over uw leven in het algemeen:',
    id: :v1,
    type: :range,
    title: 'Voelt u zich in het algemeen gelukkig?',
    tooltip: 'Geef een globale inschatting, hoe u zich in het algemeen voelt (dus niet hoe u zich op dit moment voelt',
    labels: %w[Nooit Altijd],
    required: true,
    section_end: false
  }, {
    id: :v2,
    type: :range,
    title: 'Hoe vaak voelt u dat u uw doelen gaat behalen?',
    labels: %w[Nooit Altijd],
    required: true
  }, {
    id: :v3,
    type: :range,
    title: 'Hoe vaak gaat u volledig op in waar u mee bezig bent?',
    labels: %w[Nooit Altijd],
    required: true
  }, {
    id: :v4,
    type: :range,
    title: 'Hoe vaak voelt u zich opgewekt?',
    labels: %w[Nooit Altijd],
    required: true
  }, {
    id: :v5,
    type: :range,
    title: 'Hoe vaak voelt u zich angstig?',
    labels: %w[Nooit Altijd],
    required: true
  }, {
    id: :v6,
    type: :range,
    title: 'Hoe vaak bereikt u de belangrijke doelen die u uzelf stelt?',
    labels: %w[Nooit Altijd],
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Hoe zou u uw gezondheid beoordelen?',
    labels: %w[Verschrikkelijk Uitstekend],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'In hoeverre leeft u een nuttig en betekenisvol leven?',
    labels: ['Helemaal niet', 'Volledig'],
    required: true
  }, {
    id: :v9,
    type: :range,
    title: 'Krijgt u hulp en steun van anderen wanneer u dit nodig hebt?',
    labels: ['Helemaal niet', 'Volledig'],
    required: true
  }, {
    id: :v10,
    type: :range,
    title: 'Voelt u dat wat u doet in uw leven zinvol en waardevol is?',
    labels: ['Helemaal niet', 'Volledig'],
    required: true
  }, {
    id: :v11,
    type: :range,
    title: 'Voelt u passie en interesse voor dingen?',
    labels: ['Helemaal niet', 'Volledig'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Hoe eenzaam voelt u zich in het dagelijkse leven?',
    labels: ['Helemaal niet', 'Volledig'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Hoe tevreden bent u met uw huidige lichamelijke gezondheid?',
    labels: ['Helemaal niet', 'Volledig'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Hoe vaak voelt u zich positief?',
    labels: %w[Nooit Altijd],
    required: true
  }, {
    id: :v15,
    type: :range,
    title: 'Hoe vaak voelt u zich boos?',
    labels: %w[Nooit Altijd],
    required: true
  }, {
    id: :v16,
    type: :range,
    title: 'Hoe vaak kunt u aan uw verantwoordelijkheden voldoen?',
    labels: %w[Nooit Altijd],
    required: true
  }, {
    id: :v17,
    type: :range,
    title: 'Hoe vaak voelt u zich verdrietig?',
    labels: %w[Nooit Altijd],
    required: true
  }, {
    id: :v18,
    type: :range,
    title: 'Hoe vaak verliest u het besef van tijd terwijl u met iets plezierigs bezig bent?',
    labels: %w[Nooit Altijd],
    required: true
  }, {
    id: :v19,
    type: :range,
    title: 'Hoe gezond bent u in vergelijking met anderen van uw leeftijd en geslacht?',
    labels: %w[Verschrikkelijk Uitstekend],
    required: true
  }, {
    id: :v20,
    type: :range,
    title: 'In hoeverre voelt u dat er van u wordt gehouden?',
    labels: ['Helemaal niet', 'Volledig'],
    required: true
  }, {
    id: :v21,
    type: :range,
    title: 'In hoeverre heeft u een gevoel van richting in uw leven?',
    labels: ['Helemaal niet', 'Volledig'],
    required: true
  }, {
    id: :v22,
    type: :range,
    title: 'Hoe tevreden bent u met uw persoonlijke relaties?',
    labels: ['Helemaal niet', 'Volledig'],
    required: true
  }, {
    id: :v23,
    type: :range,
    title: 'In het algemeen, in hoeverre voelt u zich tevreden?',
    labels: ['Helemaal niet', 'Volledig'],
    required: true
  }, {
    id: :v24,
    type: :radio,
    title: 'Geef aan wat voor u van toepassing is:',
    options: [
      { title: 'Ik heb een betaalde baan (of werk op een sociale werkplaats, of volg onderwijs/opleiding als voornaamste daginvulling)', shows_questions: %i[v25] },
      { title: 'Ik heb geen betaalde baan (bijvoorbeeld omdat ik ben afgekeurd) of ben gepensioneerd', shows_questions: %i[v26] }],
    show_otherwise: false
  }, {
    id: :v25,
    hidden: true,
    type: :range,
    title: 'Hoe tevreden bent u met het feit dat u een betaalde baan heeft (of op een sociale werkplaats werkt, of onderwijs/opleiding volgt als voornaamste daginvulling)?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter']
  }, {
    id: :v26,
    hidden: true,
    type: :range,
    title: 'Hoe tevreden bent u met het feit dat u geen betaalde baan heeft omdat u bent afgekeurd of gepensioneerd bent?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter']
  }, {
    id: :v27,
    type: :range,
    title: 'Hoe tevreden bent u met hoe goed u bij kas zit?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter'],
    required: true
  }, {
    id: :v28,
    type: :range,
    title: 'Hoe tevreden bent u met het aantal van uw vriendschappen?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter'],
    required: true
  }, {
    id: :v29,
    type: :range,
    title: 'Hoe tevreden bent u met de kwaliteit van uw vriendschappen?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter'],
    required: true
  }, {
    id: :v30,
    type: :range,
    title: 'Hoe tevreden bent u met de dingen die u in uw vrije tijd doet?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter'],
    required: true
  }, {
    id: :v31,
    type: :range,
    title: 'Hoe tevreden bent u met uw woonomstandigheden?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter'],
    required: true
  }, {
    id: :v32,
    type: :radio,
    title: 'Bent u in het afgelopen jaar beschuldigd van een misdrijf?',
    options: %w[Ja Nee],
    show_otherwise: false
  }, {
    id: :v33,
    type: :radio,
    title: 'Bent u in het afgelopen jaar slachtoffer geweest van lichamelijk geweld?',
    options: %w[Ja Nee],
    show_otherwise: false
  }, {
    id: :v34,
    type: :range,
    title: 'Hoe tevreden bent u met uw persoonlijke veiligheid?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter'],
    required: true
  }, {
    id: :v35,
    type: :radio,
    title: 'Geef aan wat voor u van toepassing is:',
    options: [
      { title: 'Ik leef samen met partner', shows_questions: %i[v36] },
      { title: 'Ik woon samen met kinderen zonder partner', shows_questions: %i[v36] },
      { title: 'Ik woon alleen', shows_questions: %i[v37] },
      { title: 'Anders' }],
    show_otherwise: false
  }, {
    id: :v36,
    type: :range,
    hidden: true,
    title: 'Hoe tevreden bent u met de persoon of personen waarmee u samenleeft?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter']
  }, {
    id: :v37,
    type: :range,
    hidden: true,
    title: 'Hoe tevreden bent u met het feit dat u alleen woont?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter']
  }, {
    id: :v38,
    type: :range,
    title: 'Hoe tevreden bent u met uw seksuele leven?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter'],
    required: true
  }, {
    id: :v39,
    type: :range,
    title: 'Hoe tevreden bent u met uw relatie met uw familie?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter'],
    required: true,
    tooltip: 'Deze vraag heeft betrekking op familieleden waarmee u niet samenwoont'
  }, {
    id: :v40,
    type: :range,
    title: 'Hoe tevreden bent u met uw psychische gezondheid?',
    labels: ['Kan niet slechter', 'Gemengd (tevreden en ontevreden)', 'Kan niet beter'],
    required: true,
    section_end: true
  }, {
    section_start: 'Geef bij de onderstaande uitspraken aan in hoeverre deze <b>in het algemeen</b> aansluiten bij  uw ervaringen of gevoelens:',
    id: :v41,
    type: :range,
    title: 'In het algemeen heb ik het gevoel dat ik grip heb op de situatie waarin ik leef.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true,
    section_end: false
  }, {
    id: :v42,
    type: :range,
    title: 'Als ik terugkijk op mijn leven dan ben ik tevreden met hoe de dingen zijn gelopen.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v43,
    type: :range,
    title: 'Over het algemeen ben ik positief over mezelf en voel ik me zeker van mezelf.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v44,
    type: :range,
    title: 'Ik heb vertrouwen in mijn opvattingen, zelfs als ze in strijd zijn met wat de meeste andere mensen denken.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v45,
    type: :range,
    title: 'Ik heb het gevoel dat ik me als mens, in de loop van de tijd, goed heb ontwikkeld.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v46,
    type: :range,
    title: 'Ik ben erin geslaagd om thuis een levensstijl op te bouwen waarbij ik me prettig voel.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v47,
    type: :range,
    title: 'Ik leef mijn leven van dag tot dag en ik denk niet echt na over de toekomst.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v48,
    type: :range,
    title: 'In het algemeen heb ik het gevoel dat ik iets belangrijks heb bijgedragen aan de samenleving.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v49,
    type: :range,
    title: 'In mijn hoofd voel ik me vrij en op mijn gemak.',
    labels: ['Helemaal niet', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v50,
    type: :range,
    title: 'Ik voel me voldaan en comfortabel met mijzelf in het dagelijks leven.',
    labels: ['Helemaal niet', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v51,
    type: :range,
    title: 'Mijn levensstijl geeft me een gevoel van rust en stabiliteit.',
    labels: ['Helemaal niet', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v52,
    type: :range,
    title: 'Ik heb rust en harmonie in mijn hoofd.',
    labels: ['Helemaal niet', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v53,
    type: :range,
    title: 'Het is moeilijk voor me om me ergens thuis te voelen.',
    labels: ['Helemaal niet', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v54,
    type: :range,
    title: 'De manier waarop ik leef geeft me gevoelens van rust en comfort.',
    labels: ['Helemaal niet', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v55,
    type: :range,
    title: 'Ik voel me angstig en onrustig in mijn hoofd.',
    labels: ['Helemaal niet', 'Soms', 'Altijd'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over <b>de afgelopen twee weken</b>:',
    id: :v56,
    type: :range,
    title: 'In welke mate vindt u dat pijn u weerhoudt van wat u moet doen?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true,
    section_end: false
  }, {
    id: :v57,
    type: :range,
    title: 'Hoe goed kunt u zich concentreren?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v58,
    type: :range,
    title: 'Hoe tevreden bent u met uw leefomgeving (bijvoorbeeld lawaai, klimaat, vervuiling, aantrekkelijkheid)?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v59,
    type: :range,
    title: 'Hebt u genoeg energie voor het leven van alledag?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v60,
    type: :range,
    title: 'Hoe tevreden bent u met uw uiterlijk?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v61,
    type: :range,
    title: 'Hoe tevreden bent u met uw slaap?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v62,
    type: :range,
    title: 'Bent u tevreden met uw vermogen om alledaagse activiteiten te verrichten (bijvoorbeeld eten, wassen, boodschappen, schoonmaken)?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v63,
    type: :range,
    title: 'In hoeverre bent u in staat om een baan te hebben?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v64,
    type: :range,
    title: 'Hoe tevreden bent u met uzelf?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v65,
    type: :range,
    title: 'Hoe tevreden bent u met uw toegang tot gezondheidszorg?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v66,
    type: :range,
    title: 'Hoe tevreden bent u met uw toegang tot vervoer?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v67,
    type: :range,
    title: 'Hoe goed kunt u zich lichamelijk verplaatsen?',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true,
    section_end: true
  }, {
    section_start: 'Geef aan in hoeverre u het eens bent met de volgende uitspraken over uw leven:',
    id: :v68,
    type: :range,
    title: 'Ik ben baas over mijn eigen leven.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true,
    section_end: false
  }, {
    id: :v69,
    type: :range,
    title: 'Als ik hard werk zal ik succes hebben.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v70,
    type: :range,
    title: 'In mijn privé-leven wordt wat ik doe vooral bepaald door anderen.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v71,
    type: :range,
    title: 'Op mijn werk wordt wat ik doe vooral bepaald door anderen.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v72,
    type: :range,
    title: 'Het lot staat mijn plannen vaak in de weg.',
    labels: ['Helemaal niet', 'Gemiddeld', 'Volledig'],
    required: true
  }, {
    id: :v73,
    type: :range,
    title: 'Vergeleken met de meeste mensen van mijn leeftijd voel ik me meestal…',
    labels: ['Veel jonger', 'Zo oud als ik ben', 'Veel ouder'],
    required: true,
    section_end: true
  }]
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Positieve emoties',
      ids: %i[v4 v14 v23],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Betekenis',
      ids: %i[v8 v10 v21],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Voldoening',
      ids: %i[v2 v6 v16],
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
