# frozen_string_literal: true

if Person.all.select{|person| person.auth_user.blank?}.count == 0 && (Rails.env.development? || Rails.env.staging?)
  demo_organization = 'sport-data-valley'
  demo_team = 'sdv-team'
  normal_role_title = 'normal'

  organization = Organization.find_by(name: demo_organization)
  team = organization.teams.find_by(name: demo_team)
  normal_role = team.roles.where(title: normal_role_title).first

  # Create weekly protocol
  Person.create!(first_name: 'Jan',
                last_name: 'Fictief',
                gender: 'male',
                mobile_phone: "06#{rand(10**8).to_s.rjust(8, '0')}",
                role: normal_role)

  Person.create!(first_name: 'Janiee',
                last_name: 'Fictieva',
                gender: 'female',
                mobile_phone: "06#{rand(10**8).to_s.rjust(8, '0')}",
                role: normal_role)

  Person.create!(first_name: 'Janiea',
                 last_name: 'Fictieva',
                 gender: 'female',
                 mobile_phone: "06#{rand(10 ** 8).to_s.rjust(8, '0')}",
                 role: normal_role)

  Person.create!(first_name: 'Janieb',
                 last_name: 'Fictieva',
                 gender: 'female',
                 mobile_phone: "06#{rand(10 ** 8).to_s.rjust(8, '0')}",
                 role: normal_role)

  Person.create!(first_name: 'Janied',
                 last_name: 'Fictieva',
                 gender: 'female',
                 mobile_phone: "06#{rand(10 ** 8).to_s.rjust(8, '0')}",
                 role: normal_role)

  Person.create!(first_name: 'Janiee',
                 last_name: 'Fictieva',
                 gender: 'female',
                 mobile_phone: "06#{rand(10 ** 8).to_s.rjust(8, '0')}",
                 role: normal_role)

  Person.create!(first_name: 'Janief',
                 last_name: 'Fictieva',
                 gender: 'female',
                 mobile_phone: "06#{rand(10 ** 8).to_s.rjust(8, '0')}",
                 role: normal_role)

  Person.create!(first_name: 'Din',
                  last_name: 'Djarin',
                  gender: 'male',
                  mobile_phone: "06#{rand(10 ** 8).to_s.rjust(8, '0')}",
                  role: normal_role)

  Person.create!(first_name: 'Anakin',
                  last_name: 'Skywalker',
                  gender: 'male',
                  mobile_phone: "06#{rand(10 ** 8).to_s.rjust(8, '0')}",
                  role: normal_role)

  # Create daily protocol instance
  protocol = Protocol.find_by(name: 'daily_protocol')
  person = Team.find_by(name: demo_team).roles.where(group: Person::STUDENT).first.people.where(email: nil)[1]
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )

  invitation_set = InvitationSet.create!(person: person)

  [prot_sub.responses.first, prot_sub.responses.second].each do |responseobj|
    responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  end

  invitation_token = invitation_set.invitation_tokens.create!
  puts "Daily protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"


  # Create squash protocol instance
  protocol = Protocol.find_by(name: 'squash')
  person = Team.find_by_name(demo_team).roles.where(group: Person::STUDENT).first.people.where(email: nil)[2]
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now
  )

  invitation_set = InvitationSet.create!(person: person)

  prot_sub.responses.first.update!(open_from: 1.minute.ago, invitation_set: invitation_set)

  invitation_token = invitation_set.invitation_tokens.create!
  puts "Squash protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Create restq protocol instance
  protocol = Protocol.find_by(name: 'restq')
  person = Team.find_by_name(demo_team).roles.where(group: Person::STUDENT).first.people.where(email: nil)[3]
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now
  )

  invitation_set = InvitationSet.create!(person: person)

  prot_sub.responses.first.update!(open_from: 1.minute.ago, invitation_set: invitation_set)

  invitation_token = invitation_set.invitation_tokens.create!
  puts "Restq protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Create squash OTR
  puts ''
  protocol = Protocol.find_by(name: 'squash_otr')
  token = 'squash'
  OneTimeResponse.create!(token: token, protocol: protocol) unless OneTimeResponse.exists?(token: token)
  puts "One time response: #{Rails.application.routes.url_helpers.one_time_response_url(q: token)}"

  # Create ostrc_o_h protocol instance
  protocol = Protocol.find_by(name: 'ostrc_h_o')
  person = Team.find_by_name(demo_team).roles.where(group: Person::STUDENT).first.people.where(email: nil)[4]
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now
  )

  invitation_set = InvitationSet.create!(person: person)

  prot_sub.responses.first.update!(open_from: 1.minute.ago, invitation_set: invitation_set)

  invitation_token = invitation_set.invitation_tokens.create!
  puts "OSTRC H+O protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Create rheumatism daily questionnaire protocol instance
  protocol = Protocol.find_by(name: 'daily_protocol_rheumatism')
  person = Team.find_by_name(demo_team).roles.where(group: Person::STUDENT).first.people.where(email: nil)[5]
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now
  )

  invitation_set = InvitationSet.create!(person: person)

  prot_sub.responses.first.update!(open_from: 1.minute.ago, invitation_set: invitation_set)

  invitation_token = invitation_set.invitation_tokens.create!
  puts "Daily rheumatism protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Create rheumatism one time protocol instance
  protocol = Protocol.find_by(name: 'rheumatism_one_time')
  person = Team.find_by_name(demo_team).roles.where(group: Person::STUDENT).first.people.where(email: nil)[6]
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now
  )

  invitation_set = InvitationSet.create!(person: person)

  # NOTE: for non-periodic (one-off) protocols that have multiple questionnaires,
  #       set all of them to opened (like below), instead of just the first response.
  prot_sub.responses.each do |responseobj|
    responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  end

  invitation_token = invitation_set.invitation_tokens.create!
  puts "Rheumatism one time protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Create move mood and motivation one time protocol instance
  protocol = Protocol.find_by(name: MMM_PROTOCOL_NAME)
  person = Team.find_by_name(demo_team).roles.where(group: Person::STUDENT).first.people.where(email: nil)[7]
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now
  )

  invitation_set = InvitationSet.create!(person: person)

  prot_sub.responses.first.update!(open_from: 1.minute.ago, invitation_set: invitation_set)

  invitation_token = invitation_set.invitation_tokens.create!
  puts "Move, Mood and Motivation: #{invitation_set.invitation_url(invitation_token.token_plain)}"
end
