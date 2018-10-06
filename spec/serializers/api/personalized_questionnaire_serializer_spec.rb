# frozen_string_literal: true

require 'rails_helper'

describe Api::PersonalizedQuestionnaireSerializer do
  let(:response) { FactoryBot.create(:response) }

  subject(:json) { described_class.new(response).as_json.with_indifferent_access }

  it 'should contain the correct value for the uuid' do
    expect(response.uuid).to_not be_blank
    expect(json['uuid']).to eq response.uuid
  end

  it 'should contain the correct value for the questionnaire_title' do
    title = response.measurement.questionnaire.title
    expect(title).to_not be_blank
    expect(json['questionnaire_title']).to eq title
  end

  it 'should contain the correct value for the questionnaire_content' do
    content = response.measurement.questionnaire.content.as_json
    expect(content).to_not be_blank
    expect(json['questionnaire_content'].as_json).to eq content
  end

  it 'should cache the questionnaire after calling it' do
    expect_any_instance_of(QuestionnaireGenerator)
      .to receive(:generate_hash_questionnaire)
      .once
      .and_call_original
    obj = described_class.new(response)

    obj.questionnaire_content
    obj.questionnaire_content
  end
end
