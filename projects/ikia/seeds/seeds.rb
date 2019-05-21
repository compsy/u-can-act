# frozen_string_literal: true

if Rails.env.development? || Rails.env.staging?
  if OneTimeResponse.count.zero?
    solo_protocol = 'demo-solo-protocol'
    puts 'Generating onetime response'
    OneTimeResponse.destroy_all
    protocol = Protocol.find_by_name(solo_protocol)
    token = 'demoikia'
    OneTimeResponse.create!(token: token, protocol: protocol)

    puts Rails.application.routes.url_helpers.one_time_response_url(q: token)
    puts 'Generated onetime response'
  else
    token = OneTimeResponse.first.token
    puts 'Existing onetime response'
    puts Rails.application.routes.url_helpers.one_time_response_url(q: token)
  end
end
