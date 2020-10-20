# frozen_string_literal: true

class FixResponses < ActiveInteraction::Base
  # Regex to make these:
  # sed $'s/></\\\n/g' < input_fields.html | grep -i "id=" |
  # sed -e 's/^.*id="\([^"]*\)".*$/\1/g' | sort | uniq | grep -i "deze_student"
  VARIABLES = %w[
    v2_deze_student_is_gestopt_met_de_opleiding
    v2_ik_ben_gestopt_met_de_begeleiding_van_deze_student
    v2_ik_heb_de_begeleiding_van_deze_student_overgedragen_aan_iemand_anders
    v2_ik_heb_deze_week_geen_contact_gehad_met_deze_student
    v3_0_2_de_omgeving_van_deze_student_betrekken_bij_de_begeleiding
    v3_0_3_de_omgeving_van_deze_student_veranderen
    v3_0_3_de_relatie_met_deze_student_verbeteren_en_of_onderhouden
    v3_0_3_deze_student_zelfinzicht_geven
    v3_0_3_emotioneel_welzijn_van_deze_student_ontwikkelen
    v3_0_3_inzicht_krijgen_in_de_belevingswereld_van_deze_student
    v3_0_3_inzicht_krijgen_in_de_omgeving_van_deze_student
    v3_0_3_vaardigheden_van_deze_student_ontwikkelen
    v3_1_2_de_omgeving_van_deze_student_betrekken_bij_de_begeleiding
    v3_1_3_de_omgeving_van_deze_student_veranderen
    v3_1_3_de_relatie_met_deze_student_verbeteren_en_of_onderhouden
    v3_1_3_deze_student_zelfinzicht_geven
    v3_1_3_emotioneel_welzijn_van_deze_student_ontwikkelen
    v3_1_3_inzicht_krijgen_in_de_belevingswereld_van_deze_student
    v3_1_3_inzicht_krijgen_in_de_omgeving_van_deze_student
    v3_1_3_vaardigheden_van_deze_student_ontwikkelen
    v3_2_2_de_omgeving_van_deze_student_betrekken_bij_de_begeleiding
    v3_2_3_de_omgeving_van_deze_student_veranderen
    v3_2_3_de_relatie_met_deze_student_verbeteren_en_of_onderhouden
    v3_2_3_deze_student_zelfinzicht_geven
    v3_2_3_emotioneel_welzijn_van_deze_student_ontwikkelen
    v3_2_3_inzicht_krijgen_in_de_belevingswereld_van_deze_student
    v3_2_3_inzicht_krijgen_in_de_omgeving_van_deze_student
    v3_2_3_vaardigheden_van_deze_student_ontwikkelen
    v3_3_2_de_omgeving_van_deze_student_betrekken_bij_de_begeleiding
    v3_3_3_de_omgeving_van_deze_student_veranderen
    v3_3_3_de_relatie_met_deze_student_verbeteren_en_of_onderhouden
    v3_3_3_deze_student_zelfinzicht_geven
    v3_3_3_emotioneel_welzijn_van_deze_student_ontwikkelen
    v3_3_3_inzicht_krijgen_in_de_belevingswereld_van_deze_student
    v3_3_3_inzicht_krijgen_in_de_omgeving_van_deze_student
    v3_3_3_vaardigheden_van_deze_student_ontwikkelen
    v3_4_2_de_omgeving_van_deze_student_betrekken_bij_de_begeleiding
    v3_4_3_de_omgeving_van_deze_student_veranderen
    v3_4_3_de_relatie_met_deze_student_verbeteren_en_of_onderhouden
    v3_4_3_deze_student_zelfinzicht_geven
    v3_4_3_emotioneel_welzijn_van_deze_student_ontwikkelen
    v3_4_3_inzicht_krijgen_in_de_belevingswereld_van_deze_student
    v3_4_3_inzicht_krijgen_in_de_omgeving_van_deze_student
    v3_4_3_vaardigheden_van_deze_student_ontwikkelen
    v3_5_2_de_omgeving_van_deze_student_betrekken_bij_de_begeleiding
    v3_5_3_de_omgeving_van_deze_student_veranderen
    v3_5_3_de_relatie_met_deze_student_verbeteren_en_of_onderhouden
    v3_5_3_deze_student_zelfinzicht_geven
    v3_5_3_emotioneel_welzijn_van_deze_student_ontwikkelen
    v3_5_3_inzicht_krijgen_in_de_belevingswereld_van_deze_student
    v3_5_3_inzicht_krijgen_in_de_omgeving_van_deze_student
    v3_5_3_vaardigheden_van_deze_student_ontwikkelen
    v3_6_2_de_omgeving_van_deze_student_betrekken_bij_de_begeleiding
    v3_6_3_de_omgeving_van_deze_student_veranderen
    v3_6_3_de_relatie_met_deze_student_verbeteren_en_of_onderhouden
    v3_6_3_deze_student_zelfinzicht_geven
    v3_6_3_emotioneel_welzijn_van_deze_student_ontwikkelen
    v3_6_3_inzicht_krijgen_in_de_belevingswereld_van_deze_student
    v3_6_3_inzicht_krijgen_in_de_omgeving_van_deze_student
    v3_6_3_vaardigheden_van_deze_student_ontwikkelen
    v3_7_2_de_omgeving_van_deze_student_betrekken_bij_de_begeleiding
    v3_7_3_de_omgeving_van_deze_student_veranderen
    v3_7_3_de_relatie_met_deze_student_verbeteren_en_of_onderhouden
    v3_7_3_deze_student_zelfinzicht_geven
    v3_7_3_emotioneel_welzijn_van_deze_student_ontwikkelen
    v3_7_3_inzicht_krijgen_in_de_belevingswereld_van_deze_student
    v3_7_3_inzicht_krijgen_in_de_omgeving_van_deze_student
    v3_7_3_vaardigheden_van_deze_student_ontwikkelen
    v3_8_2_de_omgeving_van_deze_student_betrekken_bij_de_begeleiding
    v3_8_3_de_omgeving_van_deze_student_veranderen
    v3_8_3_de_relatie_met_deze_student_verbeteren_en_of_onderhouden
    v3_8_3_deze_student_zelfinzicht_geven
    v3_8_3_emotioneel_welzijn_van_deze_student_ontwikkelen
    v3_8_3_inzicht_krijgen_in_de_belevingswereld_van_deze_student
    v3_8_3_inzicht_krijgen_in_de_omgeving_van_deze_student
    v3_8_3_vaardigheden_van_deze_student_ontwikkelen
    v3_9_2_de_omgeving_van_deze_student_betrekken_bij_de_begeleiding
    v3_9_3_de_omgeving_van_deze_student_veranderen
    v3_9_3_de_relatie_met_deze_student_verbeteren_en_of_onderhouden
    v3_9_3_deze_student_zelfinzicht_geven
    v3_9_3_emotioneel_welzijn_van_deze_student_ontwikkelen
    v3_9_3_inzicht_krijgen_in_de_belevingswereld_van_deze_student
    v3_9_3_inzicht_krijgen_in_de_omgeving_van_deze_student
    v3_9_3_vaardigheden_van_deze_student_ontwikkelen
  ].freeze

  # Fixes MongoDB responses
  def execute
    @total_seen = 0
    @total_replaced = 0
    questionnaire = Questionnaire.find_by(name: 'dagboek mentoren')
    if questionnaire.blank?
      puts 'Error: questionnaire not found'
      return
    end
    questionnaire.measurements.each do |measurement|
      measurement.responses.where.not(content: nil).find_each do |response|
        fix_response_content(response.content)
      end
    end
    puts "Total replaced/seen: #{@total_replaced} / #{@total_seen}."
  end

  private

  def fix_response_content(content)
    response_content = ResponseContent.find(content)
    @total_seen += 1
    @atleastonereplaced = false
    new_hsh = calculate_new_hash(response_content.content)
    return unless @atleastonereplaced

    @total_replaced += 1
    response_content.content = new_hsh
    response_content.save!
  end

  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/MethodLength
  def calculate_new_hash(content_hsh)
    new_hsh = {}
    timings = [true, false]
    content_hsh.each do |key, val|
      replaced = false
      new_key = key.dup
      timings.each do |timing|
        VARIABLES.each do |variable|
          varregex = variable.gsub('deze_student', '[a-z_]+?')
          varregex = "#{varregex}_timing" if timing
          varregex = /\A#{varregex}\z/
          next unless key&.match?(varregex)

          new_key = timing ? "#{variable}_timing" : variable
          @atleastonereplaced = true if new_key != key # only count it if we actually change the key
          replaced = true
          break
        end
        break if replaced
      end
      new_hsh[new_key] = val
    end
    new_hsh
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/MethodLength
end
