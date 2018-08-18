# frozen_string_literal: true
db_title = '' # Dagboekvragenlijst moet geen titel hebben alleen een logo

db_name1 = 'differentiatie docenten'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]

percieved_control_items = ['1', '2', '3', '4', '5', '6']
attitude_items = ['1', '2', '3', '4', '5', '6']
competence_items = ['1', '2', '3', '4', '5', '6']

dagboek_content = [{
  section_start: 'Dagboek docenten',
  type: :raw,
  content: ''
}, {
  section_start: "Perceived control (terugblik op de betreffende les)",
  id: :v1,
  title: "Ik kon nauwkeurig bepalen in hoeverre de leerling begreep wat ik hem/haar heb geleerd.",
  type: :likert,
  options: percieved_control_items
}, {
  id: :v2,
  title: "Ik kon een alternatieve uitleg of een voorbeeld geven wanneer leerlingen iets niet begrepen.",
  type: :likert,
  options: percieved_control_items
}, {
  id: :v3,
  title: "Ik heb leertaken zodanig kunnen ontwerpen dat ik tegemoet ben gekomen aan de individuele behoeften van leerlingen met extra ondersteuningsbehoeften.",
  type: :likert,
  options: percieved_control_items
}, 

{
  section_start: "Nakomen intentie",
  content: "",
  type: :raw,
}, 
#{
  #section_start: "Tijdens de afgelopen les…",
  #id: :v4,
  #uses: {
    #previous: :v4,
    #default: 'De vorige meting'
  #},
  #title: "Je hebt de vorige keer aangegeven het eens te zijn met de volgende stelling: \n {{previous_v4}} \n gedaan?",
  #type: :likert,
  #options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
#}, {
  #section_start: "Tijdens de afgelopen les…",
  #id: :v5,
  #uses: {
    #previous: :v5,
    #default: 'De vorige meting'
  #},
  #title: "Je hebt de vorige keer aangegeven het eens te zijn met de volgende stelling: \n {{previous_v4}} \n gedaan?",
  #type: :likert,
  #options: ['1<br>helemaal niet waar', '2', '3', '4', '5<br>helemaal waar']
#},

{
  section_start: "Attitude",
  type: :raw,
  content: '<p class="flow-text section-explanation">Geef (naar aanleiding van afgelopen les) aan in hoeverre je het eens bent met onderstaande stellingen.</p>' 
},{
  id: :v6,
  title: '"Ik geloof dat elke leerling kan leren binnen het reguliere curriculum van de school, als het curriculum is aangepast aan hun individuele behoeften."',
  type: :likert,
  options: attitude_items
}, {
  id: :v7,
  title: '"Ik vind dat passend onderwijs academische vooruitgang van alle leerlingen mogelijk maakt, ongeacht hun bekwaamheden."',
  type: :likert,
  options: attitude_items
},

{
  section_start: "Competence, autonomy &amp; relatedness support richting lln.",
  type: :raw,
  content: '<p class="flow-text section-explanation">Tijdens de les heb ik...</p>' 
},{
  id: :v8,
  title: '1. ...leerlingen geholpen om zichzelf te verbeteren in mijn vak.',
  type: :likert,
  options: competence_items
}, {
  id: :v9,
  title: '2. ...leerlingen laten blijken dat zij in staat waren om de lesactiviteiten te kunnen uitvoeren.',
  type: :likert,
  options: competence_items
}, {
  id: :v10,
  title: "3. ...leerlingen voorzien van verschillende opties en keuzemogelijkheden.",
  type: :likert,
  options: competence_items
}, {
  id: :v11,
  title: "4. ...leerlingen aangemoedigd om vragen te stellen.",
  type: :likert,
  options: competence_items
}, {
  id: :v12,
  title: "5. ...geluisterd naar hoe de leerlingen hun taken wilden uitvoeren.",
  type: :likert,
  options: competence_items
}, {
  id: :v13,
  title: "6. ...leerlingen ondersteund waar nodig.",
  type: :likert,
  options: competence_items
}, {
  id: :v14,
  title: "7. ...leerlingen aangemoedigd om samen te werken.",
  type: :likert,
  options: competence_items
}, {
  id: :v15,
  title: "8. ...interesse getoond in alle leerlingen.",
  type: :likert,
  options: competence_items
}]

dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!


