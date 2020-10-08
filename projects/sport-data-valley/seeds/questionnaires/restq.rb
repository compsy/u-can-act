db_title = 'RESTQ'

db_name1 = 'restq'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

def question(id, question_en, question_nl)
  return {
    id: id,
    type: 'likert',
    title: {
      en: question_en,
      nl: question_nl,
    },
    options: [{
      title: { en: 'Never', nl: 'Nooit' }
    }, {
      title: { en: 'Seldom', nl: 'Zelden' }
    }, {
      title: { en: 'Sometimes', nl: 'Soms' }
    }, {
      title: { en: 'Often', nl: 'Regelmatig' }
    }, {
      title: { en: 'More often', nl: 'Vaak' }
    }, {
      title: { en: 'Very often', nl: 'Heel vaak' }
    }, {
      title: { en: 'Always', nl: 'Altijd' }
    }]
  }
end

questionnaire_content = [{
  type: 'raw',
  content: {
    en: "<h2>Welcome to the Recovery-Stress Questionnaire (RESTQ)!</h2>\n<p class=\"flow-text\" style=\"font-size:medium;\">This questionnaire consists of a series of statements. These statements possibly describe your mental, emotional, or physical well-being or your activities during the past few days and nights.</p>",
    nl: "<h2>Welkom bij de Recovery-Stress Questionnaire (RESTQ)!</h2>\n<p class=\"flow-text\" style=\"font-size:medium;\">Deze vragenlijst bestaat uit een serie stellingen. Deze stellingen geven mogelijke weergaven van je mentaal, emotioneel en lichamelijk welzijn of van je activiteiten tijdens\nde laatste week.</p>"
  }
}, {
  id: :v1,
  type: :textfield,
  title: {en: 'Name:', nl: 'Naam:'}
}, {
  id: :v2,
  type: :number,
  title: {en: 'Age', nl: 'Leeftijd'},
  min: 0,
  max: 140
}, {
  id: :v3,
  type: :textfield,
  title: {en: 'Sport:', nl: 'Sport:'}
}, {
  id: :v4,
  type: :textfield,
  title: {en: 'Events:', nl: 'Onderdeel:'}
}, {
  id: :v5,
  type: :date,
  title: {en: 'Date', nl: 'Datum'}
}, {
  id: :v6,
  type: :time,
  title: {en: 'Time', nl: 'Tijd'},
  hours_from: 0,
  hours_to: 24
}, {
  type: :raw,
  content: {
    en: "<h3>Instruction</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\"> Please select the answer that most accurately reflects your thoughts and activities. Indicate how often each statement was right in your case in the past days. The statements related to performance should refer to performance during competition as well as during practice.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"> For each statement there are seven possible answers.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"> Please make your selection by marking the number corresponding to the appropriate answer.</p>",
    nl: "<h3>Instructie</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\"> Selecteer het antwoord dat het best past bij je gedachten en activiteiten. Geef aan hoe vaak een stelling waar was voor jou in de laatste paar dagen. De stellingen die verwijzen naar het sporten gaan zowel over wedstrijden als over trainingen.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"> Voor elke stelling zijn er zeven mogelijke antwoorden.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"> Beantwoord de vraag door het nummer van het best passende antwoord in te vullen.</p>"
  }
}, {
  type: :raw,
  content: {
    en: '<h4>Example</h4>',
    nl: '<h4>Voorbeeldvraag</h4>'
  }
},
  question(:v7, '...  I read the paper _very often_', '... heb ik de krant gelezen _heel vaak_'),
{
  type: :raw,
  content: {
    en: "<p class=\"flow-text\" style=\"font-size:medium;\"> In this example, the VERY OFTEN is marked. This means that you read a newspaper very often in the past week.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"> If you are unsure which answer to choose, select the one that most closely applies to you.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"> Please respond to the statements in order without interruption..</p>",
    nl: "<p class=\"flow-text\" style=\"font-size:medium;\"> In dit voorbeeld is HEEL VAAK ingevuld. Dit betekent, dat je heel vaak de krant hebt gelezen tijdens de afgelopen week.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"> Als je niet goed weet welk antwoord je moet kiezen, vul dan het antwoord in dat het meest op jou van toepassing is.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"> Beantwoord de vragen zonder onderbreking.</p>"
  }
}, {
  type: :raw,
  content: {
    en: '<h3>In the past week ...</h3>',
    nl: '<h3>Tijdens de afgelopen week ...</h3>'
  }
},
  question(:v8, '... I watched TV __', '... heb ik televisie gekeken __'),
  question(:v9, '... I did not get enough sleep __', '... heb ik niet genoeg geslapen __'),
  question(:v10, '... I finished important tasks __', '... heb ik belangrijke zaken afgerond __'),
  question(:v11, '... I was unable to concentrate well __', '... kon ik me niet goed concentreren __'),
  question(:v12, '...  everything bothered me __', '... stoorde ik me aan alles __'),
  question(:v13, '... I laughted __', '... heb ik gelachen __'),
  question(:v14, '... I felt physically bad __', '... voelde ik me lichamelijk slecht __'),
  question(:v15, '... I was in a bad mood __', '... was ik in een slechte stemming __'),
  question(:v16, '... I felt physically relaxed __', '... voelde ik me lichamelijk ontspannen __'),
  question(:v17, '... I was in good spirits __', '... was ik opgewekt __'),
  question(:v18, '... I had difficulties in concentrating __', '... had ik moeite mij te concentreren __'),
  question(:v19, '... I worried about unresolved problems __', '... maakte ik me zorgen over onopgeloste problemen __'),
  question(:v20, '... I felt at ease __', '... voelde ik me op mijn gemak __'),
  question(:v21, '... I had a good time with friends __', '... had ik lol met vrienden __'),
  question(:v22, '... I had a headache __', '... had ik hoofdpijn __'),
  question(:v23, '... I was tired from work __', '... was ik moe van mijn werk __'),
  question(:v24, '... I was successful in what I did __', '... lukten de dingen die ik deed __'),
  question(:v25, '... I couldn’t switch my mind off __', '... kon ik mijn hoofd niet leegmaken van gedachten __'),
  question(:v26, '... I fell asleep satisfied and relaxed __', '... viel ik tevreden en ontspannen in slaap __'),
  question(:v27, '... I felt uncomfortable __', '... voelde ik me NIET prettig __'),
  question(:v28, '... I was annoyed by others __', '... was ik geïrriteerd door anderen __'),
  question(:v29, '... I felt down __', '... voelde ik me somber __'),
  question(:v30, '... I visited some close friends __', '... ben ik bij goede vrienden op bezoek geweest __'),
  question(:v31, '... I felt depressed __', '... voelde ik me depressief __'),
  question(:v32, '... I was dead tired after work __', '... was ik doodmoe na mijn werk __'),
  question(:v33, '... other people got on my nerves __', '... werkten anderen op mijn zenuwen __'),
  question(:v34, '... I had a satisfying sleep __', '... heb ik goed geslapen __'),
  question(:v35, '... I felt anxious or inhibited __', '... voelde ik me gespannen of geremd __'),
  question(:v36, '... I felt physically fit __', '... voelde ik me lichamelijk fit __'),
  question(:v37, '... I was fed up with everything __', '... had ik overal genoeg van __'),
  question(:v38, '... I was lethargic __', '... had ik nergens zin in __'),
  question(:v39, '... I felt I had to perform well in front of others __', '... had ik het gevoel dat ik goed moest presteren in het bijzijn van anderen __'),
  question(:v40, '... I had fun __', '... had ik plezier __'),
  question(:v41, '... I was in a good mood __', '... was ik in een goede stemming __'),
  question(:v42, '... I was overtired __', '... was ik oververmoeid __'),
  question(:v43, '... I slept restlessly __', '... sliep ik onrustig __'),
  question(:v44, '... I was annoyed __', '... ergerde ik me __'),
  question(:v45, '... I felt as if I could get everything done __', '... voelde ik me alsof ik alles af kon krijgen __'),
  question(:v46, '... I was upset __', '... was ik van slag __'),
  question(:v47, '... I put off making decisions __', '... heb ik beslissingen voor me uit geschoven __'),
  question(:v48, '... I made important decisions __', '... heb ik in het dagelijks leven belangrijke beslissingen genomen __'),
  question(:v49, '... I felt physically exhausted __', '... voelde ik me lichamelijk uitgeput __'),
  question(:v50, '... I felt happy __', '... was ik blij __'),
  question(:v51, '... I felt under pressure __', '... voelde ik dat ik onder druk stond __'),
  question(:v52, '...  everything was too much for me __', '... was alles teveel voor me __'),
  question(:v53, '... my sleep was interrupted easily __', '... heb ik heel licht geslapen __'),
  question(:v54, '... I felt content __', '... voelde ik me tevreden __'),
  question(:v55, '... I was angry with someone __', '... was ik boos op iemand __'),
  question(:v56, '... I had some good ideas __', '... had ik een aantal goede ideeën __'),
  question(:v57, '... parts of my body were aching __', '... deden delen van mijn lichaam pijn __'),
  question(:v58, '... I could not get rest during the breaks __', '... kon ik tijdens de pauzes niet uitrusten __'),
  question(:v59, '... I was convinced I could achieve my set goals during performance __', '... was ik ervan overtuigd dat ik mijn doelen in de sport kon halen __'),
  question(:v60, '... I recovered well physically __', '... herstelde ik lichamelijk goed __'),
  question(:v61, '... I felt burned out by my sport __', '... voelde ik me opgebrand door mijn sport __'),
  question(:v62, '... I accomplished many worthwhile things in my sport __', '... heb ik veel waardevolle dingen bereikt in mijn sport __'),
  question(:v63, '... I prepared myself mentally for performance __', '... heb ik me mentaal op het sporten voorbereid __'),
  question(:v64, '... my muscles felt stiff or tense during performance __', '... voelden mijn spieren stijf of gespannen tijdens het sporten __'),
  question(:v65, '... I had the impression there were too few breaks __', '... had ik de indruk dat er te weinig pauzes waren __'),
  question(:v66, '... I was convinced that I could achieve my performance at any time __', '... was ik ervan overtuigd dat ik op ieder moment goed zou kunnen presteren __'),
  question(:v67, '... I dealt very effectively with my teammates’ problems __', '... kon ik goed omgaan met problemen van andere teamleden __'),
  question(:v68, '... I was in a good condition physically __', '... had ik een goede lichamelijke gesteldheid __'),
  question(:v69, '... I pushed myself during performance __', '... ben ik diep gegaan tijdens het sporten __'),
  question(:v70, '... I felt emotionally drained from performance __', '... voelde ik me emotioneel uitgeput van het sporten __'),
  question(:v71, '... I had muscle pain after performance __', '... had ik spierpijn na het sporten __'),
  question(:v72, '... I was convinced that I performed well __', '... was ik ervan overtuigd dat ik goed gepresteerd had tijdens het sporten __'),
  question(:v73, '... too much was demanded of me during the breaks __', '... werd er te veel van me gevraagd tijdens de pauzes __'),
  question(:v74, '... I psyched myself up before performance __', '... heb ik mezelf opgepept voor het sporten __'),
  question(:v75, '... I felt that I wanted to quit my sport __', '... had ik het gevoel dat ik met mijn sport wilde stoppen __'),
  question(:v76, '... I felt very energetic __', '... zat ik vol energie __'),
  question(:v77, '... I easily understood how my teammates felt about things __', '... kon ik goed begrijpen hoe andere teamleden over dingen dachten __'),
  question(:v78, '... I was convinced that I had trained well __', '... was ik ervan overtuigd dat ik goed getraind had __'),
  question(:v79, '... the breaks were not at the right times __', '... waren de pauzes niet op het goede moment __'),
  question(:v80, '... I felt vulnerable to injuries __', '... voelde ik me kwetsbaar voor blessures __'),
  question(:v81, '... I set definite goals for myself during performance __', '... heb ik mezelf duidelijke doelen gesteld tijdens het sporten __'),
  question(:v82, '... my body felt strong __', '... voelde mijn lichaam sterk __'),
  question(:v83, '... I felt frustrated by my sport __', '... voelde ik me gefrustreerd door mijn sport __'),
  question(:v84, '... I dealt with emotional problems in my sport very calmly __', '... kon ik heel kalm met emotionele problemen in mijn sport omgaan __'),
  {
    type: :raw,
    content: {en: '<h4>Thank you very much!</h4>', nl: '<h4>Bedankt voor het invullen!</h4>'}
  }
]

questionnaire.content = { questions: questionnaire_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
