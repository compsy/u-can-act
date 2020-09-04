# frozen_string_literal: true

module Api
  class PersonSerializer < ActiveModel::Serializer
    type 'people'
    attributes :first_name, :last_name, :gender, :email, :mobile_phone, :iban, :id,
               :account_active, :my_open_responses, :auth0_id_string

    def my_open_responses
      object.my_open_responses(false).map { |response| ResponseSerializer.new(response) }
    end

    def auth0_id_string
      return object.auth_user.auth0_id_string if object.auth_user.present?

      ''
    end
  end
end
