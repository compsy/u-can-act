# frozen_string_literal: true

if Person.count == 0 && (Rails.env.development? || Rails.env.staging?)
  demo_organization = 'sport-data-valley'
  demo_team = 'sdv-team'
  solo_role_title = 'Demo-solo'
  solo_protocol = 'general-solo-protocol'

  organization = Organization.find_by_name(demo_organization)
  team = organization.teams.find_by_name(demo_team)
  solo_role = team.roles.where(title: solo_role_title).first
  Person.create!(first_name: 'Jan',
                last_name: 'Fictief',
                gender: 'male',
                mobile_phone: "06#{rand(10**8).to_s.rjust(8, '0')}",
                role: solo_role)

  puts 'Generating onetime response'
  OneTimeResponse.destroy_all
  protocol = Protocol.find_by_name(solo_protocol)
  token = solo_protocol
  OneTimeResponse.create!(token: token, protocol: protocol)

  puts Rails.application.routes.url_helpers.one_time_response_url(q: token)
  puts 'Generated onetime response'
end
