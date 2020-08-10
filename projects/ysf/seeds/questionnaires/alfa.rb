# frozen_string_literal: true

title = 'Alfa'

name = 'KCT Alfa'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

content = [
  {
    type: :raw,
    content: '
  <p class="flow-text">
    <em>Toestemmingsverklaring</em>
  </p>
  <center>
    Voor deelname aan wetenschappelijk onderzoek
  </center><br />
  <p class="flow-text">
    "Your Special Forces"
  </p>

  <p class="flow-text">
    De <b>informatiebrief</b> is, nu en ook later, te vinden op
    <a href="https://yourspecialforces.nl/sep2020" target="_blank">
      https://yourspecialforces.nl/sep2020
    </a>.
  </p>

  <ol class="flow-text">
    <li>
    Ik verklaar op een voor mij duidelijke wijze te zijn ingelicht over de aard en het doel van het
    onderzoek. Ik ben in de gelegenheid gesteld om vragen over het onderzoek te stellen en mijn
    vragen zijn naar tevredenheid beantwoord.
    </li>

    <li>
    Ik weet dat de gegevens en resultaten uit dit onderzoek op een beveiligde server worden
    opgeslagen en gebruikt worden in toekomstig onderzoek rondom de selectie en ontwikkeling
    van operators.
    </li>

    <li>
    Ik geef toestemming om de gegevens te verwerken voor de doeleinden zoals beschreven in
    de informatiebrief.
    </li>

    <li>
    Ik begrijp dat ik mijn deelname op ieder moment, om wat voor reden dan ook, mag en kan
    beëindigen zonder dat hieraan enige consequenties verbonden zijn.
    </li>
  </ol>
  '
  },
  {
    id: :v1,
    type: :radio,
    title: '',
    options: [
      'Ik doe <b>wel</b> mee aan het onderzoek',
      'Ik doe <b>niet</b> mee aan het onderzoek'
    ],
    show_otherwise: false
  }
]

questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
