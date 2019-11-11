# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class ProtocolController < JwtApiController
        def index
          render json: Protocol.all
        end
      end
    end
  end
end
