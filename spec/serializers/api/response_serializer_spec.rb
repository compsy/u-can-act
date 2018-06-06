# frozen_string_literal: true

require 'rails_helper'

describe Api::ResponseSerializer do
  let(:response) { FactoryBot.create(:response) }
  subject(:json) { described_class.new(response).as_json.with_indifferent_access }

  it 'should contain the correct value for the uuid' do
    expect(response.uuid).to_not be_blank
    expect(json['uuid']).to eq response.uuid
  end

  it 'should render its questionnaire using the QuestionnaireShortSerializer' do
    expect(Api::QuestionnaireShortSerializer)
      .to receive(:new)
      .and_call_original
      .twice
    described_class.new(response).as_json
  end
end
