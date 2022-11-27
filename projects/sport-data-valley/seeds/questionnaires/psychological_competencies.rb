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
      {
        title: {
          nl: 'Helemaal mee oneens',
          en: 'Strongly disagree'
        },
        numeric_value: 0
      },
      {
        title: {
          nl: 'Mee oneens',
          en: 'Disagree'
        },
        numeric_value: 25
      },
      {
        title: {
          nl: 'Neutraal',
          en: 'Neutral'
        },
        numeric_value: 50
      },
      {
        title: {
          nl: 'Mee eens',
          en: 'Agree'
        },
        numeric_value: 75
      },
      {
        title: {
          nl: 'Helemaal mee eens',
          en: 'Strongly agree'
        },
        numeric_value: 100
      }
    ],
    hidden: false,
  }
  FREQUENCY_QUESTION_OPTIONS = {
    type: :likert,
    options: [
      {
        title: {
          nl: 'Bijna nooit',
          en: 'Almost never'
        },
        numeric_value: 0
      },
      {
        title: {
          nl: 'Soms',
          en: 'Sometimes'
        },
        numeric_value: 33
      },
      {
        title: {
          nl: 'Vaak',
          en: 'Often'
        },
        numeric_value: 67
      },
      {
        title: {
          nl: 'Bijna altijd',
          en: 'Almost always'
        },
        numeric_value: 100
      }
    ],
    hidden: false,
  }
  ABSOLUTE_FREQUENCY_QUESTION_OPTIONS = {
    type: :likert,
    options: [
      {
        title: {
          nl: 'Nooit',
          en: 'Never'
        },
        numeric_value: 0
      },
      {
        title: {
          nl: 'Zelden',
          en: 'Rarely'
        },
        numeric_value: 25
      },
      {
        title: {
          nl: 'Soms',
          en: 'Sometimes'
        },
        numeric_value: 50
      },
      {
        title: {
          nl: 'Vaak',
          en: 'Often'
        },
        numeric_value: 75
      },
      {
        title: {
          nl: 'Altijd',
          en: 'Always'
        },
        numeric_value: 100
      }
    ],
    hidden: false,
  }
end

dagboek_content = [
  {
    type: :raw,
    content: {
      nl: "<h2>Vragenlijst psychologische competenties</h2>\n<p class=\"flow-text\" style=\"font-size:medium;\">Beste deelnemer,</p>\n<p class=\"flow-text\" style=\"font-size:medium;\">Welkom bij de vragenlijst psychologische competenties.</p><p class=\"flow-text\" style=\"font-size:medium;\">Deze vragenlijst is ontwikkeld om inzicht te krijgen in de psychologische competenties van deelnemers die actief zijn in een bepaald prestatiedomein. Hierbij kan onder andere gedacht worden aan: sport, muziek, dans, ALO of de politie. Psychologische competenties zijn relatief stabiele vaardigheden die van belang zijn om op hoog niveau te kunnen presteren. Voorbeelden hiervan zijn focus, veerkracht en commitment. Ook kan het beheersen van deze vaardigheden het risico op gezondheidsproblemen verkleinen en het algeheel welzijn verbeteren. De vragen in deze vragenlijst hebben betrekking op jouw ervaringen en perspectieven binnen jouw prestatiedomein.</p>\n<h3>Procedure</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\"><ul class='browser-default'><li>Het invullen van de vragenlijst duurt ongeveer 15 minuten.</li><li>Zorg ervoor dat je op een rustige plek bent waar je ongestoord kunt werken zonder te overleggen met anderen.</li><li>Zet je telefoon op ‘niet storen’ zodat je geen berichtjes ontvangt.</li><li>Laat je niet afleiden tijdens het invullen, probeer je volledige aandacht bij de vragenlijst te houden.</li></ul><h3>Uitleg vragenlijst</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\"><ul class='browser-default'><li>Let goed op de instructie die boven de vragen en stellingen staat. Hierin wordt meer informatie gegeven over de bijbehorende stellingen.</li><li>Je kunt steeds maar één antwoord kiezen.</li><li>Het is van belang om alle vragen te beantwoorden en alle stellingen van een antwoord te voorzien.</li><li>Beantwoord de vragen zo eerlijk mogelijk en geef je eigen mening.</li><li>Er zijn geen 'goede' of 'foute' antwoorden!</li></ul>",
      en: "<h2>Questionnaire psychological competencies</h2>\n<p class=\"flow-text\" style=\"font-size:medium;\">Dear Participant,</p>\n<p class=\"flow-text\" style=\"font-size:medium;\">Welcome to the psychological competencies questionnaire.</p><p class=\"flow-text\" style=\"font-size:medium;\">This questionnaire was developed to gain insight into the psychological competencies of participants who are active in a particular performance domain. A few examples of these performance domains are: sports, music, dance, physical education and the police. Psychological competencies are relatively stable skills that are important for high performance. Examples are focus, resilience and commitment. Mastering these skills can also reduce the risk of health problems and improve overall well-being. The questions in this questionnaire relate to your experiences and perspectives within your performance domain.</p>\n<h3>Procedure</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\"><ul class='browser-default'><li>Completing the questionnaire takes about 15 minutes.</li><li>Make sure you are in a quiet place, so you won’t be disturbed.</li><li>Complete the questionnaire without consulting others.</li><li>Set your phone to 'do not disturb', so that you do not receive any messages.</li><li>Try to not get distracted, try to keep your full attention on completing the questionnaire.</li></ul><h3>Questionnaire explanation</h3>\n<p class=\"flow-text\" style=\"font-size:medium;\"><ul class='browser-default'><li>Pay close attention to the instructions above the statements. This provides more information about the corresponding statements.</li><li>You can only choose one answer at a time.</li><li>It is important to answer all questions and statements.</li><li>Answer the questions as honestly as possible and give your own opinion. There are no 'right' or 'wrong' answers!</li></ul>"
    }
  }, {
    section_start: "",
    id: :v3b,
    type: :raw,
    hidden: false,
    content: {
      nl: "<p class=\"flow-text\" style=\"font-size:medium;\">De volgende 29 uitspraken gaan over jezelf in jouw prestatiedomein. Als er in de stelling staat 'mijn activiteit' dan wordt er dus gedoeld op jouw specifieke prestatiedomein. Is jouw prestatiedomein bijvoorbeeld basketbal, dan vul je hier voor jezelf ‘basketbal’ in. Doe je een dansopleiding? Dan vul je hier voor jezelf ‘dans’ in, etc.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\">Het is van belang om de vragen zo eerlijk mogelijk in te vullen en je eigen mening te geven. Bij deze vragen kun je uit 5 antwoorden kiezen. Lees de vragen goed door en sla geen vragen over. Kies het antwoord dat het beste bij je past. Er zijn geen 'goede' of 'foute' antwoorden! Je kunt kiezen uit de volgende antwoorden:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Helemaal mee oneens</strong><br />Als je het helemaal oneens bent met de uitspraak, of als de uitspraak helemaal niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Mee oneens</strong><br />Als je het oneens bent met de uitspraak, of als de uitspraak niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Neutraal</strong><br />Als je niet kunt beslissen, of als de uitspraak wel en niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Mee eens</strong><br />Als je het eens bent met de uitspraak, of als de uitspraak wel bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Helemaal mee eens</strong><br />Als je het helemaal eens bent met de uitspraak, of als de uitspraak helemaal bij je past</p>",
      en: "<p class=\"flow-text\" style=\"font-size:medium;\">The following 29 statements are about yourself in your performance domain. When the statement says 'my activity' it is referring to your specific performance domain. For example, if your performance domain is basketball, then you enter 'basketball' here for yourself. Do you study dance? Then replace ‘my activity’ for 'dance', etc.</p>\n<p class=\"flow-text\" style=\"font-size:medium;\">It is important to read the statements and choose your answer <strong>as honestly as possible</strong>, and to give <strong>your own opinion</strong>. For these statements you can choose from 5 answers. Read the statements carefully and do not skip any statements. Choose the answer that suits you best. <strong>There are no 'right' or 'wrong' answers!</strong> You can choose from the following answers:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Strongly disagree</strong><br />If you totally disagree with the statement, or if the statement doesn't suit you at all</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Disagree</strong><br />If you disagree with the statement, or if the statement doesn't suit you</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Neutral</strong><br />If you cannot decide, or if the statement does and does not suit you</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Agree</strong><br />If you agree with the statement, or if the statement suits you</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Strongly agree</strong><br />If you totally agree with the statement, or if the statement suits you completely</p>"
    }
  }, PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v4,
    title: {
      nl: 'Je hebt een bepaald niveau in <em>mijn activiteit</em> en je kunt niet echt veel doen om dat niveau te veranderen',
      en: 'You have a certain level of ability in <em>my activity</em> and you cannot really do much to change that level'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v5,
    title: {
      nl: 'Ik beoordeel de dingen die ik heb meegemaakt, zodat ik ervan kan leren',
      en: 'I reappraise my experiences so I can learn from them'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v6,
    title: {
      nl: 'Om succesvol te zijn in <em>mijn activiteit</em> moet je technieken en vaardigheden leren en deze regelmatig oefenen',
      en: 'To be successful in <em>my activity</em> you need to learn techniques and skills, and practice them regularly'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v7,
    title: {
      nl: 'Ik ben toegewijd om <em>mijn activiteit</em> te blijven doen',
      en: 'I am dedicated to keep doing <em>my activity</em>'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v8,
    title: {
      nl: 'Doorgaans herstel ik snel na moeilijke momenten',
      en: 'I tend to bounce back quickly after hard times'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v9,
    title: {
      nl: 'Zelfs als je het probeert, zal het niveau dat je bereikt in <em>mijn activiteit</em> weinig veranderen',
      en: 'Even if you try, the level you reach in <em>my activity</em> will change very little'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v10,
    title: {
      nl: 'Je moet een bepaalde "gave" hebben om goed te zijn in <em>mijn activiteit</em>',
      en: 'You need to have a certain "gift" to be good at <em>my activity</em>'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v11,
    title: {
      nl: 'Ik probeer na te denken over mijn sterke en zwakke punten',
      en: 'I try to think about my strengths and weaknesses'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v12,
    title: {
      nl: 'Je moet leren en hard werken om goed te zijn in <em>mijn activiteit</em>',
      en: 'You need to learn and to work hard to be good at <em>my activity</em>'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v13,
    title: {
      nl: 'Als je hard werkt word je altijd beter in mijn <em>activiteit</em>',
      en: 'In <em>my activity</em>, if you work hard at it, you will always get better'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v14,
    title: {
      nl: 'Ik ben bereid elk obstakel te overwinnen om <em>mijn activiteit</em> te blijven doen',
      en: 'I am willing to overcome any obstacle to keep doing <em>my activity</em>'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v15,
    title: {
      nl: 'Ik vind het moeilijk om door stressvolle gebeurtenissen heen te komen',
      en: 'I have a hard time making it through stressful events'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v16,
    title: {
      nl: 'Om goed te zijn in <em>mijn activiteit</em> moet je geboren zijn met bepaalde basiskwaliteiten die je succes mogelijk maken',
      en: 'To be good at <em>my activity</em>, you need to be born with the basic qualities which allow you success'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v17,
    title: {
      nl: 'Ik ben vastbesloten om <em>mijn activiteit</em> te blijven doen',
      en: 'I am determined to keep doing <em>my activity</em>'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v18,
    title: {
      nl: 'Om een hoog prestatieniveau in <em>mijn activiteit</em> te bereiken moet je door leer- en trainingsperiodes heen',
      en: 'To reach a high level of performance in <em>my activity</em>, you must go through periods of learning and training'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v19,
    title: {
      nl: 'Ik denk over mijn acties na, zodat ik ze kan verbeteren',
      en: 'I think about my actions to see whether I can improve them'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v20,
    title: {
      nl: 'Het kost me niet veel tijd om te herstellen van een stressvolle gebeurtenis',
      en: 'It does not take me long to recover from a stressful event'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v21,
    title: {
      nl: 'Hoe goed je bent in <em>mijn activiteit</em> zal altijd verbeteren als je eraan werkt',
      en: 'How good you are at <em>my activity</em> will always improve if you work at it'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v22,
    title: {
      nl: 'Het is moeilijk voor mij om terug te veren wanneer er iets ergs gebeurt',
      en: 'It is hard for me to snap back when something bad happens'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v23,
    title: {
      nl: 'Het is moeilijk om te veranderen hoe goed je bent in <em>mijn activiteit</em>',
      en: 'It is difficult to change how good you are at <em>my activity</em>'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v24,
    title: {
      nl: 'Ik ben erg gehecht aan <em>mijn activiteit</em>',
      en: 'I am very attached to <em>my activity</em>'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v25,
    title: {
      nl: 'Ik kom meestal met weinig moeite door moeilijke tijden',
      en: 'I usually get through difficult times with little trouble'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v26,
    title: {
      nl: 'Ik zal zo lang mogelijk <em>mijn activiteit</em> blijven doen',
      en: 'I will continue to do <em>my activity</em> for as long as I can'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v27,
    title: {
      nl: 'Om goed te zijn in <em>mijn activiteit</em> moet je van nature getalenteerd zijn',
      en: 'To be good at <em>my activity</em> you need to be naturally gifted'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v28,
    title: {
      nl: 'Om nieuwe ideeën te begrijpen, denk ik na over mijn ervaringen uit het verleden',
      en: 'I think about my past experiences to understand new ideas'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v29,
    title: {
      nl: 'Ik ben bereid om bijna alles te doen om <em>mijn activiteit</em> te blijven doen',
      en: 'I am willing to do almost anything to keep doing <em>my activity</em>'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v30,
    title: {
      nl: 'Als je er voldoende moeite voor doet word je altijd beter in <em>mijn activiteit</em>',
      en: 'If you put enough effort into it, you will always get better at <em>my activity</em>'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v31,
    title: {
      nl: 'Ik doe er meestal lang over om tegenslagen in mijn leven te overwinnen',
      en: 'I tend to take a long time to get over set-backs in my life'
    }
  }), PsychologicalCompetenciesMethods::DEFAULT_QUESTION_OPTIONS.merge(
  {
    id: :v32,
    title: {
      nl: 'Ik probeer na te denken over hoe ik dingen de volgende keer beter kan doen',
      en: 'I try to think about how I can do things better next time'
    },
    section_end: true
  }), {
    section_start: "",
    id: :v32a,
    hidden: false,
    type: :raw,
    content: {
      nl: "<p class=\"flow-text\" style=\"font-size:medium;\">Hieronder staan 8 uitspraken die kunnen worden gebruikt om ervaringen in jouw prestatiedomein te beschrijven. Als er in de stelling staat 'mijn activiteit' dan wordt er dus gedoeld op jouw specifieke prestatiedomein. Is jouw prestatiedomein bijvoorbeeld basketbal, dan vul je hier voor jezelf ‘basketbal’ in. Doe je een dansopleiding? Dan vul je hier voor jezelf ‘dans’ in, etc. Als er in de stelling staat trainer/ coach/ docent, dan kies je de rol die in jouw prestatiedomein van toepassing is. Doe je een opleiding? Dan kies je hier ‘docent’. Werk je voornamelijk met een coach? Dan vul je hier voor jezelf ‘coach’ in.</p><p class=\"flow-text\" style=\"font-size:medium;\">Lees elke uitspraak zorgvuldig en herinner je zo nauwkeurig mogelijk hoe vaak jij hetzelfde ervaart. Kies het antwoord dat <strong>het beste bij je past, ook hier zijn geen 'goede' of 'foute' antwoorden</strong>. Besteed niet te veel tijd aan een bepaalde uitspraak. Je kunt kiezen uit de volgende antwoorden:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Bijna nooit</strong><br />Als je dit bijna nooit doet, of als deze uitspraak bijna niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Soms</strong><br />Als je dit soms doet, of als deze uitspraak een beetje bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Vaak</strong><br />Als je dit vaak doet, of als deze uitspraak goed bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Bijna altijd</strong><br />Als je dit bijna altijd doet, of als deze uitspraak bijna helemaal bij je past</p>",
      en: "<p class=\"flow-text\" style=\"font-size:medium;\">Below are 8 statements that can be used to describe experiences in your performance domain. When the statement says 'my activity' it is referring to your specific performance domain. For example, if your performance area is basketball, then you should enter 'basketball' here for yourself. Do you study dance? Then replace ‘my activity’ for 'dance', etc. If the statement says trainer/coach/teacher, then choose the role that applies in your performance domain. Are you doing an education programme? Then choose 'teacher' here. Do you work mainly with a coach? Then fill in 'coach' here.</p><p class=\"flow-text\" style=\"font-size:medium;\">Read each statement carefully and remember as accurately as possible how often you experience the same thing. Choose the answer that <strong>suits you best</strong>, there are <strong>no 'right' or 'wrong' answers</strong> here either. Don't spend too much time on a particular statement. You can choose from the following answers:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Almost never</strong><br />If you hardly ever do this, or if this statement hardly suits you</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Sometimes</strong><br />If you do this sometimes, or if this statement suits you a bit</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Often</strong><br />If you do this often, or if this statement suits you well</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Almost always</strong><br />If you almost always do this, or if this statement suits you almost completely</p>"
    }
  }, PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v33,
    title: {
      nl: 'Als een trainer/ coach/ docent mij vertelt hoe ik een fout die ik heb gemaakt moet corrigeren, vat ik dat vaak persoonlijk op en ben ik van streek',
      en: 'When a trainer/ coach/ teacher tells me how to correct a mistake I\'ve made, I tend to take it personally and feel upset'
    }
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v34,
    title: {
      nl: 'Als ik bezig ben met <em>mijn activiteit</em>, kan ik mijn aandacht richten en afleiding blokkeren',
      en: 'When I am doing <em>my activity</em>, I can focus my attention and block out distractions'
    }
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v35,
    title: {
      nl: 'Wanneer een trainer/ coach/ docent kritiek op mij heeft raak ik eerder van streek dan dat het mij helpt',
      en: 'When a trainer/ coach/ teacher criticizes me, I become upset rather than helped'
    }
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v36,
    title: {
      nl: 'Het is makkelijk voor mij om te voorkomen dat afleidende gedachten interfereren met iets waar ik naar kijk of naar luister',
      en: 'It is easy for me to keep distracting thoughts from interfering with something I am watching or listening to'
    }
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v37,
    title: {
      nl: 'Als een trainer/ coach/ docent mij bekritiseert of tegen me uitvalt, verbeter ik de fout zonder er van streek door te raken',
      en: 'If a trainer/ coach/ teacher criticizes me or falls out at me, I correct the mistake without getting upset about it'
    }
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v38,
    title: {
      nl: 'Ik ga heel goed om met onverwachte situaties in <em>mijn activiteit</em>',
      en: 'I handle unexpected situations in <em>my activity</em> very well'
    }
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v39,
    title: {
      nl: 'Het is makkelijk voor mij om mijn aandacht of focus te richten op een enkel object of persoon',
      en: 'It is easy for me to direct my attention or focus on a single object or person'
    }
  }), PsychologicalCompetenciesMethods::FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v40,
    title: {
      nl: 'Ik verbeter mijn vaardigheden door goed te luisteren naar tips en instructies van trainers/ coaches/ docenten',
      en: 'I improve my skills by listening carefully to advice and instruction from trainers/ coaches/ teachers'
    },
    section_end: true
  }), {
    section_start: "",
    id: :v40a,
    hidden: false,
    type: :raw,
    content: {
      nl: "<p class=\"flow-text\" style=\"font-size:medium;\">De volgende 9 uitspraken gaan over jezelf in jouw prestatiedomein. Lees elke uitspraak zorgvuldig en kies het antwoord <strong>dat het beste bij je past, ook hier zijn geen 'goede' of 'foute' antwoorden</strong>. Besteed niet te veel tijd aan een bepaalde stelling. Je kunt kiezen uit de volgende antwoorden:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Nooit</strong><br />Als je dit nooit doet, of als de uitspraak helemaal niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Zelden</strong><br />Als je dit zelden doet, of als de uitspraak niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Soms</strong><br />Als je dit soms doet, of als de uitspraak wel en niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Vaak</strong><br />Als je dit vaak doet, of als de uitspraak bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Altijd</strong><br />Als je dit altijd doet, of als de uitspraak helemaal bij je past</p>",
      en: "<p class=\"flow-text\" style=\"font-size:medium;\">The next 9 statements are about yourself in your performance domain. Read each statement carefully and choose the answer that <strong>suits you best</strong>, there are <strong>no 'right' or 'wrong' answers</strong> here either. Don't spend too much time on a particular statement. You can choose from the following answers:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Never</strong><br />If you never do this, or if the statement doesn't suit you at all</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Rarely</strong><br />If you rarely do this, or if the statement doesn't suit you</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Sometimes</strong><br />If you do this sometimes, or if the statement does and does not suit you</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Often</strong><br />If you do this often, or if the statement suits you</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Always</strong><br />If you always do this, or if the statement suits you completely</p>"
    }
  }, PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v41,
    title: {
      nl: 'Ik heb een doel bereikt dat jaren werk heeft gekost',
      en: 'I have achieved a goal that took years of work'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v42,
    title: {
      nl: 'Ik heb tegenslagen overwonnen om een belangrijke uitdaging te overwinnen',
      en: 'I have overcome setbacks to conquer an important challenge'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v43,
    title: {
      nl: 'De meeste prestaties ga ik met vertrouwen in dat ik het goed zal doen',
      en: 'In most performances, I go in confident that I will do well'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v44,
    title: {
      nl: 'Tegenslagen ontmoedigen mij niet',
      en: 'Setbacks don\'t discourage me'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v45,
    title: {
      nl: 'Ik maak af waar ik aan begin',
      en: 'I finish whatever I begin'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v46,
    title: {
      nl: 'Ik kan meestal zelfverzekerd blijven, zelfs tijdens een van mijn slechtere prestaties',
      en: 'I can usually remain confident even through one of my poorer performances'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v47,
    title: {
      nl: 'Ik ben een harde werker',
      en: 'I am a hard worker'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v48,
    title: {
      nl: 'Ik ben ijverig',
      en: 'I am diligent'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v49,
    title: {
      nl: 'Ik heb vertrouwen in mezelf',
      en: 'I have faith in myself'
    },
    section_end: true
  }), {
    section_start: "",
    id: :v49a,
    hidden: false,
    type: :raw,
    content: {
      nl: "<p class=\"flow-text\" style=\"font-size:medium;\">De volgende 10 uitspraken gaan over jezelf binnen jouw prestatiedomein. Geef aan of deze uitspraken bij jou passen. Lees elke uitspraak zorgvuldig en kies het antwoord <strong>dat het beste bij je past, er zijn geen 'goede' of 'foute' antwoorden</strong>. Besteed niet te veel tijd aan een bepaalde uitspraak. Je kunt kiezen uit de volgende antwoorden:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Nooit</strong><br />Als je dit nooit doet, of als de uitspraak helemaal niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Zelden</strong><br />Als je dit zelden doet, of als de uitspraak niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Soms</strong><br />Als je dit soms doet, of als de uitspraak wel en niet bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Vaak</strong><br />Als je dit vaak doet, of als de uitspraak bij je past</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Altijd</strong><br />Als je dit altijd doet, of als de uitspraak helemaal bij je past</p>",
      en: "<p class=\"flow-text\" style=\"font-size:medium;\">The next 10 statements are about yourself within your performance domain. Please indicate whether these statements apply to you. Read each statement carefully and choose the answer that <strong>suits you best</strong>, there are <strong>no 'right' or 'wrong'</strong> answers. Don't spend too much time on a particular statement. You can choose from the following answers:</p><p class=\"flow-text\" style=\"font-size:medium;\"><strong>Never</strong><br />If you never do this, or if the statement doesn't suit you at all</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Rarely</strong><br />If you rarely do this, or if the statement doesn't suit you</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Sometimes</strong><br />If you do this sometimes, or if the statement does and does not suit you</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Often</strong><br />If you do this often, or if the statement suits you</p>\n<p class=\"flow-text\" style=\"font-size:medium;\"><strong>Always</strong><br />If you always do this, or if the statement suits you completely</p>"
    }
  }, PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v50,
    title: {
      nl: 'Ik ben me bewust van hoe ik me voel',
      en: 'I recognize how I feel'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v51,
    title: {
      nl: 'Ik kan goed uitdrukken hoe ik me voel',
      en: 'I can express how I feel to others'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v52,
    title: {
      nl: 'Ik ga over mijn grenzen heen op fysiek gebied',
      en: 'I cross my physical boundaries'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v53,
    title: {
      nl: 'Ik ga over mijn grenzen heen op mentaal gebied',
      en: 'I cross my psychological boundaries'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v54,
    title: {
      nl: 'Ik kan goed aangeven wanneer er te veel van me wordt gevraagd',
      en: 'I can communicate to others when they are asking too much of me'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v55,
    title: {
      nl: 'Ik kan op een effectieve manier \'nee\' zeggen en mijn grenzen aangeven',
      en: 'I can effectively say ‘no’ and protect my boundaries'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v56,
    title: {
      nl: 'Ik vraag om hulp als ik pijn en oververmoeidheid ervaar',
      en: 'I ask for help when I when I feel overtired or overtrained'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v57,
    title: {
      nl: 'Ik neem verantwoordelijkheid voor het bewaken van mijn grenzen',
      en: 'I take responsibility to protect my boundaries'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v58,
    title: {
      nl: 'Ik geef uit mezelf aan waar mijn grenzen liggen',
      en: 'I show initiative in communicating what boundaries I have'
    },
  }), PsychologicalCompetenciesMethods::ABSOLUTE_FREQUENCY_QUESTION_OPTIONS.merge(
  {
    id: :v59,
    title: {
      nl: 'Ik spreek mensen erop aan als ze over mijn grenzen gaan',
      en: 'I actively communicate to other people when they are crossing my boundaries'
    },
    section_end: true
  })
]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: { nl: 'Coachbaarheid', en: 'Coachability' },
      ids: %i[v33 v35 v37 v40],
      preprocessing: {
        v33: invert,
        v35: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: { nl: 'Reflectie', en: 'Reflection' },
      ids: %i[v5 v11 v19 v28 v32],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: { nl: 'Groeimindset', en: 'Growth mindset' },
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
      label: { nl: 'Commitment', en: 'Commitment' },
      ids: %i[v7 v14 v17 v24 v26 v29],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s5,
      label: { nl: 'Zelfvertrouwen', en: 'Confidence' },
      ids: %i[v43 v46 v49],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s6,
      label: { nl: 'Focus', en: 'Focus' },
      ids: %i[v34 v36 v38 v39],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s7,
      label: { nl: 'Veerkracht', en: 'Resilience' },
      ids: %i[v8 v15 v20 v22 v25 v31],
      preprocessing: {
        v15: invert,
        v22: invert,
        v31: invert
      },
      operation: :average,
      round_to_decimals: 0 },
    { id: :s8,
      label: { nl: 'Doorzettingsvermogen', en: 'Perseverance' },
      ids: %i[v41 v42 v44 v45 v47 v48],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s9,
      label: { nl: 'Grenzen stellen bewaken', en: 'Set and protect boundaries' },
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
