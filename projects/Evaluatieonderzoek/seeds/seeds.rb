# frozen_string_literal: true

if Person.all.select{|person| person.auth_user.blank?}.count == 0 && (Rails.env.development? || Rails.env.staging?)
  def generate_phone
    "06#{rand(10**8).to_s.rjust(8, '0')}"
  end
  puts 'Generating people - Started'

  organization = Organization.find_by(name: 'Evaluatieonderzoek')
  team = organization.teams.find_by(name: 'Evaluatieonderzoek')
  student = team.roles.where(title: 'Evalueerder').first

  students =[
    { first_name: 'Jan',       last_name: 'Jansen',      gender: 'male',   role: student},
    { first_name: 'Klaziena',  last_name: 'Kramer',      gender: 'female', role: student},
    { first_name: 'Aaltje',    last_name: 'Hoendersma',  gender: 'female', role: student}
  ]

  students.each do |student_hash|
    phone = generate_phone
    phone = generate_phone while Person.find_by(mobile_phone: phone).present?
    Person.create!(first_name: student_hash[:first_name],
                   last_name: student_hash[:last_name],
                   gender: student_hash[:gender],
                   mobile_phone: phone, role: student_hash[:role])
  end
  puts 'Generating people - Finished'

  # Evaluatieonderzoek
  puts ''
  protocol = Protocol.find_by(name: 'evaluatieonderzoek')
  person = Team.find_by(name: 'Evaluatieonderzoek').roles.where(group: Person::SOLO).first.people[0]
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
  responseobj = prot_sub.responses.first # evaluatieonderzoek
  invitation_set = InvitationSet.create!(person: person)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "Evaluatieonderzoek: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Evaluatieonderzoek informed consent
  protocol = Protocol.find_by(name: 'evaluatieonderzoek')
  person = Team.find_by(name: 'Evaluatieonderzoek').roles.where(group: Person::SOLO).first.people[1]
  prot_start = Time.zone.now.beginning_of_day
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: prot_start
  )
  RescheduleResponses.run!(protocol_subscription: prot_sub,
                           future: TimeTools.increase_by_duration(prot_start, -1.second))
  responseobj = prot_sub.responses.first # evaluatieonderzoek
  invitation_set = InvitationSet.create!(person: person)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "Evaluatieonderzoek informed consent: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Telefonische interviews
  puts ''
  protocol = Protocol.find_by(name: 'telefonische_interviews')
  person = Team.find_by(name: 'Evaluatieonderzoek').roles.where(group: Person::SOLO).first.people[2]
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
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "Telefonische interviews: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # One time responses
  OneTimeResponse.destroy_all

  puts ''
  protocol = Protocol.find_by(name: 'evaluatieonderzoek')
  token = 'abc'
  OneTimeResponse.create!(token: token, protocol: protocol)
  puts "One time response: #{Rails.application.routes.url_helpers.one_time_response_url(q: token)}"

  puts ''
  protocol = Protocol.find_by(name: 'symposium')
  token = 'symposium'
  OneTimeResponse.create!(token: token, protocol: protocol)
  puts "One time response: #{Rails.application.routes.url_helpers.one_time_response_url(q: token)}"

  puts ''
  protocol = Protocol.find_by(name: 'boek')
  token = 'boek'
  OneTimeResponse.create!(token: token, protocol: protocol)
  puts "One time response: #{Rails.application.routes.url_helpers.one_time_response_url(q: token)}"
end
