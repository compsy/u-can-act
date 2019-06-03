# frozen_string_literal: true

require 'rails_helper'

describe Api::QuestionnaireShortSerializer do
  subject(:json) { described_class.new(questionnaire).as_json.with_indifferent_access }

  let!(:questionnaire) { FactoryBot.create(:questionnaire) }

  it 'contains the correct value for the key' do
    expect(questionnaire.key).not_to be_blank
    expect(json['key']).to eq questionnaire.key
  end

  it 'contains the correct value for the title' do
    expect(questionnaire.title).not_to be_blank
    expect(json['title']).to eq questionnaire.title
  end
end
