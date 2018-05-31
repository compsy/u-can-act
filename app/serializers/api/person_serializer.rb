# frozen_string_literal: true

module Api
  class PersonSerializer < ActiveModel::Serializer
    attributes :first_name, :last_name, :gender, :email, :mobile_phone, :iban
  end
end
