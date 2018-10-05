# frozen_string_literal: true

OneTimeResponse.delete_all
protocol = Protocol.find_by_name('evaluatieonderzoek')
OneTimeResponse.create!(token: 'abc', protocol: protocol)

puts Rails.application.routes.url_helpers.one_time_response_url(t: 'abc')
puts 'Generated onetime response'
