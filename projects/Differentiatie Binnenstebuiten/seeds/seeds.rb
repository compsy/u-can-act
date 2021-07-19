# frozen_string_literal: true

# These seeds need to be loaded first, and in order.
%w[questionnaires protocols organizations teams].each do |seed_directory|
  Dir[File.join(File.dirname(__FILE__), seed_directory, '**', '*.rb')].each do |file|
    require file
  end
end

if Person.all.select{|person| person.auth_user.blank?}.count == 0 && (Rails.env.development? || Rails.env.staging?)

  team_name = 'Differentiatie Binnenstebuiten'

  def generate_phone
    "06#{rand(10**8).to_s.rjust(8, '0')}"
  end
  puts 'Generating people - Started'

  organization = Organization.find_by(name: team_name)
  team = organization.teams.find_by(name: team_name)
  team ||= Team.create!(name: team_name, organization: organization)

  docenten_title = 'Docenten'
  docent = team.roles.where(title: docenten_title).first
  docent ||= team.roles.create!(group: Person::STUDENT, title: docenten_title)

  scholieren_title = 'Scholieren'
  scholier = team.roles.where(title: scholieren_title).first
  scholier ||= team.roles.create!(group: Person::STUDENT, title: scholieren_title)

  scholier = team.roles.where(title: scholieren_title).first

  students = [
    { first_name: 'Differentiatie', last_name: 'Student',             gender: 'female', role: scholier },
    { first_name: 'Differentiatie', last_name: 'Student IC',             gender: 'female', role: scholier },
    { first_name: 'Differentiatie', last_name: 'Docent',              gender: nil,      role: docent },
    { first_name: 'Differentiatie', last_name: 'Docent vorige vraag', gender: nil,      role: docent },
    { first_name: 'Differentiatie', last_name: 'Docent vorige vraag maar leeg', gender: nil,      role: docent }
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

  # Differentiatie person
  person = Team.find_by(name: team_name).roles.where(group: Person::STUDENT, title: scholieren_title)
               .first
               .people
               .where(first_name: 'Differentiatie', last_name: 'Student').first

  person.protocol_subscriptions.create(
    protocol: Protocol.find_by(name: 'differentiatie_studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )
  responseobj = person.protocol_subscriptions.first.responses.first

  invitation_set = InvitationSet.create!(person: person)
  responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "differentiatie student meting: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Differentiatie person
  person = Team.find_by(name: team_name).roles.where(group: Person::STUDENT, title: scholieren_title)
               .first
               .people
               .where(first_name: 'Differentiatie', last_name: 'Student IC').first

  person.protocol_subscriptions.create(
    protocol: Protocol.find_by(name: 'differentiatie_studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobj = person.protocol_subscriptions.first.responses.first

  invitation_set = InvitationSet.create!(person: person)
  responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "differentiatie student meting IC: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Differentiatie person bijna klaar
  person = Team.find_by(name: team_name).roles.where(group: Person::STUDENT, title: scholieren_title)
               .first
               .people
               .where(first_name: 'Differentiatie', last_name: 'Student').first

  person.protocol_subscriptions.create(
    protocol: Protocol.find_by(name: 'differentiatie_studenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: 34.weeks.ago.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )
  responseobj = person.protocol_subscriptions.first.responses.last

  invitation_set = InvitationSet.create!(person: person)
  responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "differentiatie student meting laatste: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  puts ''

  # Differentiatie docent
  person = Team.find_by(name: team_name).roles.where(group: Person::STUDENT, title: docenten_title)
               .first
               .people
               .where(first_name: 'Differentiatie', last_name: 'Docent').first
  person.protocol_subscriptions.create(
    protocol: Protocol.find_by(name: 'differentiatie_docenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )
  responseobj = person.protocol_subscriptions.first.responses.first
  invitation_set = InvitationSet.create!(person: person)
  responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "differentiatie 1e docent meting: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Differentiatie docent met responses
  person = Team.find_by(name: team_name).roles.where(group: Person::STUDENT, title: docenten_title)
               .first
               .people
               .where(first_name: 'Differentiatie', last_name: 'Docent vorige vraag').first
  person.protocol_subscriptions.create(
    protocol: Protocol.find_by(name: 'differentiatie_docenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: 2.weeks.ago.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )

  responseobj = person.protocol_subscriptions.first.responses.first
  response_content = ResponseContent.create_with_scores!(content: {v14: 'Ik ga bezig met begrijpend lezen.' },
                                                         response: responseobj)
  responseobj.content = response_content.id
  responseobj.complete!
  responseobj.save

  responseobj = person.protocol_subscriptions.first.responses.second
  invitation_set = InvitationSet.create!(person: person)
  responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "differentiatie docent meting met eerdere vragenlijst: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Differentiatie docent met responses maar leeg
  person = Team.find_by(name: team_name).roles.where(group: Person::STUDENT, title: docenten_title)
               .first
               .people
               .where(first_name: 'Differentiatie', last_name: 'Docent vorige vraag maar leeg').first
  person.protocol_subscriptions.create(
    protocol: Protocol.find_by(name: 'differentiatie_docenten'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: 2.weeks.ago.beginning_of_week,
    informed_consent_given_at: 10.minutes.ago
  )

  responseobj = person.protocol_subscriptions.first.responses.first
  response_content = ResponseContent.create_with_scores!(content: {},
                                                         response: responseobj)
  responseobj.content = response_content.id
  responseobj.complete!
  responseobj.save

  responseobj = person.protocol_subscriptions.first.responses.second
  invitation_set = InvitationSet.create!(person: person)
  responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  invitation_token = invitation_set.invitation_tokens.create!
  puts "differentiatie docent meting met eerdere vragenlijst maar geen antwoord: #{invitation_set.invitation_url(invitation_token.token_plain)}"
end
