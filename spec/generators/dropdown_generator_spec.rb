# frozen_string_literal: true

require 'rails_helper'

describe DropdownGenerator do
  let!(:question) do
    {
      section_start: 'Algemeen',
      id: :v1,
      type: :dropdown,
      title: 'Hoe voelt u zich vandaag?',
      options: %w[slecht goed],
      label: 'rmc regio'
    }
  end

  it_should_behave_like 'a generator'
end
