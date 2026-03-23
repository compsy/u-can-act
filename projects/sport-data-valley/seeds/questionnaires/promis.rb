# frozen_string_literal: true

db_title = ''

questionnaire_key = File.basename(__FILE__)[0...-3]
db_name1 = questionnaire_key
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = questionnaire_key if questionnaire.key.blank?

dagboek_content = [
  # ===========================================================================
  # Section 1: Algemeen (Global01 + Global02)
  # ===========================================================================
  {
    type: :raw,
    content: { nl: '<h4>Algemeen</h4>', en: '<h4>General</h4>' }
  },
  {
    id: :global01,
    title: { nl: 'Hoe vindt u over het algemeen uw gezondheid?',
             en: 'In general, how would you rate your health?' },
    type: :likert,
    options: [
      { nl: 'Uitstekend', en: 'Excellent' },
      { nl: 'Heel goed', en: 'Very good' },
      { nl: 'Goed', en: 'Good' },
      { nl: 'Redelijk', en: 'Fair' },
      { nl: 'Slecht', en: 'Poor' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :global02,
    title: { nl: 'Hoe vindt u over het algemeen uw kwaliteit van leven?',
             en: 'In general, how would you rate your quality of life?' },
    type: :likert,
    options: [
      { nl: 'Uitstekend', en: 'Excellent' },
      { nl: 'Heel goed', en: 'Very good' },
      { nl: 'Goed', en: 'Good' },
      { nl: 'Redelijk', en: 'Fair' },
      { nl: 'Slecht', en: 'Poor' }
    ],
    required: true,
    show_otherwise: false
  },

  # ===========================================================================
  # Section 2: Fysieke gezondheid (Physical Function 8b)
  # ===========================================================================
  {
    type: :raw,
    content: { nl: '<h4>Fysieke gezondheid</h4>',
               en: '<h4>Physical health</h4>' }
  },
  {
    id: :pfa11,
    title: { nl: 'Kunt u klusjes doen zoals stofzuigen of in de tuin werken?',
             en: 'Are you able to do chores such as vacuuming or yard work?' },
    type: :likert,
    options: [
      { nl: 'Zonder moeite', en: 'Without any difficulty' },
      { nl: 'Met een beetje moeite', en: 'With a little difficulty' },
      { nl: 'Met enige moeite', en: 'With some difficulty' },
      { nl: 'Met veel moeite', en: 'With much difficulty' },
      { nl: 'Kan het niet', en: 'Unable to do' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :pfa21,
    title: { nl: 'Kunt u in een normaal tempo trappen op en afgaan?',
             en: 'Are you able to go up and down stairs at a normal pace?' },
    type: :likert,
    options: [
      { nl: 'Zonder moeite', en: 'Without any difficulty' },
      { nl: 'Met een beetje moeite', en: 'With a little difficulty' },
      { nl: 'Met enige moeite', en: 'With some difficulty' },
      { nl: 'Met veel moeite', en: 'With much difficulty' },
      { nl: 'Kan het niet', en: 'Unable to do' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :pfa23,
    title: { nl: 'Kunt u een wandeling van ten minste 15 minuten maken?',
             en: 'Are you able to go for a walk of at least 15 minutes?' },
    type: :likert,
    options: [
      { nl: 'Zonder moeite', en: 'Without any difficulty' },
      { nl: 'Met een beetje moeite', en: 'With a little difficulty' },
      { nl: 'Met enige moeite', en: 'With some difficulty' },
      { nl: 'Met veel moeite', en: 'With much difficulty' },
      { nl: 'Kan het niet', en: 'Unable to do' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :pfa53,
    title: { nl: 'Kunt u boodschappen doen en winkelen?',
             en: 'Are you able to run errands and shop?' },
    type: :likert,
    options: [
      { nl: 'Zonder moeite', en: 'Without any difficulty' },
      { nl: 'Met een beetje moeite', en: 'With a little difficulty' },
      { nl: 'Met enige moeite', en: 'With some difficulty' },
      { nl: 'Met veel moeite', en: 'With much difficulty' },
      { nl: 'Kan het niet', en: 'Unable to do' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :pfc12,
    title: { nl: 'Wordt u door uw gezondheid op dit moment beperkt in het verrichten van twee uur lichamelijke arbeid?',
             en: 'Does your health now limit you in doing two hours of physical labor?' },
    type: :likert,
    options: [
      { nl: 'Helemaal niet', en: 'Not at all' },
      { nl: 'Heel weinig', en: 'Very little' },
      { nl: 'Enigszins', en: 'Somewhat' },
      { nl: 'Behoorlijk', en: 'Quite a lot' },
      { nl: 'Kan het niet', en: 'Cannot do' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :pfb1,
    title: { nl: 'Wordt u door uw gezondheid op dit moment beperkt in het uitvoeren van matig zwaar werk in en om het huis, zoals stofzuigen, vloeren vegen of boodschappen naar binnen dragen?',
             en: 'Does your health now limit you in doing moderate work around the house, like vacuuming, sweeping floors or carrying in groceries?' },
    type: :likert,
    options: [
      { nl: 'Helemaal niet', en: 'Not at all' },
      { nl: 'Heel weinig', en: 'Very little' },
      { nl: 'Enigszins', en: 'Somewhat' },
      { nl: 'Behoorlijk', en: 'Quite a lot' },
      { nl: 'Kan het niet', en: 'Cannot do' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :pfa5,
    title: { nl: 'Wordt u door uw gezondheid op dit moment beperkt in het tillen of dragen van boodschappen?',
             en: 'Does your health now limit you in lifting or carrying groceries?' },
    type: :likert,
    options: [
      { nl: 'Helemaal niet', en: 'Not at all' },
      { nl: 'Heel weinig', en: 'Very little' },
      { nl: 'Enigszins', en: 'Somewhat' },
      { nl: 'Behoorlijk', en: 'Quite a lot' },
      { nl: 'Kan het niet', en: 'Cannot do' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :pfa4,
    title: { nl: 'Wordt u door uw gezondheid op dit moment beperkt in het uitvoeren van zwaar werk in en om het huis, zoals vloeren schrobben, of tillen of verplaatsen van zware meubels?',
             en: 'Does your health now limit you in doing heavy work around the house like scrubbing floors, or lifting or moving heavy furniture?' },
    type: :likert,
    options: [
      { nl: 'Helemaal niet', en: 'Not at all' },
      { nl: 'Heel weinig', en: 'Very little' },
      { nl: 'Enigszins', en: 'Somewhat' },
      { nl: 'Behoorlijk', en: 'Quite a lot' },
      { nl: 'Kan het niet', en: 'Cannot do' }
    ],
    required: true,
    show_otherwise: false
  },

  # ===========================================================================
  # Section 3: Mentale gezondheid (Depression 4a)
  # ===========================================================================
  {
    type: :raw,
    content: { nl: '<h4>Mentale gezondheid</h4>',
               en: '<h4>Mental health</h4>' }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Geef a.u.b. antwoord voor de afgelopen 7 dagen.</p>',
               en: '<p class="flow-text">Please respond for the past 7 days.</p>' }
  },
  {
    id: :eddep04,
    title: { nl: 'Ik voelde me alsof ik niets waard was.',
             en: 'I felt worthless.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Vaak', en: 'Often' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :eddep06,
    title: { nl: 'Ik voelde me hulpeloos.',
             en: 'I felt helpless.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Vaak', en: 'Often' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :eddep29,
    title: { nl: 'Ik voelde me depressief.',
             en: 'I felt depressed.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Vaak', en: 'Often' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :eddep41,
    title: { nl: 'Ik voelde me zonder hoop.',
             en: 'I felt hopeless.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Vaak', en: 'Often' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },

  # ===========================================================================
  # Section 4: Sociale activiteiten / rollen (Social Roles and Activities 4a)
  # ===========================================================================
  {
    type: :raw,
    content: { nl: '<h4>Sociale activiteiten / rollen</h4>',
               en: '<h4>Social activities / roles</h4>' }
  },
  {
    id: :srpper11,
    title: { nl: 'Ik heb moeite om al mijn gewone vrijetijdsactiviteiten met anderen te doen.',
             en: 'I have trouble doing all of my regular leisure activities with others.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Meestal', en: 'Usually' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :srpper18,
    title: { nl: 'Ik heb moeite om alle gezins-/familieactiviteiten te doen die ik wil doen.',
             en: 'I have trouble doing all of the family activities that I want to do.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Meestal', en: 'Usually' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :srpper23,
    title: { nl: 'Ik heb moeite om al mijn gewone werk (inclusief werk thuis) te doen.',
             en: 'I have trouble doing all of my usual work (include work at home).' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Meestal', en: 'Usually' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :srpper46,
    title: { nl: 'Ik heb moeite om alle activiteiten met vrienden te doen die ik wil doen.',
             en: 'I have trouble doing all of the activities with friends that I want to do.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Meestal', en: 'Usually' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },

  # ===========================================================================
  # Section 5: Pijn (Pain Intensity 1a)
  # ===========================================================================
  {
    type: :raw,
    content: { nl: '<h4>Pijn</h4>',
               en: '<h4>Pain</h4>' }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Geef a.u.b. antwoord voor de afgelopen 7 dagen.</p>',
               en: '<p class="flow-text">Please respond for the past 7 days.</p>' }
  },
  {
    id: :global07,
    title: { nl: 'Hoe zou u gemiddeld uw pijn beoordelen? (0 = Geen pijn, 10 = Ergst denkbare pijn)',
             en: 'How would you rate your pain on average? (0 = No pain, 10 = Worst imaginable pain)' },
    type: :range,
    min: 0,
    max: 10,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      { nl: '', en: '' },
      { nl: '', en: '' },
      { nl: '', en: '' },
      { nl: '', en: '' },
      { nl: '', en: '' },
      { nl: '', en: '' },
      { nl: '', en: '' },
      { nl: '', en: '' },
      { nl: '', en: '' },
      { nl: '', en: '' },
      { nl: '', en: '' }
    ]
  },

  # ===========================================================================
  # Section 6: Vermoeidheid (Fatigue 4a)
  # ===========================================================================
  {
    type: :raw,
    content: { nl: '<h4>Vermoeidheid</h4>',
               en: '<h4>Fatigue</h4>' }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Geef a.u.b. antwoord voor de afgelopen 7 dagen.</p>',
               en: '<p class="flow-text">Please respond for the past 7 days.</p>' }
  },
  {
    id: :hi7,
    title: { nl: 'Ik heb last van vermoeidheid.',
             en: 'I feel fatigued.' },
    type: :likert,
    options: [
      { nl: 'Helemaal niet', en: 'Not at all' },
      { nl: 'Een beetje', en: 'A little bit' },
      { nl: 'Enigszins', en: 'Somewhat' },
      { nl: 'In vrij hoge mate', en: 'Quite a bit' },
      { nl: 'In zeer hoge mate', en: 'Very much' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :an3,
    title: { nl: 'Het kost me moeite om met dingen te <u>beginnen</u> omdat ik zo moe ben.',
              en: 'I have trouble starting things because I am tired.' },
    type: :likert,
    options: [
      { nl: 'Helemaal niet', en: 'Not at all' },
      { nl: 'Een beetje', en: 'A little bit' },
      { nl: 'Enigszins', en: 'Somewhat' },
      { nl: 'In vrij hoge mate', en: 'Quite a bit' },
      { nl: 'In zeer hoge mate', en: 'Very much' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :fatexp41,
    title: { nl: 'Hoe afgepeigerd voelde u zich gemiddeld genomen?',
             en: 'How run-down did you feel on average?' },
    type: :likert,
    options: [
      { nl: 'Helemaal niet', en: 'Not at all' },
      { nl: 'Een beetje', en: 'A little bit' },
      { nl: 'Enigszins', en: 'Somewhat' },
      { nl: 'Behoorlijk', en: 'Quite a bit' },
      { nl: 'Heel erg', en: 'Very much' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :fatexp40,
    title: { nl: 'Hoe vermoeid was u gemiddeld genomen?',
             en: 'How fatigued were you on average?' },
    type: :likert,
    options: [
      { nl: 'Helemaal niet', en: 'Not at all' },
      { nl: 'Een beetje', en: 'A little bit' },
      { nl: 'Enigszins', en: 'Somewhat' },
      { nl: 'Behoorlijk', en: 'Quite a bit' },
      { nl: 'Heel erg', en: 'Very much' }
    ],
    required: true,
    show_otherwise: false
  },

  # ===========================================================================
  # Section 7: Emotionele problemen (Anxiety 4a)
  # ===========================================================================
  {
    type: :raw,
    content: { nl: '<h4>Emotionele problemen</h4>',
               en: '<h4>Emotional problems</h4>' }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">Geef a.u.b. antwoord voor de afgelopen 7 dagen.</p>',
               en: '<p class="flow-text">Please respond for the past 7 days.</p>' }
  },
  {
    id: :edanx01,
    title: { nl: 'Ik voelde me angstig.',
             en: 'I felt fearful.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Vaak', en: 'Often' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :edanx40,
    title: { nl: 'Ik vond het moeilijk om me op iets anders dan mijn angst en bezorgdheid te concentreren.',
             en: 'I found it hard to focus on anything other than my anxiety.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Vaak', en: 'Often' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :edanx41,
    title: { nl: 'Mijn zorgen waren me te veel.',
             en: 'My worries overwhelmed me.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Vaak', en: 'Often' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :edanx53,
    title: { nl: 'Ik voelde me slecht op mijn gemak.',
             en: 'I felt uneasy.' },
    type: :likert,
    options: [
      { nl: 'Nooit', en: 'Never' },
      { nl: 'Zelden', en: 'Rarely' },
      { nl: 'Soms', en: 'Sometimes' },
      { nl: 'Vaak', en: 'Often' },
      { nl: 'Altijd', en: 'Always' }
    ],
    required: true,
    show_otherwise: false
  }
]

questionnaire.content = {
  questions: dagboek_content,
  scores: []
}
questionnaire.title = db_title
questionnaire.save!
