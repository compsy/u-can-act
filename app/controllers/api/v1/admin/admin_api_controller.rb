# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AdminApiController < ApiController
        before_action :authenticate_admin
      end
    end
  end
end
