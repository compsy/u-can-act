# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Admin::AdminApiController, type: :controller do
  controller do
    def dummy
      render plain: 'dummy called'
    end
  end

  before do
    routes.draw { get 'dummy' => 'api/v1/admin/admin_api#dummy' }
  end

  it_behaves_like 'a jwt authenticated route', :dummy, {}
end
