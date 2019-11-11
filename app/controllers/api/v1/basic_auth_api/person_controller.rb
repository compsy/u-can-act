# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      class PersonController < BasicAuthApiController
        def show_list
          auth_users = AuthUser.where(auth0_id_string: person_params[:person_auth0_ids])
          render status: :ok, json: auth_users.map{|x| x.person}
        end

        private

        def person_params
          params.permit(:person_auth0_ids)
        end
      end
    end
  end
end
