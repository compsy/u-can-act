# frozen_string_literal: true

class ResponseContent
  include Mongoid::Document
  field :content, type: Hash
end
