# frozen_string_literal: true

db_title = ''

questionnaire_key = File.basename(__FILE__)[0...-3]
db_name1 = questionnaire_key
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = questionnaire_key if questionnaire.key.blank?

dagboek_content = [
  {
    type: :raw,
    content: { nl: '<h4>De Hartfalen Vragenlijst (Kansas City) (KCCQ-12)</h4>', en: '<h4>Kansas City Cardiomyopathy Questionnaire (KCCQ-12)</h4>' }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">De volgende vragen hebben betrekking op uw hartfalen en hoe dit uw leven kan beïnvloeden. Lees en beantwoord de volgende vragen. Er zijn geen juiste of foute antwoorden. Kruis het antwoord aan dat het beste bij u past.</p>',
               en: '<p class="flow-text">The following questions refer to your heart failure and how it may affect your life. Please read and complete the following questions. There are no right or wrong answers. Please mark the answer that best applies to you.</p>' }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">De volgende vragen hebben betrekking op uw hartfalen en hoe dit uw leven kan beïnvloeden. Lees en beantwoord de volgende vragen. Er zijn geen juiste of foute antwoorden. Kruis het antwoord aan dat het beste bij u past.</p>',
               en: '<p class="flow-text">The following questions refer to your heart failure and how it may affect your life. Please read and complete the following questions. There are no right or wrong answers. Please mark the answer that best applies to you.</p>' }
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">1. Hartfalen beïnvloedt verschillende mensen op verschillende manieren. Sommigen zijn voornamelijk kortademig, anderen voelen zich voornamelijk moe en lusteloos. Geef aan in welke mate hartfalen (bijvoorbeeld kortademigheid of vermoeidheid en lusteloosheid) u heeft beperkt in uw vermogen om de volgende bezigheden te doen gedurende de afgelopen 2 weken.</p>',
               en: '<p class="flow-text">1. Heart failure affects different people in different ways. Some feel shortness of breath while others feel fatigue. Please indicate how much you are limited by heart failure (shortness of breath or fatigue) in your ability to do the following activities over the past 2 weeks.</p>' }
  },
  {
    id: :v1a,
    title: { nl: 'Zich douchen/een bad nemen', en: 'Showering/Bathing' },
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      { nl: 'Heel erg beperkt', en: 'Extremely limited' },
      { nl: 'Vrij beperkt', en: 'Quite a bit limited' },
      { nl: 'Matig beperkt', en: 'Moderately limited' },
      { nl: 'Een klein beetje beperkt', en: 'Slightly limited' },
      { nl: 'Helemaal niet beperkt', en: 'Not at all limited' },
      { nl: 'Om andere redenen beperkt of heb de bezigheid niet gedaan', en: 'Limited for other reasons or did not do the activity' }
    ]
  },
  {
    id: :v1b,
    title: { nl: 'Ongeveer honderd meter op vlakke grond lopen', en: 'Walking 1 block on level ground' },
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      { nl: 'Heel erg beperkt', en: 'Extremely limited' },
      { nl: 'Vrij beperkt', en: 'Quite a bit limited' },
      { nl: 'Matig beperkt', en: 'Moderately limited' },
      { nl: 'Een klein beetje beperkt', en: 'Slightly limited' },
      { nl: 'Helemaal niet beperkt', en: 'Not at all limited' },
      { nl: 'Om andere redenen beperkt of heb de bezigheid niet gedaan', en: 'Limited for other reasons or did not do the activity' }
    ]
  },
  {
    id: :v1c,
    title: { nl: 'Rennen of zich haasten (bijvoorbeeld om een bus te halen)', en: 'Hurrying or jogging (as if to catch a bus)' },
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      { nl: 'Heel erg beperkt', en: 'Extremely limited' },
      { nl: 'Vrij beperkt', en: 'Quite a bit limited' },
      { nl: 'Matig beperkt', en: 'Moderately limited' },
      { nl: 'Een klein beetje beperkt', en: 'Slightly limited' },
      { nl: 'Helemaal niet beperkt', en: 'Not at all limited' },
      { nl: 'Om andere redenen beperkt of heb de bezigheid niet gedaan', en: 'Limited for other reasons or did not do the activity' }
    ]
  },
  {
    id: :v2,
    title: { nl: '<br>2. Hoeveel keer had u last van gezwollen voeten, enkels of benen toen u \'s morgens wakker werd gedurende de afgelopen 2 weken?',
             en: '<br>2. Over the past 2 weeks, how many times did you have swelling in your feet, ankles or legs when you woke up in the morning?' },
    type: :likert,
    options: [
      { nl: 'Elke morgen', en: 'Every morning' },
      { nl: '3 keer of meer per week, maar niet elke dag', en: '3 or more times per week but not every day' },
      { nl: '1 tot 2 keer per week', en: '1-2 times per week' },
      { nl: 'Minder dan 1 keer per week', en: 'Less than once a week' },
      { nl: 'Nooit gedurende de afgelopen 2 weken', en: 'Never over the past 2 weeks' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v3,
    title: { nl: '<br>3. Hoeveel keer, gemiddeld genomen, hebben vermoeidheid en lusteloosheid uw vermogen beperkt om te doen wat u wilde gedurende de afgelopen 2 weken?',
             en: '<br>3. Over the past 2 weeks, on average, how many times has fatigue limited your ability to do what you wanted?' },
    type: :likert,
    options: [
      { nl: 'Voortdurend', en: 'All of the time' },
      { nl: 'Meerdere keren per dag', en: 'Several times per day' },
      { nl: 'Tenminste 1 keer per dag', en: 'At least once a day' },
      { nl: '3 keer of meer per week, maar niet elke dag', en: '3 or more times per week but not every day' },
      { nl: '1 tot 2 keer per week', en: '1-2 times per week' },
      { nl: 'Minder dan 1 keer per week', en: 'Less than once a week' },
      { nl: 'Nooit gedurende de afgelopen 2 weken', en: 'Never over the past 2 weeks' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v4,
    title: { nl: '<br>4. Hoeveel keer, gemiddeld genomen, heeft kortademigheid uw vermogen beperkt om te doen wat u wilde gedurende de afgelopen 2 weken?',
             en: '<br>4. Over the past 2 weeks, on average, how many times has shortness of breath limited your ability to do what you wanted?' },
    type: :likert,
    options: [
      { nl: 'Voortdurend', en: 'All of the time' },
      { nl: 'Meerdere keren per dag', en: 'Several times per day' },
      { nl: 'Tenminste 1 keer per dag', en: 'At least once a day' },
      { nl: '3 keer of meer per week, maar niet elke dag', en: '3 or more times per week but not every day' },
      { nl: '1 tot 2 keer per week', en: '1-2 times per week' },
      { nl: 'Minder dan 1 keer per week', en: 'Less than once a week' },
      { nl: 'Nooit gedurende de afgelopen 2 weken', en: 'Never over the past 2 weeks' }
    ],
    required: true, 
    show_otherwise: false
  },
  {
    id: :v5,
    title: { nl: '<br>5. Hoeveel keer moest u, gemiddeld genomen, door kortademigheid zittend in een stoel slapen of met tenminste 3 kussens in uw rug om u te ondersteunen gedurende de afgelopen 2 weken?',
             en: '<br>5. Over the past 2 weeks, on average, how many times have you been forced to sleep sitting up in a chair or with at least 3 pillows to prop you up because of shortness of breath?' },
    type: :likert,
    options: [
      { nl: 'Elke nacht', en: 'Every night' },
      { nl: '3 keer of meer per week, maar niet elke nacht', en: '3 or more times per week but not every day' },
      { nl: '1 tot 2 keer per week', en: '1-2 times per week' },
      { nl: 'Minder dan 1 keer per week', en: 'Less than once a week' },
      { nl: 'Nooit gedurende de afgelopen 2 weken', en: 'Never over the past 2 weeks' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v6,
    title: { nl: '<br>6. In hoeverre heeft uw hartfalen uw mogelijkheid beperkt om van het leven te genieten gedurende de afgelopen 2 weken?',
             en: '<br>6. Over the past 2 weeks, how much has your heart failure limited your enjoyment of life?' },
    type: :likert,
    options: [
      { nl: 'Heel erg beperkt', en: 'It has extremely limited my enjoyment of life' },
      { nl: 'Vrij beperkt', en: 'It has limited my enjoyment of life quite a bit' },
      { nl: 'Matig beperkt', en: 'It has moderately limited my enjoyment of life' },
      { nl: 'Een klein beetje beperkt', en: 'It has slightly limited my enjoyment of life' },
      { nl: 'Helemaal niet beperkt', en: 'It has not limited my enjoyment of life at all' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    id: :v7,
    title: { nl: '<br>7. Hoe zou u zich voelen wanneer u de rest van uw leven zou moeten doorbrengen met uw hartfalen zoals het nu is?',
             en: '<br>7. If you had to spend the rest of your life with your heart failure the way it is right now, how would you feel about this?' },
    type: :likert,
    options: [
      { nl: 'Helemaal ontevreden', en: 'Not at all satisfied' },
      { nl: 'Grotendeels ontevreden', en: 'Mostly dissatisfied' },
      { nl: 'Enigszins tevreden', en: 'Somewhat satisfied' },
      { nl: 'Grotendeels tevreden', en: 'Mostly satisfied' },
      { nl: 'Helemaal tevreden', en: 'Completely satisfied' }
    ],
    required: true,
    show_otherwise: false
  },
  {
    type: :raw,
    content: { nl: '<p class="flow-text">8. In welke mate beïnvloedt uw hartfalen uw manier van leven? Geef aan hoe uw hartfalen eventueel uw deelname aan de volgende bezigheden beperkt heeft gedurende de afgelopen 2 weken.</p>',
               en: '<p class="flow-text">8. How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in the following activities over the past 2 weeks.</p>' }
  },
  {
    id: :v8a,
    title: { nl: 'Hobby\'s, vrijetijdsbesteding', en: 'Hobbies, recreational activities' },
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      { nl: 'Heel erg beperkt', en: 'Severely Limited' },
      { nl: 'Vrij beperkt', en: 'Limited quite a bit' },
      { nl: 'Matig beperkt', en: 'Moderately limited' },
      { nl: 'Een klein beetje beperkt', en: 'Slightly limited' },
      { nl: 'Helemaal niet beperkt', en: 'Did not limit at all' },
      { nl: 'Om andere redenen beperkt of heb de bezigheid niet gedaan', en: 'Does not apply or did not do for other reasons' }
    ]
  },
  {
    id: :v8b,
    title: { nl: 'Werk of huishoudelijke taken / klusjes uitvoeren', en: 'Working or doing household chores' },
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      { nl: 'Heel erg beperkt', en: 'Severely Limited' },
      { nl: 'Vrij beperkt', en: 'Limited quite a bit' },
      { nl: 'Matig beperkt', en: 'Moderately limited' },
      { nl: 'Een klein beetje beperkt', en: 'Slightly limited' },
      { nl: 'Helemaal niet beperkt', en: 'Did not limit at all' },
      { nl: 'Om andere redenen beperkt of heb de bezigheid niet gedaan', en: 'Does not apply or did not do for other reasons' }
    ]
  },
  {
    id: :v8c,
    title: { nl: 'Familie of vrienden gaan bezoeken', en: 'Visiting family or friends out of your home' },
    type: :range,
    min: 0,
    max: 5,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      { nl: 'Heel erg beperkt', en: 'Severely Limited' },
      { nl: 'Vrij beperkt', en: 'Limited quite a bit' },
      { nl: 'Matig beperkt', en: 'Moderately limited' },
      { nl: 'Een klein beetje beperkt', en: 'Slightly limited' },
      { nl: 'Helemaal niet beperkt', en: 'Did not limit at all' },
      { nl: 'Om andere redenen beperkt of heb de bezigheid niet gedaan', en: 'Does not apply or did not do for other reasons' }
    ]
  }
]

questionnaire.content = {
  questions: dagboek_content,
  scores: []
}
questionnaire.title = db_title
questionnaire.save!