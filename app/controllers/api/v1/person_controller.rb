# frozen_string_literal: true

module Api
  module V1
    class PersonController < ApiController
      before_action :authenticate_person
      before_action :set_person, only: %i[show index]
      before_action :set_responses, only: %i[index show]

      def create
        person = Person.new(person_params)
        if person.save?
          head 202
        else
          # TODO: Render the errors
        end
      end

      private

      def person_params
        params.require(:person).permit(:first_name, :last_name, :email, :mobile_phone)
      end

    end
  end
end
