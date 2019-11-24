# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class OneTimeResponseController < JwtApiController
        before_action :set_person
        before_action :load_one_time_response, only: :show
        before_action :subscribe_person, only: :show

        def show
          redirect_to redirect_url
          #SubscribeToProtocol.run!(
            #protocol: OneTimeResponse.all.first.protocol,
            #person: @person.first
          #)
          #render json: @person.protocol_subscriptions
          # TODO: Create a new OTR and store it in the user
          # TODO Move to Basicauth?
        end

        def index
          # render json: Person.all.first.protocol_subscriptions
          # TODO List all OTRs available for this user

          #@person.protocol_subscriptions.each do |protocol_subscription|
            #RescheduleResponses.run!(protocol_subscription: protocol_subscription,
                                     #future: 10.minutes.ago)
          #end
          #render json: Person.all.first.my_open_responses.select { |x| x.protocol_subscription.protocol.id == 1 }
          render json: OneTimeResponse.all
        end

        def test
        end

        private

        def subscribe_person
          protocol_subscription = SubscribeToProtocol.run!(protocol: @one_time_response.protocol,
                                                           #mentor: mentor,
                                                           person: @person)
          RescheduleResponses.run!(protocol_subscription: protocol_subscription,
                                   future: 10.minutes.ago)
        end

        def mentor
          @mentor ||= Person.find_by(id: protocol_subscription_create_params[:mentor_id])
        end

        def set_person
          @person = Person.all.first
        end

        def redirect_url
          # TODO: Filter on OTRs here
          # TODO: Move to OTR and combine with other OTR controller
          responses = @person.my_open_responses.select { |x| x.protocol_subscription.protocol.id == 1 }
          invitation_set = InvitationSet.create!(person_id: @person.id,
                                                 responses: responses)
          invitation_token = invitation_set.invitation_tokens.create!
          invitation_set.invitation_url(invitation_token.token_plain, false)
        end

        def load_one_time_response
          token = one_time_response_params[:token]
          Rails.logger.info token
          Rails.logger.info '!'*1000
          @one_time_response = OneTimeResponse.find_by(token: token)
          return @one_time_response if @one_time_response.present?

          render(status: :not_found, json: 'De vragenlijst kon niet gevonden worden.')
        end

        def one_time_response_params
          params.permit(:token)
        end
      end
    end
  end
end
