# frozen_string_literal: true

require 'spec_helper'

describe Result do
  let(:response_body) do
    {
      'duration' => 73,
      'name' => 'svc-messages',
      'subject' => 'bluemix@compsy.nl',
      'activationId' => '05d35624da7b4740935624da7be740f0',
      'publish' => false,
      'annotations' => [
        { 'key' => 'path', 'value' => 'bluemix@compsy.nl_dev/svc-messages' },
        { 'key' => 'waitTime', 'value' => 44 },
        { 'key' => 'kind', 'value' => 'nodejs =>6' },
        { 'key' => 'limits', 'value' => { 'timeout' => 60_000, 'memory' => 256, 'logs' => 10 } },
        { 'key' => 'initTime', 'value' => 59 }
      ],
      'version' => '0.0.96',
      'response' => {
        'result' => { 'payload' => 'The message' },
        'success' => true, 'status' => 'success'
      },
      'end' => 1_533_042_267_344,
      'logs' => [],
      'start' => 1_533_042_267_271,
      'namespace' => 'bluemix@compsy.nl_dev'
    }
  end

  it 'assigns fields to attr_accessors' do
    result = described_class.new response_body
    expect(result.duration).to eq(73)
    expect(result.name).to eq('svc-messages')
    expect(result.subject).to eq('bluemix@compsy.nl')
    expect(result.activationId).to eq('05d35624da7b4740935624da7be740f0')
    expect(result.publish).to eq(false)
    expect(result.annotations).to be_a Array
    expect(result.annotations).to eq(
      [
        { 'key' => 'path', 'value' => 'bluemix@compsy.nl_dev/svc-messages' },
        { 'key' => 'waitTime', 'value' => 44 },
        { 'key' => 'kind', 'value' => 'nodejs =>6' },
        { 'key' => 'limits', 'value' => { 'timeout' => 60_000, 'memory' => 256, 'logs' => 10 } },
        { 'key' => 'initTime', 'value' => 59 }
      ]
    )
    expect(result.version).to eq('0.0.96')
    expect(result.response).to eq(
      'result' => { 'payload' => 'The message' },
      'success' => true, 'status' => 'success'
    )

    expect(result.end).to eq(1_533_042_267_344)
    expect(result.logs).to eq([])
    expect(result.start).to eq(1_533_042_267_271)
    expect(result.namespace).to eq('bluemix@compsy.nl_dev')
  end
end
