# frozen_string_literal: true

if (Rails.env.development? || Rails.env.staging?)
  puts 'Generating onetime response'
  OneTimeResponse.destroy_all
  protocol = Protocol.find_by_name('evaluatieonderzoek')
  token = 'abc'
  OneTimeResponse.create!(token: token, protocol: protocol)

  puts Rails.application.routes.url_helpers.one_time_response_url(t: token)
  puts 'Generated onetime response'
end
