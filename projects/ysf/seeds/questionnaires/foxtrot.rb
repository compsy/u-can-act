# frozen_string_literal: true

title = 'Foxtrot'

name = 'KCT Foxtrot'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title, image,options, section_end)
  res = {
    id: id,
    type: :likert,
    title: "<p class=\"flow-text\">#{title}</p><img src=\"/images/questionnaires/kct/#{image}\" style=\"width: 80%; margin-left: 3rem;\" />",
    options: options,
    show_otherwise: false
  }
  res[:section_end] = true if section_end
  res
end

def create_block_question(id, title, image, section_end: false)
  create_question(id, title, image,
    [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "Geen van deze",
      "Weet ik niet"
    ], section_end)
end

content = [
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
      Met de intelligentievragenlijst kun je testen hoe goed je bent in logisch
      denken en hoe goed je in gedachten figuren kunt keren en draaien. Deze eerste
      pagina bevat 11 verschillende figuren. We schatten dat het je ongeveer 15
      minuten zal kosten. Het is een vrij intensieve vragenlijst, maar de resultaten
      zijn de moeite waard. De totale tijd die deelnemers met het
      intelligentieonderdeel bezig zijn kan per persoon flink verschillen. Vrijwel
      niemand zal alle vragen kunnen oplossen. Dit is niet
      erg, probeer dan vooral de volgende figuur.
    </p>
    <p class="flow-text section-explanation">
      Kun je bij de onderstaande opdrachten aangeven welk figuur (A, B, C, D, E, F) op de plaats van het vraagteken hoort?
    </p>'
  },
  create_block_question(:v1, "1.", 'mr_43.jpg'),
  create_block_question(:v2, "2.", 'mr_44.jpg'),
  create_block_question(:v3, "3.", 'mr_45.jpg'),
  create_block_question(:v4, "4.", 'mr_46.jpg'),
  create_block_question(:v5, "5.", 'mr_47.jpg'),
  create_block_question(:v6, "6.", 'mr_48.jpg'),
  create_block_question(:v7, "7.", 'mr_50.jpg'),
  create_block_question(:v8, "8.", 'mr_53.jpg'),
  create_block_question(:v9, "9.", 'mr_54.jpg'),
  create_block_question(:v10, "10.", 'mr_55.jpg'),
  create_block_question(:v11, "11.", 'mr_56.jpg'),
]
questionnaire.content = { questionnaire: content, scores: [] }
questionnaire.title = title
questionnaire.save!

