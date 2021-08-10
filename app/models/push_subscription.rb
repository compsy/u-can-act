# frozen_string_literal: true

class PushSubscription < ApplicationRecord
  belongs_to :protocol
  validates :url, presence: true
  validates :name, presence: true, uniqueness: { scope: :protocol_id }
  validates :method, inclusion: %w[GET POST PUT]

  def push_response(response)
    return unless response&.person&.auth_user&.present?

    HTTParty.send(method.downcase.to_sym,
                  url,
                  headers: { Authorization: "Bearer #{response.person.auth_user.generate_token}" },
                  body: {
                    raw_data: {
                      'serviceName' => 'u-can-act',
                      'data' => Api::ResponseSerializer.new(response,
                                                            with_protocol_completion: true).as_json
                    }.to_json
                  })
  end
end
