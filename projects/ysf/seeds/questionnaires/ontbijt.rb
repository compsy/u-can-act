# frozen_string_literal: true

ontbijt_introduction = {
  type: :raw,
  content: '<p class="flow-text section-explanation">
      Paresto test in samenwerking met het KCT tijdens de VO/ECO een aantal nieuwe ontbijtvariaties zoals pannenkoeken of havermout die je naast het normale ontbijt krijgt aangeboden.
      Deze ontbijtvariaties hebben een relatief hoge calorische waarde (±1000 Kcal) om tegemoet te komen aan het hoge energieverbruik tijdens de opleiding.
      Het verzoek is om per ontbijttype 3 vragen te beantwoorden.
      Alle vragen zijn optioneel dus als je een ontbijt gemist hebt dan kun je de antwoorden leeg laten.
    </p>'
}

def create_ontbijt_question(id, titel)
  v = "v".dup.concat(id.to_s)
  [
    {
      section_start: "Ontbijt #{id.to_s} - #{titel}",
      id: v.dup.concat("-smaak").to_sym,
      type: :range,
      required: false,
      title: 'Wat vind je van de smaak?',
      labels: [
        'Niet lekker',
        'Heel erg lekker'
      ],
      show_otherwise: false
    },
    {
      id: v.dup.concat("-aanvulling").to_sym,
      type: :range,
      required: false,
      title: 'Vind je dit ontbijttype een goede aanvulling op het "normale ontbijt" (alleen brood en beleg)?',
      labels: [
        'Helemaal geen goede aanvulling',
        'Een zeer goede aanvulling'
      ],
      show_otherwise: false
    },
    {
      id: v.dup.concat("-maag").to_sym,
      type: :range,
      required: false,
      title: 'Hoe valt dit ontbijttype "op de maag" (m.n. als jij je direct na het ontbijt fysiek moet gaan inspannen)?',
      labels: [
        'Zeer licht',
        'Veel te zwaar'
      ],
      show_otherwise: false,
      section_end: true
    }
  ]
end

title = 'Ontbijt'
name = 'KCT Ontbijt'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = 'ontbijt'

content = [
  ontbijt_introduction,
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
