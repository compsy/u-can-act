# frozen_string_literal: true

db_title = 'Dagboekvragenlijst'
db_name1 = 'Dagboek_ouders'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

dagboek_content = [
  {
    section_start: '<strong>De volgende vragen gaan over hoe u zich op dit moment voelt:</strong>',
    id: :v1,
    type: :range,
    title: 'Trots',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: false
  }, {
    id: :v2,
    type: :range,
    title: 'Boos',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v3,
    type: :range,
    title: 'Tevreden',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v4,
    type: :range,
    title: 'Beschaamd',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v5,
    type: :range,
    title: 'Vol energie',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v6,
    type: :range,
    title: 'Vrolijk',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Verdrietig',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'Bang',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v9,
    type: :range,
    title: 'Gelukkig',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v10,
    type: :range,
    title: 'Eenzaam',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v11,
    type: :range,
    title: 'Zenuwachtig',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Geliefd',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Gestrest',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Ontspannen',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v15,
    type: :range,
    title: 'Geïrriteerd',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v16,
    type: :range,
    title: 'Ik ben in de war over hoe ik me voel.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v17,
    type: :range,
    title: 'Ik heb het vandaag druk gehad.',
    labels: ['Helemaal niet', 'Heel erg'],
    section_end: true
  }, {
    section_start: 'Denk aan de <i>voor u belangrijkste gebeurtenis</i> van vandaag.',
    id: :v18,
    type: :radio,
    title: 'Hoe leuk was deze gebeurtenis?',
    options: [
      { title: 'Helemaal niet leuk' },
      { title: 'Niet leuk' },
      { title: 'Een beetje leuk', shows_questions: %i[v18a v18b] },
      { title: 'Leuk', shows_questions: %i[v18a v18b] },
      { title: 'Heel erg leuk', shows_questions: %i[v18a v18b] }],
    section_end: false
  }, {
    id: :v18a,
    type: :range,
    hidden: true,
    title: 'Ik heb geprobeerd om het positieve gevoel vast te houden.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v18b,
    type: :range,
    hidden: true,
    title: 'Ik heb teruggedacht aan deze gebeurtenis.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v19,
    type: :radio,
    title: 'Hoe vervelend was deze gebeurtenis?',
    options: [
      { title: 'Helemaal niet vervelend' },
      { title: 'Niet vervelend' },
      { title: 'Een beetje vervelend', shows_questions: %i[v19a v19b] },
      { title: 'Vervelend', shows_questions: %i[v19a v19b] },
      { title: 'Heel erg vervelend', shows_questions: %i[v19a v19b] }],
  }, {
    id: :v19a,
    type: :range,
    hidden: true,
    title: 'Ik heb gepiekerd over deze gebeurtenis.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v19b,
    type: :range,
    hidden: true,
    title: 'Ik heb geprobeerd om niet over deze gebeurtenis na te denken.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v20,
    type: :radio,
    title: 'Heeft u met iemand over deze gebeurtenis gepraat?',
    options: [
      { title: 'Nee, met niemand', shows_questions: %i[v20b] },
      { title: 'Ja, met mijn partner', shows_questions: %i[v20a] },
      { title: 'Ja, met een vriend(in)', shows_questions: %i[v20a] },
      { title: 'Ja, met een collega', shows_questions: %i[v20a] },
      { title: 'Ja, met mijn kind', shows_questions: %i[v20a] },
      { title: 'Ja, met iemand anders', shows_questions: %i[v20a] }],
    show_otherwise: false
  }, {
    id: :v20a,
    hidden: true,
    type: :checkbox,
    title: 'Hoe reageerde deze persoon toen je over de gebeurtenis vertelde?',
    options: [
      { title: 'Hij/zij werd boos' },
      { title: 'Hij/zij vond het niet belangrijk' },
      { title: 'Hij/zij nam de tijd om naar mij te luisteren' },
      { title: 'Hij/zij troostte me' },
      { title: 'Hij/zij moest lachen' },
      { title: 'Hij/zij knuffelde me' }],
    show_otherwise: true,
    otherwise_label: 'Anders, namelijk',
    tooltip: 'Meerdere antwoorden mogelijk'
  }, {
    id: :v20b,
    type: :range,
    hidden: true,
    title: 'Had u wel met iemand over deze gebeurtenis willen praten?',
    labels: ['Helemaal niet', 'Heel graag'],
    required: true
  }, {
    type: :raw,
    content: '<p class="flow-text">In hoeverre had deze gebeurtenis (of uw gevoelens of gedachten erover) invloed op...</p>'
  }, {
    id: :v21,
    type: :range,
    title: '...uw geduld met uw kind?',
    labels: ['Ik had veel minder geduld dan normaal', 'Geen invloed', 'Ik had veel meer geduld dan normaal'],
    required: true
  }, {
    id: :v22,
    type: :range,
    title: '...uw aandacht of tijd voor uw kind?',
    labels: ['Ik had veel minder aandacht dan normaal', 'Geen invloed', 'Ik had veel meer aandacht dan normaal'],
    required: true
  }, {
    id: :v23,
    type: :range,
    title: '...hoeveel plezier u beleefde aan het contact met uw kind?',
    labels: ['Ik beleefde veel minder plezier aan ons contact', 'Geen invloed', 'Ik beleefde veel meer plezier aan ons contact'],
    required: true,
    section_end: true
  }, {
    section_start: 'Hoe denkt u dat uw kind zich vandaag voelde?',
    id: :v24,
    type: :range,
    title: 'Trots',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: false
  }, {
    id: :v25,
    type: :range,
    title: 'Boos',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v26,
    type: :range,
    title: 'Tevreden',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v27,
    type: :range,
    title: 'Beschaamd',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v28,
    type: :range,
    title: 'Vol energie',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v29,
    type: :range,
    title: 'Vrolijk',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v30,
    type: :range,
    title: 'Verdrietig',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v31,
    type: :range,
    title: 'Bang',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v32,
    type: :range,
    title: 'Gelukkig',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v33,
    type: :range,
    title: 'Eenzaam',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v34,
    type: :range,
    title: 'Zenuwachtig',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v35,
    type: :range,
    title: 'Geliefd',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v36,
    type: :range,
    title: 'Gestrest',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v37,
    type: :range,
    title: 'Ontspannen',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v38,
    type: :range,
    title: 'Geïrriteerd',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over het gedrag van uw kind:',
    id: :v39,
    type: :radio,
    title: 'Heeft uw kind vandaag iets bijzonders meegemaakt?',
    options: [
      { title: 'Ja', shows_questions: %i[v39a] },
      { title: 'Nee' },
      { title: 'Weet ik niet' }],
    show_otherwise: false,
    section_end: false
  }, {
    id: :v39a,
    type: :radio,
    hidden: true,
    title: 'Waar had deze gebeurtenis mee te maken?',
    options: [
      { title: 'Met hem/haarzelf' },
      { title: 'Met zijn haar vriend(en) of vriendin(nen)' },
      { title: 'Met iets dat op school gebeurd is' },
      { title: 'Met zijn/haar ouders of familie' }],
    show_otherwise: true
  }, {
    id: :v40,
    type: :range,
    title: 'Mijn kind heeft het vandaag druk gehad.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v41,
    type: :range,
    title: 'Mijn kind was vandaag gemakkelijk in de omgang.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v42,
    type: :range,
    title: 'Mijn kind was vandaag overstuur.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v43,
    type: :range,
    title: 'Mijn kind maakte zich vandaag zorgen.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v44,
    type: :range,
    title: 'Mijn kind had vandaag lichamelijk ongemak (bijv. misselijk, pijn, duizelig).',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v45,
    type: :range,
    title: 'Mijn kind heeft de afgelopen nacht goed geslapen.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v46,
    type: :range,
    title: 'Mijn kind heeft vandaag goed gegeten.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over u en uw kind:',
    id: :v47,
    type: :range,
    title: 'Bent u tevreden met hoeveel tijd u vandaag samen met uw kind bent geweest?',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: false
  }, {
    id: :v48,
    type: :range,
    title: 'Ik had vandaag ruzie met mijn kind.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v49,
    type: :range,
    title: 'Ik ben vandaag boos geworden op mijn kind.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true
  }, {
    id: :v50,
    type: :range,
    title: 'Ik heb vandaag iets leuks gedaan met mijn kind (bijv. lezen, voetballen, muziek maken, koekjes bakken)',
    labels: ['Helemaal niet', 'Heel veel'],
    required: true
  }, {
    id: :v51,
    type: :range,
    title: 'Ik heb mijn kind vandaag getroost.',
    labels: ['Helemaal niet', 'Heel veel'],
    required: true
  }, {
    id: :v52,
    type: :range,
    title: 'Mijn kind en ik hebben elkaar vandaag geknuffeld.',
    labels: ['Helemaal niet', 'Heel veel'],
    required: true
  }, {
    id: :v53,
    type: :range,
    title: 'Ik heb me vandaag zorgen gemaakt over mijn kind.',
    labels: ['Helemaal niet', 'Heel veel'],
    required: true
  }, {
    id: :v54,
    type: :range,
    title: 'Ik moest vandaag mijn plannen veranderen vanwege het gedrag of de emoties van mijn kind.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: true
  }, {
    section_start: 'Tot slot...',
    id: :v55,
    type: :range,
    title: 'Vandaag was een leuke dag.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: false
  }, {
    id: :v56,
    type: :range,
    title: 'Ik kijk uit naar morgen.',
    labels: ['Helemaal niet', 'Heel erg'],
    required: true,
    section_end: true
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
