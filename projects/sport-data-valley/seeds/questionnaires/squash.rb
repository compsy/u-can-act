# frozen_string_literal: true

db_title = 'SQUASH'

db_name1 = 'squash'
questionnaire = Questionnaire.find_by(name: db_name1)
questionnaire ||= Questionnaire.new(name: db_name1)
questionnaire.key = File.basename(__FILE__)[0...-3]

def combined_day_time_question(id, title, tooltip = nil)
  [{
    id: "v#{id}".to_sym,
    type: :number,
    required: true,
    title: "#{title}<br><em>Dagen/week</em>",
    placeholder: 'Vul het aantal dagen in',
    tooltip: tooltip,
    maxlength: 1,
    min: 0,
    max: 7,
    hidden: true
  },
  {
    id: "v#{id+1}".to_sym,
    type: :time,
    title: '<em>Uren en Minuten / dag</em>',
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: 'uren',
    minutes_label: 'minuten',
    required: true,
    hidden: true
  }]
end

dagboek_content = [
  {
    id: :v1, # 1
    type: :radio,
    show_otherwise: false,
    title: 'Vult u deze lijst in voor iemand jonger of ouder dan 12 jaar?',
    options: [
      { title: 'Jonger', shows_questions: (2..23).map{|x| "v#{x}".to_sym} },
      { title: 'Ouder', shows_questions: (24..47).map{|x| "v#{x}".to_sym}  }
    ]
  }, {
    id: :v2,
    hidden: true,
    type: :raw,
    content: '<p class="flow-text"><u>Woonwerkverkeer</u><br>Neem in uw gedachten een normale week in de afgelopen maanden.<br> Wilt u aangeven hoeveel dagen per week uw kind deze activiteiten verrichtte en hoeveel tijd uw kind daar gemiddeld op zo\'n dag mee bezig was?<br> <strong>Als uw kind een activiteit niet heeft verricht, vul dan een 0 in</strong></p>'
}]
dagboek_content += combined_day_time_question(3, 'Lopen naar school')
dagboek_content += combined_day_time_question(5, 'Fietsen naar school','Het gaat hier om zelf fietsen, achteropzitten telt niet mee')
dagboek_content << {
  id: :v7,
  hidden: true,
  type: :raw,
  content: '<p class="flow-text"><u>Activiteiten op school</u><br>Neem in uw gedachten een normale week in de afgelopen maanden.<br> Wilt u aangeven hoeveel dagen per week uw kind deze activiteiten verrichtte en hoeveel tijd uw kind daar gemiddeld op zo\'n dag mee bezig was? <br> <strong>Als uw kind een activiteit niet heeft verricht, vul dan een 0 in</strong></p>'
}
dagboek_content += combined_day_time_question(8, 'Gymlessen op school')
dagboek_content += combined_day_time_question(10, 'Schoolzwemmen','Het gaat hier specifiek om zwemlessen die via de school van uw kind worden aangeboden. Zwemles buiten schooltijd telt hier niet mee.')
dagboek_content += combined_day_time_question(12, 'Buiten spelen op school','Buitenschoolse opvang telt hier niet mee. Het gaat om activiteiten zoals touwtje springen, skateboarden, renspelletjes en klimmen op het klimrek.')

dagboek_content << {
  id: :v14,
  hidden: true,
  type: :raw,
  content: '<p class="flow-text"><u>Vrije tijd</u><br>Neem in uw gedachten een normale week in de afgelopen maanden.<br> Wilt u aangeven hoeveel dagen per week uw kind deze activiteiten verrichtte en hoeveel tijd uw kind daar gemiddeld op zo\'n dag mee bezig was?<br> <strong>Als uw kind een activiteit niet heeft verricht, vul dan een 0 in</strong></p>'
}
dagboek_content += combined_day_time_question(15, 'Wandelen','Wandelen van en naar school niet meetellen.')
dagboek_content += combined_day_time_question(17, 'Fietsen','Fietsen van en naar school niet meetellen. Het gaat hier om zelf fietsen. Achterop zitten telt niet mee.')
dagboek_content += combined_day_time_question(19, 'Buiten spelen','Buitenschoolse opvang telt hier wel mee. Het gaat om activiteiten zoals touwtje springen, skateboarden, renspelletjes en klimmen op het klimrek of voetballen op straat.')
dagboek_content += combined_day_time_question(21, 'Zwemles', 'Schoolzwemmen telt hier niet mee.')
dagboek_content << {id: :v23,
  hidden: true,
  title: 'Welke sport(en) beoefent uw kind? (bijvoorbeeld fitness/conditietraining, tennis, hardlopen, voetbal). <br> <strong>Maximaal 4 sporten opschrijven(zwemles en gym op school tellen niet mee.)</strong><br> <strong>Als uw kind niet aan sport doet kunt u de vraag overslaan </strong>',
  add_button_label: 'Sport toevoegen',
  remove_button_label: 'Verwijder sport',
  type: :expandable,
  default_expansions: 0,
  max_expansions: 4,
  content: [{
    section_start: '',
    id: :v23_1,
    type: :textarea,
    placeholder: 'Vul de naam van de sport in',
    required: true,
    title: 'Sport',
  },
  {
  id: :v23_2,
    type: :number,
    required: true,
    title: "Hoeveel dagen per week doet uw kind aan deze sport ",
    placeholder: 'Vul het aantal dagen in',
    maxlength: 1,
    min: 0,
    max: 7
  },
  {
    id: :v23_3,
    type: :time,
    title: 'Hoeveel tijd is uw kind gemiddeld op zo\'n dag met deze sport bezig?',
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: 'uren',
    minutes_label: 'minuten',
    required: true
  }]
}

dagboek_content << {
    id: :v24,
    hidden: true,
    type: :raw,
    content: '<p class="flow-text"><u>Woonwerkverkeer</u><br>Neem in uw gedachten een normale week in de afgelopen maanden. Wilt u aangeven hoeveel dagen per week u deze activiteiten verrichtte en hoeveel tijd u daar gemiddeld op zo\'n dag mee bezig was? </p>'
}

dagboek_content << {
    id: :v25,
    hidden: true,
    type: :raw,
    content: '<p class="flow-text"><u>Woon/werk verkeer (heen en terug)</u><br>Als u een activiteit niet heeft verricht, vul dan een 0 in</p>'
}

dagboek_content += combined_day_time_question(26, 'Lopen van en naar werk of school')
dagboek_content += combined_day_time_question(28, 'Fietsen van en naar werk of school')

dagboek_content << {
    id: :v30,
    hidden: true,
    type: :raw,
    content: '<p class="flow-text"><u>Lichamelijke activiteit op werk of school</u><br>Neem in uw gedachten een normale week in de afgelopen maanden. Wilt u aangeven hoeveel uur u gemiddeld per week met deze activiteit bezig was?<br><strong>Als u een activiteit niet heeft verricht, vul dan een 0 in</strong> </p>'
}

dagboek_content << {
  id: :v31,
  type: :time,
  title: 'Licht en matig inspannend werk (zittend/staand werk, met af en toe lopen, zoals bureauwerk of lopend werk met lichte lasten)<br>Uren / week',
  hours_from: 0,
  hours_to: 120,
  hours_step: 1,
  hours_label: 'uren',
  minutes_label: 'minuten',
  required: true,
  hidden: true
}
dagboek_content << {
  id: :v32,
  type: :time,
  title: 'Zwaar inspannend werk (lopend werk of werk waarbij regelmatig zware dingen moeten worden opgetild)',
  hours_from: 0,
  hours_to: 120,
  hours_step: 1,
  hours_label: 'uren',
  minutes_label: 'minuten',
  required: true,
  hidden: true
}

dagboek_content << {
  id: :v33,
  hidden: true,
  type: :raw,
  content: '<p class="flow-text"><u>Huishoudelijke activiteiten</u><br>Neem in uw gedachten een normale week in de afgelopen maanden. Wilt u aangeven hoeveel dagen per week u deze activiteiten verrichtte en hoeveel tijd u daar gemiddeld op zo\'n dag mee bezig was?<br><strong>Als u een activiteit niet heeft verricht, vul dan een 0 in</strong></p>'
}

dagboek_content += combined_day_time_question(34, 'Licht en matig inspannend huishoudelijk werk (staand werk, zoals koken, afwassen, strijken, kind eten geven/in bad doen en lopend werk, zoals stofzuigen, boodschappen doen)')
dagboek_content += combined_day_time_question(36, 'Zwaar inspannend huishoudelijk werk (vloer schrobben, tapijt uitkloppen, met zware boodschappen lopen) ')

dagboek_content << {
  id: :v38,
  hidden: true,
  type: :raw,
  content: '<p class="flow-text"><u>Vrije tijd</u><br>Neem in uw gedachten een normale week in de afgelopen maanden. Wilt u aangeven hoeveel dagen per week u deze activiteiten verrichtte en hoeveel tijd u daar gemiddeld op zo\'n dag mee bezig was?<br><strong>Als u een activiteit niet heeft verricht, vul dan een 0 in</strong></p>'
}

dagboek_content += combined_day_time_question(39, 'Wandelen')
dagboek_content += combined_day_time_question(41, 'Fietsen')
dagboek_content += combined_day_time_question(43, 'Tuinieren')
dagboek_content += combined_day_time_question(45, 'Klussen/doe-het-zelven')

dagboek_content << {
  id: :v47,
  hidden: true,
  title: 'Welke sport(en) beoefent u? (bijvoorbeeld fitness/conditietraining, tennis, hardlopen, voetbal).<br> <strong>Maximaal 4 sporten opschrijven(zwemles en gym op school tellen niet mee.)</strong><br> <strong>Als uw kind niet aan sport doet kunt u de vraag overslaan </strong>',
  add_button_label: 'Sport toevoegen',
  remove_button_label: 'Verwijder sport',
  type: :expandable,
  default_expansions: 0,
  max_expansions: 4,
  content: [{
    section_start: '',
    id: :v47_1,
    type: :textarea,
    placeholder: 'Vul de naam van de sport in',
    required: true,
    title: 'Sport',
  },
  {
  id: :v47_2,
    type: :number,
    required: true,
    title: "Hoeveel dagen per week doet u aan deze sport ",
    placeholder: 'Vul het aantal dagen in',
    maxlength: 1,
    min: 0,
    max: 7
  },
  {
    id: :v47_3,
    type: :time,
    title: 'Hoeveel tijd bent u op zo\'n dag met deze sport bezig?',
    hours_from: 0,
    hours_to: 24,
    hours_step: 1,
    hours_label: 'uren',
    minutes_label: 'minuten',
    required: true
  }]
}


questionnaire.content = { questions: dagboek_content, scores: [] }
questionnaire.title = db_title
questionnaire.save!
