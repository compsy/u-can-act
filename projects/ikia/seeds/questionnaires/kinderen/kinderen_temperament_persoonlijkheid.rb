# frozen_string_literal: true

db_title = 'Persoonlijkheid'

db_name1 = 'EATQ-R'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Hieronder staan 65 uitspraken die je kunt gebruiken om jezelf te beschrijven.<br>
We willen graag dat je voor elke uitspraak invult of de uitspraak waar is voor jou.<br>
Lees iedere uitspraak goed en kies dan het antwoord dat <u>het beste bij jou past</u>.<br>
Er zijn geen goede of foute antwoorden.<br><br>

Hoe waar is elke uitspraak voor jou?</p>'
  }, {
    id: :v1,
    type: :likert,
    title: 'Ik vind het makkelijk om mijn gedachten goed bij mijn huiswerk te houden (huiswerk is thuis een
opdracht maken voor school, bijvoorbeeld een toets leren of een spreekbeurt maken)',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v2,
    type: :likert,
    title: 'Het grootste deel van de dag voel ik me wel gelukkig',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v3,
    type: :likert,
    title: 'Ik zou het spannend vinden om naar een nieuwe plaats te verhuizen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v4,
    type: :likert,
    title: 'Ik vind het fijn om een warme wind in mijn gezicht te voelen waaien',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v5,
    type: :likert,
    title: 'Als ik kwaad ben op iemand, zeg ik vaak dingen waarvan ik weet dat ze pijn doen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v6,
    type: :likert,
    title: 'Ik zie het vaak als er iets kleins verandert om me heen, zoals wanneer het lichter wordt in een kamer door de zon',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v7,
    type: :likert,
    title: 'Het kost me veel moeite om dingen op tijd af te krijgen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v8,
    type: :likert,
    title: 'Als je een jongen bent kies dan deze uitspraak:<br>
Ik voel me verlegen bij meisjes<br>
Als je een meisje bent kies dan deze uitspraak:<br>
Ik voel me verlegen bij jongens',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v9,
    type: :likert,
    title: 'Als ik boos ben gooi ik met dingen of maak ik dingen kapot',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v10,
    type: :likert,
    title: 'Ik vind het moeilijk om een cadeautje pas uit te pakken als het mag',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v11,
    type: :likert,
    title: 'Ik denk dat mijn vrienden of vriendinnen vaker plezier hebben dan ik',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v12,
    type: :likert,
    title: 'Kleine veranderingen die andere mensen niet zien, zie ik meestal wel',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v13,
    type: :likert,
    title: 'Als ik echt kwaad word op iemand, zou ik hem/haar kunnen slaan',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v14,
    type: :likert,
    title: 'Als iemand zegt dat ik ergens mee moet stoppen, lukt me dat makkelijk',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v15,
    type: :likert,
    title: 'Ik voel me verlegen als ik nieuwe mensen ontmoet ',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v16,
    type: :likert,
    title: 'Ik vind het fijn om naar het fluiten van de vogels te luisteren',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v17,
    type: :likert,
    title: 'Ik wil met iemand over alles kunnen praten wat ik denk',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v18,
    type: :likert,
    title: 'Voordat ik aan mijn huiswerk begin doe ik eerst een tijdje iets leuks, zelfs als dat eigenlijk niet de bedoeling is',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v19,
    type: :likert,
    title: 'Ik zou het naar vinden om in een hele grote stad te wonen, ook al is het daar veilig',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v20,
    type: :likert,
    title: 'Ik heb al snel het gevoel dat ik moet huilen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v21,
    type: :likert,
    title: 'Ik merk geluiden om me heen eerder op dan andere mensen (zoals het tikken van de klok, de kraan die drupt enzovoort)',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v22,
    type: :likert,
    title: 'Ik ben vaak onbeleefd tegen mensen die ik niet aardig vind',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v23,
    type: :likert,
    title: 'Ik kijk graag naar de vorm van de wolken in de lucht',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v24,
    type: :likert,
    title: 'Als iemand boos is zie ik dat meteen aan zijn of haar gezicht',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v25,
    type: :likert,
    title: 'Ik baal ervan als ik iemand probeer te bellen die in gesprek is',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v26,
    type: :likert,
    title: 'Hoe meer ik mijn best doe om geen verkeerde dingen te doen, hoe groter de kans dat ik die dingen toch doe',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v27,
    type: :likert,
    title: 'Ik vind het fijn om mensen die ik aardig vind te knuffelen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v28,
    type: :likert,
    title: 'Snel van een steile berghelling naar beneden skiën lijkt me eng',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v29,
    type: :likert,
    title: 'Ik ben vaker verdrietig dan andere mensen weten',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v30,
    type: :likert,
    title: 'Als ik een moeilijke taak moet doen, begin ik er gelijk aan',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v31,
    type: :likert,
    title: 'Als ik iemand aardig vind zal ik bijna alles doen om hem of haar te helpen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v32,
    type: :likert,
    title: 'Ik word erg bang als ik bij iemand in de auto zit die graag hard rijdt',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v33,
    type: :likert,
    title: 'Ik vind het fijn om naar de bomen te kijken en er tussendoor te lopen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v34,
    type: :likert,
    title: 'Ik vind het moeilijk op school om van de ene les op de andere les over te schakelen (bijvoorbeeld eerst rekenen, dan taal)',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v35,
    type: :likert,
    title: 'Ik maak me zorgen over ons gezin als ik niet bij hen ben',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v36,
    type: :likert,
    title: 'Ik raak erg van streek als ik iets wil doen en mijn vader of moeder zegt nee',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v37,
    type: :likert,
    title: 'Ik word verdrietig als veel dingen fout gaan',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v38,
    type: :likert,
    title: 'Als ik probeer mijn aandacht bij mijn schoolwerk te houden, word ik snel afgeleid door geluiden om me heen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v39,
    type: :likert,
    title: 'Ik heb mijn huiswerk eerder af dan nodig is',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v40,
    type: :likert,
    title: 'Ik maak me zorgen dat ik in moeilijkheden zal raken',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v41,
    type: :likert,
    title: 'Ik kan goed verschillende dingen die om me heen gebeuren in de gaten houden',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v42,
    type: :likert,
    title: 'Ik durf best een gevaarlijke sport uit te proberen, zoals diepzeeduiken',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v43,
    type: :likert,
    title: 'Ik kan makkelijk een geheim bewaren',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v44,
    type: :likert,
    title: 'Het is belangrijk voor mij om goede vrienden te hebben',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v45,
    type: :likert,
    title: 'Ik ben verlegen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v46,
    type: :likert,
    title: 'Ik ben bang voor kinderen/jongeren op school die je tegen de muur aanduwen of met je boeken gooien',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v47,
    type: :likert,
    title: 'Ik raak uit mijn humeur als ik moet stoppen met iets wat ik leuk vind',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v48,
    type: :likert,
    title: 'Ik zou zonder bang te zijn dingen zoals berg-beklimmen uitproberen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v49,
    type: :likert,
    title: 'Ik stel dingen die ik moet doen uit tot het laatste moment',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v50,
    type: :likert,
    title: 'Als ik echt kwaad ben op een vriend of vriendin barst ik vaak in woede uit',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v51,
    type: :likert,
    title: 'Ik maak me zorgen dat mijn vader of moeder dood gaat of bij me weg gaat',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v52,
    type: :likert,
    title: 'Ik geniet ervan om naar plekken te gaan waar veel mensen zijn en waar veel spannende dingen gebeuren',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v53,
    type: :likert,
    title: 'Ik voel me op mijn gemak als ik andere mensen ontmoet',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v54,
    type: :likert,
    title: 'Ik ben best een aardig en vriendelijk persoon',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v55,
    type: :likert,
    title: 'Ik voel me verdrietig wanneer ik juist plezier zou moeten hebben, zoals met kerst of tijdens een uitje',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v56,
    type: :likert,
    title: 'Het ergert me vreselijk als ik lang in de rij moet staan',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v57,
    type: :likert,
    title: 'Ik voel me angstig als ik thuis een donkere kamer in ga',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v58,
    type: :likert,
    title: 'Ik pest anderen zonder dat er echt reden voor is',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v59,
    type: :likert,
    title: 'Ik let goed op als iemand me uitlegt hoe ik iets moet doen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v60,
    type: :likert,
    title: 'Ik baal er erg van als ik een fout maak in mijn schoolwerk',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v61,
    type: :likert,
    title: 'Als ik met iets bezig ben, stop ik vaak voordat het af is en ga dan iets anders doen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v62,
    type: :likert,
    title: 'Het stoort me erg als anderen mij onderbreken terwijl ik iets aan het vertellen ben',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v63,
    type: :likert,
    title: 'Als ik een plan heb hou ik net zolang vol tot ik mijn doel bereikt heb',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v64,
    type: :likert,
    title: 'Ik raak uit mijn humeur als het me niet lukt om een taak goed uit te voeren',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  }, {
    id: :v65,
    type: :likert,
    title: 'Ik vind het fijn om het ritselende geluid van herfstbladeren te horen',
    options: ['bijna nooit waar', 'meestal niet waar', 'soms waar, soms niet waar', 'meestal wel waar', 'bijna altijd waar']
  },
]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!
