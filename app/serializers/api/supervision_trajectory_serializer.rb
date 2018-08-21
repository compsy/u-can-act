# frozen_string_literal: true

module Api
  class SupervisionTrajectorySerializer < ActiveModel::Serializer
    attributes :name
    attributes :uuid
  end
end
