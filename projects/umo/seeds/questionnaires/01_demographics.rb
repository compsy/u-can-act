# frozen_string_literal: true

db_title = ''
db_name1 = 'demographics'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

WERKADRES_QUESTIONS = %i[v8_a]
POSTCODE_WERK_QUESTIONS = %i[v8_b_0 v8_b_a v8_b_b v8_b_c]

dagboek_content = [
  {
    id: :v1,
    type: :textfield,
    title: {
      nl: 'Wat is uw naam?',
      en: 'What is your name?'
    },
    required: true
  }, {
    id: :v2,
    type: :radio,
    title: {
      nl: 'Wat is uw geslacht?',
      en: 'What is your gender identity?'
    },
    required: true,
    show_otherwise: false,
    options: [
      {
        nl: 'Man',
        en: 'Male'
      },
      {
        nl: 'Vrouw',
        en: 'Female'
      },
      {
        nl: 'Anders',
        en: 'Other'
      },
      {
        nl: 'Zeg ik liever niet',
        en: 'Prefer not to say'
      }
    ]
  }, {
    id: :v3,
    type: :number,
    title: {
      nl: 'In welk jaar bent u geboren?',
      en: 'What is your year of birth?'
    },
    min: 1900,
    max: 2030,
    required: true,
    maxlength: 4
  }, {
    type: :raw,
    content: {
      nl: '<p class="flow-text">Om eventuele verhuizingen van mensen bij te houden, willen wij graag uw woonadres en/of postcode weten. Wilt u hieronder uw adres en/of postcode invullen? Uw adresgegevens zullen nooit gedeeld worden met mensen buiten het onderzoeksteam.</p>',
      en: '<p class="flow-text">To keep track of any possible moves, we would like to ask you for your residence address and/or postal code. This information will never be shared with anyone outside of the research team.</p>'
    }
  }, {
    id: :v4_a,
    type: :textfield,
    title: {
      nl: 'Straat',
      en: 'Street'
    },
    required: false
  }, {
    id: :v4_b,
    type: :number,
    title: {
      nl: 'Huisnummer',
      en: 'Number'
    },
    required: false
  }, {
    id: :v4_c,
    type: :textfield,
    title: {
      nl: 'Postcode',
      en: 'Postal code'
    },
    required: true
  }, {
    id: :v5,
    type: :dropdown,
    title: {
      nl: 'Wat is uw hoogst voltooide opleiding?',
      en: 'What is your highest achieved education level?'
    },
    options: [
      {
        nl: 'Geen opleiding',
        en: 'No education'
      },
      {
        nl: 'Basisschool',
        en: 'Elementary school'
      },
      {
        nl: 'Middelbare school',
        en: 'High school'
      },
      {
        nl: 'Middelbaar beroepsonderwijs (MBO)',
        en: 'Vocational education (mbo)'
      },
      {
        nl: 'Hoger beroepsonderwijs (HBO)',
        en: 'Higher vocational education/university of applied sciences (hbo)'
      },
      {
        nl: 'Universiteit (WO)',
        en: 'University (wo)'
      },
      {
        nl: 'Anders',
        en: 'Other'
      }
    ],
    required: true
  }, {
    id: :v6,
    type: :radio,
    title: {
      nl: 'Wat is uw voornaamste dagelijkse bezigheid?',
      en: 'What is your primary daily occupation?'
    },
    options: [
      { 
        title: {
          nl: 'Student/scholier',
          en: 'Student/in school'
        }, 
        shows_questions: WERKADRES_QUESTIONS + POSTCODE_WERK_QUESTIONS 
      },
      { 
        title: {
          nl: 'Zelfstandig ondernemer',
          en: 'Entrepreneur'
        }, 
        shows_questions: WERKADRES_QUESTIONS + POSTCODE_WERK_QUESTIONS 
      },
      { 
        title: {
          nl: 'Werkzaam in loondienst',
          en: 'Employed'
        }, 
        shows_questions: WERKADRES_QUESTIONS + POSTCODE_WERK_QUESTIONS 
      },
      { 
        title: {
          nl: 'Vrijwilligerswerk',
          en: 'Volunteer'
        }, 
        shows_questions: WERKADRES_QUESTIONS 
      },
      {
        nl: 'De zorg voor gezin',
        en: 'Caring for the family'
      },
      {
        nl: 'Geen werk',
        en: 'Unemployed'
      },
      {
        nl: 'Anders',
        en: 'Other'
      }
    ],
    required: true
  }, {
    id: :v7,
    type: :radio,
    title: {
      nl: 'Wat is uw netto maandelijks huishoudensinkomen?',
      en: 'What is your net monthly household income?'
    },
    required: true,
    show_otherwise: false,
    options: [
      {
        nl: 'Minder dan 980€',
        en: 'Less than 980€'
      },
      {
        nl: 'Tussen 980€ en 1870€',
        en: 'Between 980€ and 1870€'
      },
      {
        nl: 'Tussen 1870€ en 2680€',
        en: 'Between 1870€ and 2680€'
      },
      {
        nl: 'Tussen 2680€ en 3800€',
        en: 'Between 2680€ and 3800€'
      },
      {
        nl: 'Tussen 3800€ en 5460€',
        en: 'Between 3800€ and 5460€'
      },
      {
        nl: 'Meer dan 5460€',
        en: 'More than 5460€'
      },
      {
        nl: 'Weet ik niet/zeg ik liever niet',
        en: "Don't know/prefer not to say"
      }
    ]
  }, {
    id: :v8_a,
    hidden: true,
    type: :radio,
    title: {
      nl: 'Wat is het meest op u van toepassing (in een situatie zonder corona pandemie)?',
      en: 'Which situation applies the most to you?'
    },
    required: true,
    show_otherwise: false,
    options: [
      {
        nl: 'Ik werk/studeer altijd op een vast adres (anders dan thuis)',
        en: 'I always work or study from a fixed location (other than at home)'
      },
      {
        nl: 'Ik werk/studeer meestal op een vast adres (anders dan thuis)',
        en: 'I often work or study from a fixed location (other than at home)'
      },
      { 
        title: {
          nl: 'Ik werk/studeer altijd thuis',
          en: 'I always work or study from home'
        }, 
        hides_questions: POSTCODE_WERK_QUESTIONS 
      },
      { 
        title: {
          nl: 'Ik werk/studeer op verschillende adressen',
          en: 'I work or study at different locations'
        }, 
        hides_questions: POSTCODE_WERK_QUESTIONS 
      }
    ]
  }, {
    id: :v8_b_0,
    hidden: true,
    type: :raw,
    content: {
      nl: '<p class="flow-text">Wat is het adres en/of de postcode van uw werk/studeeradres? Vul het adres en/of de postcode in van de plek waar u het meeste werkt/studeert als u niet vanuit huis werkt/studeert.</p>',
      en: '<p class="flow-text">If you do not work or study from home, what is the address and/or postal code for your location of work or study?</p>'
    }
  }, {
    id: :v8_b_a,
    hidden: true,
    type: :textfield,
    title: {
      nl: 'Straat',
      en: 'Street'
    },
    required: false
  }, {
    id: :v8_b_b,
    hidden: true,
    type: :number,
    title: {
      nl: 'Huisnummer',
      en: 'Number'
    },
    required: false
  }, {
    id: :v8_b_c,
    hidden: true,
    type: :textfield,
    title: {
      nl: 'Postcode',
      en: 'Postal code'
    },
    required: true
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
