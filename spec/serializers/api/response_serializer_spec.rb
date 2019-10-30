# frozen_string_literal: true

require 'rails_helper'

describe Api::ResponseSerializer do
  let(:response) { FactoryBot.create(:response, :completed, opened_at: 10.minutes.ago) }
  subject(:json) { described_class.new(response).as_json.with_indifferent_access }

  it 'contains the correct value for the uuid' do
    expect(response.uuid).not_to be_blank
    expect(json['uuid']).to eq response.uuid
  end

  it 'renders its questionnaire using the QuestionnaireShortSerializer' do
    expect(Api::QuestionnaireShortSerializer)
      .to receive(:new)
      .and_call_original
      .twice
    described_class.new(response).as_json
  end

  it 'contains the correct value for the open_from' do
    expect(response.open_from).not_to be_blank
    expect(json['open_from']).to eq response.open_from
  end

  it 'contains the correct value for the opened_at' do
    expect(response.opened_at).not_to be_blank
    expect(json['opened_at']).to eq response.opened_at
  end

  it 'contains the correct value for the completed_at' do
    expect(response.completed_at).not_to be_blank
    expect(json['completed_at']).to eq response.completed_at
  end

  it 'contains the correct value for the values' do
    allow(response).to receive(:values).and_return({'v1' => 5, 'v2' => 'yes'})
    expect(response.values).not_to be_blank
    expect(json['values']).to eq response.values
  end
end
