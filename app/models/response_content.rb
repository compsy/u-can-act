# frozen_string_literal: true

class ResponseContent
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: Hash
end
