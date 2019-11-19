# frozen_string_literal: true

class PushSubscription < ApplicationRecord
  belongs_to :protocol
  validates :url, presence: true
  validates :name, presence: true, uniqueness: true
  validates :method, inclusion: %w[GET POST PUT]

  def push_response(response)
    HTTParty.send(method.downcase.to_sym,
                  url,
                  headers: { Authorization: "Bearer #{response.generate_token}" },
                  body: {'serviceName' => 'u-can-act', 'data' => Api::ResponseSerializer.new(response).as_json })
  end
end
