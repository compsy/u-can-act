# frozen_string_literal: true

# These seeds need to be loaded first, and in order.
%w[questionnaires protocols organizations teams].each do |seed_directory|
  Dir[File.join(File.dirname(__FILE__), seed_directory, '**', '*.rb')].each do |file|
    require file
  end
end

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
