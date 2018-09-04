# frozen_string_literal: true

title = 'Q-CAP-KCT' 
name = 'KCT Q-CAP'
questionnaire = Questionnaire.find_by_name(name)
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

def rotate_question(id, title, image, section_end: false)
  create_question(id, title, image, [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H"
    ], section_end)
end

content = [
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation"> 
      Met de intelligentievragenlijst kunt u testen hoe goed u bent in logisch
      denken en hoe goed u in gedachten figuren kunt keren en draaien. Deze eerste
      pagina bevat 11 verschillende figuren. We schatten dat het u ongeveer 15
      minuten zal kosten. Het is een vrij intensieve vragenlijst, maar de resultaten
      zijn de moeite waard. Op de volgende pagina volgen nog 24 kubussen waar u
      waarschijnlijk ongeveer 30 minuten mee bezig zal zijn. De totale tijd die
      deelnemers met het intelligentieonderdeel bezig zijn kan per persoon flink
      verschillen. Vrijwel niemand zal alle vragen kunnen oplossen. Dit is niet
      erg, probeer dan vooral de volgende figuur.
    </p>
    <p class="flow-text section-explanation">
      Kunt u bij de onderstaande opdrachten aangeven welk figuur (A, B, C, D, E, F) op de plaats van het vraagteken hoort?
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
  {
    type: :raw,
    title: 'Figuren draaien',
    content: '
    <p class="flow-text section-explanation"> 
      Op deze pagina staan 24 kubussen. Dit is het laatste onderdeel; het kost
      u nog ongeveer 30 minuten. De onderstaande kubussen hebben op iedere zijkant
      een andere afbeelding.<br><br>Kunt u bij de onderstaande opdrachten aangeven
      welke kubus (A, B, C, D, E, F) een gekantelde versie zou kunnen zijn van de
      linker kubus (de kubus waar een X onder staat).
    </p>'
  },
  rotate_question(:v12, "12.", 'HGIN_3D_001.png'),
  rotate_question(:v13, "13.", 'HGIN_3D_002.png'),
  rotate_question(:v14, "14.", 'HGIN_3D_003.png'),
  rotate_question(:v15, "15.", 'HGIN_3D_004.png'),
  rotate_question(:v16, "16.", 'HGIN_3D_005.png'),
  rotate_question(:v17, "17.", 'HGIN_3D_006.png'),
  rotate_question(:v18, "18.", 'HGIN_3D_007.png'),
  rotate_question(:v19, "19.", 'HGIN_3D_008.png'),
  rotate_question(:v20, "20.", 'HGIN_3D_009.png'),
  rotate_question(:v21, "21.", 'HGIN_3D_010.png'),
  rotate_question(:v22, "22.", 'HGIN_3D_011.png'),
  rotate_question(:v23, "23.", 'HGIN_3D_012.png'),
  rotate_question(:v24, "24.", 'HGIN_3D_013.png'),
  rotate_question(:v25, "25.", 'HGIN_3D_014.png'),
  rotate_question(:v26, "26.", 'HGIN_3D_015.png'),
  rotate_question(:v27, "27.", 'HGIN_3D_016.png'),
  rotate_question(:v28, "28.", 'HGIN_3D_017.png'),
  rotate_question(:v29, "29.", 'HGIN_3D_018.png'),
  rotate_question(:v30, "30.", 'HGIN_3D_019.png'),
  rotate_question(:v31, "31.", 'HGIN_3D_020.png'),
  rotate_question(:v32, "32.", 'HGIN_3D_021.png'),
  rotate_question(:v33, "33.", 'HGIN_3D_022.png'),
  rotate_question(:v34, "34.", 'HGIN_3D_023.png'),
  rotate_question(:v35, "35.", 'HGIN_3D_024.png')
]
questionnaire.content = content
questionnaire.title = title
questionnaire.save!
#
#######################################

