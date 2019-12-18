# frozen_string_literal: true

if Person.all.select{|person| person.auth_user.blank?}.count == 0 && (Rails.env.development? || Rails.env.staging?)
  demo_organization = 'sport-data-valley'
  demo_team = 'sdv-team'
  solo_role_title = 'Demo-solo'
  normal_role_title = 'normal'
  solo_protocol = 'general-solo-protocol'

  organization = Organization.find_by_name(demo_organization)
  team = organization.teams.find_by_name(demo_team)
  solo_role = team.roles.where(title: solo_role_title).first
  normal_role = team.roles.where(title: normal_role_title).first

  # Create weekly protocol
  Person.create!(first_name: 'Jan',
                last_name: 'Fictief',
                gender: 'male',
                mobile_phone: "06#{rand(10**8).to_s.rjust(8, '0')}",
                role: normal_role)

  #protocol = Protocol.find_by(name: 'training_log')
  #person = Team.find_by_name(demo_team).roles.where(group: Person::STUDENT).first.people[0]

  #prot_sub = ProtocolSubscription.create!(
    #protocol: protocol,
    #person: person,
    #state: ProtocolSubscription::ACTIVE_STATE,
    #start_date: Time.zone.now
  #)

  #invitation_set = InvitationSet.create!(person: person)

  ## Add the responses to the invitation set
  #responseobj = prot_sub.responses.first
  #responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)

  #invitation_token = invitation_set.invitation_tokens.create!
  #puts "After training protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  Person.create!(first_name: 'Janie',
                last_name: 'Fictieva',
                gender: 'female',
                mobile_phone: "06#{rand(10**8).to_s.rjust(8, '0')}",
                role: normal_role)

  protocol = Protocol.find_by(name: 'daily_protocol')
  person = Team.find_by_name(demo_team).roles.where(group: Person::STUDENT).first.people[1]
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )

  invitation_set = InvitationSet.create!(person: person)

  [prot_sub.responses.first, prot_sub.responses.second].each do |responseobj|
    responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  end

  invitation_token = invitation_set.invitation_tokens.create!
  puts "Daily protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  puts 'Generating onetime response'
  protocol = Protocol.find_by_name(solo_protocol)
  token = solo_protocol
  otr = OneTimeResponse.find_by(token: token)
  otr ||= OneTimeResponse.create!(token: token, protocol: protocol)

  puts Rails.application.routes.url_helpers.one_time_response_url(q: token)
  puts 'Generated onetime response'
end
