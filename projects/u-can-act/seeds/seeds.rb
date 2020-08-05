# frozen_string_literal: true

if Person.all.select{|person| person.auth_user.blank?}.count == 0 && (Rails.env.development? || Rails.env.staging?)
  def generate_phone
    "06#{rand(10**8).to_s.rjust(8, '0')}"
  end
  puts 'Generating people - Started'

  organization = Organization.find_or_create_by(name: 'Default organization')
  team = organization.teams.find_or_create_by(name: 'Default team')

  student = team.roles.where(title: 'student').first
  student ||= team.roles.create!(group: Person::STUDENT, title: 'student')

  nameting_student = team.roles.where(title: 'nameting-student').first
  nameting_student ||= team.roles.create!(group: Person::STUDENT, title: 'nameting-student')

  mentor = team.roles.where(group: Person::MENTOR).first
  mentor ||= team.roles.create!(group: Person::MENTOR, title: 'mentor')

  students = [
    { first_name: 'Jan',       last_name: 'Jansen',      gender: 'male',   role: student },
    { first_name: 'Klaziena',  last_name: 'Kramer',      gender: 'female', role: student },
    { first_name: 'Erika',     last_name: 'de Bür',      gender: 'female', role: student },
    { first_name: 'Eric',      last_name: 'de Vries',    gender: 'male',   role: student },
    { first_name: 'Henk',      last_name: 'Veenstra',    gender: 'male',   role: student },
    { first_name: 'Bert',      last_name: 'Huizinga',    gender: nil,      role: student },
    { first_name: 'Arjen',     last_name: 'Arends',      gender: 'male',   role: nameting_student },
    { first_name: 'Bernard',   last_name: 'Berends',     gender: 'male',   role: nameting_student },
    { first_name: 'Cornelis',  last_name: 'Cornelissen', gender: 'male',   role: nameting_student },
    { first_name: 'Dirk',      last_name: 'de Dienaar',  gender: 'male',   role: nameting_student },
    { first_name: 'Emma',      last_name: 'Eggen',       gender: 'female', role: nameting_student },
    { first_name: 'Fennelien', last_name: 'Flandal',     gender: 'female', role: nameting_student }
  ]

  students.each do |student_hash|
    phone = generate_phone
    phone = generate_phone while Person.find_by(mobile_phone: phone).present?
    Person.create!(first_name: student_hash[:first_name],
                   last_name: student_hash[:last_name],
                   gender: student_hash[:gender],
                   mobile_phone: phone, role: student_hash[:role])
  end

  mentors = [
    { first_name: 'Koos', last_name: 'Barendrecht', gender: 'male', email: 'koos_barendrecht@example.com' },
    { first_name: 'Anna', last_name: 'Groen', gender: 'female', email: 'anna_groen@example.com' },
    { first_name: 'Men', last_name: 'Tor', gender: nil, email: 'men_tor@example.com' }
  ]

  mentors.each do |mentor_hash|
    phone = generate_phone
    phone = generate_phone while Person.find_by(mobile_phone: phone).present?
    Person.create!(first_name: mentor_hash[:first_name],
                   last_name: mentor_hash[:last_name],
                   gender: mentor_hash[:gender],
                   email: mentor_hash[:email],
                   mobile_phone: phone, role: mentor)
  end

  puts 'Generating people - Finished'
end

# WARNING: seeds below are not idempotent: use dbsetup after changing something
if Rails.env.development? && ProtocolSubscription.count.zero?

  # Mentor pre assessment
  puts ''
  protocol = Protocol.find_by(name: 'mentoren voormeting/nameting')
  person = Team.find_by(name: 'Default team').roles.where(group: Person::MENTOR).first.people[0]
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobj = prot_sub.responses.first # voormeting
  invitation_set = InvitationSet.create!(person: person)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "mentor voormeting: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Mentor diary
  protocol = Protocol.find_by(name: 'mentoren dagboek')
  person = Team.find_by(name: 'Default team').roles.where(group: Person::MENTOR).first.people[1]
  students = Team.find_by(name: 'Default team').roles.where(group: Person::STUDENT).first.people[0..-2]
  invitation_set = InvitationSet.create!(person: person)
  invitation_token = invitation_set.invitation_tokens.create!
  students.each do |student|
    prot_sub = ProtocolSubscription.create!(
      protocol: protocol,
      person: person,
      filling_out_for: student,
      state: ProtocolSubscription::ACTIVE_STATE,
      start_date: Time.zone.now.beginning_of_week
    )
    responseobj = prot_sub.responses.first
    responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  end
  puts "mentor dagboek: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Mentor post assessment
  protocol = Protocol.find_by(name: 'mentoren voormeting/nameting')
  person = Team.find_by(name: 'Default team').roles.where(group: Person::MENTOR).first.people[2]
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )
  responseobj = prot_sub.responses.last # nameting
  prot_sub.responses.first.update_attributes!(open_from: 2.weeks.from_now) # make sure the voormeting is not open
  invitation_set = InvitationSet.create!(person: person)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  nameting_students = Team.find_by(name: 'Default team').roles.where(title: 'nameting-student').first.people[0..-2]
  nameting_students.each do |student|
    prot_sub = ProtocolSubscription.create!(
      protocol: protocol,
      person: person,
      filling_out_for: student,
      state: ProtocolSubscription::ACTIVE_STATE,
      start_date: 10.years.ago.beginning_of_week
    )
  end
  puts "mentor nameting: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Student pre assessment
  puts ''
  student = Team.find_by(name: 'Default team').roles.where(group: Person::STUDENT).first.people[0]
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by(name: 'studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobj = student.protocol_subscriptions.first.responses.first # voormeting
  student.protocol_subscriptions.first.responses.second.update_attributes!(open_from: 2.weeks.from_now)
  invitation_set = InvitationSet.create!(person: student)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "student voormeting: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Student diary
  student = Team.find_by(name: 'Default team').roles.where(group: Person::STUDENT).first.people[1]
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by(name: 'studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )
  responseobj = student.protocol_subscriptions.first.responses[10] # een dagboekmeting
  student.protocol_subscriptions.first.responses.first.update_attributes!(open_from: 2.weeks.from_now)
  invitation_set = InvitationSet.create!(person: student)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "student dagboek: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Student diary almost in streak
  student = Team.find_by(name: 'Default team').roles.where(group: Person::STUDENT).first.people[2]
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by(name: 'studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )
  responseobjs = student.protocol_subscriptions.first.responses
  responseobjs[0...3].each do |resp|
    resp.update_attributes!(
      open_from: (2.days.ago - 10.minutes),
      completed_at: 2.day.ago
    )
  end
  responseobj = responseobjs.fifth
  invitation_set = InvitationSet.create!(person: student)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "student dagboek (bijna in streak): #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Student post assessment
  student = Team.find_by(name: 'Default team').roles.where(group: Person::STUDENT).first.people[3]
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by(name: 'studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )
  responseobj = student.protocol_subscriptions.first.responses
                       .select { |x| x.measurement.questionnaire.name =~ /nameting/ }.first # nameting
  voormeting = student.protocol_subscriptions.first.responses.first
  dagboekmeting = student.protocol_subscriptions.first.responses.second
  [voormeting, dagboekmeting].each { |resp| resp.update_attributes!(open_from: 2.weeks.from_now) }
  invitation_set = InvitationSet.create!(person: student)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "student nameting: #{invitation_set.invitation_url(invitation_token.token_plain)}"
  puts ''

end
