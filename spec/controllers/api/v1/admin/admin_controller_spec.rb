# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    module Admin
      describe AdminApiController, type: :controller do
        controller do
          def dummy
            render plain: 'dummy called'
          end
        end

        before do
          routes.draw { get 'dummy' => 'api/v1/admin/admin_api#dummy' }
        end

        it_should_behave_like 'a jwt authenticated route', :dummy, {}
      end
    end
  end
end
