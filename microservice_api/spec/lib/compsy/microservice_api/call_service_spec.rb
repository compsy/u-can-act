# frozen_string_literal: true

require 'spec_helper'

describe CallService do
  let(:options)  { { action: 'action', namespace: '1', parameters: {} } }
  let(:api_path) { "/namespaces/#{options[:namespace]}/actions/#{options[:action]}" }
  let(:result) do
    httparty_response(
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
    )
  end

  let(:session) { FactoryBot.build :basic_auth_session }
  before { allow(BasicAuthSession).to receive(:new).and_return session }

  it 'performs a GET on the responses API' do
    expect(session).to receive(:post).with(
      api_path, {}
    ).and_return result

    described_class.run(action: options[:action],
                        namespace: options[:namespace],
                        parameters: options[:parameters]).result
  end

  it 'returns a result object' do
    expect(session).to receive(:post).with(
      api_path, {}
    ).and_return result

    result = described_class.run(options).result

    expect(result).to be_a(Models::Result)
    expect(result.response['result']['payload']).to eq('The message')
  end
end
