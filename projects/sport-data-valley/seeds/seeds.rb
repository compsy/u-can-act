# frozen_string_literal: true

if Person.count == 0 && (Rails.env.development? || Rails.env.staging?)
  solo_protocol = 'general-solo-protocol'

  puts 'Generating onetime response'
  OneTimeResponse.destroy_all
  protocol = Protocol.find_by_name(solo_protocol)
  token = solo_protocol
  OneTimeResponse.create!(token: token, protocol: protocol)

  puts Rails.application.routes.url_helpers.one_time_response_url(q: token)
  puts 'Generated onetime response'
end
