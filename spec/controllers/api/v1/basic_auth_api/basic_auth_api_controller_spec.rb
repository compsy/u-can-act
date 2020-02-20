# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::BasicAuthApi::BasicAuthApiController, type: :controller do
  controller do
    def dummy
      render plain: 'dummy called'
    end
  end

  before do
    routes.draw { get 'dummy' => 'api/v1/basic_auth_api/basic_auth_api#dummy' }
  end

  let!(:params) { {} }

  it_behaves_like 'a basic authenticated route', 'get', :dummy
end
