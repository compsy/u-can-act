# frozen_string_literal: true

module Api
  class RoleSerializer < ActiveModel::Serializer
    attributes :title
    attributes :group
    attributes :uuid
  end
end
