# frozen_string_literal: true

require 'swagger_helper'

describe 'Protocols API' do
  let(:Authorization) { basic_encode(ENV['API_KEY'], ENV['API_SECRET']) }

  path '/basic_auth_api/protocols' do
  end
end
