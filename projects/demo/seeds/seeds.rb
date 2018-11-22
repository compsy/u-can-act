# These seeds need to be loaded first, and in order.
%w[questionnaires protocols organizations teams].each do |seed_directory|
  Dir[File.join(File.dirname(__FILE__), seed_directory, '**', '*.rb')].each do |file|
    require file
  end
end

if Person.count == 0 && (Rails.env.development? || Rails.env.staging?)
  def generate_phone
    "06#{rand(10 ** 8).to_s.rjust(8,'0')}"
  end
  puts 'Generating people - Started'

  demo_organization = 'Demo-organization'
  demo_team = 'Demo-team'
  solo_role_title = 'Demo-solo'
  solo_protocol = 'demo-solo-protocol'

  organization = Organization.find_by_name(demo_organization)
  team = organization.teams.find_by_name(demo_team)
  solo_role = team.roles.where(title: solo_role_title).first

  students =[
    { first_name: 'Solo',       last_name: 'Demo',      gender: 'male',   role: solo_role},
    { first_name: 'Klaziena',  last_name: 'Kramer',      gender: 'female', role: solo_role},
  ]

  students.each do |student_hash|
    phone = generate_phone
    while Person.find_by_mobile_phone(phone).present?
      phone = generate_phone
    end
    Person.create!(first_name: student_hash[:first_name],
                   last_name: student_hash[:last_name],
                   gender: student_hash[:gender],
                   mobile_phone: phone, role: student_hash[:role])
  end
  puts 'Generating people - Finished'

  # Solo
  puts ''
  protocol = Protocol.find_by_name(solo_protocol)
  person = Team.find_by_name(demo_team).roles.where(group: Person::SOLO).first.people[0]
  prot_start = Time.zone.now.beginning_of_day
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: prot_start,
    informed_consent_given_at: Time.zone.now
  )
  RescheduleResponses.run!(protocol_subscription: prot_sub,
                           future: TimeTools.increase_by_duration(prot_start, -1.second))
  responseobj = prot_sub.responses.first
  invitation_set = InvitationSet.create!(person: person)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "Demo informed consent: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Demo informed consent
  protocol = Protocol.find_by_name(solo_protocol)
  person = Team.find_by_name(demo_team).roles.where(group: Person::SOLO).first.people[1]
  prot_start = Time.zone.now.beginning_of_day
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: prot_start
  )
  RescheduleResponses.run!(protocol_subscription: prot_sub,
                           future: TimeTools.increase_by_duration(prot_start, -1.second))
  responseobj = prot_sub.responses.first # demo
  invitation_set = InvitationSet.create!(person: person)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "Demo informed consent: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  puts 'Generating onetime response'
  OneTimeResponse.destroy_all
  protocol = Protocol.find_by_name(solo_protocol)
  token = 'demosolo'
  OneTimeResponse.create!(token: token, protocol: protocol)

  puts Rails.application.routes.url_helpers.one_time_response_url(q: token)
  puts 'Generated onetime response'
end
