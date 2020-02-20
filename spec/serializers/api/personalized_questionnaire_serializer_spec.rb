# frozen_string_literal: true

require 'rails_helper'

describe Api::PersonalizedQuestionnaireSerializer do
  subject(:json) { described_class.new(response).as_json.with_indifferent_access }

  let(:response) { FactoryBot.create(:response) }

  it 'contains the correct value for the uuid' do
    expect(response.uuid).not_to be_blank
    expect(json['uuid']).to eq response.uuid
  end

  it 'contains the correct value for the questionnaire_title' do
    title = response.measurement.questionnaire.title
    expect(title).not_to be_blank
    expect(json['questionnaire_title']).to eq title
  end

  it 'contains the correct value for the questionnaire_content' do
    content = response.measurement.questionnaire.content[:questions].as_json
    expect(content).not_to be_blank
    expect(json['questionnaire_content'].as_json).to eq content
  end

  it 'caches the questionnaire after calling it' do
    expect_any_instance_of(QuestionnaireGenerator)
      .to receive(:generate_hash_questionnaire)
      .once
      .and_call_original
    obj = described_class.new(response)

    obj.questionnaire_content
    obj.questionnaire_content
  end
end
