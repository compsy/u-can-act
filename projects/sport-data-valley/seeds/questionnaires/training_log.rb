# frozen_string_literal: true

db_title = 'Training log'

db_name1 = 'training_log'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

dagboek_content = [
  {
    type: :raw,
    content: {
      nl: '<p class="flow-text">Feedback op de trainingssessie</p><br><img src="/sport-data-valley/training_log_header.jpg" style="width:100%" class="questionnaire-image" />',
      en: '<p class="flow-text">Feedback on the training session</p><br><img src="/sport-data-valley/training_log_header.jpg" style="width:100%" class="questionnaire-image" />'
    }
  },
  {
    id: :v1,
    title: { nl: 'Trainingtype', en: 'Training type' },
    type: :dropdown,
    placeholder: { nl: 'Selecteer uw antwoord...', en: 'Select your answer...' },
    options: [
      { nl: 'Atletiek', en: 'Athletics', i18n: 'components.dashboards.questionnaire.training_type.athletics' },
      { nl: 'Badminton', en: 'Badminton', i18n: 'components.dashboards.questionnaire.training_type.badminton' },
      { nl: 'Basketbal', en: 'Basketball', i18n: 'components.dashboards.questionnaire.training_type.basketball' },
      { nl: 'Boksen', en: 'Boxing', i18n: 'components.dashboards.questionnaire.training_type.boxing' },
      { nl: 'Dansen', en: 'Dancing', i18n: 'components.dashboards.questionnaire.training_type.dancing' },
      { nl: 'Fitness / Krachttraining', en: 'Fitness / Strength training', i18n: 'components.dashboards.questionnaire.training_type.fitness_power_training' },
      { nl: 'Golf', en: 'Golf', i18n: 'components.dashboards.questionnaire.training_type.golf' },
      { nl: 'Gymnastiek', en: 'Gymnastics', i18n: 'components.dashboards.questionnaire.training_type.gymnastics' },
      { nl: 'Handbal', en: 'Handball', i18n: 'components.dashboards.questionnaire.training_type.handball' },
      { nl: 'Hardlopen', en: 'Running', i18n: 'components.dashboards.questionnaire.training_type.running' },
      { nl: 'Hiken', en: 'Hiking', i18n: 'components.dashboards.questionnaire.training_type.hiking' },
      { nl: 'Hockey', en: 'Field hockey', i18n: 'components.dashboards.questionnaire.training_type.field_hockey' },
      { nl: 'Honkbal', en: 'Baseball', i18n: 'components.dashboards.questionnaire.training_type.baseball' },
      { nl: 'IJshockey', en: 'Ice hockey', i18n: 'components.dashboards.questionnaire.training_type.ice_hockey' },
      { nl: 'Inline skaten', en: 'Inline skating', i18n: 'components.dashboards.questionnaire.training_type.inline_skating' },
      { nl: 'Judo', en: 'Judo', i18n: 'components.dashboards.questionnaire.training_type.judo' },
      { nl: 'Karate', en: 'Karate', i18n: 'components.dashboards.questionnaire.training_type.karate' },
      { nl: 'Klimmen', en: 'Climbing', i18n: 'components.dashboards.questionnaire.training_type.climbing' },
      { nl: 'Korfbal', en: 'Korfball', i18n: 'components.dashboards.questionnaire.training_type.korfball' },
      { nl: 'Kunstschaatsen', en: 'Figure skating', i18n: 'components.dashboards.questionnaire.training_type.figure_skating' },
      { nl: 'Mountainbiken', en: 'Mountain biking', i18n: 'components.dashboards.questionnaire.training_type.mountain_biking' },
      { nl: 'Paardrijden', en: 'Horse riding', i18n: 'components.dashboards.questionnaire.training_type.horse_riding' },
      { nl: 'Plyometrische training', en: 'Plyometric training', i18n: 'components.dashboards.questionnaire.training_type.plyometric_training' },
      { nl: 'Powerliften / bodybuilding', en: 'Power lifting / Body building', i18n: 'components.dashboards.questionnaire.training_type.power_lifting_body_building' },
      { nl: 'Roeien', en: 'Rowing', i18n: 'components.dashboards.questionnaire.training_type.rowing' },
      { nl: 'Rugby', en: 'Rugby', i18n: 'components.dashboards.questionnaire.training_type.rugby' },
      { nl: 'Schaatsen', en: 'Speed skating', i18n: 'components.dashboards.questionnaire.training_type.ice_skating' },
      { nl: 'Shorttrack', en: 'Short track', i18n: 'components.dashboards.questionnaire.training_type.short_track' },
      { nl: 'Softbal', en: 'Softball', i18n: 'components.dashboards.questionnaire.training_type.softball' },
      { nl: 'Squash', en: 'Squash', i18n: 'components.dashboards.questionnaire.training_type.squash' },
      { nl: 'Tennis', en: 'Tennis', i18n: 'components.dashboards.questionnaire.training_type.tennis' },
      { nl: 'Voetbal', en: 'Football', i18n: 'components.dashboards.questionnaire.training_type.football' },
      { nl: 'Volleybal', en: 'Volleyball', i18n: 'components.dashboards.questionnaire.training_type.volleyball' },
      { nl: 'Wielrennen', en: 'Cycling', i18n: 'components.dashboards.questionnaire.training_type.cycling' },
      { nl: 'Zeilen', en: 'Sailing', i18n: 'components.dashboards.questionnaire.training_type.sailing' },
      { nl: 'Zwemmen', en: 'Swimming', i18n: 'components.dashboards.questionnaire.training_type.swimming' },
      { nl: 'Anders', en: 'Other', i18n: 'components.dashboards.questionnaire.training_type.other' }
    ],
    required: true
  },
  {
    id: :v2,
    title: { nl: 'Sessietype', en: 'Session type' },
    type: :dropdown,
    placeholder: { nl: 'Selecteer uw antwoord...', en: 'Select your answer...' },
    options: [
      { nl: 'Circuit', en: 'Circuit', i18n: 'components.dashboards.questionnaire.session_type.circuit' },
      { nl: 'Extensieve duur', en: 'Extensive endurance', i18n: 'components.dashboards.questionnaire.session_type.extensive_endurance' },
      { nl: 'Extensieve interval', en: 'Extensive interval', i18n: 'components.dashboards.questionnaire.session_type.extensive_interval' },
      { nl: 'Extensieve tempo', en: 'Extensive tempo', i18n: 'components.dashboards.questionnaire.session_type.extensive_tempo' },
      { nl: 'Herstel', en: 'Recovery', i18n: 'components.dashboards.questionnaire.session_type.recovery' },
      { nl: 'Intensieve duur', en: 'Intensive endurance', i18n: 'components.dashboards.questionnaire.session_type.intensive_endurance' },
      { nl: 'Intensieve interval', en: 'Intensive interval', i18n: 'components.dashboards.questionnaire.session_type.intensive_interval' },
      { nl: 'Intensieve tempo', en: 'Intensive tempo', i18n: 'components.dashboards.questionnaire.session_type.intensive_tempo' },
      { nl: 'Power', en: 'Power', i18n: 'components.dashboards.questionnaire.session_type.power' },
      { nl: 'Kracht', en: 'Strength', i18n: 'components.dashboards.questionnaire.session_type.strength' },
      { nl: 'Skills', en: 'Skills', i18n: 'components.dashboards.questionnaire.session_type.skills' },
      { nl: 'Sprint', en: 'Sprint', i18n: 'components.dashboards.questionnaire.session_type.sprint' },
      { nl: 'Teamtraining', en: 'Team training', i18n: 'components.dashboards.questionnaire.session_type.team_training' },
      { nl: 'Techniek', en: 'Technique', i18n: 'components.dashboards.questionnaire.session_type.technique' },
      { nl: 'Testen', en: 'Testing', i18n: 'components.dashboards.questionnaire.session_type.testing' },
      { nl: 'Vaartspel', en: 'Fartlek', i18n: 'components.dashboards.questionnaire.session_type.fartlek' },
      { nl: 'Wedstrijd', en: 'Match', i18n: 'components.dashboards.questionnaire.session_type.match' },
      { nl: 'Wedstrijdvoorbereiding', en: 'Match preparation', i18n: 'components.dashboards.questionnaire.session_type.match_preparation' },
      { nl: 'Anders', en: 'Other', i18n: 'components.dashboards.questionnaire.session_type.other' }
    ],
    required: true
  },
  {
    id: :v5,
    type: :number,
    title: { nl: 'Tijdsduur (min)', en: 'Duration (min)' },
    placeholder: { nl: 'Vul een getal in', en: 'Enter a number' },
    required: true,
    maxlength: 4,
    min: 0,
    max: 1440 # 24hrs
  },
  {
    id: :v3,
    type: :date_and_time,
    hours_id: :v4_uur,
    minutes_id: :v4_minuten,
    today: true,
    placeholder: { nl: 'Vul een datum en tijd in', en: 'Enter a date and time' },
    title: { nl: 'Begonnen op', en: 'Started at' },
    required: true,
    max: true
  },
  {
    id: :v6,
    title: 'RPE score',
    type: :range,
    min: 1,
    max: 10,
    step: 1,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    vertical: true,
    gradient: true,
    labels: [
      { nl: 'Heel licht', en: 'Really easy' },
      { nl: 'Licht', en: 'Easy' },
      { nl: 'Gemiddeld', en: 'Moderate' },
      { nl: 'Pittig', en: 'Sort of hard' },
      { nl: 'Zwaar', en: 'Hard' },
      { nl: '', en: '' },
      { nl: 'Heel zwaar', en: 'Really hard' },
      { nl: '', en: '' },
      { nl: 'Heel, heel zwaar', en: 'Really, really hard' },
      { nl: 'Maximaal', en: 'Maximal' }
    ]
  },
  {
    id: :v7,
    title: { nl: 'Tevredenheid over training', en: 'Training satisfaction' },
    type: :range,
    min: 1,
    max: 5,
    step: 0.5,
    required: true,
    ticks: true,
    no_initial_thumb: true,
    labels: [
      { nl: 'Totaal ontevreden', en: 'Completely dissatisfied' },
      { nl: 'Ontevreden', en: 'Dissatisfied' },
      { nl: 'Normaal', en: 'Normal' },
      { nl: 'Tevreden', en: 'Satisfied' },
      { nl: 'Totaal tevreden', en: 'Completely satisfied' }
    ]
  },
  {
    id: :v8,
    type: :textarea,
    title: { nl: 'Opmerkingen', en: 'Comments' },
    placeholder: { nl: 'Vul iets in (optioneel)', en: 'Enter some text (optional)' }
  }
]

questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
