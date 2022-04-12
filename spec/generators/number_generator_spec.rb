# frozen_string_literal: true

require 'rails_helper'

describe NumberGenerator do
  let!(:question) do
    {
      section_start: 'Tot slot',
      hidden: true,
      id: :v2,
      type: :number,
      title: 'Wat is je postcode?',
      tooltip: 'some tooltip',
      maxlength: 4,
      placeholder: 'bv. 1234',
      min: 0,
      max: 9999,
      required: true,
      section_end: true
    }
  end

  let(:previous_value) { 2 }
  let(:previous_response) { { v2: previous_value } }

  it_behaves_like 'a generator'
  it_behaves_like 'a generator with value'
end
