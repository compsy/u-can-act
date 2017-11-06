# frozen_string_literal: true

# Running rake db:reset will leave seeds with a terminated connection.
ActiveRecord::Base.connection.reconnect! if Rails.env.development?

Dir[File.join(File.dirname(__FILE__), 'seeds', 'questionnaires', '**', '*.rb')].each do |file|
  require file
end

Dir[File.join(File.dirname(__FILE__), 'seeds', 'protocols', '**', '*.rb')].each do |file|
  require file
end

# Load seeds from the seeds directory.
Dir[File.join(File.dirname(__FILE__), 'seeds', '*.rb')].each do |file|
  require file
end

# Remember to use create!/save! instead of create/save everywhere in seeds

# WARNING: seeds below are not idempotent: use dbsetup after changing something
if Rails.env.development?
  puts ""
  protocol = Protocol.find_by_name('pilot - mentoren 1x per week')
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
    puts "mentor questionnaire: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
  end
  protocol = Protocol.find_by_name('pilot - mentoren nameting')
  person = Organization.first.roles.where(group: Person::MENTOR).first.people.first
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

  student = Organization.first.roles.where(group: Person::STUDENT).first.people.first
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

  student = Organization.first.roles.where(group: Person::STUDENT).first.people.second
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
  student = Organization.first.roles.where(group: Person::STUDENT).first.people.third
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

  student = Organization.first.roles.where(group: Person::STUDENT).first.people.fourth
  student.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('pilot - studenten 5x per week'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobjs = student.protocol_subscriptions.first.responses
  responseobjs[0...4].each do |response|
    response.update_attributes!(
      open_from: (1.day.ago - 10.minutes),
      completed_at: 1.day.ago,
      invited_state: Response::SENT_STATE
    )
  end
  responseobj = responseobjs.fifth
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "student 5x per week questionnaire - Bijna in streak -: #{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"

end

puts 'Seeds loaded!'

