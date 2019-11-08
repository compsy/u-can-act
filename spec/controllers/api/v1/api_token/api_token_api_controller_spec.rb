# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ApiToken::ApiTokenApiController, type: :controller do
  controller do
    def dummy
      render plain: 'dummy called'
    end
  end

  before do
    routes.draw { get 'dummy' => 'api/v1/api_token/api_token_api#dummy' }
  end

  let!(:params) { {} }

  it_behaves_like 'a basic authenticated route', 'get', :dummy
end
