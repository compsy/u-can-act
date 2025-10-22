# frozen_string_literal: true

# SportPro Profile Setup Questionnaire (One-time)
# Profile information and consent for sport professionals

db_title = 'SportPro Profiel Setup'
questionnaire_key = 'sportpro_profiel_setup'

db_name1 = 'SportPro Profiel Setup'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.find_by(key: questionnaire_key)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = questionnaire_key

# Questionnaire content
sportpro_profile_content = [
  {
    type: :raw,
    content: '<h5>Persoonskenmerken</h5>',
  },
  {
    id: :birth_year,
    type: :dropdown,
    title: '1. Wat is je geboortejaar?',
    options: (1920..2025).map(&:to_s).reverse,
  },
  {
    id: :gender,
    type: :radio,
    title: '2. Wat is je geslacht?',
    options: [
      'man',
      'vrouw',
      'wil ik liever niet zeggen'
    ],
  },
  {
    type: :raw,
    content: '<h4>Opleiding & ervaring</h4>',
  },
  {
    id: :highest_education,
    type: :radio,
    title: '3. Wat is je hoogst afgeronde opleiding?',
    options: [
      'mbo',
      'hbo',
      'wo',
    ],
  },
  {
    id: :relevant_education,
    type: :textarea,
    title: '4. Welke functierelevante opleiding(en) en cursussen heb je gevolgd?',
  },
  {
    id: :experience_specific_role,
    type: :radio,
    title: '5. Hoeveel jaar werkervaring heb je in deze specifieke functie?',
    options: [
      '<1',
      '1–3',
      '4–6',
      '>7 jaar'
    ],
    show_otherwise: false, 
 },
  {
    id: :experience_total,
    type: :radio,
    title: '6. Hoeveel jaar werkervaring heb je in totaal?',
    options: [
      '<1',
      '1–3',
      '4–6',
      '>7 jaar'
    ],
    show_otherwise: false,
  },
  {
    type: :raw,
    content: '<h4>Werkcontext</h4>',
  },
  {
    id: :employer,
    type: :radio,
    title: '7. Wie is je werkgever?',
    options: [
      'sportvereniging',
      'gemeente',
      'sportserviceorganisatie',
    ],
  },
  {
    id: :job_title,
    type: :textarea,
    title: '8. Wat is je huidige functiebenaming?',
  },
  {
    id: :employment_scope,
    type: :radio,
    title: '9. Wat is de omvang van je aanstelling?',
    options: [
      '<0,3 fte',
      '0,3–0,5 fte',
      '0,6–0,8 fte',
      '>0,8 fte'
    ],
    show_otherwise: false,
  },
  {
    id: :funding_sources,
    type: :checkbox,
    title: '10. Hoe wordt je functie gefinancierd? (meerdere antwoorden mogelijk)',
    options: [
      'gemeente',
      'sportbond',
      'sportbedrijf',
      'een vereniging',
      'meerdere verenigingen',
    ],
  },
  {
    id: :work_location,
    type: :textarea,
    title: '11. In welke plaats/gemeente werk je voornamelijk binnen deze functie?',
  },
  {
    id: :main_assignments,
    type: :checkbox,
    title: '12. Heb je bij je aanstelling een concrete opdracht mee gekregen, zo ja welke drie zijn het belangrijkst:',
    max_selections: 3,
    options: [
      'Adviseren en ondersteunen verenigingsbestuur',
      'Fungeren als schakel tussen bestuur, commissies en vrijwilligers',
      'Het aansturen van vrijwilligers/betaalde medewerkers',
      'Het sportaanbod binnen de vereniging uitbreiden',
      'Betere benutting van accommodatie door het organiseren activiteiten of evenementen met andere partijen (bijv. scholen, bedrijven)',
      'Het onderhouden en verbeteren van samenwerking met externe contacten (bijv. gemeente, marktpartijen)',
      'Maatschappelijke waarde creëren door bredere groep mensen gebruik te laten maken van het sportpark (bijv. buurtbewoners, jongeren)',
      'Ledenaantal verhogen van de vereniging',
      'Het versterken van de identiteit van de vereniging',
      'Het versterken van de sociale cohesie binnen de vereniging',
    ],
  },
  {
    id: :additional_context,
    type: :textarea,
    title: '13. Zijn er nog andere zaken die interessant zijn in relatie tot je werkcontext die je wil delen?',
    section_end: true
  }
]

questionnaire.content = { questions: sportpro_profile_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!