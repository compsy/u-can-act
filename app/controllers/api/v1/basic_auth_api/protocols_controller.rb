# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      class ProtocolsController < BasicAuthApiController
        def create
          res = CreateOrUpdateProtocol.run(**update_protocol_params)
          return created(res.protocol) if res.valid?

          validation_error res.errors
        end

        private

        def update_protocol_params
          params.require(:protocol).permit(
            [:name,
             :duration,
             :invitation_text,
             :informed_consent_questionnaire_key,
             { questionnaires:
               [:key,
                { measurement:
                  %i[open_from_offset open_from_day period open_duration reminder_delay priority stop_measurement
                     should_invite only_redirect_if_nothing_else_ready prefilled redirect_url] }] }]
          )
        end
      end
    end
  end
end
