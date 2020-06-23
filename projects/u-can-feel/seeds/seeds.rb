# frozen_string_literal: true

if Rails.env.development? || Rails.env.staging?
  OneTimeResponse.destroy_all
  puts 'Questionnaire demo links:'
  puts ''

  Dir[Rails.root.join('projects',
                      'u-can-feel',
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
end
