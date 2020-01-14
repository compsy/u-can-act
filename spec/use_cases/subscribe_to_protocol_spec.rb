# frozen_string_literal: true

require 'rails_helper'

describe SubscribeToProtocol do
  let(:protocol) { FactoryBot.create(:protocol) }
  let(:person) { FactoryBot.create(:person) }

  it 'does not warn if the protocol has measurements' do
    FactoryBot.create(:measurement, protocol: protocol)
    expect(Rails.logger)
      .not_to receive(:warn)
      .with("Protocol #{protocol.id} does not have any measurements")
    described_class.run!(protocol: protocol, person: person)
  end

  it 'warns if the protocol does not have measurements' do
    expect(Rails.logger)
      .to receive(:warn)
      .with("Protocol #{protocol.id} does not have any measurements")
    described_class.run!(protocol: protocol, person: person)
  end

  it 'works by providing a protocol object' do
    expect(person.protocol_subscriptions).to be_blank
    described_class.run!(protocol: protocol, person: person)
    person.reload
    expect(person.protocol_subscriptions).not_to be_blank
    expect(person.protocol_subscriptions.first.protocol).to eq protocol
    expect(person.protocol_subscriptions.first.state).to eq ProtocolSubscription::ACTIVE_STATE
  end

  it 'works by providing a protocol string' do
    expect(person.protocol_subscriptions).to be_blank
    described_class.run!(protocol_name: protocol.name, person: person)
    person.reload
    expect(person.protocol_subscriptions).not_to be_blank
    expect(person.protocol_subscriptions.first.protocol).to eq protocol
  end

  it 'uses the parent as a mentor when there is one' do
    parent = FactoryBot.create(:person)
    person.parent = parent
    person.save!
    expect(person.protocol_subscriptions).to be_blank
    described_class.run!(protocol_name: protocol.name, person: person)
    person.reload
    expect(person.protocol_subscriptions).not_to be_blank
    expect(person.protocol_subscriptions.first.protocol).to eq protocol
    expect(person.protocol_subscriptions.first.filling_out_for).to eq person
  end

  it 'works with a timestring' do
    start_date = 10.hours.ago
    described_class.run!(protocol_name: protocol.name, person: person, start_date: start_date)
    person.reload
    expect(person.protocol_subscriptions.first.start_date).to be_within(1.second).of start_date
  end

  it 'raises if the provided protocol is not found' do
    expect { described_class.run!(protocol_name: 'test', person: person) }
      .to raise_error(RuntimeError, 'Protocol not found')
  end
end
