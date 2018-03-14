# frozen_string_literal: true

# Running rake db:reset will leave seeds with a terminated connection.
ActiveRecord::Base.connection.reconnect! if Rails.env.development?

# These seeds need to be loaded first, and in order.
%w[questionnaires protocols organizations teams].each do |seed_directory|
  Dir[File.join(File.dirname(__FILE__), 'seeds', seed_directory, '**', '*.rb')].each do |file|
    require file
  end
end

# Load seeds from the seeds directory.
Dir[File.join(File.dirname(__FILE__), 'seeds', '*.rb')].each do |file|
  require file
end

# Remember to use create!/save! instead of create/save everywhere in seeds

# WARNING: seeds below are not idempotent: use dbsetup after changing something
if Rails.env.development? && ProtocolSubscription.count.zero?

  # Mentor pre assessment
  puts ''
  protocol = Protocol.find_by_name('mentoren voormeting/nameting')
  person = Team.find_by_name('Default team').roles.where(group: Person::MENTOR).first.people[0]
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
  protocol = Protocol.find_by_name('mentoren dagboek')
  person = Team.find_by_name('Default team').roles.where(group: Person::MENTOR).first.people[1]
  students = Team.find_by_name('Default team').roles.where(group: Person::STUDENT).first.people[0..-2]
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
  protocol = Protocol.find_by_name('mentoren voormeting/nameting')
  person = Team.find_by_name('Default team').roles.where(group: Person::MENTOR).first.people[2]
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
  puts "mentor nameting: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Student pre assessment
  puts ''
  student = Team.find_by_name('Default team').roles.where(group: Person::STUDENT).first.people[0]
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('studenten'),
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
  student = Team.find_by_name('Default team').roles.where(group: Person::STUDENT).first.people[1]
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('studenten'),
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
  student = Team.find_by_name('Default team').roles.where(group: Person::STUDENT).first.people[2]
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )
  responseobjs = student.protocol_subscriptions.first.responses
  responseobjs[0...3].each do |resp|
    resp.update_attributes!(
      open_from: (2.days.ago - 10.minutes),
      completed_at: 2.day.ago)
  end
  responseobj = responseobjs.fifth
  invitation_set = InvitationSet.create!(person: student)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "student dagboek (bijna in streak): #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Student post assessment
  student = Team.find_by_name('Default team').roles.where(group: Person::STUDENT).first.people[3]
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )
  responseobj = student.protocol_subscriptions.first.responses.
    select{|x|x.measurement.questionnaire.name =~ /nameting/}.first # nameting
  voormeting = student.protocol_subscriptions.first.responses.first
  dagboekmeting = student.protocol_subscriptions.first.responses.second
  [voormeting, dagboekmeting].each { |resp| resp.update_attributes!(open_from: 2.weeks.from_now) }
  invitation_set = InvitationSet.create!(person: student)
  responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "student nameting: #{invitation_set.invitation_url(invitation_token.token_plain)}"
  puts ''

end

puts 'Seeds loaded!'
