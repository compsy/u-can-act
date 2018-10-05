# frozen_string_literal: true

require 'rails_helper'

describe SubscribeToProtocol do
  let(:protocol) { FactoryBot.create(:protocol) }
  let(:person) { FactoryBot.create(:person) }

  it 'should warn if the protocol does not have measurements' do
    expect(Rails.logger)
      .to receive(:warn)
      .with("Protocol #{protocol.id} does not have any measurements")
    described_class.run!(protocol: protocol, person: person)
  end

  it 'should work by providing a protocol object' do
    expect(person.protocol_subscriptions).to be_blank
    described_class.run!(protocol: protocol, person: person)
    person.reload
    expect(person.protocol_subscriptions).to_not be_blank
    expect(person.protocol_subscriptions.first.protocol).to eq protocol
    expect(person.protocol_subscriptions.first.state).to eq ProtocolSubscription::ACTIVE_STATE
  end

  it 'should work by providing a protocol string' do
    expect(person.protocol_subscriptions).to be_blank
    described_class.run!(protocol_name: protocol.name, person: person)
    person.reload
    expect(person.protocol_subscriptions).to_not be_blank
    expect(person.protocol_subscriptions.first.protocol).to eq protocol
  end

  it 'should work with a timestring' do
    start = 10.hours.ago
    described_class.run!(protocol_name: protocol.name, person: person, start_date: start)
    person.reload
    expect(person.protocol_subscriptions.first.start_date).to be_within(1.seconds).of start
  end

  it 'should raise if the provided protocol is not found' do
    expect { described_class.run!(protocol_name: 'test', person: person) }
      .to raise_error(RuntimeError, 'Protocol not found')
  end
end
