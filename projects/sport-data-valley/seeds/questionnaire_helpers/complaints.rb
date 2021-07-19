class Complaints
  class << self
    def ordered_letters(with_otherwise)
      return %w[h n s u e r w c o d l b g t k q a f x i] if with_otherwise

      %w[h n s u e r w c o d l b g t k q a f x]
    end

    def location_description
      {
        'h' => 'Hoofd',
        'n' => 'Nek',
        's' => 'Schouder',
        'u' => 'Bovenarm',
        'e' => 'Elleboog',
        'r' => 'Onderarm',
        'w' => 'Hand/Pols',
        'c' => 'Borstkas',
        'o' => 'Romp',
        'd' => 'Wervelkolom, Thoracaal (hoge rug)',
        'l' => 'Wervelkolom, Lumbaal (lage rug)',
        'b' => 'Bekken/Billen',
        'g' => 'Heup/Lies',
        't' => 'Bovenbeen',
        'k' => 'Knie',
        'q' => 'Onderbeen',
        'a' => 'Enkel',
        'f' => 'Voet',
        'x' => 'Locatie overstijgend/Locatie niet gespecificeerd',
        'i' => 'Anders, namelijk...'
      }
    end

    def complaint_descriptions(letter)
      result = {
        'h' => 'Kneuzing',
        'k' => '(Schaaf-)wond/Snee',
        'm' => 'Spier',
        'j' => 'Verstuiking',
        'd' => 'Dislocatie',
        'f' => 'Breuk',
        'n' => 'Neurologisch',
        'o' => 'Orgaan',
        'w' => 'Whiplash',
        'c' => 'Lesie',
        'a' => 'Artritis',
        'z' => 'Niet nader gespecificeerde pijn',
        'u' => 'Instabiliteit',
        't' => 'Pees',
        'g' => 'Synovitis',
        's' => 'Overbelasting',
        'y' => 'Overbelasting',
        'v' => 'Vasculair',
        'pb' => 'Bekkenorgaan; blaas' # NOTE: two characters
      }
      case letter
      when 'h'
        result['j'] = 'Wervel, facetgewricht'
        result['c'] = 'Tussenwervelschijf'
      when 'h'
        result['o'] = 'Orgaan (oren/ogen/mond/tanden)'
        result['z'] = 'Hoofdpijn'
        result['n'] = 'Hersenschudding'
      when 's'
        result['d'] = '(Acute) dislocatie'
        result['j'] = 'Subluxatie'
        result['n'] = 'Neurologisch of vasculair'
        result['a'] = '(Osteo)artritis'
        result['t'] = 'Overbelasting pezen'
        result['u'] = 'Chronische instabiliteit'
      when 'u'
        result['s'] = 'Overbelasting bot (stressfractuur)'
      when 'e'
        result['t'] = 'Overbelasting pezen'
        result['n'] = 'Neurologisch of vasculair'
        result['a'] = '(Osteo)artritis'
      when 'r'
        result['s'] = 'Overbelasting bot (stressfractuur)'
      when 'w'
        result['j'] = 'Kneuzing'
        result['t'] = 'Overbelasting pezen'
        result['a'] = '(Osteo)artritis'
      when 'c'
        result['s'] = 'Stressfractuur rib'
        result['o'] = 'Borstholte / longen'
      when 'o'
        result['t'] = 'Pees abdomen'
        result['g'] = 'Biomechanische blessure abdomen'
      when 'd'
        result['j'] = 'Gewricht'
        result['c'] = 'Tussenwervelschijf'
        result['g'] = 'Thoracaal posturaal syndroom'
        result['a'] = '(Osteo)artritis'
      when 'l'
        result['j'] = 'Gewricht'
        result['c'] = 'Tussenwervelschijf'
        result['g'] = 'Facetpijn, stijfheid'
        result['s'] = 'Stressfractuur'
        result['n'] = 'Neuraal'
        result['a'] = '(Osteo)artritis'
      when 'b'
        result['j'] = '(SI) Gewricht (excl. S5/L1)'
        result['g'] = 'Synovitis/Bursitis'
        result['s'] = 'Stressfractuur'
        result['n'] = 'Neuraal'
      when 'g'
        result['j'] = 'Gewricht'
        result['g'] = 'Ontsteking/Synovitis'
        result['s'] = 'Stressfractuur'
        result['n'] = 'Neuraal'
      when 't'
        result['s'] = 'Stressfractuur'
        result['y'] = 'Andere overbelasting'
        result['n'] = 'Neuraal'
      when 'k'
        result['j'] = 'Verstuikingen/Ligamenten'
        result['a'] = '(Osteo)artritis'
      when 'q'
        result['s'] = 'Stressfractuur'
        result['y'] = 'Andere overbelasting'
        result['n'] = 'Neuraal'
      when 'a'
        result['j'] = 'Verstuikingen/Ligamenten'
        result['g'] = 'Synovitis/Bursitis'
        result['n'] = 'Neuraal'
        result['a'] = '(Osteo)artritis'
      when 'f'
        result['j'] = 'Verstuikingen/Ligamenten'
        result['n'] = 'Neuraal'
        result['a'] = '(Osteo)artritis'
      when 'x'
        result['j'] = 'Verstuikingen/Ligamenten'
        result['s'] = 'Stressfractuur'
        result['g'] = 'Posturaal syndroom'
        result['n'] = 'Neuraal'
        result['a'] = '(Osteo)artritis'
      when 'i'
        result['j'] = 'Verstuikingen/Ligamenten'
        result['s'] = 'Stressfractuur'
        result['g'] = 'Posturaal syndroom'
        result['n'] = 'Neuraal'
        result['a'] = '(Osteo)artritis'
      else
        # do nothing
      end
      result
    end

    def complaint_list
      {
        'h' => %w[h k m j d f n o z],
        'n' => %w[h k w j c m d f n o a z],
        's' => %w[h k m d u j c t g f s n a z],
        'u' => %w[h k m t f s y n z],
        'e' => %w[h k m d u c t g f s n a z],
        'r' => %w[h k m t f s y n z],
        'w' => %w[h k m j d u c t g f s n v a z],
        'c' => %w[h k m j d u g f s o z],
        'o' => %w[h k m t g o pb z],
        'd' => %w[h k m j c f g a z],
        'l' => %w[h k m j c u g f s n a z],
        'b' => %w[h k m t j u g f s n z],
        'g' => %w[h k m t j c d u g f s n o a z],
        't' => %w[h k m f s y n z],
        'k' => %w[h k m t j c d u g f s a z],
        'q' => %w[h k m t f s y n v z],
        'a' => %w[h k t j c d u g f s n v a z],
        'f' => %w[h k m t j c d g f s n a z],
        'x' => %w[h k m t j c d u f s g n a],
        'i' => %w[h k m t j c d u f s g n a]
      }
    end

    def complaint_description(letter, complaint_letter)
      "#{complaint_descriptions(letter)[complaint_letter]}"
    end

    def complaint_code(letter, complaint_letter)
      "#{letter.upcase}#{complaint_letter.upcase}".ljust(4, 'X')
    end

    def complaint_options(letter)
      complaint_list[letter].map { |complaint_letter| { title: complaint_description(letter, complaint_letter), value: complaint_code(letter, complaint_letter) } }
    end

    def prefix(letter)
      "v_o_#{letter}_"
    end

    def prefix_score(letter)
      "s_o_#{letter}_"
    end

    def pain_at_description(letter)
      return 'de klacht' if letter === 'i'

      "de klacht aan je <strong>#{location_description[letter]}</strong>"
    end

    def prefix_all(letter, *more)
      more.map { |pos| "#{prefix(letter)}#{pos}".to_sym }
    end

    def prefixed_complaint_questions(letter)
      prefixed = prefix(letter)
      shown_questions_first_complaint = prefix_all(letter, 7, 8, 10)
      acute_shown_questions = prefix_all(letter, 9, '9a')
      overloaded_shown_questions = prefix_all(letter, 11)
      shown_questions_treated = prefix_all(letter, 13)
      shown_questions_participated = prefix_all(letter, 2, 3, 4)
      [
        {
          id: "#{prefixed}15".to_sym,
          hidden: true,
          type: :raw,
          section_start: "Letsel aan je <strong>#{location_description[letter]}</strong>",
          content: '<div></div>'
        },
        {
          id: "#{prefixed}0".to_sym,
          hidden: true,
          type: :textfield,
          required: true,
          title: 'Anders, namelijk:'
        },
        {
          id: "#{prefixed}1".to_sym,
          hidden: true,
          type: :radio,
          title: "</p><h6>Vraag 1 - Deelname</h6><p class='flow-text'>Heb je enige moeite met deelname aan het sporten gehad door #{pain_at_description(letter)} in de afgelopen 7 dagen?</p><p>",
          options: [
            { title: 'Volledige deelname, maar met klachten', numeric_value: 8, shows_questions: shown_questions_participated },
            { title: 'Verminderde deelname door klachten', numeric_value: 17, shows_questions: shown_questions_participated },
            { title: 'Kan niet deelnemen door klachten', numeric_value: 100 }
          ],
          show_otherwise: false
        },
        {
          id: "#{prefixed}2".to_sym,
          hidden: true,
          type: :radio,
          title: "</p><h6>Vraag 2 - Aangepaste training/competitie</h6><p class='flow-text'>In welke mate heb je het sporten aangepast door #{pain_at_description(letter)} in de afgelopen 7 dagen?</p><p>",
          options: [
            { title: 'Geen aanpassing', numeric_value: 0 },
            { title: 'In geringe mate aangepast', numeric_value: 8 },
            { title: 'In redelijke mate aangepast', numeric_value: 17 },
            { title: 'In grote mate aangepast', numeric_value: 25 }
          ],
          show_otherwise: false
        },
        {
          id: "#{prefixed}3".to_sym,
          hidden: true,
          type: :radio,
          title: "</p><h6>Vraag 3 - Prestatie</h6><p class='flow-text'>In welke mate heeft #{pain_at_description(letter)} een negatieve invloed gehad op je prestatie in de afgelopen 7 dagen?</p><p>",
          options: [
            { title: 'Geen invloed', numeric_value: 0 },
            { title: 'In geringe mate beïnvloed', numeric_value: 8 },
            { title: 'In redelijke mate beïnvloed', numeric_value: 17 },
            { title: 'In grote mate beïnvloed', numeric_value: 25 }
          ],
          show_otherwise: false
        },
        {
          id: "#{prefixed}4".to_sym,
          hidden: true,
          type: :radio,
          title: "</p><h6>Vraag 4 - Symptomen</h6><p class='flow-text'>Hoeveel pijn heb je ervaren als gevolg van #{pain_at_description(letter)} de afgelopen 7 dagen?</p><p>",
          options: [
            { title: 'Geen pijn', numeric_value: 0 },
            { title: 'Geringe pijn', numeric_value: 8 },
            { title: 'Redelijke pijn', numeric_value: 17 },
            { title: 'Ernstige pijn', numeric_value: 25 }
          ],
          show_otherwise: false
        },
        {
          id: "#{prefixed}5".to_sym,
          hidden: true,
          type: :likert,
          title: "Op hoeveel van de afgelopen 7 dagen heb je niet volledig of geheel niet kunnen deelnemen aan het sporten ten gevolge van #{pain_at_description(letter)}?",
          options: [
            { title: '0', numeric_value: 0 },
            { title: '1', numeric_value: 1 },
            { title: '2', numeric_value: 2 },
            { title: '3', numeric_value: 3 },
            { title: '4', numeric_value: 4 },
            { title: '5', numeric_value: 5 },
            { title: '6', numeric_value: 6 },
            { title: '7', numeric_value: 7 }
          ],
          show_otherwise: false
        },
        {
          id: "#{prefixed}6".to_sym,
          hidden: true,
          type: :radio,
          title: "Is dit de eerste keer dat je #{pain_at_description(letter)} meldt?",
          options: [
            { title: 'Ja', shows_questions: shown_questions_first_complaint },
            { title: 'Nee, ik heb hetzelfde probleem korter dan vier weken geleden ook gemeld' },
            { title: 'Nee, ik heb hetzelfde probleem langer dan vier weken geleden ook gemeld', shows_questions: shown_questions_first_complaint }
          ],
          show_otherwise: false
        },
        {
          id: "#{prefixed}7".to_sym,
          hidden: true,
          type: :radio,
          title: "Tijdens welke activiteit is het letsel aan je <strong>#{location_description[letter]}</strong> ontstaan?",
          options: [
            { title: 'Sportspecifieke training' },
            { title: 'Kracht & fitness training' },
            { title: 'Wedstrijd' },
            { title: 'Onbekend' }
          ],
          show_otherwise: true,
          otherwise_label: 'Anders, namelijk', # TODO: don't forget to translate this text to english also
        },
        {
          id: "#{prefixed}8".to_sym,
          hidden: true,
          type: :radio,
          title: "Betreft #{pain_at_description(letter)} een acuut letsel of overbelasting?",
          options: [
            { title: 'Acuut letsel', shows_questions: acute_shown_questions },
            { title: 'Overbelastingsletsel', shows_questions: overloaded_shown_questions }
          ],
          show_otherwise: false
        },
        {
          id: "#{prefixed}9".to_sym,
          hidden: true,
          type: :checkbox,
          title: "Wat is de oorzaak van het letsel aan je <strong>#{location_description[letter]}</strong>?",
          tooltip: 'Bijvoorbeeld: Landing na een sprong / Botsing met een object / Overstrekking',
          options: [
            { title: 'Wil ik niet zeggen / Weet ik niet', hides_questions: ["#{prefixed}9a".to_sym] }
          ],
          show_otherwise: false,
          required: false
        },
        {
          id: "#{prefixed}9a".to_sym,
          hidden: true,
          type: :textarea,
          title: '',
          placeholder: 'Vul oorzaak in',
          required: true
        },
        {
          id: "#{prefixed}10".to_sym,
          hidden: true,
          type: :radio,
          title: "Wat is de aard van het letsel aan je <strong>#{location_description[letter]}</strong>?",
          options: complaint_options(letter),
          show_otherwise: false
        },
        {
          id: "#{prefixed}11".to_sym,
          hidden: true,
          type: :textarea,
          title: 'Kun je in je eigen woorden uitleggen wat er is gebeurd?',
          required: true
        },
        {
          id: "#{prefixed}12".to_sym,
          hidden: true,
          type: :radio,
          title: "Ben je voor #{pain_at_description(letter)} de afgelopen 7 dagen behandeld door een therapeut of arts?",
          options: [
            { title: 'Ja', shows_questions: shown_questions_treated },
            { title: 'Nee' }
          ],
          show_otherwise: false
        },
        {
          id: "#{prefixed}13".to_sym,
          hidden: true,
          type: :radio,
          title: "Door wie ben je voor #{pain_at_description(letter)} de afgelopen 7 dagen behandeld?",
          options: [
            { title: 'Fysiotherapeut' },
            { title: 'Manueel therapeut' },
            { title: 'Masseur' },
            { title: 'Sportarts' },
            { title: 'Huisarts' },
            { title: 'Specialist' }
          ],
          show_otherwise: true,
          otherwise_label: 'Anders, namelijk', # TODO: don't forget to translate this text to english also
        },
        {
          id: "#{prefixed}14".to_sym,
          section_end: true,
          hidden: true,
          type: :raw,
          content: '<div></div>'
        }
      ]
    end

    def prefixed_complaint_ids(letter)
      # If the area is "Anders, namelijk..." render an extra textfield to ask for the area.
      return prefix_all(letter, 0, 1, 5, 6, 12, 14, 15) if letter === 'i'

      prefix_all(letter, 1, 5, 6, 12, 14, 15)
    end

    def all_complaint_questions(with_otherwise = false)
      result = []
      ordered_letters(with_otherwise).each do |letter|
        result += prefixed_complaint_questions(letter)
      end
      result
    end

    def all_complaint_options(with_otherwise = false)
      result = []
      ordered_letters(with_otherwise).each do |letter|
        result << { title: location_description[letter], shows_questions: prefixed_complaint_ids(letter) }
      end
      result
    end

    def all_complaint_scores(with_otherwise = false)
      result = []
      ordered_letters(with_otherwise).each do |letter|
        result << complaint_score(letter)
      end
      result
    end

    def complaint_score(letter)
      {
        id: "#{prefix_score(letter)}1".to_sym,
        label: location_description[letter],
        ids: prefix_all(letter, 1, 2, 3, 4),
        operation: :sum,
        round_to_decimals: 0
      }
    end
  end
end
