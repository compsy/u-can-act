# frozen_string_literal: true

require 'rails_helper'

describe CheckboxGenerator do
  let!(:question) do
    {
      section_start: 'Algemeen',
      id: :v1,
      type: :checkbox,
      title: 'Hoe voelt u zich vandaag?',
      options: %w[slecht goed]
    }
  end

  let(:previous_response) { { v1_slecht: 'slecht' } }

  it_behaves_like 'a generator'
  it_behaves_like 'a checkable generator'
end
