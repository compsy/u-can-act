# frozen_string_literal: true

db_title = ''

db_name1 = 'ostrc_h'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

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

shown_questions_health = PrefixMethods::prefix_all(2, 3, 4, 5, 6, 7)

dagboek_content = [
  {
    id: :v1,
    type: :radio,
    title: 'In hoeverre heb je de afgelopen 7 dagen tijdens je trainingen en/of wedstrijden hinder ondervonden van gezondheidsklachten?',
    options: [
      { title: 'Ik heb geen gezondheidsklachten gehad', numeric_value: 0 },
      { title: 'Ik heb volledig deelgenomen maar had wel hinder van gezondheidsklachten', numeric_value: 8, shows_questions: shown_questions_health },
      { title: 'Ik heb verminderd deelgenomen vanwege gezondheidsklachten', numeric_value: 17, shows_questions: shown_questions_health },
      { title: 'Ik heb helemaal niet deelgenomen vanwege gezondheidsklachten', numeric_value: 100 }
    ],
    show_otherwise: false
  },
  {
    id: :v2,
    hidden: true,
    type: :radio,
    title: 'In welke mate heb je in de afgelopen 7 dagen je training of deelname aan wedstrijden aangepast vanwege je gezondheidsklachten?',
    options: [
      { title: 'Niet aangepast', numeric_value: 0 },
      { title: 'Een klein beetje aangepast', numeric_value: 8 },
      { title: 'Redelijk aangepast', numeric_value: 17 },
      { title: 'Heel erg aangepast', numeric_value: 25 }
    ],
    show_otherwise: false
  },
  {
    id: :v3,
    hidden: true,
    type: :radio,
    title: 'In hoeverre heb je in de afgelopen 7 dagen gemerkt dat je gezondheidsklachten je prestatie hebben beinvloed?',
    options: [
      { title: 'Niet beinvloed', numeric_value: 0 },
      { title: 'Een klein beetje beinvloed', numeric_value: 8 },
      { title: 'Redelijk beinvloed', numeric_value: 17 },
      { title: 'Heel erg beinvloed', numeric_value: 25 }
    ],
    show_otherwise: false
  },
  {
    id: :v4,
    hidden: true,
    type: :radio,
    title: 'Hoeveel pijn heb je ervaren als gevolg van de gezondheidsklachten?',
    options: [
      { title: 'Geen pijn', numeric_value: 0 },
      { title: 'Lichte pijn', numeric_value: 8 },
      { title: 'Redelijke pijn', numeric_value: 17 },
      { title: 'Ernstige pijn', numeric_value: 25 }
    ],
    show_otherwise: false
  },
  {
    id: :v5,
    hidden: true,
    type: :number,
    title: 'Hoeveel dagen in de week heb je niet volledig kunnen deelnemen aan een training of wedstrijd ten gevolge van je gezondheidsklachten?',
    required: true,
    maxlength: 1,
    min: 0,
    max: 7
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
      'Zere keel'
    ],
    show_otherwise: true,
    required: true
  },
  {
    id: :v7,
    hidden: true,
    type: :radio,
    title: 'Ben je voor je gezondheidsklachten de afgelopen 7 dagen behandeld door een therapeut of arts?',
    options: %w[Ja Nee],
    show_otherwise: false
  }
]

questionnaire.content = {
  questions: dagboek_content,
  scores: [
    {
      id: :s1,
      label: 'H-score',
      ids: %i[v1],
      operation: :average,
      round_to_decimals: 0
    }
  ]
}
questionnaire.title = db_title
questionnaire.save!
