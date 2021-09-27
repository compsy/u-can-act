# frozen_string_literal: true

def sociogram_question(id, text)
  id = id.to_s
  [
    {
      section_start: text,
      id: id + "_1",
      type: :number,
      required: true,
      title: "Antwoord 1:",
      maxlength: 2,
      min: 0,
      max: 99,
      hint: 'Het antwoord moet een nummer tussen 0 en 99 zijn.'
    },
    {
      id: id + "_2",
      type: :number,
      required: false,
      title: "Antwoord 2:",
      maxlength: 2,
      min: 0,
      max: 99,
      hint: 'Het antwoord moet een nummer tussen 0 en 99 zijn.'
    },
    {
      id: id + "_3",
      type: :number,
      required: false,
      title: "Antwoord 3:",
      maxlength: 2,
      min: 0,
      max: 99,
      hint: 'Het antwoord moet een nummer tussen 0 en 99 zijn.',
      section_end: true
    }
  ]
end

content = [
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
      Hieronder vind je een lijst met uitdrukkingen die verschillende aspecten van individueel en/of groepsgedrag beschrijven.
      Geef aan welke personen volgens jou het meest voldoen aan de beschrijving.
      Noteer minimaal één en maximaal drie cursist nummers per vraag.<br>
      <br>
    </p>
    '
  },
  *sociogram_question(:doelgericht, "Handelt doelgericht en durft beslissingen te nemen (hoeft niet per definitie om kaderleden te gaan)."),
  *sociogram_question(:inzicht, "Heeft snel inzicht in de bedoeling van opdrachten en leert gemakkelijk."),
  *sociogram_question(:planmatig, "Gaat planmatig en effectief te werk om het gewenste resultaat te bereiken."),
  *sociogram_question(:tijdsdruk, "Blijft goed presteren onder tijdsdruk, bij tegenslag, teleurstelling of 'gevaar'. Blijft altijd kalm en doelgericht, ook onder zware omstandigheden."),
  *sociogram_question(:moeite, "Heeft soms moeite om dingen van anderen aan te nemen."),
  *sociogram_question(:aanpassen, "Past zich gemakkelijk aan in wisselende omstandigheden."),
  *sociogram_question(:afspraken, "Komt gemaakte afspraken na."),
  *sociogram_question(:zorgvuldig, "Is precies en zorgvuldig en voert taken vaak foutloos uit."),
  *sociogram_question(:durf, "Durft verandwoordelijkheid te nemen en accepteert de gevolgen van zijn eigen handelen, beslissingen en gemaakte afspraken."),
  *sociogram_question(:samenwerken, "Werk ik graag mee samen om een opdracht te halen."),
  *sociogram_question(:nietsamenwerken, "Werk ik liever <b>niet</b> mee samen."),
  *sociogram_question(:vertrouw, "Deze persoon vertrouw ik het meest, ook als het om persoonlijke dingen gaat."),
  *sociogram_question(:betrouwbaar, "Handelt altijd naar eer en geweten, is betrouwbaar en aanspreekbaar; spreekt indien nodig ook anderen aan.")
]

title = 'Sociogram'
name = 'KCT Sociogram'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = 'sociogram'

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
