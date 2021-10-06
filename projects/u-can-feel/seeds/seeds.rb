# frozen_string_literal: true

if Person.all.select { |person| person.auth_user.blank? }.count == 0 && (Rails.env.development? || Rails.env.staging?)
  demo_organization = 'UCF'
  demo_team = 'UCF'
  normal_role_title = 'School1'

  organization = Organization.find_by(name: demo_organization)
  team = organization.teams.find_by(name: demo_team)
  normal_role = team.roles.where(title: normal_role_title).first

  Person.create!(first_name: 'Janie',
                 last_name: 'Fictieva',
                 gender: 'female',
                 email: 'test@default.com',
                 role: normal_role)

  # Create diary study protocol instance
  protocol = Protocol.find_by(name: 'diary_study')
  person = Team.find_by(name: demo_team).roles.where(title: normal_role_title).first.people.first
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now
  )

  invitation_set = InvitationSet.create!(person: person)

  # Test out the first diary study response
  [prot_sub.responses.first].each do |responseobj|
    responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  end

  invitation_token = invitation_set.invitation_tokens.create!
  puts "Diary study protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"

  # Create cohort study protocol instance
  protocol = Protocol.find_by(name: 'cohort_study')
  person = Team.find_by(name: demo_team).roles.where(title: normal_role_title).first.people.first
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now
  )

  invitation_set = InvitationSet.create!(person: person)

  # Test out all questionnaires
  prot_sub.responses.each do |responseobj|
    responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  end

  invitation_token = invitation_set.invitation_tokens.create!
  puts "Cohort study protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"
end
