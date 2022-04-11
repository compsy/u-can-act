# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a checkable generator' do
  include_context 'with raw'

  context 'when a previous value exists' do
    let(:question_with_previous_response) { question.merge({ previous_response: previous_response }) }

    it 'adds checked to the option that matches the previous value' do
      result = subject.generate(question_with_previous_response)
      expect(result).to include 'checked'
    end
  end
end
