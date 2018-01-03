# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe 'student_mentor_class' do
    it 'should return an empty string if no is mentor is set' do
      instance_variable_set(:@use_mentor_layout, nil)
      result = student_mentor_class
      expected = ''
      expect(result).to eq(expected)
    end

    it 'should return the student class if is mentor is false' do
      instance_variable_set(:@use_mentor_layout, false)
      result = student_mentor_class
      expected = 'student'
      expect(result).to eq(expected)
    end

    it 'should return the mentor class if is mentor is true' do
      instance_variable_set(:@use_mentor_layout, true)
      result = student_mentor_class
      expected = 'mentor'
      expect(result).to eq(expected)
    end
  end

  describe 'logo_image' do
    it 'should return the black logo if no is mentor is set' do
      instance_variable_set(:@use_mentor_layout, nil)
      result = logo_image
      expected = 'U_can_act_logo_ZWART.png'
      expect(result).to eq(expected)
    end

    it 'should return the green logo if is mentor is false' do
      instance_variable_set(:@use_mentor_layout, false)
      result = logo_image
      expected = 'U_can_act_logo_CMYK_GROEN.png'
      expect(result).to eq(expected)
    end

    it 'should return the blue logo if is mentor true' do
      instance_variable_set(:@use_mentor_layout, true)
      result = logo_image
      expected = 'U_can_act_logo_CMYK_BLAUW.png'
      expect(result).to eq(expected)
    end
  end
end
