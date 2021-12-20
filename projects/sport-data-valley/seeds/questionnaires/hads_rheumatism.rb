# frozen_string_literal: true

db_title = ''
db_name1 = 'hads_rheumatism'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Wij willen graag weten hoe u zich de laatste tijd heeft gevoeld. Wilt u bij elke vraag het cijfer voor het antwoord dat het meest op u van toepassing is omcirkelen? Denk erom, het gaat bij deze vragen om hoe u zich de laatste tijd (in het bijzonder de afgelopen 4 weken) voelde, dus niet om hoe u zich in het verleden heeft gevoeld. Denk niet te lang na, uw eerste reactie is waarschijnlijk de meest nauwkeurige.</p>',
  }, {
    id: :v1,
    type: :radio,
    title: 'Ik voel me de laatste tijd gespannen',
    options: [
      { title: 'meestal', numeric_value: 3 },
      { title: 'vaak', numeric_value: 2 },
      { title: 'af en toe, soms', numeric_value: 1 },
      { title: 'helemaal niet', numeric_value: 0 }
    ],
    show_otherwise: false
  }, {
    id: :v2,
    type: :radio,
    title: 'Ik geniet nog steeds van de dingen waar ik vroeger van genoot.',
    options: [{ title: 'zeker zo veel', numeric_value: 0 },
              { title: 'wat minder', numeric_value: 1 },
              { title: 'duidelijk minder', numeric_value: 2 },
              { title: 'nauwelijks nog', numeric_value: 3 }],
    show_otherwise: false
  }, {
    id: :v3,
    type: :radio,
    title: 'Ik krijg de laatste tijd het angstige gevoel alsof er elk moment iets vreselijks zal gebeuren.',
    options: [{ title: 'heel zeker en vrij erg', numeric_value: 3 },
              { title: 'ja, maar niet zo erg', numeric_value: 2 },
              { title: 'een beetje, maar ik maak me er geen zorgen over', numeric_value: 1 },
              { title: 'helemaal niet', numeric_value: 0 }],
    show_otherwise: false
  }, {
    id: :v4,
    type: :radio,
    title: 'Ik kan lachen en de dingen van de vrolijke kant zien.',
    options: [{ title: 'net zoveel als vroeger', numeric_value: 0 },
              { title: 'nu wat minder', numeric_value: 1 },
              { title: 'nu duidelijk minder', numeric_value: 2 },
              { title: 'helemaal niet meer', numeric_value: 3 }],
    show_otherwise: false
  }, {
    id: :v5,
    type: :radio,
    title: 'Ik maak me de laatste tijd ongerust.',
    options: [{ title: 'heel erg vaak', numeric_value: 3 },
              { title: 'vaak', numeric_value: 2 },
              { title: 'niet zo vaak', numeric_value: 1 },
              { title: 'heel soms', numeric_value: 0 }],
    show_otherwise: false
  }, {
    id: :v6,
    type: :radio,
    title: 'Ik voel me de laatste tijd opgewekt',
    options: [{ title: 'helemaal niet', numeric_value: 3 },
              { title: 'niet vaak', numeric_value: 2 },
              { title: 'soms', numeric_value: 1 },
              { title: 'meestal', numeric_value: 0 }],
    show_otherwise: false
  }, {
    id: :v7,
    type: :radio,
    title: 'Ik kan de laatste tijd rustig zitten en me ontspannen',
    options: [{ title: 'zeker', numeric_value: 0 },
              { title: 'meestal', numeric_value: 1 },
              { title: 'niet vaak', numeric_value: 2 },
              { title: 'helemaal niet', numeric_value: 3 }],
    show_otherwise: false
  }, {
    id: :v8,
    type: :radio,
    title: 'Ik voel me de laatste tijd alsof alles moeizamer gaat.',
    options: [{ title: 'bijna altijd', numeric_value: 3 },
              { title: 'heel vaak', numeric_value: 2 },
              { title: 'soms', numeric_value: 1 },
              { title: 'helemaal niet', numeric_value: 0 }],
    show_otherwise: false
  }, {
    id: :v9,
    type: :radio,
    title: 'Ik krijg de laatste tijd een soort benauwd, gespannen gevoel in mijn maag.',
    options: [{ title: 'helemaal niet', numeric_value: 0 },
              { title: 'soms', numeric_value: 1 },
              { title: 'vrij vaak', numeric_value: 2 },
              { title: 'heel vaak', numeric_value: 3 }],
    show_otherwise: false
  }, {
    id: :v10,
    type: :radio,
    title: 'Ik heb de laatste tijd geen interesse meer in mijn uiterlijk.',
    options: [{ title: 'zeker', numeric_value: 3 },
              { title: 'niet meer zoveel als ik zou moeten', numeric_value: 2 },
              { title: 'mogelijk wat minder', numeric_value: 1 },
              { title: 'evenveel interesse als voorheen', numeric_value: 0 }],
    show_otherwise: false
  }, {
    id: :v11,
    type: :radio,
    title: 'Ik voel me de laatste tijd rusteloos.',
    options: [{ title: 'heel erg', numeric_value: 3 },
              { title: 'tamelijk veel', numeric_value: 2 },
              { title: 'niet erg veel', numeric_value: 1 },
              { title: 'helemaal niet', numeric_value: 0 }],
    show_otherwise: false
  }, {
    id: :v12,
    type: :radio,
    title: 'Ik verheug me van tevoren al op dingen.',
    options: [{ title: 'net zoveel als vroeger', numeric_value: 0 },
              { title: 'een beetje minder dan vroeger', numeric_value: 1 },
              { title: 'zeker minder dan vroeger', numeric_value: 2 },
              { title: 'bijna nooit', numeric_value: 3 }],
    show_otherwise: false
  }, {
    id: :v13,
    type: :radio,
    title: 'Ik krijg de laatste tijd plotseling gevoelens van angst of paniek.',
    options: [{ title: 'zeer vaak', numeric_value: 3 },
              { title: 'tamelijk vaak', numeric_value: 2 },
              { title: 'niet erg vaak', numeric_value: 1 },
              { title: 'helemaal niet', numeric_value: 0 }],
    show_otherwise: false
  }, {
    id: :v14,
    type: :radio,
    title: 'Ik kan van een goed boek genieten of een radio- of televisieprogramma',
    options: [{ title: 'vaak', numeric_value: 0 },
              { title: 'soms', numeric_value: 1 },
              { title: 'niet vaak', numeric_value: 2 },
              { title: 'heel zelden', numeric_value: 3 }],
    show_otherwise: false
  }
]

dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Anxiety',
      ids: %i[v1 v3 v5 v7 v9 v11 v13],
      operation: :sum,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Depression',
      ids: %i[v2 v4 v6 v8 v10 v12 v14],
      operation: :sum,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
