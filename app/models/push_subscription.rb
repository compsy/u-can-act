# frozen_string_literal: true

class PushSubscription < ApplicationRecord
  SDV_TEMPLATE = 'sdv'
  UMO_CKAN_TEMPLATE = 'umo-ckan'

  TEMPLATES = [SDV_TEMPLATE, UMO_CKAN_TEMPLATE].freeze

  belongs_to :protocol
  validates :url, presence: true
  validates :name, presence: true, uniqueness: { scope: :protocol_id }
  validates :method, inclusion: %w[GET POST PUT]
  validates :template, inclusion: TEMPLATES

  def push_response(response)
    push_sdv_response(response) if template == SDV_TEMPLATE
    push_umo_ckan_response(response) if template == UMO_CKAN_TEMPLATE
  end

  def push_sdv_response(response)
    return unless response&.person&.auth_user&.present?

    HTTParty.send(method.downcase.to_sym,
                  url,
                  headers: { Authorization: "Bearer #{response.person.auth_user.generate_token}" },
                  body: { raw_data: { 'serviceName' => 'u-can-act',
                                      'data' => Api::ResponseSerializer.new(response).as_json }.to_json })
  end

  def push_umo_ckan_response(response)
    HTTParty.send(method.downcase.to_sym,
                  url,
                  headers: { 'X-CKAN-API-Key': ENV['CKAN_TOKEN'], 'Content-Type': 'application/json' },
                  body: Api::CkanResponseSerializer.new(response).to_json)
  end
end
