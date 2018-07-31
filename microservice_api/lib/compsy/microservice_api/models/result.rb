# frozen_string_literal: true

require 'virtus'

module Compsy
  module MicroserviceApi
    module Models
      class Result
        include Virtus.model

        attribute :id, Integer

        attribute :duration, Integer
        attribute :name, String
        attribute :subject, String
        attribute :activationId, String
        attribute :publish, Boolean
        attribute :annotations, Array

        attribute :version, String
        attribute :response, Hash

        attribute :start, Integer
        attribute :end, Integer
        attribute :logs, Array
        attribute :namespace, String
      end
    end
  end
end
