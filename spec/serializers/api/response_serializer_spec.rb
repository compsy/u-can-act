# frozen_string_literal: true

require 'rails_helper'

describe Api::ResponseSerializer do
  let(:protocol_subscription) do
    FactoryBot.create(:protocol_subscription,
                      external_identifier: 'my-external-id',
                      invitation_text_nl: 'invitation-text-nl')
  end
  let(:responseobj) do
    FactoryBot.create(:response, :completed, opened_at: 10.minutes.ago, protocol_subscription: protocol_subscription)
  end
  subject(:json) { described_class.new(responseobj).as_json.with_indifferent_access }

  it 'contains the correct attributes' do
    expect(json).not_to be_nil
    expect(json.keys).to match_array %w[
      uuid
      open_from
      expires_at
      opened_at
      completed_at
      values
      external_identifier
      external_identifiers
      questionnaire
      invitation_texts
      protocol_completion
      measurement_id
      protocol_subscription_id
    ]
  end

  it 'contains the correct value for the uuid' do
    expect(responseobj.uuid).not_to be_blank
    expect(json['uuid']).to eq responseobj.uuid
  end

  it 'renders its questionnaire using the QuestionnaireShortSerializer' do
    expect(Api::QuestionnaireShortSerializer)
      .to receive(:new)
      .and_call_original
      .once
    described_class.new(responseobj).as_json
  end

  it 'contains the correct value for the open_from' do
    expect(responseobj.open_from).not_to be_blank
    expect(json['open_from']).to eq responseobj.open_from
  end

  it 'contains the correct value for the expires_at' do
    expect(responseobj.open_from).not_to be_blank
    expect(json['expires_at']).to eq responseobj.expires_at
  end

  it 'contains the correct value for the opened_at' do
    expect(responseobj.opened_at).not_to be_blank
    expect(json['opened_at']).to eq responseobj.opened_at
  end

  it 'contains the correct value for the completed_at' do
    expect(responseobj.completed_at).not_to be_blank
    expect(json['completed_at']).to eq responseobj.completed_at
  end

  it 'contains the correct value for the values' do
    allow(responseobj).to receive(:values).and_return('v1' => 5, 'v2' => 'yes')
    expect(responseobj.values).not_to be_blank
    expect(json['values']).to eq responseobj.values
  end

  it 'contains the correct value for the external identifier' do
    expect(responseobj.protocol_subscription.external_identifier).not_to be_blank
    expect(json['external_identifier']).to eq responseobj.protocol_subscription.external_identifier
  end

  it 'contains the correct value for the external identifiers' do
    expect(responseobj.external_identifiers).not_to be_blank
    expect(json['external_identifiers']).to match_array responseobj.external_identifiers
  end

  it 'contains the correct value for the invitation_texts' do
    expect(json['invitation_texts']).to match_array ['invitation-text-nl']
  end

  it 'contains an empty protocol completion if we do not pass a parameter' do
    expect(json['protocol_completion']).to match_array([])
  end

  it 'contains a protocol completion if we do pass a parameter' do
    json = described_class.new(responseobj, with_protocol_completion: true).as_json.with_indifferent_access
    expected = [{ 'completed' => true,
                  'future' => false,
                  'future_or_current' => false,
                  'periodical' => false,
                  'reward_points' => 1,
                  'streak' => -1,
                  'open_from' => responseobj.open_from,
                  'questionnaire_key' => responseobj.measurement.questionnaire.key }]
    expect(json['protocol_completion']).to match_array(expected)
  end

  it 'removes future entries from the protocol completion' do
    # Create a future response that should not be included in the protocol completion
    FactoryBot.create(:response,
                      measurement: responseobj.measurement,
                      protocol_subscription: responseobj.protocol_subscription,
                      open_from: 1.week.from_now)
    json = described_class.new(responseobj, with_protocol_completion: true).as_json.with_indifferent_access
    expected = [{ 'completed' => true,
                  'future' => false,
                  'future_or_current' => false,
                  'periodical' => false,
                  'reward_points' => 1,
                  'streak' => -1,
                  'open_from' => responseobj.open_from,
                  'questionnaire_key' => responseobj.measurement.questionnaire.key }]
    expect(json['protocol_completion']).to match_array(expected)
  end
end
