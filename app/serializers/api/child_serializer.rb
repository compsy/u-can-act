# frozen_string_literal: true

module Api
  class ChildSerializer < ActiveModel::Serializer
    type 'people'
    attributes :id, :first_name, :email, :account_active, :role

    def role
      object.role&.title || ''
    end
  end
end
