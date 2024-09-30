# frozen_string_literal: true

if Person.all.select{|person| person.auth_user.blank?}.count == 0 && (Rails.env.development? || Rails.env.staging?)
  def generate_phone
    "06#{rand(10**8).to_s.rjust(8, '0')}"
  end
  puts 'Generating people - Started'

  usc_organization = 'USC Chan'
  usc_team = 'USC-team'
  solo_role_title = 'USC-solo'
  solo_protocol = 'usc_chan'

  organization = Organization.find_by(name: usc_organization)
  team = organization.teams.find_by(name: usc_team)
  solo_role = team.roles.find_by(title: solo_role_title)

  students = [
    { first_name: 'Solo', last_name: 'Demo', gender: 'male', role: solo_role },
    { first_name: 'Klaziena', last_name: 'Kramer', gender: 'female', role: solo_role }
  ]

  students.each do |student_hash|
    phone = generate_phone
    phone = generate_phone while Person.find_by(mobile_phone: phone).present?
    Person.create!(first_name: student_hash[:first_name],
                   last_name: student_hash[:last_name],
                   gender: student_hash[:gender],
                   mobile_phone: phone,
                   role: student_hash[:role],
                   locale: 'en')
  end
  puts 'Generating people - Finished'

  # Solo
  puts ''
  protocol = Protocol.find_by(name: solo_protocol)
  person = Team.find_by(name: usc_team).roles.find_by(group: Person::SOLO).people[0]
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
  responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "USC questionnaire: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # USC informed consent
  protocol = Protocol.find_by(name: solo_protocol)
  person = Team.find_by(name: usc_team).roles.find_by(group: Person::SOLO).people[1]
  prot_start = Time.zone.now.beginning_of_day
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: prot_start
  )
  RescheduleResponses.run!(protocol_subscription: prot_sub,
                           future: TimeTools.increase_by_duration(prot_start, -1.second))
  responseobj = prot_sub.responses.first
  invitation_set = InvitationSet.create!(person: person)
  responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "USC informed consent: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  puts 'Generating onetime response'
  OneTimeResponse.destroy_all
  protocol = Protocol.find_by(name: solo_protocol)
  token = 'uscsolo'
  OneTimeResponse.create!(token: token, protocol: protocol)

  puts Rails.application.routes.url_helpers.one_time_response_url(q: token)
  puts 'Generated onetime response'
end
