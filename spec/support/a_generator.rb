# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a generator' do
  include_context 'with raw'

  describe 'generate' do
    it 'generates something' do
      result = subject.generate(question)
      expect(result).not_to be_nil
    end

    it 'adds a title if one exists' do
      return unless question.key? :title

      result = subject.generate(question)
      expect(result).to include question[:title]
    end

    it 'adds an id if one exists' do
      return unless question.key? :id

      result = subject.generate(question)
      expect(result).to include question[:id].to_s
    end
  end
end
