# frozen_string_literal: true

module QuestionnaireHelper
  def logo_image
    return 'U_can_act_logo_ZWART.png' if @is_mentor.nil?
    @is_mentor ? 'U_can_act_logo_CMYK_BLAUW.png' : 'U_can_act_logo_CMYK_GROEN.png'
  end
end
