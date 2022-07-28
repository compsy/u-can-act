# frozen_string_literal: true
db_title = 'Informatie over doorgaan of stoppen'
db_name1 = 'exit_lijst'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

info_over_doorgaan = <<~'END'
  <div>
    <p><h4><strong>Informatie over doorgaan</strong></h4></p>
    <p>
      Heel fijn dat je nog wel even door wil gaan met de dagboekstudie! Je krijgt nog tot ongeveer oktober elke week 
      een sms met een link naar de vragenlijst van ons. Net als eerder kun je natuurlijk op elk moment gewoon stoppen
      met het invullen, en als je er een week niet aan toekomt, kun je gewoon de volgende week weer meedoen.
    </p>
    <p>
      Wij sturen je rond oktober informatie over hoe je dan je beloning kunt krijgen, ook als je eerder ophoudt met het 
      invullen.
    </p>
    <p>
      Heb je op dit moment nog vragen? Je kunt ons altijd mailen: Ymkje Anna de Vries (<a href='mailto:y.a.de.vries@rug.nl' target='_blank' rel='noopener noreferrer'>y.a.de.vries@rug.nl</a>) of Bert Wienen (<a href='mailto:b.wienen@windesheim.nl' target='_blank' rel='noopener noreferrer'>b.wienen@windesheim.nl</a>).
    </p>
    <p>
      <strong>Vergeet niet om hieronder op de Opslaan knop te drukken zodat we weten dat je graag nog even doorgaat!</strong>
    </p>
  </div>
END


info_over_stoppen = <<~'END'
  <div>
    <p><h4><strong>Informatie over stoppen en je beloning</strong></h4></p>
    <p>
    <strong>Belangrijk: lees deze informatie goed en vergeet niet om hieronder op de Opslaan knop te drukken zodat we weten dat je wil stoppen!</strong>
  </p>
    <p>
      Als je ervoor kiest om te stoppen met de dagboekstudie, krijg je na het weekend van 16 en 17 juli geen sms-jes meer van ons.  
    </p>
    <p>
      Om je beloning uit te kunnen betalen, heeft de universiteit wat extra gegevens van je nodig, zoals je bankrekeningnummer en je BSN. Dit moet je invullen in de betalingstool van de universiteit. 
    </p>
    <p>
    De betalingstool kun je hier vinden: <a href='https://rbpreg.gai.rug.nl/sys/account/login' target='_blank' rel='noopener noreferrer'>https://rbpreg.gai.rug.nl/sys/account/login</a>. <strong>Het is belangrijk dat je het telefoonnummer en emailadres invult dat je nu ook gebruikt voor de dagboekstudie, zodat we je kunnen vinden in het systeem.</strong>
  </p>
  <p>
    We hebben voor de betalingstool ook een handleiding geschreven. Die kun je hier vinden: <a href='https://u-can-feel.nl/img/handleiding.pdf' target='_blank' rel='noopener noreferrer'>https://u-can-feel.nl/img/handleiding.pdf</a>.
   </p>
   <p>
   <strong>Het kan even duren voordat je de beloning op je bankrekening hebt.</strong> We moeten eerst van alle deelnemers de gegevens ontvangen. We streven ernaar de beloning uiterlijk half september uit te betalen. Als we jouw gegevens niet kunnen vinden in de betalingstool, zullen we opnieuw contact met je zoeken.
  </p>
    <p>
      Heb je op dit moment nog vragen? Je kunt ons altijd mailen: Ymkje Anna de Vries (<a href='mailto:y.a.de.vries@rug.nl' target='_blank' rel='noopener noreferrer'>y.a.de.vries@rug.nl</a>) of Bert Wienen (<a href='mailto:b.wienen@windesheim.nl' target='_blank' rel='noopener noreferrer'>b.wienen@windesheim.nl</a>).
    </p>
    <p>
    Nu geen tijd om je gegevens in te vullen in de betalingstool? Alle informatie is ook op de website terug te vinden bij het laatste nieuws: <a href='https://u-can-feel.nl' target='_blank' rel='noopener noreferrer'>u-can-feel.nl</a>.
  </p>
    <p>
      <strong>Vergeet niet om hieronder op de Opslaan knop te drukken zodat we weten dat je wil stoppen! </strong>
    </p>
  </div>
END

dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Het schooljaar loopt ten einde. We willen je daarom graag informatie geven over hoe je je beloning kunt krijgen. Maar voor ons onderzoek zou het ook heel mooi zijn als je nog even door zou willen gaan, zodat we nog betere gegevens krijgen. Aan jou dus de keus:
</p>'
  }, {
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'Wil je liever stoppen met de dagboekstudie of nog even doorgaan?',
    options: [
      { title: 'Ik wil nog wel even doorgaan (tot ongeveer oktober) om nog meer geld te verdienen', shows_questions: %i[v2_doorgaan] },
      { title: 'Ik wil graag stoppen met de dagboekstudie en mijn beloning krijgen', shows_questions: %i[v2_stoppen] }
    ]
  }, {
    id: :v2_doorgaan,
    hidden: true,
    type: :raw,
    content: info_over_doorgaan
  }, {
    id: :v2_stoppen,
    hidden: true,
    type: :raw,
    content: info_over_stoppen
  }
]




dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
