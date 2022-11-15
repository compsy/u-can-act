# frozen_string_literal: true

db_title = ''
db_name1 = 'psychological_competencies'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

class PsychologicalCompetenciesMethods
  DEFAULT_QUESTION_OPTIONS = {
    type: :likert,
    options: [
      { title: 'Helemaal mee oneens', numeric_value: 0 },
      { title: 'Mee oneens', numeric_value: 25 },
      { title: 'Neutraal', numeric_value: 50 },
      { title: 'Mee eens', numeric_value: 75 },
      { title: 'Helemaal mee eens', numeric_value: 100 }
    ],
    hidden: false,
  }
  FREQUENCY_QUESTION_OPTIONS = {
    type: :likert,
    options: [
      { title: 'Bijna nooit', numeric_value: 0 },
      { title: 'Soms', numeric_value: 33 },
      { title: 'Vaak', numeric_value: 67 },
      { title: 'Bijna altijd', numeric_value: 100 }
    ],
    hidden: false,
  }
  ABSOLUTE_FREQUENCY_QUESTION_OPTIONS = {
    type: :likert,
    options: [
      { title: 'Nooit', numeric_value: 0 },
      { title: 'Zelden', numeric_value: 25 },
      { title: 'Soms', numeric_value: 50 },
      { title: 'Vaak', numeric_value: 75 },
      { title: 'Altijd', numeric_value: 100 }
    ],
    hidden: false,
  }
end

dagboek_content = [
  {
    type: :raw,
    content: "<h2>Vragenlijst psychologische competenties</h2>\n<p class=\"flow-text\" style=\"font-size:medium;\">Beste deelnemer,</p>\n<p class=\"flow-text\" style=\"font-size:medium;\">Welkom bij de vragenlijst psychologische competenties.</p><p class=\"flow-text\" style=\"font-size:medium;\">Deze vragenlijst is ontwikkeld om inzicht te krijgen in de psychologische competenties van deelnemers die actief zijn in een bepaald prestatiedomein. Hierbij kan onder andere gedacht worden aan: sport, muziek, dans, ALO of de politie. Psychologische competenties zijn relatief stabiele vaardigheden die van belang zijn om op hoog niveau te kunnen presteren. Voorbeelden hiervan zijn focus, veerkracht en commitment. Ook kan het beheersen van deze vaardigheden het risico op gezondheidsproblemen verkleinen en het algeheel welzijn verbeteren. De vragen in deze vragenlijst hebben betrekking op jouw ervaringen en perspectieven binnen jouw prestatiedomein.</p>\n<h3>Procedure</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\"><ul class='browser-default'><li>Het invullen van de vragenlijst duurt ongeveer 15 minuten.</li><li>Zorg ervoor dat je op een rustige plek bent waar je ongestoord kunt werken zonder te overleggen met anderen.</li><li>Zet je telefoon op ‘niet storen’ zodat je geen berichtjes ontvangt.</li><li>Laat je niet afleiden tijdens het invullen, probeer je volledige aandacht bij de vragenlijst te houden.</li></ul><h3>Uitleg vragenlijst</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\"><ul class='browser-default'><li>Let goed op de instructie die boven de vragen en stellingen staat. Hierin wordt meer informatie gegeven over de bijbehorende stellingen.</li><li>Je kunt steeds maar één antwoord kiezen.</li><li>Het is van belang om alle vragen te beantwoorden en alle stellingen van een antwoord te voorzien.</li><li>Beantwoord de vragen zo eerlijk mogelijk en geef je eigen mening.</li><li>Er zijn geen 'goede' of 'foute' antwoorden!</li></ul>"
  }, {
    section_start: "",
    id: :v3b,
    type: :raw,
    hidden: false,
    content: {
      nl: "<p class=\"flow-text\" style=\"font-size:medium;\">De volgende 29 uitspraken gaan over jezelf in jouw prestatiedomein. Als er in de stelling staat 'mijn activiteit' dan wordt er dus gedoeld op jouw specifieke prestatiedomein. Is jouw prestatiedomein bijvoorbeeld basketbal, dan vul je hier voor jezelf ‘basketbal’ in. Doe je een dansopleiding? Dan vul je hier voor jezelf ‘dans’ in, etc.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\">Het is van belang om de vragen zo eerlijk mogelijk in te vullen en je eigen mening te geven. Bij deze vragen kun je uit 5 antwoorden kiezen. Lees de vragen goed door en sla geen vragen over. Kies het antwoord dat het beste bij je past. Er zijn geen 'goede' of 'foute' antwoorden! Je kunt kiezen uit de volgende antwoorden:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Helemaal mee oneens</strong><br />Als je het helemaal oneens bent met de uitspraak, of als de uitspraak helemaal niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Mee oneens</strong><br />Als je het oneens bent met de uitspraak, of als de uitspraak niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Neutraal</strong><br />Als je niet kunt beslissen, of als de uitspraak wel en niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Mee eens</strong><br />Als je het eens bent met de uitspraak, of als de uitspraak wel bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Helemaal mee eens</strong><br />Als je het helemaal eens bent met de uitspraak, of als de uitspraak helemaal bij je past</p>"
    }
  }, PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v4,
    title: 'Je hebt een bepaald niveau in <em>mijn activiteit</em> en je kunt niet echt veel doen om dat niveau te veranderen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v5,
    title: 'Ik beoordeel de dingen die ik heb meegemaakt, zodat ik ervan kan leren'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v6,
    title: 'Om succesvol te zijn in <em>mijn activiteit</em> moet je technieken en vaardigheden leren en deze regelmatig oefenen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v7,
    title: 'Ik ben toegewijd om <em>mijn activiteit</em> te blijven doen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v8,
    title: 'Doorgaans herstel ik snel na moeilijke momenten'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v9,
    title: 'Zelfs als je het probeert, zal het niveau dat je bereikt in <em>mijn activiteit</em> weinig veranderen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v10,
    title: 'Je moet een bepaalde "gave" hebben om goed te zijn in <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v11,
    title: 'Ik probeer na te denken over mijn sterke en zwakke punten'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v12,
    title: 'Je moet leren en hard werken om goed te zijn in <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v13,
    title: 'Als je hard werkt word je altijd beter in mijn <em>activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v14,
    title: 'Ik ben bereid elk obstakel te overwinnen om <em>mijn activiteit</em> te blijven doen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v15,
    title: 'Ik vind het moeilijk om door stressvolle gebeurtenissen heen te komen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v16,
    title: 'Om goed te zijn in <em>mijn activiteit</em> moet je geboren zijn met bepaalde basiskwaliteiten die je succes mogelijk maken'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v17,
    title: 'Ik ben vastbesloten om <em>mijn activiteit</em> te blijven doen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v18,
    title: 'Om een hoog prestatieniveau in <em>mijn activiteit</em> te bereiken moet je door leer- en trainingsperiodes heen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v19,
    title: 'Ik denk over mijn acties na, zodat ik ze kan verbeteren'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v20,
    title: 'Het kost me niet veel tijd om te herstellen van een stressvolle gebeurtenis'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v21,
    title: 'Hoe goed je bent in <em>mijn activiteit</em> zal altijd verbeteren als je eraan werkt'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v22,
    title: 'Het is moeilijk voor mij om terug te veren wanneer er iets ergs gebeurt'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v23,
    title: 'Het is moeilijk om te veranderen hoe goed je bent in <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v24,
    title: 'Ik ben erg gehecht aan <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v25,
    title: 'Ik kom meestal met weinig moeite door moeilijke tijden'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v26,
    title: 'Ik zal zo lang mogelijk <em>mijn activiteit</em> blijven doen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v27,
    title: 'Om goed te zijn in <em>mijn activiteit</em> moet je van nature getalenteerd zijn'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v28,
    title: 'Om nieuwe ideeën te begrijpen, denk ik na over mijn ervaringen uit het verleden'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v29,
    title: 'Ik ben bereid om bijna alles te doen om <em>mijn activiteit</em> te blijven doen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v30,
    title: 'Als je er voldoende moeite voor doet word je altijd beter in <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v31,
    title: 'Ik doe er meestal lang over om tegenslagen in mijn leven te overwinnen'
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v32,
    title: 'Ik probeer na te denken over hoe ik dingen de volgende keer beter kan doen',
    section_end: true
  }), {
    section_start: "",
    id: :v32a,
    hidden: false,
    type: :raw,
    content: {
      nl: "<p class=\"flow-text\" style=\"font-size:medium;\">Hieronder staan 8 uitspraken die kunnen worden gebruikt om ervaringen in jouw prestatiedomein te beschrijven. Als er in de stelling staat 'mijn activiteit' dan wordt er dus gedoeld op jouw specifieke prestatiedomein. Is jouw prestatiedomein bijvoorbeeld basketbal, dan vul je hier voor jezelf ‘basketbal’ in. Doe je een dansopleiding? Dan vul je hier voor jezelf ‘dans’ in, etc. Als er in de stelling staat trainer/ coach/ docent, dan kies je de rol die in jouw prestatiedomein van toepassing is. Doe je een opleiding? Dan kies je hier ‘docent’. Werk je voornamelijk met een coach? Dan vul je hier voor jezelf ‘coach’ in.</p><p class=\"flow-text\" style=\"font-size:medium;\">Lees elke uitspraak zorgvuldig en herinner je zo nauwkeurig mogelijk hoe vaak jij hetzelfde ervaart. Kies het antwoord dat <strong>het beste bij je past, ook hier zijn geen 'goede' of 'foute' antwoorden</strong>. Besteed niet te veel tijd aan een bepaalde uitspraak. Je kunt kiezen uit de volgende antwoorden:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Bijna nooit</strong><br />Als je dit bijna nooit doet, of als deze uitspraak bijna niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Soms</strong><br />Als je dit soms doet, of als deze uitspraak een beetje bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Vaak</strong><br />Als je dit vaak doet, of als deze uitspraak goed bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Bijna altijd</strong><br />Als je dit bijna altijd doet, of als deze uitspraak bijna helemaal bij je past</p>"
    }
  }, PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v33,
    title: 'Als een trainer/ coach/ docent mij vertelt hoe ik een fout die ik heb gemaakt moet corrigeren, vat ik dat vaak persoonlijk op en ben ik van streek'
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v34,
    title: 'Als ik bezig ben met <em>mijn activiteit</em>, kan ik mijn aandacht richten en afleiding blokkeren'
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v35,
    title: 'Wanneer een trainer/ coach/ docent kritiek op mij heeft raak ik eerder van streek dan dat het mij helpt'
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v36,
    title: 'Het is makkelijk voor mij om te voorkomen dat afleidende gedachten interfereren met iets waar ik naar kijk of naar luister'
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v37,
    title: 'Als een trainer/ coach/ docent mij bekritiseert of tegen me uitvalt, verbeter ik de fout zonder er van streek door te raken'
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v38,
    title: 'Ik ga heel goed om met onverwachte situaties in <em>mijn activiteit</em>'
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v39,
    title: 'Het is makkelijk voor mij om mijn aandacht of focus te richten op een enkel object of persoon'
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v40,
    title: 'Ik verbeter mijn vaardigheden door goed te luisteren naar tips en instructies van trainers/ coaches/ docenten',
    section_end: true
  }), {
    section_start: "",
    id: :v40a,
    hidden: false,
    type: :raw,
    content: {
      nl: "<p class=\"flow-text\" style=\"font-size:medium;\">De volgende 9 uitspraken gaan over jezelf in jouw prestatiedomein. Lees elke uitspraak zorgvuldig en kies het antwoord <strong>dat het beste bij je past, ook hier zijn geen 'goede' of 'foute' antwoorden</strong>. Besteed niet te veel tijd aan een bepaalde stelling. Je kunt kiezen uit de volgende antwoorden:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Nooit</strong><br />Als je dit nooit doet, of als de uitspraak helemaal niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Zelden</strong><br />Als je dit zelden doet, of als de uitspraak niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Soms</strong><br />Als je dit soms doet, of als de uitspraak wel en niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Vaak</strong><br />Als je dit vaak doet, of als de uitspraak bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Altijd</strong><br />Als je dit altijd doet, of als de uitspraak helemaal bij je past</p>"
    }
  }, PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v41,
    title: 'Ik heb een doel bereikt dat jaren werk heeft gekost',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v42,
    title: 'Ik heb tegenslagen overwonnen om een belangrijke uitdaging te overwinnen',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v43,
    title: 'De meeste prestaties ga ik met vertrouwen in dat ik het goed zal doen',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v44,
    title: 'Tegenslagen ontmoedigen mij niet',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v45,
    title: 'Ik maak af waar ik aan begin',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v46,
    title: 'Ik kan meestal zelfverzekerd blijven, zelfs tijdens een van mijn slechtere prestaties',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v47,
    title: 'Ik ben een harde werker',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v48,
    title: 'Ik ben ijverig',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v49,
    title: 'Ik heb vertrouwen in mezelf',
    section_end: true
  }), {
    section_start: "",
    id: :v49a,
    hidden: false,
    type: :raw,
    content: {
      nl: "<p class=\"flow-text\" style=\"font-size:medium;\">De volgende 10 uitspraken gaan over jezelf binnen jouw prestatiedomein. Geef aan of deze uitspraken bij jou passen. Lees elke uitspraak zorgvuldig en kies het antwoord <strong>dat het beste bij je past, er zijn geen 'goede' of 'foute' antwoorden</strong>. Besteed niet te veel tijd aan een bepaalde uitspraak. Je kunt kiezen uit de volgende antwoorden:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Nooit</strong><br />Als je dit nooit doet, of als de uitspraak helemaal niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Zelden</strong><br />Als je dit zelden doet, of als de uitspraak niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Soms</strong><br />Als je dit soms doet, of als de uitspraak wel en niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Vaak</strong><br />Als je dit vaak doet, of als de uitspraak bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Altijd</strong><br />Als je dit altijd doet, of als de uitspraak helemaal bij je past</p>"
    }
  }, PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v50,
    title: 'Ik ben me bewust van hoe ik me voel',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v51,
    title: 'Ik kan goed uitdrukken hoe ik me voel',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v52,
    title: 'Ik ga over mijn grenzen heen op fysiek gebied',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v53,
    title: 'Ik ga over mijn grenzen heen op mentaal gebied',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v54,
    title: 'Ik kan goed aangeven wanneer er te veel van me wordt gevraagd',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v55,
    title: 'Ik kan op een effectieve manier \'nee\' zeggen en mijn grenzen aangeven',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v56,
    title: 'Ik vraag om hulp als ik pijn en oververmoeidheid ervaar',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v57,
    title: 'Ik neem verantwoordelijkheid voor het bewaken van mijn grenzen',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v58,
    title: 'Ik geef uit mezelf aan waar mijn grenzen liggen',
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v59,
    title: 'Ik spreek mensen erop aan als ze over mijn grenzen gaan',
    section_end: true
  })
]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Coachbaarheid',
      ids: %i[v33 v35 v37 v40],
      preprocessing: {
        v33: invert,
        v35: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Reflectie',
      ids: %i[v5 v11 v19 v28 v32],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Groeimindset',
      ids: %i[v4 v6 v9 v10 v12 v13 v16 v18 v21 v23 v27 v30],
      preprocessing: {
        v4: invert,
        v9: invert,
        v10: invert,
        v16: invert,
        v23: invert,
        v27: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s4,
      label: 'Commitment',
      ids: %i[v7 v14 v17 v24 v26 v29],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s5,
      label: 'Zelfvertrouwen',
      ids: %i[v43 v46 v49],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s6,
      label: 'Focus',
      ids: %i[v34 v36 v38 v39],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s7,
      label: 'Veerkracht',
      ids: %i[v8 v15 v20 v22 v25 v31],
      preprocessing: {
        v15: invert,
        v22: invert,
        v31: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s8,
      label: 'Doorzettingsvermogen',
      ids: %i[v41 v42 v44 v45 v47 v48],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s9,
      label: 'Grenzen stellen bewaken',
      ids: %i[v50 v51 v52 v53 v54 v55 v56 v57 v58 v59],
      preprocessing: {
        v52: invert,
        v53: invert
      },
      operation: :average,
      round_to_decimals: 0 }
  ]
}
dagboek1.title = db_title
dagboek1.save!
