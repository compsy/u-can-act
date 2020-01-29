# frozen_string_literal: true

title = 'India'

name = 'KCT India'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title, section_end: false)
  res = {
    id: id,
    type: :likert,
    title: title,
    show_otherwise: false,
    options: [
      'Zeer mee oneens',
      'Oneens',
      'Noch mee eens, noch mee oneens',
      'Mee eens',
      'Zeer mee eens',
    ]
  }
  res[:section_end] = true if section_end
  res
end

content = [
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">Geef een antwoord op onderstaande
        vragen door één van de antwoorden aan te klikken.
    </p>
    <p class="flow-text section-explanation">Geef nauwkeurig antwoord en overweeg
        hoe je over het algemeen op de betreffende stelling reageert. Besteed niet
        teveel tijd per vraag. De vragenlijst helemaal invullen duurt ongeveer 7
        minuten.
    </p>'
  },
  create_question(:v1, 'Ik vind meestal wel iets om me te motiveren'),
  create_question(:v2, 'Over het algemeen vind ik dat ik alles onder controle heb'),
  create_question(:v3, 'Ik vind dat ik over het algemeen een waardevol persoon ben'),
  create_question(:v4, 'Uitdagingen brengen gewoonlijk het beste in mij naar boven'),
  create_question(:v5, 'Als ik met andere mensen werk ben ik meestal invloedrijk'),
  create_question(:v6, 'Onverwachte veranderingen in mijn planning brengen me over het algemeen van de wijs'),
  create_question(:v7, 'Ik geef meestal niet op onder druk'),
  create_question(:v8, 'Ik heb over het algemeen veel vertrouwen in mijn eigen bekwaamheden'),
  create_question(:v9, 'Ik doe dingen meestal plichtsmatig'),
  create_question(:v10, 'Ik verwacht dat dingen soms verkeerd gaan'),
  create_question(:v11, 'Ik heb vaak een gevoel van \'ik weet niet waarmee te beginnen\' wanneer ik verschillende dingen op hetzelfde moment moet doen'),
  create_question(:v12, 'Ik heb meestal het gevoel dat ik controle heb over de dingen die gebeuren in mijn leven'),
  create_question(:v13, 'Hoe slecht dingen ook zijn ik heb meestal het gevoel dat ze positief aflopen'),
  create_question(:v14, 'Ik wens vaak dat mijn leven meer voorspelbaar was'),
  create_question(:v15, 'Als ik dingen plan zijn er vaak onvoorziene zaken/factoren die het verpesten'),
  create_question(:v16, 'Ik zie het leven meestal van de zonnige kant'),
  create_question(:v17, 'Ik zeg meestal mijn mening als ik iets wil zeggen'),
  create_question(:v18, 'Af en toe voel ik me compleet waardeloos'),
  create_question(:v19, 'Als me een taak wordt gegeven kan men er meestal op vertrouwen dat ik het uitvoer'),
  create_question(:v20, 'Ik neem meestal het initiatief in een situatie wanneer ik denk dat het nodig is'),
  create_question(:v21, 'Ik vind het over het algemeen moeilijk om te ontspannen'),
  create_question(:v22, 'Ik ben gemakkelijk afgeleid van taken waar ik mee bezig ben'),
  create_question(:v23, 'Ik weet meestal goed om te gaan met problemen die zich voordoen'),
  create_question(:v24, 'Ik bekritiseer mezelf zelden zelfs als dingen verkeerd gaan'),
  create_question(:v25, 'Ik geef me meestal voor de volle 100%'),
  create_question(:v26, 'Ik laat anderen meestal weten wanneer ik overstuur ben of geïrriteerd'),
  create_question(:v27, 'Ik maak me meestal van te voren druk over dingen die nog moeten gebeuren'),
  create_question(:v28, 'Ik voel me vaak ongemakkelijk tijdens sociale bijeenkomsten'),
  create_question(:v29, 'Als ik moeilijkheden tegen kom geef ik meestal op'),
  create_question(:v30, 'Ik ben meestal in staat vlug te reageren wanneer er onverwachte dingen gebeuren'),
  create_question(:v31, 'Zelfs onder aanzienlijke druk blijf ik meestal kalm'),
  create_question(:v32, 'Als er dingen verkeerd kunnen gaan, gaan ze meestal ook verkeerd'),
  create_question(:v33, 'Vaak overkomen dingen me gewoon'),
  create_question(:v34, 'Ik laat mijn gevoelens over het algemeen niet zien'),
  create_question(:v35, 'Ik vind het vaak moeilijk om een mentale inspanning te verrichten wanneer ik moe ben'),
  create_question(:v36, 'Als ik fouten maak, dan maak ik me daar nog dagen zorgen over'),
  create_question(:v37, 'Als ik moe ben, vind ik het moeilijk om door te gaan'),
  create_question(:v38, 'Ik vind het gemakkelijk om mensen te vertellen wat te doen'),
  create_question(:v39, 'Ik kan meestal een hoog niveau van mentale inspanning voor een langere tijd vasthouden'),
  create_question(:v40, 'Ik kijk meestal uit naar veranderingen in mijn routine'),
  create_question(:v41, 'Ik heb het idee dat wat ik doe geen verschil maakt'),
  create_question(:v42, 'Ik ben bijna nooit enthousiast voor de taken die ik moet doen'),
  create_question(:v43, 'Als ik vind dat iemand geen gelijk heeft, dan ben ik niet bang om met deze persoon hierover in discussie te gaan'),
  create_question(:v44, 'Ik hou meestal van een uitdaging'),
  create_question(:v45, 'Ik heb meestal mijn zenuwen onder controle'),
  create_question(:v46, 'In discussies geef ik meestal toe, zelfs wanneer ik een duidelijke mening heb'),
  create_question(:v47, 'Bij tegenslag vind ik het meestal moeilijk om vast te houden aan mijn doel'),
  create_question(:v48, 'Ik kan me meestal aanpassen aan uitdagingen die ik op mijn weg tegenkom')
]
questionnaire.content = content
questionnaire.title = title
questionnaire.save!
