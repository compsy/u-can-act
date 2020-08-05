# frozen_string_literal: true

module Api
  class PersonSerializer < ActiveModel::Serializer
    type 'people'
    attributes :first_name, :last_name, :gender, :email, :mobile_phone, :iban, :id, :account_active, :my_open_responses

    def my_open_responses
      object.my_open_responses(false).map { |response| ResponseSerializer.new(response) }
    end
  end
end
