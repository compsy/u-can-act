# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AdminApiController < ApiController
        before_action :verify_admin

        def verify_admin
          # TODO!!!!!! CHECK ACCESS!
        end
      end
    end
  end
end
