# frozen_string_literal: true

require 'rails_helper'

describe FixResponses, focus: true do
  describe 'execute' do
    it 'should not raise an error' do
      expect do
        described_class.run!
      end.to_not raise_error
    end
    it 'should fix answers from the mentor diary questionnaire' do
      questionnaire = FactoryBot.create(:questionnaire, name: 'dagboek mentoren')
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
      hsh = %w[]
        v1' =>
        v10' =>
        v10_timing' =>
        v11' =>
        v11_timing
        v12
        v12_timing
        v14
        v14_timing
        v15
        v15_anders_namelijk_text
        v15_anders_namelijk_text_timing
        v15_anders_namelijk_timing
        v15_ja_timing
        v15_nee_timing
        v16
        v16_timing
        v17
        v17_werken_timing
        v18
        v18_anders_namelijk_text
        v18_anders_namelijk_text_timing
        v18_anders_namelijk_timing
        v18_ja_timing
        v1_ja_timing
        v1_nee_timing
        v2
        v2_anders_namelijk_text
        v2_anders_namelijk_text_timing
        v2_anders_namelijk_timing
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
      }
      response_content = FactoryBot.create(:response_content, content: hsh)
      response = FactoryBot.create(:response, measurement: measurement, content: )
    end
  end
end
