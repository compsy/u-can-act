# frozen_string_literal: true

require 'rails_helper'

describe TextfieldGenerator do
  let!(:question) do
    {
      section_start: 'Tot slot',
      hidden: true,
      id: :v2,
      type: :textfield,
      title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
      tooltip: 'some tooltip',
      pattern: '[a-z]{1,10}',
      default_value: true,
      hint: 'Must be a lowercase word between 1 and 10 characters in length',
      placeholder: 'Place holder',
      section_end: true
    }
  end

  let(:previous_value) { 'old text value' }
  let(:previous_response) { { v2: previous_value } }

  it_behaves_like 'a generator'
  it_behaves_like 'a generator with value'
end
