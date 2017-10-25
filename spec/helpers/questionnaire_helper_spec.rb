# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireHelper do
  describe 'logo_image' do
    it 'should return the black logo if no is mentor is set' do
      result = logo_image(nil)
      expected = 'U_can_act_logo_ZWART.png'
      expect(result).to eq(expected)
    end

    it 'should return the green logo if is mentor is false' do
      result = logo_image(false)
      expected = 'U_can_act_logo_CMYK_GROEN.png'
      expect(result).to eq(expected)
    end

    it 'should return the blue logo if is mentor true' do
      result = logo_image(true)
      expected = 'U_can_act_logo_CMYK_BLAUW.png'
      expect(result).to eq(expected)
    end
  end
end
