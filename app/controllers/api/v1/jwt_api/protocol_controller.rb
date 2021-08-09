# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class ProtocolController < JwtApiController
        include ProtocolHelper

        before_action :set_protocol, only: %i[preview]

        def index
          render json: Protocol.all
        end

        def preview
          render json: PreviewProtocol.run!(protocol: @protocol,
                                            future: 10.minutes.ago,
                                            start_date: start_date(preview_params[:start_date]),
                                            end_date: end_date(preview_params[:start_date], preview_params[:end_date]),
                                            open_from_day_uses_start_date_offset:
                                              preview_params[:open_from_day_uses_start_date_offset])
        end

        private

        def set_protocol
          @protocol = Protocol.find_by(name: params[:id])
          return if @protocol.present?

          not_found(protocol: 'Protocol with that name not found')
        end

        def preview_params
          params.permit(:start_date, :end_date, :open_from_day_uses_start_date_offset)
        end
      end
    end
  end
end
