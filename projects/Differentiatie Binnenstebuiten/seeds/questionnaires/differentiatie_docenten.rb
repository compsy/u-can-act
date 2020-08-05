# frozen_string_literal: true

db_title = '' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'Differentiatie Binnenstebuiten Docenten'
dagboek1 = Questionnaire.find_by(name: db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]

attitude_items = %w[1 2 3 4 5 6]
competence_items = %w[1 2 3 4 5 6]

def question(id, title)
  likert_options = [
    'sterk mee oneens',
    'mee oneens',
    'enigszins mee oneens',
    'enigszins mee eens',
    'mee eens',
    'sterk mee eens'
  ]
  {
    id: id,
    title: title,
    type: :likert,
    options: likert_options
  }
end

dagboek_content = [{
  section_start: 'Dagboek Docenten',
  type: :raw,
  content: 'Alle onderstaande vragen gaan over de afgelopen les.'
}, {
  section_start: 'Interactie met de leerlingen',
  type: :raw,
  content: '<p class="flow-text"><em>Geef per stelling aan in hoeverre je het eens bent met de betreffende stelling.</em></p><p class="flow-text">Tijdens de les heb ik...</p>'
},
question(:v1, '1. ...leerlingen geholpen om zichzelf te verbeteren in mijn vak.'),
question(:v2, '2. ...leerlingen laten blijken dat zij in staat waren om de lesactiviteiten te kunnen uitvoeren.'),
question(:v3, '3. ...leerlingen voorzien van verschillende opties en keuzemogelijkheden.'),
question(:v4, '4. ...leerlingen aangemoedigd om vragen te stellen.'),
question(:v5, '5. ...geluisterd naar hoe leerlingen hun taken wilden uitvoeren.'),
question(:v6, '6. ...leerlingen ondersteund waar nodig.'),
question(:v7, '7. ...leerlingen aangemoedigd om samen te werken.'),
question(:v8, '8. ...interesse getoond in alle leerlingen.'),
{
  section_start: 'Eigen competenties',
  type: :raw,
  content: '<p class="flow-text"><em>Geef per stelling aan in hoeverre je het eens bent met de betreffende stelling.</em></p>'
},
question(:v9, '1. Ik kon nauwkeurig bepalen in hoeverre de leerling begreep wat ik hem/haar heb geleerd.'),
question(:v10, '2. Ik kon een alternatieve uitleg of een voorbeeld geven wanneer leerlingen iets niet begrepen.'),
question(:v11, '3. Ik kon leertaken zodanig ontwerpen dat ik tegemoet ben gekomen aan de individuele behoeften van leerlingen met extra ondersteuningsbehoeften.'),
question(:v12, '4. Ik kon storend gedrag in de klas in de hand houden.'),
{
  section_start: 'Ondersteuning / aanpassingen',
  type: :raw,
  content: {
    first: '<p class="flow-text">Je hebt aangegeven (enigszins) bereid te zijn waar nodig aanpassingen te doen of extra ondersteuning te bieden om tegemoet te komen aan de individuele behoeften van de leerlingen.</p>',
    normal: '<p class="flow-text">Vorige  keer  heb  je  aangegeven  dat  je  tijdens  deze  les  de  volgende  ondersteuning  zou  bieden: </p> <p class="flow-text"><em>{{previous_v14}}</em></p>'
  },
  uses: {
    previous: :v14,
    default: '(geen antwoord gegeven)',
  },
},
{
  id: :v13,
  type: :textarea,
  required: true,
  title: {
    first: 'Welke ondersteuning / aanpassingen heb je volgens jou tijdens deze les geboden?',
    normal: 'Heb je dit gedaan zoals je het van plan was? Zo nee, waardoor kwam dit?'
  }
},
{
  id: :v14,
  type: :textarea,
  required: true,
  title: 'Welke ondersteuning / aanpassingen ga je tijdens de volgende les bieden?'
}]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
