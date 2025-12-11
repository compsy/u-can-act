# frozen_string_literal: true

# SportPro Weekly Logboek Questionnaire

db_title = 'SportPro wekelijks logboek'
questionnaire_key = 'sportpro_wekelijks_logboek'

db_name1 = 'SportPro Wekelijks Logboek'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.find_by(key: questionnaire_key)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = questionnaire_key

# Questionnaire content
sportpro_content = [
  {
    section_start: 'Activiteiten en tijdsbesteding',
    type: :raw,
    content: '<p>Welkom bij je wekelijkse Sportpro-logboek. Vul onderstaande vragen in over je werk van de afgelopen week.</p>'
  },
  {
    id: :hours_worked,
    type: :radio,
    title: '1. Hoeveel uur heb je ongeveer gewerkt deze week als sportpark- of verenigingsmanager?',
    options: [
      '<10',
      '10–19',
      '20–29',
      '30–39',
      '40+'
    ],
    show_otherwise: false
  },
  {
  id: :weekly_activities_intro,
  type: :raw,
  content: '<h5 class="flow-text" style="margin:0 0 .5rem;">2. Welke van onderstaande activiteiten heb je deze week binnen deze rol uitgevoerd? Geef daarna hieronder aan welk percentage van je totale werktijd in deze functie je hier deze week ongeveer aan hebt besteed.</h5>' \
},
{
  id: :act_activities,
  type: :checkbox,
  title: '',
  options: [{ title: 'Organiseren van activiteiten/evenementen', shows_questions: %i[perc_activities] }],
  show_otherwise: false
},
{
  id: :perc_activities,
  type: :range,
  title: '2. Percentage tijd besteed aan organiseren van activiteiten/evenementen:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :act_volunteers,
  type: :checkbox,
  title: '',
  options: [{ title: 'Ondersteunen van vrijwilligers', shows_questions: %i[perc_volunteers] }],
  show_otherwise: false
},
{
  id: :perc_volunteers,
  type: :range,
  title: '2. Percentage tijd besteed aan ondersteunen van vrijwilligers:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :act_board,
  type: :checkbox,
  title: '',
  options: [{ title: 'Ondersteunen van bestuur', shows_questions: %i[perc_board] }],
  show_otherwise: false
},
{
  id: :perc_board,
  type: :range,
  title: '2. Percentage tijd besteed aan ondersteunen van bestuur:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :act_facility,
  type: :checkbox,
  title: '',
  options: [{ title: 'Beheer/accommodatiezaken', shows_questions: %i[perc_facility] }],
  show_otherwise: false
},
{
  id: :perc_facility,
  type: :range,
  title: '2. Percentage tijd besteed aan beheer/accommodatiezaken:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :act_municipality,
  type: :checkbox,
  title: '',
  options: [{ title: 'Contact met gemeente', shows_questions: %i[perc_municipality] }],
  show_otherwise: false
},
{
  id: :perc_municipality,
  type: :range,
  title: '2. Percentage tijd besteed aan contact met gemeente:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :act_sportbond,
  type: :checkbox,
  title: '',
  options: [{ title: 'Contact met sportbond', shows_questions: %i[perc_sportbond] }],
  show_otherwise: false
},
{
  id: :perc_sportbond,
  type: :range,
  title: '2. Percentage tijd besteed aan contact met sportbond:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :act_social_orgs,
  type: :checkbox,
  title: '',
  options: [{ title: 'Samenwerking met maatschappelijke organisaties', shows_questions: %i[perc_social_orgs] }],
  show_otherwise: false
},
{
  id: :perc_social_orgs,
  type: :range,
  title: '2. Percentage tijd besteed aan samenwerking met maatschappelijke organisaties:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :act_communication,
  type: :checkbox,
  title: '',
  options: [{ title: 'Communicatie/PR/promotie', shows_questions: %i[perc_communication] }],
  show_otherwise: false
},
{
  id: :perc_communication,
  type: :range,
  title: '2. Percentage tijd besteed aan communicatie/PR/promotie:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :act_finance,
  type: :checkbox,
  title: '',
  options: [{ title: 'Financiën/fondsen/subsidies', shows_questions: %i[perc_finance] }],
  show_otherwise: false
},
{
  id: :perc_finance,
  type: :range,
  title: '2. Percentage tijd besteed aan financiën/fondsen/subsidies:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :act_cohesion,
  type: :checkbox,
  title: '',
  options: [{ title: 'Versterken van de sociale cohesie', shows_questions: %i[perc_cohesion] }],
  show_otherwise: false
},
{
  id: :perc_cohesion,
  type: :range,
  title: '2. Percentage tijd besteed aan versterken van de sociale cohesie:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :act_identity,
  type: :checkbox,
  title: '',
  options: [{ title: 'Versterken van de identiteit', shows_questions: %i[perc_identity] }],
  show_otherwise: false
},
{
  id: :perc_identity,
  type: :range,
  title: '2. Percentage tijd besteed aan versterken van de identiteit:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
{
  id: :perc_other,
  type: :range,
  title: '2. Percentage tijd besteed aan andere activiteiten:',
  labels: ['0%', '100%'],
  max: 100,
  hidden: true
},
  {
    id: :contact_parties,
    type: :checkbox,
    title: '3. Met welke partijen had je deze week contact? (meerdere antwoorden mogelijk)',
    options: [
      'Leden',
      'Vrijwilligers',
      'Bestuursleden',
      'Gemeente',
      'Sportbond',
      'Sportbedrijf/sportserviceorganisatie',
      'Commerciële aanbieders',
      'Scholen/onderwijs',
      'Zorg- of welzijnsorganisaties',
    ],
    show_otherwise: false
  },
  {
    id: :contact_other,
    type: :textarea,
    title: 'Specificeer andere contactpartijen:',
    hidden: true
  },
  {
    id: :contact_ranking,
    type: :textarea,
    title: '4. Als je terugkijkt op afgelopen week: met welke van de bij vraag 3 genoemde partijen had je het meeste contact, en met welke het minste? Zet ze in volgorde van meest naar minst contact.',
    tooltip: 'Bijvoorbeeld: 1. Vrijwilligers, 2. Leden, 3. Gemeente, etc.'
  },

  # Challenging activities section
{
  id: :challenging_activities,
  type: :expandable,
  section_start: 'Uitdagende situaties',
  title: '5. Wat was/waren voor jou de meest uitdagende situatie(s) deze week? Dit kan gelinkt zijn aan de bovenstaande activiteiten en/of partijen, maar kan ook een andere situatie zijn.' \
         '(Kies minimaal 1 en maximaal 3.)',
  add_button_label: 'Activiteit toevoegen',
  remove_button_label: 'Verwijder activiteit',
  default_expansions: 0, 
  max_expansions: 3,    
  content: [
    {
      section_start: '',
      id: :challenge_title,
      type: :textarea,
      required: true,
      title: 'Welke situatie was dit?',
      placeholder: 'Bijv. “Organiseren van activiteiten/evenementen”'
    },
    {
      id: :challenge_action,
      type: :textarea,
      required: true,
      title: 'Handelen: Beschrijf de concrete situatie uit je werk deze week die voor jou uitdagend was.',
      tooltip: 'Waarom deed je deze activiteit? Wat wilde je bereiken? Wie waren erbij? ' \
               'Welke vaardigheden heb je ingezet (communiceren/overtuigen, netwerken/verbinden, ' \
               'organiseren/plannen, financieel inzicht, leiderschap/aansturen, samenwerken, ' \
               'omgaan met weerstand/conflicten)?'
    },
    {
      id: :challenge_reflection,
      type: :textarea,
      title: 'Terugblikken: Wat gebeurde er precies in die situatie?',
      tooltip: 'Wat deed je? Wat wilde je? Wie nam het initiatief? Wat wilden/deden anderen? ' \
               'Hoe beïnvloedden anderen jouw reactie?'
    },
    {
      id: :challenge_awareness,
      type: :textarea,
      title: 'Bewustworden: Waarom handelde je zoals je handelde?',
      tooltip: 'Wat ging goed/minder goed? Waardoor kwam dat? Welke factoren speelden een rol? ' \
               'Waren je vaardigheden voldoende om dit te volbrengen?'
    },
    {
      id: :challenge_alternatives,
      type: :textarea,
      title: 'Alternatieven: Wat had je eventueel anders kunnen doen?',
      tooltip: 'Welke andere mogelijkheden had je? Voor- en nadelen? Welke vaardigheden/competenties ' \
               'zou je verder moeten ontwikkelen?'
    },
    {
      id: :challenge_learning,
      type: :textarea,
      title: 'Uitproberen: Wat neem je mee uit deze situatie voor een volgende keer?'
    },
    {
      id: :challenge_frequency,
      type: :radio,
      title: 'Is deze activiteit uitzonderlijk of veelvoorkomend binnen jouw functie?',
      options: ['Uitzonderlijk', 'Veelvoorkomend'],
      show_otherwise: false
    }
  ],
  section_end: true
},
  {
    section_start: 'Uitdagende activiteit 3',
    id: :challenge_3,
    hidden: true,
    type: :raw,
    content: '<p class="flow-text section-explanation">Beschrijf de derde uitdagende activiteit:</p>'
  },
  {
    id: :challenge_3_title,
    type: :textarea,
    title: 'Welke activiteit was dit? (Kopieer de naam uit vraag 5)',
    hidden: true
  },
  {
    id: :challenge_3_action,
    type: :textarea,
    title: 'Handelen: Beschrijf de concrete situatie uit je werk deze week die voor jou uitdagend was.',
    tooltip: 'Bijvoorbeeld: Waarom deed je deze activiteit? Wat wilde je bereiken? Wie waren hierbij aanwezig? Welke vaardigheden heb jij ingezet, denk aan: communiceren / overtuigen, netwerken / verbinden, organiseren / plannen, financieel inzicht, leiderschap / aansturen, samenwerken, omgaan met weerstand/conflicten',
    hidden: true
  },
  {
    id: :challenge_3_reflection,
    type: :textarea,
    title: 'Terugblikken: Wat gebeurde er precies in die situatie?',
    tooltip: 'Bijvoorbeeld: Wat deed je? Wat wilde je? Wie nam het initiatief voor deze activiteit/situatie? Wat wilden of deden anderen? Hoe beïnvloedde anderen jouw reactie?',
    hidden: true
  },
  {
    id: :challenge_3_awareness,
    type: :textarea,
    title: 'Bewustworden: Waarom handelde je zoals je handelde?',
    tooltip: 'Bijvoorbeeld: Wat ging goed en wat ging minder goed? Waardoor kwam dat? Welke factoren speelden een rol in mijn handelen? Waren mijn vaardigheden voldoende om deze situatie te volbrengen?',
    hidden: true
  },
  {
    id: :challenge_3_alternatives,
    type: :textarea,
    title: 'Alternatieven: Wat had je eventueel anders kunnen doen in die situatie?',
    tooltip: 'Welke andere mogelijkheden had je gehad? Welke voor- en nadelen hebben die? Welke vaardigheden en competenties zou je hiervoor verder moeten ontwikkelen?',
    hidden: true
  },
  {
    id: :challenge_3_learning,
    type: :textarea,
    title: 'Uitproberen: Wat neem je mee uit deze situatie voor een volgende keer?',
    hidden: true
  },
  {
    id: :challenge_3_frequency,
    type: :radio,
    title: 'Is deze activiteit een uitzonderlijke of veelvoorkomende activiteit binnen jouw functie als sportpark-/verenigingsmanager?',
    options: [
      'Uitzonderlijk',
      'Veelvoorkomend'
    ],
    show_otherwise: false,
    hidden: true,
    section_end: true
  },
  {
    section_start: 'Overige werkzaamheden deze week',
    type: :raw,
    content: '<p></p>'
  },
  {
    id: :insufficient_time,
    type: :textarea,
    title: '6. Waar had je deze week te weinig tijd voor?'
  },
  {
    id: :obstacles,
    type: :textarea,
    title: '7. Welke andere knelpunten of belemmeringen kwam je deze week tegen?'
  },
  {
    id: :skills_needed,
    type: :textarea,
    title: '8. Waar had je deze week meer kennis of vaardigheden in willen hebben?'
  },
  {
    id: :success_experience,
    type: :textarea,
    title: '9. Welke succeservaring had je deze week?'
  },
  {
    id: :takeaways,
    type: :textarea,
    title: '10. Wat neem je mee uit deze week naar de volgende?',
    section_end: true
  }
]
questionnaire.content = { questions: sportpro_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!