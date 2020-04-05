# frozen_string_literal: true

db_title = 'Toestemmingsverklaring'
db_name1 = 'Informed_consent_kinderen'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1

ic_content = <<~'END'
<div class="informed-consent">
  <ul>
    <li>
      Ik heb de informatie voor deelnemers gelezen en/of met mijn ouders besproken en geef
      toestemming om mijn gegevens te gebruiken. Ik kon aanvullende vragen stellen. Mijn
      vragen zijn genoeg beantwoord. Ik had genoeg tijd om te beslissen of ik meedoe.
    </li>
    <li>
      Ik weet dat deelname aan dit onderzoek geheel vrijwillig is en dat ik mijn deelname op
      elk moment kan beëindigen. Daarvoor hoef ik geen reden te geven, en dit zal geen
      negatieve gevolgen voor mij hebben.
    </li>
    <li>
      Ik begrijp dat mijn gegevens veilig worden verwerkt (anoniem/gecodeerd) zodat mijn
      inlognaam, geboortedatum, postcode en de andere antwoorden die ik geef worden
      bewaard in een beveiligde computeromgeving.
    </li>
    <li>
      Ik begrijp dat mijn anonieme onderzoeksgegevens lange tijd worden bewaard om
      nieuwe onderzoeksvragen te beantwoorden en kunnen worden gedeeld met andere
      onderzoekers.
    </li>
    <li>
      Jullie mogen contact met me opnemen voor vervolgonderzoek waarna ik zelf zal
      bepalen of ik daar aan mee wil doen.
    </li>
  </ul>
</div>
END

dagboek_content = [
  {
    type: :raw,
    content: ic_content
  }, {
    id: :v1,
    type: :checkbox,
    required: true,
    title: '',
    options: [
      'Ik verklaar dat bovenstaande informatie mij duidelijk is en ga hiermee akkoord.'
    ],
    show_otherwise: false
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
