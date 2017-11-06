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
end
