# frozen_string_literal: true

module Api
  class AuthUserSerializer < ActiveModel::Serializer
    attributes :auth0_id_string

    has_one :person do
      PersonSerializer.new(object.person) if object.person.present?
    end
  end
end
