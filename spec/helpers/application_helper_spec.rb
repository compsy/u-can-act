# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe 'current_user' do
    it 'returns the currently logged in user' do
      person = FactoryBot.create(:person)
      cookie_auth(person)
      instance_variable_set(:@current_user, nil)
      result = current_user
      expect(result).to eq person
      result = instance_variable_get(:@current_user)
      expect(result).to eq person
    end

    it 'returns nil if no user is set' do
      instance_variable_set(:@current_user, nil)
      result = current_user
      expect(result).to be_nil
      result = instance_variable_get(:@current_user)
      expect(result).to be_nil
    end

    it 'returns the @ value if set' do
      returnval = 'thisiswhatitshouldreturn'
      instance_variable_set(:@current_user, returnval)
      result = current_user
      expect(result).to eq returnval
    end
  end

  describe 'student_mentor_class' do
    it 'returns an empty string if no is mentor is set' do
      instance_variable_set(:@use_mentor_layout, nil)
      result = student_mentor_class
      expected = ''
      expect(result).to eq(expected)
    end

    it 'returns the student class if is mentor is false' do
      instance_variable_set(:@use_mentor_layout, false)
      result = student_mentor_class
      expected = 'student'
      expect(result).to eq(expected)
    end

    it 'returns the mentor class if is mentor is true' do
      instance_variable_set(:@use_mentor_layout, true)
      result = student_mentor_class
      expected = 'mentor'
      expect(result).to eq(expected)
    end
  end

  describe 'logo_image' do
    it 'returns the fallback logo if no is mentor is set' do
      instance_variable_set(:@use_mentor_layout, nil)
      result = logo_image
      expected = 'logo.png'
      expect(result).to eq(expected)
    end

    it 'returns the student logo if is mentor is false' do
      instance_variable_set(:@use_mentor_layout, false)
      result = logo_image
      expected = 'logo_student.png'
      expect(result).to eq(expected)
    end

    it 'returns the mentor logo if is mentor true' do
      instance_variable_set(:@use_mentor_layout, true)
      result = logo_image
      expected = 'logo_mentor.png'
      expect(result).to eq(expected)
    end
  end
end
