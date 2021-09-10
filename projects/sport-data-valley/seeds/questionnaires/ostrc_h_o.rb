# frozen_string_literal: true

db_title = ''

db_name1 = 'ostrc_h_o'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

require File.expand_path('../questionnaire_helpers/complaints.rb', __dir__)

class PrefixMethods
  class << self
    def prefix(num)
      "v#{num}"
    end

    def prefix_all(*numbers)
      numbers.map { |num| prefix(num).to_sym }
    end
  end
end

shown_questions_health = PrefixMethods::prefix_all(1, 5, 6, 7, '1a')
shown_questions_injury = PrefixMethods::prefix_all('_o_2', '_o_3')
shown_questions_hours = PrefixMethods::prefix_all('_o_3')
shown_questions_participated = PrefixMethods::prefix_all(2, 3, 4)

dagboek_content = [
  {
    type: :raw,
    content: '<h4 class="header">Fysieke- & gezondheidsklachten vragenlijst</h4><p class="flow-text">In deze vragenlijst vragen we naar blessures en gezondheidsklachten die je mogelijk de afgelopen 7 dagen hebt ervaren. Afhankelijk van het aantal klachten duurt het invullen van de vragenlijst 0 – 3 minuten.</p><p class="flow-text">De volgende vragen gaan over eventuele hinder die je hebt ondervonden bij het sporten door fysieke en/of mentale klachten. Kies bij elke vraag het antwoord wat jouw situatie het beste omschrijft. Kies bij twijfel het meest passende antwoord.</p>'
  },
  {
    id: :v0,
    type: :radio,
    title: 'Heb je in de afgelopen 7 dagen hinder ondervonden bij het sporten ten gevolge van een blessure, ziekte of andere gezondheidsklachten?',
    options: [
      {
        title: 'Nee, ik heb volledig deelgenomen zonder klachten',
        numeric_value: 0,
        shows_questions: shown_questions_hours
      },
      {
        title: 'Ja, ik heb hinder ondervonden door <strong>een blessure / fysieke klachten</strong>',
        numeric_value: 8,
        shows_questions: shown_questions_injury,
        tooltip: 'Let op: de klachten betreffen alleen blessures / klachten aan het bewegingsapparaat. Denk hierbij aan een overbelaste spier, kneuzing, hersenschudding etc.'
      },
      {
        title: 'Ja, ik heb hinder ondervonden door <strong>een ziekte / gezondheidsklachten</strong>',
        numeric_value: 17,
        shows_questions: shown_questions_health + shown_questions_hours,
        tooltip: 'Let op: de klachten betreffen alleen ziekte / gezondheidsklachten. Denk hierbij aan een buikpijn, koorts, pijn op de borst etc.'
      },
      { title: 'Ja, ik heb hinder ondervonden door <strong>beide</strong>, zowel een blessure / fysieke klachten als een ziekte / gezondheidsklachten', numeric_value: 100, shows_questions: shown_questions_health + shown_questions_injury }
    ],
    tooltip: 'De volgende vragen gaan over mogelijke klachten die je hebt ondervonden tijdens het sporten. Onder sporten verstaan wij praktijklessen, trainingen en wedstrijden.',
    show_otherwise: false
  },
  {
    id: :v1a,
    hidden: true,
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan specifiek over de <strong>ziekte/gezondheidsklachten</strong> die je de afgelopen 7 dagen hebt ervaren, niet over eventuele blessures.</p>'
  },
  {
    id: :v1,
    hidden: true,
    type: :radio,
    title: "</p><h6>Vraag 1 - Deelname</h6><p class='flow-text'>Heb je enige moeite met deelname aan het sporten gehad door <strong>ziekte/gezondheidsklachten</strong> in de afgelopen 7 dagen?</p><p>",
    options: [
      { title: 'Volledige deelname, maar met klachten', numeric_value: 8, shows_questions: shown_questions_participated },
      { title: 'Verminderde deelname door klachten', numeric_value: 17, shows_questions: shown_questions_participated },
      { title: 'Kan niet deelnemen door klachten', numeric_value: 100 }
    ],
    show_otherwise: false
  },
  {
    id: :v2,
    hidden: true,
    type: :radio,
    title: "</p><h6>Vraag 2 - Aangepaste training/competitie</h6><p class='flow-text'>In welke mate heb je het sporten aangepast door <strong>ziekte/gezondheidsklachten</strong> in de afgelopen 7 dagen?</p><p>",
    options: [
      { title: 'Niet aangepast', numeric_value: 0 },
      { title: 'In geringe mate aangepast', numeric_value: 8 },
      { title: 'In redelijke mate aangepast', numeric_value: 17 },
      { title: 'In grote mate aangepast', numeric_value: 25 }
    ],
    show_otherwise: false
  },
  {
    id: :v3,
    hidden: true,
    type: :radio,
    title: "</p><h6>Vraag 3 - Prestatie</h6><p class='flow-text'>In welke mate heeft de <strong>ziekte/gezondheidsklachten</strong> een negatieve invloed gehad op je prestatie in de afgelopen 7 dagen?</p><p>",
    options: [
      { title: 'Geen invloed', numeric_value: 0 },
      { title: 'In geringe mate beïnvloed', numeric_value: 8 },
      { title: 'In redelijke mate beïnvloed', numeric_value: 17 },
      { title: 'In grote mate beïnvloed', numeric_value: 25 }
    ],
    show_otherwise: false
  },
  {
    id: :v4,
    hidden: true,
    type: :radio,
    title: "</p><h6>Vraag 4 - Symptomen</h6><p class='flow-text'>In welke mate heb je <strong>symptomen of gezondheidsklachten</strong> ervaren in de afgelopen 7 dagen?</p><p>",
    options: [
      { title: 'Geen symptomen of gezondheidsklachten', numeric_value: 0 },
      { title: 'Geringe symptomen of gezondheidsklachten', numeric_value: 8 },
      { title: 'Redelijke symptomen of gezondheidsklachten', numeric_value: 17 },
      { title: 'Ernstige symptomen of gezondheidsklachten', numeric_value: 25 }
    ],
    show_otherwise: false
  },
  {
    id: :v5,
    hidden: true,
    type: :likert,
    title: 'Hoeveel dagen in de week heb je niet volledig kunnen deelnemen aan het sporten ten gevolge van je <strong>gezondheidsklachten</strong>?',
    options: [
      { title: '0', numeric_value: 0 },
      { title: '1', numeric_value: 1 },
      { title: '2', numeric_value: 2 },
      { title: '3', numeric_value: 3 },
      { title: '4', numeric_value: 4 },
      { title: '5', numeric_value: 5 },
      { title: '6', numeric_value: 6 },
      { title: '7', numeric_value: 7 }
    ],
    show_otherwise: false
  },
  {
    id: :v6,
    hidden: true,
    type: :checkbox,
    title: 'Welke symptomen heb je de afgelopen 7 dagen ervaren?',
    options: [
      'Angstig / Onrustig',
      'Buikpijn',
      'Diarree',
      'Flauwvallen',
      'Gevoel van slapte / Vermoeidheid',
      'Hoesten',
      'Hoofdpijn',
      'Jeuk / Uitslag',
      'Koorts',
      'Kortademig / Benauwd',
      'Misselijkheid',
      'Onregelmatige pols / Palpitaties',
      'Oogklachten',
      'Oorklachten',
      'Opgezette lymfeklieren',
      'Overgeven',
      'Pijn elders',
      'Pijn op de borst',
      'Prikkelbaar',
      'Slapeloosheid',
      'Stijf / Gevoelloos',
      'Teneergeslagen / Depressief',
      'Urinewegproblemen of problemen met de geslachtsdelen',
      'Verstopping',
      'Verstopte neus / Loopneus / Niezen',
      'Wil ik niet zeggen',
      'Zere keel'
    ],
    show_otherwise: true,
    required: true
  },
  {
    id: :v7,
    hidden: true,
    type: :radio,
    title: 'Ben je voor je <strong>gezondheidsklachten</strong> de afgelopen 7 dagen behandeld door een therapeut of arts?',
    options: %w[Ja Nee],
    show_otherwise: false,
  },
  {
    id: :v_o_2,
    hidden: true,
    type: :checkbox,
    title: 'In welke regio vond(en) de klacht(en) plaats?',
    options: Complaints::all_complaint_options,
    show_otherwise: false,
    required: true
  },
  *Complaints::all_complaint_questions,
  {
    id: :v_o_3,
    hidden: true,
    type: :number,
    title: 'Hoeveel uur heb je de afgelopen week gesport?',
    required: true,
    maxlength: 3,
    min: 0,
    max: 100
  },
]

questionnaire.content = {
  questions: dagboek_content,
  scores: [
    {
      id: :s_h_1,
      label: 'ziekte/gezondheidsklachten',
      ids: %i[v1 v2 v3 v4],
      operation: :sum,
      round_to_decimals: 0
    },
    *Complaints::all_complaint_scores
  ]
}
questionnaire.title = db_title
questionnaire.save!
