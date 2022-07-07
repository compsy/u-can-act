# frozen_string_literal: true
db_title = 'Informatie over het krijgen van je beloning'
db_name1 = 'exit_lijst_eindexamen'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1


dagboek_content = [
  {
    type: :raw,
    content: "<p class='flow-text'>Het schooljaar loopt ten einde. Daarom krijg je na het weekend van 16 en 17 juli 
    geen sms-jes meer van ons. We willen je daarom ook graag informatie geven over hoe je je beloning kunt krijgen. 
</p>
<p class='flow-text'>
<strong>Belangrijk: lees deze informatie goed door. Je kunt dit ook op de website terug vinden bij het laatste nieuws: 
<a href='https://u-can-feel.nl' target='_blank' rel='noopener noreferrer'>u-can-feel.nl</a>. </strong>
</p>
<p class='flow-text'>
  Om je beloning uit te kunnen betalen, heeft de universiteit wat extra gegevens van je nodig, zoals je bankrekeningnummer en je BSN. Dit moet je invullen in de betalingstool van de universiteit. 
</p>
<p class='flow-text'>
De betalingstool kun je hier vinden: <a href='https://rbpreg.gai.rug.nl/sys/account/login' target='_blank' rel='noopener noreferrer'>https://rbpreg.gai.rug.nl/sys/account/login</a>. <strong>Het is belangrijk dat je het telefoonnummer en emailadres invult dat je nu ook gebruikt, zodat we je kunnen vinden in het systeem.</strong>
</p>
<p class='flow-text'>
We hebben voor de betalingstool ook een handleiding geschreven. Die kun je hier vinden: <a href='https://u-can-feel.nl/img/handleiding.pdf' target='_blank' rel='noopener noreferrer'>https://u-can-feel.nl/img/handleiding.pdf</a>.
</p>
<p class='flow-text'>
<strong>Het kan even duren voordat je de beloning op je bankrekening hebt.</strong> Heb je half september je beloning nog niet ontvangen? Neem dan contact met ons op.
</p>
<p class='flow-text'>
  Heb je op dit moment nog vragen? Je kunt ons altijd mailen: Ymkje Anna de Vries (<a href='mailto:y.a.de.vries@rug.nl' target='_blank' rel='noopener noreferrer'>y.a.de.vries@rug.nl</a>) of Bert Wienen (<a href='mailto:b.wienen@windesheim.nl' target='_blank' rel='noopener noreferrer'>b.wienen@windesheim.nl</a>).
</p>
<p class='flow-text'>
  Nu geen tijd om hiermee bezig te gaan? Kijk dan later op de website (laatste nieuws) voor deze informatie: <a href='https://u-can-feel.nl' target='_blank' rel='noopener noreferrer'>u-can-feel.nl</a>.
</p>"
  }
]




dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!