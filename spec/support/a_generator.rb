# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a generator' do
  before :each do
    question[:raw] = question.deep_dup
  end

  describe 'generate' do
    it 'should generate something' do
      result = subject.generate(question)
      expect(result).to_not be_nil
    end

    it 'should add a title if one exists' do
      return unless question.key? :title

      result = subject.generate(question)
      expect(result).to include question[:title]
    end

    it 'should add an id if one exists' do
      return unless question.key? :id

      result = subject.generate(question)
      expect(result).to include question[:id].to_s
    end
  end
end
