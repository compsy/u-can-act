# frozen_string_literal: true

if Rails.env.development? || Rails.env.staging?
  OneTimeResponse.destroy_all
  puts 'Questionnaire demo links:'
  puts ''

  Dir[Rails.root.join('projects',
                      'ikia',
                      'seeds',
                      'questionnaires',
                      '**',
                      '*.rb')].map { |x| File.basename(x, '.rb') }.each do |questionnaire_key|
    questionnaire = Questionnaire.find_by(key: questionnaire_key)
    next unless questionnaire

    # Create the protocol for the questionnaire

    pr_name = questionnaire_key
    boek_protocol = Protocol.find_by_name(pr_name)
    boek_protocol ||= Protocol.new(name: pr_name)
    boek_protocol.duration = 1.day

    boek_protocol.save!

    boek_id = questionnaire.id
    boek_measurement = boek_protocol.measurements.find_by(questionnaire_id: boek_id)
    boek_measurement ||= boek_protocol.measurements.build(questionnaire_id: boek_id)
    boek_measurement.open_from_offset = 0 # open right away
    boek_measurement.period = nil # one-off and not repeated
    boek_measurement.open_duration = nil # always open
    boek_measurement.reward_points = 0
    boek_measurement.stop_measurement = true # unsubscribe immediately
    boek_measurement.should_invite = false # don't send invitations
    boek_measurement.redirect_url = '/klaar' # after filling out questionnaire, go to person edit page.
    boek_measurement.save!

    # Create one time response
    protocol = Protocol.find_by_name(pr_name)
    token = questionnaire_key
    OneTimeResponse.create!(token: token, protocol: protocol)
    puts "#{Rails.application.routes.url_helpers.one_time_response_url(q: token)}"
  end
  puts ''

  # Create dummy users with responses
  def create_dummy!(role_title:, role_group:, email:, first_name:, auth0_id_string:, protocol_name:)
    puts "Creating #{first_name} dummy..."
    team = Team.find_by(name: 'IKIA')
    role = team.roles.where(group: role_group, title: role_title).first

    auth_user = AuthUser.find_by(auth0_id_string: auth0_id_string)
    person = nil
    person = auth_user.person if auth_user.present?
    Person.find_by(email: email)&.destroy unless person.present?
    person ||= Person.new
    person.email = email
    person.first_name = first_name
    person.last_name = 'Test'
    person.role = role
    person.account_active = true
    person.save!

    auth_user ||= person.auth_user
    auth_user ||= person.build_auth_user(password_digest: SecureRandom.hex(10))
    auth_user.person_id = person.id
    auth_user.access_level = AuthUser::USER_ACCESS_LEVEL
    auth_user.auth0_id_string = auth0_id_string
    auth_user.save!

    # create responses
    protocol = Protocol.find_by(name: protocol_name)
    person.protocol_subscriptions.destroy_all
    protsub = ProtocolSubscription.create!(protocol: protocol, person: person,
                                           start_date: 1.hour.ago, informed_consent_given_at: Time.zone.now,
                                           state: ProtocolSubscription::ACTIVE_STATE)
    protocol.measurements.each do |measurement|
      questionnaire = measurement.questionnaire
      random_response_content = RandomResponseGenerator.generate(questionnaire.content)
      response = Response.create!(measurement: measurement, protocol_subscription: protsub,
                                  open_from: 5.minutes.ago, opened_at: 3.minutes.ago)
      response_content = ResponseContent.create_with_scores!(content: random_response_content, response: response)
      response.update!(content: response_content.id.to_s)
      response.complete!
    end
  end

  create_dummy!(
    role_title: 'kids',
    role_group: Person::STUDENT,
    email: 'ikia-child@compsy.nl',
    first_name: 'Child',
    auth0_id_string: 'auth0|5e555e6737de640d5dd40873',
    protocol_name: 'kids'
  )
  create_dummy!(
    role_title: 'teens',
    role_group: Person::STUDENT,
    email: 'ikia-teen@compsy.nl',
    first_name: 'Teen',
    auth0_id_string: 'auth0|5e5564fe37de640d5dd4119c',
    protocol_name: 'teens'
  )
  create_dummy!(
    role_title: 'youngadults',
    role_group: Person::STUDENT,
    email: 'ikia-youngadult@compsy.nl',
    first_name: 'Youngadult',
    auth0_id_string: 'auth0|5e570d590767ca173c72d7b1',
    protocol_name: 'youngadults'
  )
  create_dummy!(
    role_title: 'parents',
    role_group: Person::MENTOR,
    email: 'ikia-parent@compsy.nl',
    first_name: 'Parent',
    auth0_id_string: 'auth0|5e5562e78f02500d6a318732',
    protocol_name: 'parents'
  )
end
