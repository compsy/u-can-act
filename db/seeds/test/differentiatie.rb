# frozen_string_literal: true


# Differentiatie person
person = Team.find_by_name('Default team').roles.where(group: Person::STUDENT)
              .first
              .people
              .where(first_name: 'Differentiatie', last_name: 'Student').first
person.protocol_subscriptions.create(
  protocol: Protocol.find_by_name('differentiatie_studenten'),
  state: ProtocolSubscription::ACTIVE_STATE,
  start_date: Time.zone.now.beginning_of_week,
  informed_consent_given_at: 10.minutes.ago
)
responseobj = person.protocol_subscriptions.first.responses.first
invitation_set = InvitationSet.create!(person: person)
responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
invitation_token = invitation_set.invitation_tokens.create!
puts "differentiatie meting: #{invitation_set.invitation_url(invitation_token.token_plain)}"
puts ''

# Differentiatie docent
person = Team.find_by_name('Default team').roles.where(group: Person::STUDENT)
              .first
              .people
              .where(first_name: 'Differentiatie', last_name: 'Docent').first
person.protocol_subscriptions.create(
  protocol: Protocol.find_by_name('differentiatie_docenten'),
  state: ProtocolSubscription::ACTIVE_STATE,
  start_date: Time.zone.now.beginning_of_week,
  informed_consent_given_at: 10.minutes.ago
)
responseobj = person.protocol_subscriptions.first.responses.first
invitation_set = InvitationSet.create!(person: person)
responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
invitation_token = invitation_set.invitation_tokens.create!
puts "differentiatie 1e docent meting: #{invitation_set.invitation_url(invitation_token.token_plain)}"

# Differentiatie docent met responses
person = Team.find_by_name('Default team').roles.where(group: Person::STUDENT)
              .first
              .people
              .where(first_name: 'Differentiatie', last_name: 'Docent vorige vraag').first
person.protocol_subscriptions.create(
  protocol: Protocol.find_by_name('differentiatie_docenten'),
  state: ProtocolSubscription::ACTIVE_STATE,
  start_date: 2.weeks.ago.beginning_of_week,
  informed_consent_given_at: 10.minutes.ago
)

responseobj = person.protocol_subscriptions.first.responses.first
response_content = ResponseContent.create!(content: {'v1': 'iets in de gaten houden'} )
responseobj.content = response_content.id
responseobj.save

responseobj = person.protocol_subscriptions.first.responses.second
invitation_set = InvitationSet.create!(person: person)
responseobj.update_attributes!(open_from: 1.minute.ago, invitation_set: invitation_set)
invitation_token = invitation_set.invitation_tokens.create!
puts "differentiatie docent meting met eerdere vragenlijst: #{invitation_set.invitation_url(invitation_token.token_plain)}"
