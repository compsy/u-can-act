# frozen_string_literal: true

module Api
  class AuthUserSerializer < ActiveModel::Serializer
    attributes :auth0_id_string

    has_one :person do
      PersonSerializer.new(object.person)
    end
  end
end
