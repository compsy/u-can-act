# frozen_string_literal: true

module Api
  module V1
    class QuestionnaireController < ApiController
      before_action :authenticate_auth_user
      before_action :check_admin_authenticated, only: %i[create]
      before_action :set_questionnaire, only: %i[show]

      def show
        # TODO: Add different formats
        render json: @questionnaire, serializer: Api::QuestionnaireSerializer
      end

      def create
        questionnaire = Questionnaire.new(questionnaire_params)
        if questionnaire.save
          head 201
        else
          result = { result: questionnaire.errors }
          render(status: :bad_request, json: result)
        end
      end

      private

      def check_admin_authenticated
        return if current_auth_user.role == AuthUser::ADMIN_ROLE

        result = { result: 'User is not an admin' }

        render(status: :forbidden, json: result)
      end

      def set_questionnaire
        @questionnaire = Questionnaire.find_by(key: params[:key])
        return if @questionnaire.present?

        render(status: :not_found, json: 'Vragenlijst met die key niet gevonden')
      end

      def questionnaire_params
        load_params = params.require(:questionnaire).permit(:name, :key, :title)

        # Whitelist the array
        # see https://github.com/rails/rails/issues/9454
        load_params[:content] = params[:questionnaire][:content] if params[:questionnaire][:content]
        load_params.permit!
      end
    end
  end
end
