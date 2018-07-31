# frozen_string_literal: true

require 'spec_helper'

describe BasicAuthSession do
  include Sessions
  let(:session)  { FactoryBot.build(:basic_auth_session) }
  let(:response) { double('response', code: 201, parsed_response: 'some_response') }

  describe '#initialize' do
    it 'sets the microservice_host instance attribute' do
      session = Compsy::MicroserviceApi.basic_auth_session microservice_host: 'some_microservice_host'
      expect(session.microservice_host).to eq('some_microservice_host')
    end

    it 'defaults the microservice_host to the MICROSERVICE_HOST env variable' do
      orginal_env_microservice_host = ENV['MICROSERVICE_HOST']
      ENV['MICROSERVICE_HOST'] = 'some_env_microservice_host'
      session = Compsy::MicroserviceApi.basic_auth_session
      ENV['MICROSERVICE_HOST'] = orginal_env_microservice_host
      expect(session.microservice_host).to eq('some_env_microservice_host')
    end

    it 'sets the username instance variable' do
      session = Compsy::MicroserviceApi.basic_auth_session username: 'some_username'
      expect(session.username).to eq('some_username')
    end

    it 'defaults the username to the MICROSERVICE_BASICAUTH_ID env variable' do
      orginal_env_microservice_key = ENV['MICROSERVICE_BASICAUTH_ID']
      ENV['MICROSERVICE_BASICAUTH_ID'] = 'some_env_microservice_key'
      session = Compsy::MicroserviceApi.basic_auth_session
      ENV['MICROSERVICE_BASICAUTH_ID'] = orginal_env_microservice_key
      expect(session.username).to eq('some_env_microservice_key')
    end

    it 'sets the password instance variable' do
      session = Compsy::MicroserviceApi.basic_auth_session password: 'some_password'
      expect(session.password).to eq('some_password')
    end

    it 'defaults the password to the MICROSERVICE_BASICAUTH_SECRET env variable' do
      orginal_env_microservice_secret = ENV['MICROSERVICE_BASICAUTH_SECRET']
      ENV['MICROSERVICE_BASICAUTH_SECRET'] = 'some_env_microservice_secret'
      session = Compsy::MicroserviceApi.basic_auth_session
      ENV['MICROSERVICE_BASICAUTH_SECRET'] = orginal_env_microservice_secret
      expect(session.password).to eq('some_env_microservice_secret')
    end
  end

  describe '#get' do
    let(:params) { { blocking: true, some: 'param' } }
    it 'performs a get request' do
      expect(HTTParty).to receive(:get).with(
        'http://microservice.dev/api/v1/some_path',
        query: params,
        basic_auth: { username: 'some_username', password: 'some_password' }
      )
                                       .and_return(response)
      session.get '/some_path', some: 'param'
    end

    it 'throws an error if the reponse is not within the 200 range' do
      allow(response).to receive(:code).and_return(500)
      allow(HTTParty).to receive(:get).and_return(response)
      expect { session.get '/some_path' }.to raise_error(RuntimeError, 'some_response')
    end

    it 'throws a NoSession error if the basic auth is incorrect' do
      allow(response).to receive(:code).and_return(401)
      allow(HTTParty).to receive(:get).and_return(response)
      allow(response).to receive(:headers).and_return('WWW-Authenticate' => 'Basic realm="Application"')
      expect { session.get '/some_path' }.to raise_error(Compsy::MicroserviceApi::NoSession)
    end

    it 'throws a Unauthorized error on 401 without www-authenticate header' do
      allow(response).to receive(:code).and_return(401)
      allow(HTTParty).to receive(:get).and_return(response)
      allow(response).to receive(:headers).and_return('foo' => 'bar')
      expect { session.get '/some_path' }.to raise_error(Compsy::MicroserviceApi::Unauthorized)
    end

    it 'returns the response' do
      allow(HTTParty).to receive(:get).and_return(response)
      expect(session.get('/some_path')).to eq(response)
    end
  end
end
