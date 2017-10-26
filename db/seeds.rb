# frozen_string_literal: true

# Running rake db:reset will leave seeds with a terminated connection.
ActiveRecord::Base.connection.reconnect! if Rails.env.development?

# Require personal question seeds separately because they
# need to already exist when the protocol seeds are loaded, and the
# order is different on production servers.
Dir[File.join(File.dirname(__FILE__), 'seeds', 'questionnaire_seeds', '*.rb')].each do |file|
  require file
end

# Load seeds from the seeds directory.
Dir[File.join(File.dirname(__FILE__), 'seeds', '*.rb')].each do |file|
  require file
end

# WARNING: seeds below are not idempotent: use dbsetup after changing something
# WARNING: please use create! instead of create everywhere in seeds
if Rails.env.development?
  puts ""
  protocol = Protocol.find_by_name('pilot - mentoren 1x per week')
  person = Organization.first.roles.where(group: Person::MENTOR).first.persons.first
  students = Organization.first.roles.where(Person::STUDENT)[0..-2].map{|x| x.person}
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
    puts "mentor questionnaire: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
  end
  protocol = Protocol.find_by_name('pilot - mentoren nameting')
  person = Organization.first.roles.where(group: Person::MENTOR).first.persons.first
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobj = prot_sub.responses.first
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "mentor posttest: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"

  student = Organization.first.roles.where(group: Person::STUDENT).first.persons.first
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('pilot - studenten 1x per week'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobj = student.protocol_subscriptions.first.responses.first
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "student 1x per week questionnaire: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"

  student = Organization.first.roles.where(group: Person::STUDENT).first.persons.second
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('pilot - studenten 2x per week'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobj = student.protocol_subscriptions.first.responses.first
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "student 2x per week questionnaire: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
  responseobj = student.protocol_subscriptions.first.responses.last
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "student 2x per week posttest: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"

  student = Organization.first.roles.where(group: Person::STUDENT).first.person.third
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('pilot - studenten 5x per week'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobj = student.protocol_subscriptions.first.responses.first
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "student 5x per week questionnaire: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
  responseobj = student.protocol_subscriptions.first.responses.last
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "student 5x per week posttest: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"

  puts ""
end

puts 'Seeds loaded!'
