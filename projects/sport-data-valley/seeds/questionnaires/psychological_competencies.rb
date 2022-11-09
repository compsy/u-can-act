# frozen_string_literal: true

db_title = ''
db_name1 = 'psychological_competencies'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

class PsychologicalCompetenciesMethods
  DEFAULT_QUESTION_OPTIONS = {
    type: :likert,
    hidden: true,
    options: ['Helemaal mee oneens', 'Mee oneens', 'Neutraal', 'Mee eens', 'Helemaal mee eens'],
  }
end

# TODO: fixme
after_informed_consent = %i[v4]

dagboek_content = [
  {
    type: :raw,
    content: {
      en: "<h2>Vragenlijst psychologische competenties - generiek</h2>\n<p class=\"flow-text\" style=\"font-size:medium;\">Beste deelnemer,</p>\n<p class=\"flow-text\" style=\"font-size:medium;\">Welkom bij de vragenlijst psychologische competenties.</p><p class=\"flow-text\" style=\"font-size:medium;\">Deze vragenlijst is ontwikkeld om inzicht te krijgen in de psychologische competenties van deelnemers die actief zijn in een bepaald prestatiedomein. Hierbij kan onder andere gedacht worden aan: sport, muziek, dans, ALO of de politie. Psychologische competenties zijn relatief stabiele vaardigheden die van belang zijn om op hoog niveau te kunnen presteren. Voorbeelden hiervan zijn focus, veerkracht en commitment. Ook kan het beheersen van deze vaardigheden het risico op gezondheidsproblemen verkleinen en het algeheel welzijn verbeteren. De vragen in deze vragenlijst hebben betrekking op jouw ervaringen en perspectieven binnen jouw prestatiedomein.</p>\n<h3>Privacy</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\">Als je de vragenlijst invult dan zijn de resultaten in eerste instantie voor jou persoonlijk en je eigen ontwikkeling. Er wordt vertrouwelijk omgegaan met jouw gegevens. De resultaten zullen niet zomaar gedeeld worden met docenten, coaches, trainers of derden. De resultaten kunnen gebruikt worden voor wetenschappelijk onderzoek en voor verdere ontwikkeling, prestatieverbetering, of verbetering van training en onderwijs. Onderzoek kan bijvoorbeeld gaan om verschillen in psychologische competenties tussen groepen (bv. klassen, of jaarlagen, mannen en vrouwen) of om de ontwikkeling van psychologische competenties in de tijd (tijdens een seizoen of schooljaar, of zelfs over verschillende jaren in een opleiding of talentprogramma). Persoonlijke gegevens die gebruikt worden voor wetenschappelijk onderzoek zullen te allen tijde worden geanonimiseerd. Hierdoor zal hetgeen dat jij hebt ingevuld, nooit naar jou terug te herleiden zijn. Hiervoor moet wel een geïnformeerde toestemming worden ondertekend, waarin je hier toestemming voor geeft.</p>\n<h3>Procedure</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\"><ul><li>Het invullen van de vragenlijst duurt ongeveer 15 minuten.</li><li>Zorg ervoor dat je op een rustige plek bent waar je ongestoord kunt werken zonder te overleggen met anderen.</li><li>Zet je telefoon op ‘niet storen’ zodat je geen berichtjes ontvangt.</li><li>Laat je niet afleiden tijdens het invullen, probeer je volledige aandacht bij de vragenlijst te houden.</li></ul><h3>Uitleg vragenlijst</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\"><ul><li>Let goed op de instructie die boven de vragen en stellingen staat. Hierin wordt meer informatie gegeven over de bijbehorende stellingen.</li><li>Je kunt steeds maar één antwoord kiezen.</li><li>Het is van belang om alle vragen te beantwoorden en alle stellingen van een antwoord te voorzien.</li><li>Beantwoord de vragen zo eerlijk mogelijk en geef je eigen mening.</li><li>Er zijn geen 'goede' of 'foute' antwoorden!</li></ul>\n<p class=\"flow-text\" style=\"font-size:medium;\"> Alvast bedankt voor je deelname!</p>",
      nl: "<h2>Welkom bij de Recovery-Stress Questionnaire (RESTQ)!</h2>\n<p class=\"flow-text\" style=\"font-size:medium;\"></p>"
    }
  }, {
    section_start: 'Psychologische competentievragenlijst',
    id: :v1,
    type: :radio,
    title: 'Ik verklaar op een voor mij duidelijke wijze te zijn ingelicht over aard, methode, doel, risico’s en de belasting van het onderzoek. Ik ga ermee akkoord dat de verzamelde gegevens en resultaten gebruikt kunnen worden voor wetenschappelijk onderzoek.',
    options: ['Ja', { title: 'Nee', hides_questions: after_informed_consent, shows_questions: %i[v3a] }],
    show_otherwise: false,
    required: true
  }, {
    section_start: 'Ik weet dat de gegevens en resultaten van het onderzoek verder alleen anoniem en vertrouwelijk aan derden bekend gemaakt zullen worden. Ik geef toestemming om mijn gegevens nog 10 jaar na dit onderzoek te bewaren.',
    id: :v2,
    type: :radio,
    title: 'Hoeveel dagen hebt u vermoeidheid ervaren in de afgelopen week (7 dagen)?',
    options: ['Ja', { title: 'Nee', hides_questions: after_informed_consent, shows_questions: %i[v3a] }],
    show_otherwise: false,
    required: true
  }, {
    id: :v3,
    type: :radio,
    title: 'Ik begrijp dat ik mijn deelname aan dit onderzoek te allen tijde kan stop zetten en dat ik hierdoor verder geen nadelige gevolgen zal ondervinden. Mijn vragen zijn naar tevredenheid beantwoord. Ik wil meedoen aan dit onderzoek.',
    options: ['Ja', { title: 'Nee', hides_questions: after_informed_consent, shows_questions: %i[v3a] }],
    show_otherwise: false,
    required: true,
    section_end: true,
  }, {
    id: :v3a,
    type: :raw,
    hidden: true,
    content: '<p>Error: Je geeft aan niet deel te willen nemen aan het onderzoek. Klopt dit? Dan kun je hieronder op de knop drukken om de vragenlijst te sluiten.</p>'
  }, {
    section_start: "",
    id: :v4,
    type: :raw,
    content: {
      nl: "<p class=\"flow-text\" style=\"font-size:medium;\">De volgende 29 uitspraken gaan over jezelf in jouw prestatiedomein. Als er in de stelling staat 'mijn activiteit' dan wordt er dus gedoeld op jouw specifieke prestatiedomein. Is jouw prestatiedomein bijvoorbeeld basketbal, dan vul je hier voor jezelf ‘basketbal’ in. Doe je een dansopleiding? Dan vul je hier voor jezelf ‘dans’ in, etc.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\">Het is van belang om de vragen zo eerlijk mogelijk in te vullen en je eigen mening te geven. Bij deze vragen kun je uit 5 antwoorden kiezen. Lees de vragen goed door en sla geen vragen over. Kies het antwoord dat het beste bij je past. Er zijn geen 'goede' of 'foute' antwoorden! Je kunt kiezen uit de volgende antwoorden:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Helemaal mee oneens</strong><br />Als je het helemaal oneens bent met de uitspraak, of als de uitspraak helemaal niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Mee oneens</strong><br />Als je het oneens bent met de uitspraak, of als de uitspraak niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Neutraal</strong><br />Als je niet kunt beslissen, of als de uitspraak wel en niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Mee eens</strong><br />Als je het eens bent met de uitspraak, of als de uitspraak wel bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Helemaal mee eens</strong><br />Als je het helemaal eens bent met de uitspraak, of als de uitspraak helemaal bij je past</p>"
    }
  }, PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v5,
    title: 'Je hebt een bepaald niveau in <em>mijn activiteit</em> en je kunt niet echt veel doen om dat niveau te veranderen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v6,
    title: 'Ik beoordeel de dingen die ik heb meegemaakt, zodat ik ervan kan leren'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v7,
    title: 'Om succesvol te zijn in <em>mijn activiteit</em> moet je technieken en vaardigheden leren en deze regelmatig oefenen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v8,
    title: 'Ik ben toegewijd om <em>mijn activiteit</em> te blijven doen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v9,
    title: 'Doorgaans herstel ik snel na moeilijke momenten'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v10,
    title: 'Zelfs als je het probeert, zal het niveau dat je bereikt in <em>mijn activiteit</em> weinig veranderen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v11,
    title: 'Je moet een bepaalde "gave" hebben om goed te zijn in <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v12,
    title: 'Ik probeer na te denken over mijn sterke en zwakke punten'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v13,
    title: 'Je moet leren en hard werken om goed te zijn in <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v14,
    title: 'Als je hard werkt word je altijd beter in mijn <em>activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v15,
    title: 'Ik ben bereid elk obstakel te overwinnen om <em>mijn activiteit</em> te blijven doen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v16,
    title: 'Ik vind het moeilijk om door stressvolle gebeurtenissen heen te komen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v17,
    title: 'Om goed te zijn in <em>mijn activiteit</em> moet je geboren zijn met bepaalde basiskwaliteiten die je succes mogelijk maken'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v18,
    title: 'Ik ben vastbesloten om <em>mijn activiteit</em> te blijven doen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v19,
    title: 'Om een hoog prestatieniveau in <em>mijn activiteit</em> te bereiken moet je door leer- en trainingsperiodes heen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v20,
    title: 'Ik denk over mijn acties na, zodat ik ze kan verbeteren'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v21,
    title: 'Het kost me niet veel tijd om te herstellen van een stressvolle gebeurtenis'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v22,
    title: 'Hoe goed je bent in <em>mijn activiteit</em> zal altijd verbeteren als je eraan werkt'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v23,
    title: 'Het is moeilijk voor mij om terug te veren wanneer er iets ergs gebeurt'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v24,
    title: 'Het is moeilijk om te veranderen hoe goed je bent in <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v25,
    title: 'Ik ben erg gehecht aan <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v26,
    title: 'Ik kom meestal met weinig moeite door moeilijke tijden'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v27,
    title: 'Ik zal zo lang mogelijk <em>mijn activiteit</em> blijven doen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v28,
    title: 'Om goed te zijn in <em>mijn activiteit</em> moet je van nature getalenteerd zijn'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v29,
    title: 'Om nieuwe ideeën te begrijpen, denk ik na over mijn ervaringen uit het verleden'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v30,
    title: 'Ik ben bereid om bijna alles te doen om <em>mijn activiteit</em> te blijven doen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v31,
    title: 'Als je er voldoende moeite voor doet word je altijd beter in <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v32,
    title: 'Ik doe er meestal lang over om tegenslagen in mijn leven te overwinnen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v33,
    title: 'Ik probeer na te denken over hoe ik dingen de volgende keer beter kan doen'
  }),


]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
