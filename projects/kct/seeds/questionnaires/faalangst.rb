# frozen_string_literal: true

title = 'Faalangst'

name = 'KCT Faalangst'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title)
  res = {
    id: id,
    type: :likert,
    title: title,
    show_otherwise: false,
    options: %w[1 2 3 4 5]
  }
  res
end

content = [
  {
    type: :raw,
    content: '
<p class="flow-text section-explanation">
Wilt u hieronder aangeven in hoeverre u het met de volgende stellingen eens bent?
<ul class="flow-text section-explanation">

<li>
1 = helemaal mee oneens
</li>

<li>
2 = mee oneens
</li>

<li>
3 = oneens noch eens
</li>

<li>
4 = mee eens
</li>

<li>
5 = helemaal mee eens
</li>

</ul>
</p>
'
  },
  create_question(:v1, 'Als ik aan een taak begin en het gaat meteen al niet goed, dan heb ik de neiging om op te geven.'),
  create_question(:v2, 'Als ik moet kiezen, dan zal ik eerder een relatief makkelijke taak kiezen dan een taak die ik mogelijk niet aankan.'),
  create_question(:v3, 'Een faalervaring versterkt in het algemeen mijn overtuiging dat ik niet over de benodigde vaardigheden beschik.'),
  create_question(:v4, 'Vaak bereid ik me goed voor op een taak, maar desondanks gaat het meestal niet goed als de druk te hoog wordt.'),
  create_question(:v5, 'Doorgaans werk ik erg hard, maar tevens weet ik dat de kwaliteit van mijn inspanningen nogal eens te wensen overlaat.'),
  create_question(:v6, 'Ik denk wel eens dat het beter is om helemaal geen inspanningen te leveren dan om veel inspanningen te leveren en vervolgens te falen.'),
  create_question(:v7, 'Wanneer ik met iets moeilijks bezig ben, dan spoken eerdere faalervaringen nogal eens door mijn hoofd.'),
  create_question(:v8, 'Ik vermijd vaak lastige taken omdat ik bang ben om fouten te maken.'),
  create_question(:v9, 'Vaak heb ik het gevoel dat ik een bepaalde taak wel aankan, maar door de druk van het moment slaag ik er uiteindelijk toch niet in om mijn niveau te halen.')
]

questionnaire.content = content
questionnaire.title = title
questionnaire.save!
