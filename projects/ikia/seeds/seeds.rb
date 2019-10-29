# frozen_string_literal: true

if Rails.env.development? || Rails.env.staging?
  OneTimeResponse.destroy_all
  solo_protocol = 'demo-solo-protocol'
  puts 'Generating onetime response'
  OneTimeResponse.destroy_all
  protocol = Protocol.find_by_name(solo_protocol)
  token = 'demoikia'
  OneTimeResponse.create!(token: token, protocol: protocol)

  puts Rails.application.routes.url_helpers.one_time_response_url(q: token)
  puts 'Generated onetime response'

  puts ''
  protocol = Protocol.find_by_name('kkjlo')
  token = 'kkjlo'
  OneTimeResponse.create!(token: token, protocol: protocol)
  puts "One time response: #{Rails.application.routes.url_helpers.one_time_response_url(q: token)}"

  puts ''
  protocol = Protocol.find_by_name('kkjlz')
  token = 'kkjlz'
  OneTimeResponse.create!(token: token, protocol: protocol)
  puts "One time response: #{Rails.application.routes.url_helpers.one_time_response_url(q: token)}"
end
