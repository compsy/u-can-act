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
    content: '<div class="consent-section">
      <p>Beste deelnemer,</p>
      <p> Bedankt dat je meedoet aan dit onderzoek naar de rol van sportprofessionals in sportverenigingen en sportparken. 
      Jij vult dit logboek in voor jouw rol als sportparkmanager of verenigingsmanager. Met jouw antwoorden krijgen we 
      inzicht in de werkzaamheden, samenwerkingen, uitdagingen en successen van sportprofessionals. Het doel is om beter 
      te begrijpen hoe sportprofessionals sportverenigingen en sportparken versterken, welke competenties daarvoor nodig 
      zijn en hoe opleidingen en beleid hier beter op kunnen aansluiten.</p>
      
      <p>Het logboek bestaat uit een aantal korte vragen en kost ongeveer 30 minuten per keer om in te vullen. 
      Je antwoorden worden vertrouwelijk behandeld en uitsluitend gebruikt voor dit onderzoek. De gegevens worden 
      geanalyseerd en anoniem verwerkt in de eindrapportage en andere publicaties.</p>
      
      <p>Daarnaast kunnen je antwoorden, in overleg, worden gebruikt als voorbereiding op andere onderzoeksactiviteiten 
      binnen jouw casestudie.</p>
      
      <p>Voor al je vragen of opmerkingen, neem contact op met jouw SportPro casestudie onderzoeker.</p>
      
      <p>Alvast bedankt voor je tijd en inzet!<br/>
      SportPro onderzoeksteam</p>
    </div>'
  },
  {
    id: :consent,
    type: :radio,
    title: 'Ik geef toestemming dat mijn antwoorden worden gebruikt voor onderzoeksdoeleinden',
    options: [
      { title: 'Ja', shows_questions: %i[birth_year gender highest_education relevant_education experience_specific_role experience_total employer job_title employment_scope funding_sources work_location main_assignments additional_context] },
      'Nee'
    ],
    required: true,
    show_otherwise: false
  },
  {
    type: :raw,
    content: '<h4>Persoonskenmerken</h4>',
    hidden: true
  },
  {
    id: :birth_year,
    type: :dropdown,
    title: '1. Wat is je geboortejaar?',
    options: (1920..2025).map(&:to_s).reverse,
    hidden: true
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
    hidden: true
  },
  {
    type: :raw,
    content: '<h4>Opleiding & ervaring</h4>',
    hidden: true
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
    hidden: true
  },
  {
    id: :relevant_education,
    type: :textarea,
    title: '4. Welke functierelevante opleiding(en) en cursussen heb je gevolgd?',
    hidden: true
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
    hidden: true
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
    hidden: true
  },
  {
    type: :raw,
    content: '<h4>Werkcontext</h4>',
    hidden: true
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
        hidden: true
  },
  {
    id: :job_title,
    type: :textarea,
    title: '8. Wat is je huidige functiebenaming?',
    hidden: true
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
    hidden: true
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
    hidden: true
  },
  {
    id: :work_location,
    type: :textarea,
    title: '11. In welke plaats/gemeente werk je voornamelijk binnen deze functie?',
    hidden: true
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
    hidden: true
  },
  {
    id: :additional_context,
    type: :textarea,
    title: '13. Zijn er nog andere zaken die interessant zijn in relatie tot je werkcontext die je wil delen?',
    hidden: true,
    section_end: true
  }
]

questionnaire.content = { questions: sportpro_profile_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!