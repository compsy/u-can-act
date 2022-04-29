# frozen_string_literal: true

def create_ontbijt_question(id: Integer, titel: String)
  v = "v".concat(id.to_s)
  [
    {
      id: v.concat("-textarea").to_sym,
      type: :textarea,
      title: "Ontbijt ".concat(id.to_s).concat(" - ").concat(titel)
    },
    {
      id: v.concat("-smaak").to_sym,
      type: :radio,
      required: false,
      title: 'Wat vind je van de smaak?',
      options: [
        '0' (niet lekker),
        '1',
        '2',
        '3',
        '4',
        '5' (heel erg lekker)
      ],
      show_otherwise: false
    },
    {
      id: v.concat("-aanvulling").to_sym,
      type: :radio,
      required: false,
      title: 'Vind je dit ontbijttype een goede aanvulling op het "normale ontbijt" (alleen brood en beleg)?',
      options: [
        '0' (helemaal geen goede aanvulling),
        '1',
        '2',
        '3',
        '4',
        '5' (een zeer goede aanvulling)
      ],
      show_otherwise: false
    },
    {
      id: v.concat("-maag").to_sym,
      type: :radio,
      required: false,
      title: 'Hoe valt dit ontbijttype "op de maag" (m.n. als jij je direct na het ontbijt fysiek moet gaan inspannen)?',
      options: [
        '0' (zeer licht),
        '1',
        '2',
        '3',
        '4',
        '5' (veel te zwaar)
      ],
      show_otherwise: false
    }
  ]
end

title = 'Ontbijt'
name = 'KCT Ontbijt'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = 'ontbijt'

content = [
  *create_ontbijt_question(1, "Zuivelbuffet: yoghurt en kwark, muesligranen, toegevoegde noten en honing"),
  *create_ontbijt_question(2, "Rijstepap naturel"),
  *create_ontbijt_question(3, "Rijstepap met rozijnen en banaan"),
  *create_ontbijt_question(4, "American pancakes (twee american pancakes spelt banaan + fruit"),
  *create_ontbijt_question(5, "Boerenomelet op volkoren brood"),
  *create_ontbijt_question(6, "Pannenkoek naturel"),
  *create_ontbijt_question(7, "Pannenkoek met appel"),
  *create_ontbijt_question(8, "Pannenkoek met spek"),
  *create_ontbijt_question(9, "Brinta"),
  *create_ontbijt_question(10, "Havermout appel/kaneel"),
  *create_ontbijt_question(11, "Gebakken ei met brood"),
  *create_ontbijt_question(12, "Gebakken ei met spek"),
  *create_ontbijt_question(13, "Gekookt ei"),
]

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
