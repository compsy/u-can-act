# frozen_string_literal: true

CLIMBING_ACCIDENT_QUESTIONNAIRE_NAME = 'climbing_accident'

db_name = CLIMBING_ACCIDENT_QUESTIONNAIRE_NAME
questionnaire = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
questionnaire ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
questionnaire.name = db_name

PHONE_REGEX = "^\+?\d{1,4}[-.\s]?\(?\d{1,4}\)?[-.\s]?\d{1,9}[-.\s]?\d{1,9}$"
EMAIL_REGEX = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

question_content = [
  {
    type: :raw,
    content: { nl: "<h4 class=\"header\">Rapport over klimongevallen</h4>
                    <p><i>Meld hier zo volledig mogelijk het ongeval</i></p>",
                en: "<h4 class=\"header\">Climbing Accident report</h4>
                    <p><i>Report the accident here as completely as possible</i></p>" }
  },
  # General section
  {
    section_start: {
      nl: "Algemeen",
      en: "General"
    },
    id: 'v1_accident_location',
    type: :textfield,
    required: true,
    title: {
      nl: "In welke locatie vond het ongeval plaats?",
      en: "In which location did the accident take place?"
    }
  },
  {
    id: 'v2_person_reporting',
    type: :textfield,
    required: true,
    title: {
      nl: "Wie vult dit formulier in?",
      en: "Who is filling in this form?"
    },
    placeholder: {
      nl: "Voor & Achternaam",
      en: "First & Last name"
    },
    section_end: true,
  },
  # Accident situation section
  {
    section_start: {
      nl: "Gegevens situatie ongeval",
      en: "Accident situation data"
    },
    id: 'v3a_date_of_accident',
    hours_id: 'v3b_hour_of_accident',
    minutes_id: 'v3c_minutes_of_accident',
    type: :date_and_time,
    required: true,
    title: {
      nl: "Wanneer vond het ongeval plaats?",
      en: "When did the accident take place?"
    },
    today: true
  },
  {
    id: 'v4_climber_experience',
    type: :radio,
    required: true,
    title: {
      nl: "Wat is de ervaring van de klimmer?",
      en: "What is the climber’s experience?"
    },
    options: [
      {
        title: {  nl: "Starter (eerste keer)",
                en: "Starter (first time)" },
        value: "starter"
      },
      {
        title: {  nl: "Beginner (minder dan 10 keer)",
                en: "Beginner (less than 10 times)" },
        value: "beginner"
      },
      {
        title: {  nl: "Gevorderd (tussen 10 en 30 keer)",
                en: "Advanced (between 10 and 30 times)" },
        value: "advanced"
      },
      {
        title: {  nl: "Expert (+30 keer)",
                en: "Expert (+30 times)" },
        value: "expert"
      }
    ],
    show_otherwise: false
  },
  {
    id: "v5_situation_description",
    title: {
      nl: "Omschrijf de situatie waarin het ongeval plaatsvond.",
      en: "Describe the situation in which the accident occurred."
    },
    type: :radio,
    required: true,
    options: [
      {
        title: {  nl: "Zelfstandig",
                en: "Independent" },
        value: "independent"
      },
      {
        title: {  nl: "Onder begeleiding van personeel",
                en: "Accompanied by staff" },
        value: "accompanied"
      }
    ],
    show_otherwise: false,
    section_end: true
  },
  # The Accident section
  {
    section_start: {
      nl: "Het ongeval",
      en: "The accident"
    },
    id: "v6_accident_description",
    type: :textarea,
    title: {
      nl: "Beschrijf het incident kort en duidelijk",
      en: "Describe the incident briefly and clearly"
    },
    required: true
  },
  {
    id: "v7_cause_of_injury",
    type: :radio,
    required: true,
    title: {
      nl: "Oorzaak van letsel",
      en: "Cause of the injury"
    },
    options: [
      {
        title: {  nl: "Val met verkeerde landing",
                en: "Fall with incorrect landing" },
        value: "incorrect_landing"
      },
      {
        title: {  nl: "Tijdens het boulderen opgelopen letsel (verkeerde beweging)",
                en: "Injury occured during climbing (wrong movement)" },
        value: "wrong_movement"
      },
      {
        title: {  nl: "Botsing (met wand, module of greep)",
                en: "Collision (with wall, module or handle)" },
        value: "collision_with_object"
      },
      {
        title: {  nl: "Botsing (persoon)",
                en: "Collision (with person)" },
        value: "collision_with_person"  
      },
    ],
    show_otherwise: false,
    section_end: true
  },
  # Details of the injury
  {
    section_start: {
      nl: "Gegevens ontstane letsel",
      en: "Injury details"
    },
    id: "v8_type_of_injury",
    type: :radio,
    required: true,
    title: {
      nl: "Om welk soort letsel denk je dat het gaat?",
      en: "What type of injury do you think is involved?"
    },
    options: [
      {
        title: {  nl: "Distortie (kneuzen, verzwikken, verdraaien)",
                en: "Distortion (bruising, spraining, twisting)" },
        value: "distortion"  
      },
      {
        title: {  nl: "Luxatie (uit de kom)",
                en: "Luxation (dislocation)" },
        value: "luxation"  
      },
      {
        title: {  nl: "Fractuur (gebroken)",
                en: "Fracture (broken)" },
        value: "fracture"  
      },
      {
        title: {  nl: "Oppervlakkig letsel (schaafwonden, blauwe plekken etc)",
                en: "Superficial injury (scrapes, bruises, etc)" },
        value: "superficial_injury"  
      }
    ],
    show_otherwise: true,
    otherwise_label: {
      nl: "Anders, namelijk...",
      en: "Other, namely..."
    }
  },
  {
    id: "v9_injury_body_location",
    type: :radio,
    required: true,
    title: {
      nl: "Op welk lichaamsdeel heeft het letsel betrekking? (bij meervoudig letsel, kies het zwaarste letsel)",
      en: "To which part of the body does the injury relate? (in case of multiple injuries, choose the most severe injury)?"
    },
    options: [
      {
        title: { nl: "Enkel", en: "Ankle" },
        value: "ankle"
      },
      {
        title: { nl: "Elleboog", en: "Elbow" },
        value: "elbow"
      },
      {
        title: { nl: "Pols", en: "Wrist" },
        value: "wrist"
      },
      {
        title: { nl: "Schouder", en: "Shoulder" },
        value: "shoulder"
      },
      {
        title: { nl: "Heup", en: "Hip" },
        value: "hip"
      },
      {
        title: { nl: "Knie", en: "Knee" },
        value: "knee"
      },
      {
        title: { nl: "Vingers", en: "Fingers" },
        value: "fingers"
      },
      {
        title: { nl: "Hoofd", en: "Head" },
        value: "head"
      },
      {
        title: { nl: "Nek", en: "Neck" },
        value: "neck"
      },
      {
        title: { nl: "Rug", en: "Back" },
        value: "back"
      },
      {
        title: { nl: "Hand", en: "Hand" },
        value: "hand"
      },
      {
        title: { nl: "Voet", en: "Foot" },
        value: "foot"
      },
      {
        title: { nl: "Tenen", en: "Toes" },
        value: "toes"
      },
      {
        title: { nl: "Borst", en: "Chest" },
        value: "chest"
      },
      {
        title: { nl: "Bovenarm", en: "Upper arm" },
        value: "upper_arm"
      },
      {
        title: { nl: "Onderarm", en: "Forearm" },
        value: "forearm"
      },
      {
        title: { nl: "Bovenbeen", en: "Upper leg" },
        value: "upper_leg"
      },
      {
        title: { nl: "Onderbeen", en: "Lower leg" },
        value: "lower_leg"
      }
    ],
    show_otherwise: true,
    otherwise_label: {
      nl: "Anders, namelijk...",
      en: "Other, namely..."
    },
    section_end: true
  },
  # Victim's data
  {
    section_start: {
      nl: "Gegevens slachtoffer",
      en: "Victim's data"
    },
    type: :raw,
    content: { 
      nl: "<p><strong>Vul deze zo compleet mogelijk in zodat wij contact kunnen opnemen met het slachtoffer voor nazorg.</strong></p>",
      en: "<p><strong>Please report this as completely as possible so we can contact the victim for aftercare.</strong></p>"
    }
  },
  {
    id: "v10_climber_first_name",
    type: :textfield,
    required: true,
    title: {
      nl: "Voornaam slachtoffer",
      en: "Victim's first name"
    }
  },
  {
    id: "v11_climber_last_name",
    type: :textfield,
    required: true,
    title: {
      nl: "Achternaam slachtoffer",
      en: "Victim's surname"
    }
  },
  {
    id: "v12_climber_gender",
    type: :radio,
    required: true,
    title: {
      nl: "Geslacht",
      en: "Gender"
    },
    options: [
      {
        title: { nl: "Man", en: "Male" },
        value: "male"
      },
      {
        title: { nl: "Vrouw", en: "Female" },
        value: "female"
      },
      {
        title: { nl: "X", en: "X" },
        value: "X"
      },
    ],
    show_otherwise: false
  },
  {
    id: "v13_climber_phone_number",
    type: :textfield,
    required: true,
    title: {
      nl: "Telefoonnummer",
      en: "Phone number"
    },
    pattern: PHONE_REGEX
  },
  {
    id: "v14_climber_email",
    type: :textfield,
    required: true,
    title: {
      nl: "E-mailadres",
      en: "E-mail address"
    },
    pattern: EMAIL_REGEX
  },
  {
    id: "v15_climber_age",
    type: :number,
    required: true,
    title: {
      nl: "Leeftijd in jaren",
      en: "Age in years"
    },
    min: 0,
    max: 150,
    step: 1
  },
  {
    id: "v16_is_the_climber_in_the_system",
    type: :radio,
    required: true,
    title: {
      nl: "Bevindt het slachtoffer zich in het klimhalsysteem?",
      en: "Is the victim in the climbing hall system?"
    },
    options: [
      {
        title: { nl: "Ja", en: "Yes" },
        value: "yes",
        shows_questions: ["v16a_customer_number"]
      },
      {
        title: { nl: "Nee", en: "No" },
        value: "no",
        shows_questions: ["v16b_customer_address", "v16c_customer_postcode"]
      },
    ],
    show_otherwise: false
  },
  {
    id: "v16a_customer_number",
    type: :textfield,
    required: true,
    hidden: true,
    title: {
      nl: "Vul hier het klant-  en/of pasnummer in", 
      en: "Enter customer and/or card number here"
    },
    section_end: true
  },
  {
    section_start: {
      nl: "Adres gegevens ongeregistreerde klimmer",
      en: "Address details of unregistered climber"
    },
    id: "v16b_customer_address",
    type: :textfield,
    required: true,
    hidden: true,
    title: {
      nl: "Straatnaam + huisnummer (toevoeging)",
      en: "Street name + house number (addition)"
    }
  },
  {
    id: "v16c_customer_postcode",
    type: :textfield,
    required: true,
    hidden: true,
    title: {
      nl: "Postcode + plaats",
      en: "Postal code + city"
    },
    section_end: true
  },
  # Accident handling
  {
    section_start: {
      nl: "Afhandeling ongeval",
      en: "Accident handling"
    },
    type: :raw,
    content: { nl: "<div><i><p>Registreer spoedeisende hulp (SEH) bij de volgende gevallen:</p>
                    <ol>
                      <li>De klimmer met de ambulance meegaat.</li>
                      <li>De klimmer op enige wijze naar de Spoedeisende Hulp wordt gebracht.</li>
                      <li>Het letsel overduidelijk dusdanig is dat SEH-behandeling nodig is.</li>
                    </ol></i></div>",
                en: "<div><i><p>Register emergency care in the following cases:</p>
                    <ol>
                      <li>The climber is transported by ambulance.</li>
                      <li>The climber is taken to the emergency care center by any means.</li>
                      <li>The injury is so overwhelming that emergency care treatment is required.</li>
                    </ol></i></div>" }
  },
  {
    id: "v17_type_of_care_provided",
    type: :radio,
    required: true,
    title: {
      nl: "Welke vorm van zorg is verleend?",
      en: "What type of care was provided?"
    },
    options: [
      {
        title: {
          nl: "Spoedeisende hulp (SEH)",
          en: "Emergency care"
        },
        value: "emergency_care"
      },
      {
        title: {
          nl: "EHBO (lokale behandeling o.a pleister of icepack)",
          en: "First aid (local treatment e.g. band-aid or icepack)"
        },
        value: "first_aid",
        section_end: true
      },
      {
        title: {
          nl: "Doorverwezen naar huisartenpost / huisarts",
          en: "Referred to a GP post / general practitioner"
        },
        value: "referred_to_gp",
        section_end: true
      }
    ],
    show_otherwise: false
  },
  {
    type: :raw,
    content: {
      nl: "<h4><strong>Heb jij behoefte aan nazorg? Neem contact op met je leidinggevende.</strong></h4>",
      en: "<h4><strong>Do you need aftercare? Please contact your manager.</strong></h4>"
    }
  },
  {
    id: "v18_comments",
    type: :textarea,
    required: false,
    title: {
      nl: "Heb je nog op- of aanmerkingen aan de hand van deze melding? (optional)",
      en: "Do you have any comments or remarks based on this report? (optional)"
    }
  }
]

questionnaire.content = { questions: question_content, scores: [] }
questionnaire.title = ''
questionnaire.save!