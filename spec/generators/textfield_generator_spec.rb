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
      hint: 'Must be a lowercase word between 1 and 10 characters in length',
      placeholder: 'Place holder',
      section_end: true
    }
  end

  it_should_behave_like 'a generator'
end
