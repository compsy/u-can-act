# frozen_string_literal: true

require 'spec_helper'

describe Endpoint do
  class TestEndpoint < Endpoint
    object :response, class: RSpec::Mocks::Double

    def execute
      validate_response_for do
        response
      end
    end

    def response_to_result(response)
      response['key']
    end
  end

  describe '#initialize' do
    it 'calls MicroserviceApi.basic_auth_session to fill in basic_auth_session if the session is not passed in' do
      bas_double = Compsy::MicroserviceApi::Sessions::BasicAuthSession.new # doubles dont pass AI default type checking
      allow(Compsy::MicroserviceApi).to receive(:basic_auth_session).and_return bas_double
      endpoint = TestEndpoint.new
      expect(endpoint.instance_variable_get(:@basic_auth_session)).to eq(bas_double)
    end

    it 'sets basic_auth_session to the passed basic_auth_session' do
      bas_double = double('BasicAuthSession')
      endpoint = TestEndpoint.new(basic_auth_session: bas_double)
      expect(endpoint.instance_variable_get(:@basic_auth_session)).to eq(bas_double)
    end
  end

  describe 'with validations' do
    let(:response) do
      double('httparty_repsonse', code: 200, parsed_response: {}).tap do |response|
        allow(response).to receive(:[]).with('key').and_return ['values']
        allow(response).to receive(:[]).with('errors').and_return []
      end
    end

    it 'returns the parsed response' do
      outcome = TestEndpoint.run response: response
      expect(outcome.result).to eq(['values'])
    end

    it 'is valid' do
      result = TestEndpoint.run response: response
      expect(result).to be_valid
    end

    context 'when the response contains errors' do
      before do
        allow(response).to receive(:[]).with('errors').and_return('base' => ['some_annoying_error'])
      end

      it 'adds the errors' do
        outcome = TestEndpoint.run response: response
        expect(outcome.errors.full_messages.first).to match('Some annoying error')
      end

      it 'marks the outcome as invalid' do
        outcome = TestEndpoint.run response: response
        expect(outcome).not_to be_valid
      end

      it 'does not return a result' do
        outcome = TestEndpoint.run response: response
        expect(outcome.result).to be_nil
      end
    end

    context 'when the response code is 422 but the response contains no errors' do
      it 'adds an error to base' do
        allow(response).to receive(:code).and_return 422
        outcome = TestEndpoint.run response: response
        expect(outcome).not_to be_valid
        expect(outcome.errors.full_messages).to include('Validations failed!')
      end
    end
  end
end
