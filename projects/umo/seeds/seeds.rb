# frozen_string_literal: true

if Person.all.select { |person| person.auth_user.blank? }.count == 0 && (Rails.env.development? || Rails.env.staging?)
  demo_organization = 'UMO'
  demo_team = 'UMO'
  normal_role_title = 'Participant'

  organization = Organization.find_by(name: demo_organization)
  team = organization.teams.find_by(name: demo_team)
  normal_role = team.roles.where(title: normal_role_title).first

  # Create weekly protocol
  Person.create!(first_name: 'Janie',
                 last_name: 'Fictieva',
                 gender: 'female',
                 mobile_phone: "06#{rand(10 ** 8).to_s.rjust(8, '0')}",
                 role: normal_role)

  # Create daily protocol instance
  protocol = Protocol.find_by(name: 'profiling')
  person = Team.find_by(name: demo_team).roles.where(title: normal_role_title).first.people.first
  prot_sub = ProtocolSubscription.create!(
    protocol: protocol,
    person: person,
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now
  )

  invitation_set = InvitationSet.create!(person: person)

  [prot_sub.responses.first, prot_sub.responses.second].each do |responseobj|
    responseobj.update!(open_from: 1.minute.ago, invitation_set: invitation_set)
  end

  invitation_token = invitation_set.invitation_tokens.create!
  puts "Profiling protocol: #{invitation_set.invitation_url(invitation_token.token_plain)}"
end
