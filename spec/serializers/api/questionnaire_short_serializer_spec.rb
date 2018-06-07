# frozen_string_literal: true

require 'rails_helper'

describe Api::QuestionnaireShortSerializer do
  let!(:questionnaire) { FactoryBot.create(:questionnaire) }

  subject(:json) { described_class.new(questionnaire).as_json.with_indifferent_access }
  it 'should contain the correct value for the key' do
    expect(questionnaire.key).to_not be_blank
    expect(json['key']).to eq questionnaire.key
  end

  it 'should contain the correct value for the title' do
    expect(questionnaire.title).to_not be_blank
    expect(json['title']).to eq questionnaire.title
  end
end
