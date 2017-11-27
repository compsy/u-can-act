# frozen_string_literal: true

# Running rake db:reset will leave seeds with a terminated connection.
ActiveRecord::Base.connection.reconnect! if Rails.env.development?

Dir[File.join(File.dirname(__FILE__), 'seeds', 'questionnaires', '**', '*.rb')].each do |file|
  require file
end

Dir[File.join(File.dirname(__FILE__), 'seeds', 'protocols', '**', '*.rb')].each do |file|
  require file
end

Dir[File.join(File.dirname(__FILE__), 'seeds', 'organizations', '**', '*.rb')].each do |file|
  require file
end

# Load seeds from the seeds directory.
Dir[File.join(File.dirname(__FILE__), 'seeds', '*.rb')].each do |file|
  require file
end

# Remember to use create!/save! instead of create/save everywhere in seeds

# WARNING: seeds below are not idempotent: use dbsetup after changing something
if Rails.env.development?

  # Mentor questionnaire seeds
  puts ''
  protocol = Protocol.find_by_name('mentoren dagboek')
  person = Organization.first.roles.where(group: Person::MENTOR).first.people.first
  students = Organization.first.roles.where(group: Person::STUDENT).first.people[0..-2]
  students.each do |student|
    prot_sub = ProtocolSubscription.create!(
      protocol: protocol,
      person: person,
      filling_out_for: student,
      state: ProtocolSubscription::ACTIVE_STATE,
      start_date: Time.zone.now.beginning_of_week
    )
    responseobj = prot_sub.responses.first
    responseobj.update_attributes!(
      open_from: 1.minute.ago,
      invited_state: Response::SENT_STATE)
    responseobj.initialize_invitation_token!
    puts "mentor dagboek: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
  end
  protocol = Protocol.find_by_name('mentoren voormeting/nameting')
  person = Organization.first.roles.where(group: Person::MENTOR).first.people.first
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobj = prot_sub.responses.first # voormeting
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "mentor voormeting: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
  responseobj = prot_sub.responses.last # nameting
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "mentor nameting: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"

  # Student questionnaire seeds
  puts ''
  student = Organization.first.roles.where(group: Person::STUDENT).first.people.first
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobj = student.protocol_subscriptions.first.responses.first
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "student voormeting: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
  responseobj = student.protocol_subscriptions.first.responses[10]
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "student dagboek: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
  responseobj = student.protocol_subscriptions.first.responses.last
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "student nameting: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"

  puts ''
  student = Organization.first.roles.where(group: Person::STUDENT).first.people.second
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobjs = student.protocol_subscriptions.first.responses
  responseobjs[0...3].each do |response|
    response.update_attributes!(
      open_from: (2.days.ago - 10.minutes),
      completed_at: 2.day.ago,
      invited_state: Response::SENT_STATE
    )
  end
  responseobj = responseobjs.fifth
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "student dagboek - Bijna in streak -: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"


end

puts 'Seeds loaded!'
