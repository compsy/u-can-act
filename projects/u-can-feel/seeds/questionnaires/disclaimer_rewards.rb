# frozen_string_literal: true

db_title = 'Welkom bij het onderzoek'
db_name1 = 'disclaimer_rewards'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

disclaimer_content = <<~'END'
  <div class='informed-consent'>
    <h4>INFORMATIE OVER HET ONDERZOEK</h4>
    <p><strong><i class='material-icons'>chevron_right</i> Welkom bij het u-can-feel dagboek-onderzoek!</strong></p>
    <p>
      Heel fijn dat je meedoet aan het u-can-feel onderzoek! We willen je graag vragen om ook mee te doen 
      aan het dagboek-onderzoek dat hierbij hoort. Dit houdt in dat je elke week op zaterdag een sms krijgt
      met een uitnodiging om een paar vragen te beantwoorden. De vragen gaan over je gevoelens, school en de 
      mensen om je heen. Het invullen duurt een paar minuten. Het dagboekonderzoek duurt tot het einde van het
      schooljaar. Maar je kunt op elk moment besluiten om te stoppen.
      </p>
      <p>Door mee te doen help je ons en je school om leerlingen met angst of depressieve klachten beter te helpen.
      Nog leuker: voor elke week dat je meedoet, kun je geld verdienen. Je verdient een euro per week. Als je minstens 
      3 weken achter elkaar meedoet, krijg je een bonus! Je krijgt vanaf dan 1,50 euro per week dat je meedoet.
    </p>
    <p><strong><i class='material-icons'>chevron_right</i> Belangrijk om te weten over de beloning</strong></p>
    <p>Je beloning wordt pas uitbetaald na het eind van het schooljaar. Je krijgt elke week na het invullen van 
    de vragen te zien hoeveel je al verdiend hebt. 
    </p>
    <p>
    We kunnen je beloning alleen uitbetalen als je je inschrijft bij de betalingstool van de Rijksuniversiteit Groningen. En je naam,
    adres, rekeningnummer en emailadres invult. Deze gegevens zijn op geen enkele manier te koppelen aan je antwoorden op de vragenlijsten.
    We zullen je via sms en/of email vertellen hoe dit moet na afloop van het onderzoek,
    of als je eerder besluit te stoppen. Heb je daar nu vragen over? Je kunt de onderzoekers emailen: dr. Ymkje Anna de Vries 
    (y.a.de.vries@rug.nl) of dr. Bert Wienen (b.wienen@windesheim.nl).
  </p>
  </div>
END


dagboek_content = [
  {
    id: :v1,
    type: :raw,
    content: disclaimer_content
  }, 
  {
    id: :v2,
    type: :checkbox,
    required: true,
    title: 'Uitbetaling beloning',
    options: [
      { title: 'Ik begrijp dat ik mijn beloning pas aan het eind van het schooljaar krijg. Ik begrijp ook dat ik hiervoor dan nog mijn gegevens moet invullen.' }
    ],
    show_otherwise: false
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!