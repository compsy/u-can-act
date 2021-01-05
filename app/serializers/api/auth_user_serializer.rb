# frozen_string_literal: true

module Api
  class AuthUserSerializer < ActiveModel::Serializer
    type 'auth_users'
    attributes :auth0_id_string, :person

    # It doesn't work with has_one because for some reason it passes the wrong object
    def person
      PersonSerializer.new(object.person) if object.person.present?
    end
  end
end
