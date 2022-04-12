# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a generator with value' do
  include_context 'with raw'

  context 'when a previous value exists' do
    let(:question_with_previous_response) { question.merge({ previous_response: previous_response }) }

    it 'sets the value attribute to the previous value' do
      result = subject.generate(question_with_previous_response)
      expect(result).to include "value=\"#{previous_value}\""
    end
  end
end
