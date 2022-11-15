# frozen_string_literal: true
db_title = 'Informatie over het krijgen van je beloning'
db_name1 = 'exit_lijst_reminder2'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1


dagboek_content = [
  {
    type: :raw,
    content: "<p class='flow-text'>Bedankt dat je hebt meegedaan aan ons onderzoek! We hebben de beloning uitbetaald aan iedereen die een account heeft gemaakt in de betalingstool van de RUG. We willen jou graag ook nog je beloning geven. Daarvoor moet je een account maken in de betalingstool van de RUG. Volgens onze gegevens heb je die nog niet. <strong>We gaan in november de laatste beloningen uitbetalen. Maak daarom snel een account, zodat jij ook je beloning krijgt.</strong>
</p>
<p class='flow-text'>
<strong>Lees deze informatie goed door. Je kunt dit ook op de website terug vinden bij het laatste nieuws: 
<a href='https://u-can-feel.nl' target='_blank' rel='noopener noreferrer'>u-can-feel.nl</a>. </strong>
</p>
<p class='flow-text'>
  Om je beloning uit te kunnen betalen, heeft de universiteit wat extra gegevens van je nodig, zoals je bankrekeningnummer en je BSN. Dit moet je invullen in de betalingstool van de universiteit. 
</p>
<p class='flow-text'>
De betalingstool kun je hier vinden: <a href='https://rbpreg.gai.rug.nl/sys/account/login' target='_blank' rel='noopener noreferrer'>https://rbpreg.gai.rug.nl/sys/account/login</a>. <strong>Het is belangrijk dat je het emailadres invult dat je nu ook gebruikt voor de dagboekstudie, zodat we je kunnen vinden in het systeem. Kan dat niet? Stuur ons dan een mailtje met je telefoonnummer en het emailadres van je account in de betalingstool.</strong>
</p>
<p class='flow-text'>
We hebben voor de betalingstool ook een handleiding geschreven. Die kun je hier vinden: <a href='https://u-can-feel.nl/img/handleiding.pdf' target='_blank' rel='noopener noreferrer'>https://u-can-feel.nl/img/handleiding.pdf</a>.
</p>
<p class='flow-text'>
<strong>Het kan even duren voordat je de beloning op je bankrekening hebt.</strong> We streven ernaar de beloning uiterlijk eind november uit te betalen. 
</p>
<p class='flow-text'>
  Heb je op dit moment nog vragen? Je kunt ons altijd mailen: Ymkje Anna de Vries (<a href='mailto:y.a.de.vries@rug.nl' target='_blank' rel='noopener noreferrer'>y.a.de.vries@rug.nl</a>).
</p>
<p class='flow-text'>
  Nu geen tijd om hiermee bezig te gaan? Kijk dan later op de website (laatste nieuws) voor deze informatie: <a href='https://u-can-feel.nl' target='_blank' rel='noopener noreferrer'>u-can-feel.nl</a>. Maar wacht niet te lang! <strong>Pas op, als je hieronder op Opslaan klikt, kun je de link in het sms'je/mailtje niet opnieuw openen. Kijk dan dus op de website (u-can-feel.nl) voor de informatie.</strong>
</p>"
  }
]




dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!