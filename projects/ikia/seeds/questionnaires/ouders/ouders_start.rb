# frozen_string_literal: true

db_title = 'Start'

db_name1 = 'Start_Ouders'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! We beginnen ons onderzoek met een paar vragen over wie u bent. Het invullen van deze vragenlijst duurt ongeveer 5 minuten.</p>'
  }, {
    id: :v1,
    type: :radio,
    show_otherwise: false,
    title: 'Wat is uw geslacht?',
    options: ['Man', 'Vrouw', 'Anders/ wil ik niet zeggen']
  }, {
    id: :v2,
    type: :dropdown,
    title: 'Wanneer bent u geboren? <br><br>Maand:',
    options: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december']
  }, {
    id: :v3,
    type: :number,
    title: 'Jaar:',
    tooltip: 'Vul een jaartal in vanaf 1940 als geboortejaar, bijvoorbeeld: 1976.',
    maxlength: 4,
    placeholder: 'Vul hier een getal in',
    min: 1940,
    max: 2005,
    required: true
  }, {
    id: :v4,
    type: :number,
    title: 'Wat zijn de vier cijfers van uw postcode?',
    maxlength: 4,
    placeholder: 'Bijvoorbeeld: 9714',
    min: 0,
    max: 9999,
    required: true
  }, {
    id: :v5,
    type: :dropdown,
    title: 'Wat is uw hoogst genoten opleiding?',
    options: [
      'Geen opleiding (lagere school of basisonderwijs niet afgemaakt)',
      'Lager onderwijs (basisonderwijs, speciaal basisonderwijs)',
      'Lager of voorbereidend beroepsonderwijs (zoals LTS, LEAO, LHNO, VMBO)',
      'Middelbaar algemeen voortgezet onderwijs (zoals MAVO, (M)ULO, MBO-kort/MBO-2 of MBO-3, VMBO-t)',
      'Middelbaar beroepsonderwijs of beroepsbegeleidend onderwijs (zoals MBO-lang/ MBO-4, MTS, MEAO, BOL, BBL, INAS) ',
      'Hoger algemeen en voorbereidend wetenschappelijk onderwijs (zoals HAVO, VWO, Atheneum, Gymnasium, HBS, MMS, TTO)',
      'Hoger beroepsonderwijs (zoals HBO bachelor of master, HTS, HEAO, kandidaats wetenschappelijk onderwijs, propedeuse',
      'Wetenschappelijk onderwijs (universiteit bachelor, master, of gepromoveerd)',
      'Anders']
  }, {
    id: :v6,
    type: :number,
    title: 'Hoeveel jaar heeft u onderwijs gehad nadat u de basisschool hebt verlaten?',
    maxlength: 2,
    placeholder: 'Bijvoorbeeld: 3',
    min: 0,
    max: 20,
    required: true
  }, {
    id: :v7,
    type: :radio,
    title: 'Welke situatie is het meest op u van toepassing? (Meerdere antwoorden zijn mogelijk)',
    options: [
      {title: 'Ik werk betaald', shows_questions: %i[v7_a]},
      {title: 'Ik werk onbetaald', shows_questions: %i[v7_b]},
      {title: 'Ik studeer'},
      {title: 'Ik ben werkloos/ werkzoekend'},
      {title: 'Ik zit in de ziektewet of ben gedeeltelijk arbeidsongeschikt'},
      {title: 'Ik heb een bijstandsuitkering'},
      {title: 'Ik ben met pensioen'}]
  }, {
    id: :v7_a,
    hidden: true,
    type: :number,
    title: 'Hoeveel uur werkt u?',
    maxlength: 2,
    placeholder: 'Bijvoorbeeld: 36',
    min: 0,
    max: 70,
  }, {
    id: :v7_b,
    hidden: true,
    type: :radio,
    title: 'Wat voor onbetaald werk doet u?<br><br>Ik ben:',
    options: [
      'Ik ben thuisblijfmoeder/ thuisblijfvader',
      'Ik ben mantelzorger en zorg voor één of meerdere personen',
      'Ik doe vrijwilligerswerk',]
  }, {
    type: :raw,
    content: '<p class="flow-text"> Het is belangrijk dat u de vragenlijsten in dit onderzoek steeds over hetzelfde kind invult. Als u meerdere kinderen heeft waarover u vragenlijsten in wilt vullen, dan kunt u meerdere accounts aanmaken. <br>
<br>
Beslis nu voor uzelf over welk kind u de vragenlijsten in wilt vullen. Als geheugensteuntje kunt u hieronder uw kind een nickname (bijnaam) geven. Deze nickname ziet u in de toekomst bij de vragenlijsten.</p>'
  }, {
    id: :v9,
    type: :textfield,
    title: 'Nickname van uw kind'
  }, {
    id: :v9_1,
    type: :radio,
    show_otherwise: false,
    title: 'Wat is het geslacht van uw kind?',
    options: ['Jongen', 'Meisje', 'Anders/ wil ik niet zeggen'],
    combines_with: %i[v9_3]
  }, {
    id: :v9_2,
    type: :dropdown,
    title: 'Wanneer is uw kind geboren? <br><br>Maand:',
    options: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december']
  }, {
    id: :v9_3,
    type: :number,
    title: 'Jaar:',
    tooltip: 'Vul een jaartal in vanaf 2000 als geboortejaar van uw kind, bijvoorbeeld: 2011.',
    maxlength: 4,
    placeholder: 'Vul hier een getal in',
    min: 2000,
    max: 2014,
    required: true
  }, {
    id: :v9_4,
    type: :radio,
    title: 'Wat is uw relatie tot uw kind?<br><br>Ik ben:',
    options: [
      'Biologische ouder',
      'Adoptie-ouder of pleegouder',
      'Stiefouder of partner van biologische ouder']
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
