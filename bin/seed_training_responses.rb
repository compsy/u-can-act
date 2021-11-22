# frozen_string_literal: true

def find_or_create_person(email)

  demo_organization = 'sport-data-valley'
  demo_team = 'sdv-team'
  normal_role_title = 'normal'

  organization = Organization.find_by(name: demo_organization)
  team = organization.teams.find_by(name: demo_team)
  normal_role = team.roles.where(title: normal_role_title).first

  person = Person.find_by(email: email)
  person ||= Person.new(email: email)

  person.first_name = 'Voornaam'
  person.last_name = 'Achternaam'
  person.role = normal_role
  person.account_active = true

  person.save!
  person
end

def training_type(idx)
  types = %w[voetballen MTB hardlopen kracht]
  i = idx % types.count
  types[i]
end

def session_type(idx)
  types = ['ext uithoudingsvermogen',
    'ext interval',
    'fartlek',
    'general fitness',
    'int uithoudingsvermogen',
    'int interval',
    'int tempo',
    'anders',
    'race',
    'herstel',
  ]
  i = idx % types.count
  types[i]
end

def rpe_score(idx)
  scores = (1..9).map(&:to_s)
  i = idx % scores.count
  scores[i]
end

def satisfaction(idx)
  scores = %w[2 2.5 3 3.5 3.5 4 4.5 5]
  i = idx % scores.count
  scores[i]
end

def duration(idx)
  durations = %w[30 45 60 120]
  i = idx % durations.count
  durations[i]
end

def time_of_start(date, idx)
  offsets = [7, 14, 18, 20]
  i = idx % offsets.count
  date.beginning_of_day + offsets[i].hours
end

def date_format(time_with_zone)
  time_with_zone.strftime('%F')
end

def hour_format(time_with_zone)
  time_with_zone.strftime('%H').to_i.to_s
end

def minute_format(time_with_zone)
  time_with_zone.strftime('%M').to_i.to_s
end

def create_training_log_response(person, idx, timestamp)
  protocol_name = 'training_log'
  puts "Creating responses for #{protocol_name}"
  protocol = Protocol.find_by(name: protocol_name)
  raise "Error: protocol named #{protocol_name} not found" unless protocol

  protsub = ProtocolSubscription.find_by(person: person, protocol: protocol)
  protsub ||= ProtocolSubscription.new(person: person, protocol: protocol)

  protsub.state = ProtocolSubscription::COMPLETED_STATE
  protsub.start_date = Time.new(2016).in_time_zone
  protsub.end_date = Time.new(2017).in_time_zone
  protsub.save!

  questionnaire_name = protocol_name
  questionnaire_id = Questionnaire.find_by(name: questionnaire_name).id
  measurement = protocol.measurements.where(questionnaire_id: questionnaire_id).first

  protsub_id = protsub.id
  measurement_id = measurement.id
  filled_out_by_id = protsub.person.id
  filled_out_for_id = protsub.filling_out_for.id

  Response.where(protocol_subscription_id: protsub_id, measurement_id: measurement_id).each do |response|
    ResponseContent.find(response.content).destroy if response.content.present?
    response.destroy
  end

  response_params = {}
  response_params[:protocol_subscription_id] = protsub_id
  response_params[:measurement_id] = measurement_id
  response_params[:filled_out_by_id] = filled_out_by_id
  response_params[:filled_out_for_id] = filled_out_for_id

  response_params[:open_from] = timestamp - 1.minute
  response_params[:opened_at] = timestamp
  response_params[:completed_at] = timestamp + 1.minute

  content = {}
  content[:v1] = training_type(idx)
  content[:v2] = session_type(idx)

  starting_at = time_of_start(timestamp, idx)
  content[:v3] = date_format(starting_at)
  content[:v4_uren] = hour_format(starting_at)
  content[:v4_minuten] = minute_format(starting_at)

  content[:v5] = duration(idx)
  content[:v6] = rpe_score(idx)
  content[:v7] = satisfaction(idx)
  content[:v8] = 'a comment'

  response_content = ResponseContent.create_with_scores!(
    content: content,
    response: Response.new(measurement_id: response_params[:measurement_id])
  )
  response_params[:content] = response_content.id

  PushSubscriptionsJob.perform_later(Response.create!(response_params))
end

(1..100).each do |idx|
  email = "questionnaire_participant_#{idx}@researchable.nl"
  person = find_or_create_person(email)

  n_days = ((Time.zone.now - 2.months.ago)/1.day).floor
  (1..n_days).each do |days|
    date = days.days.ago.beginning_of_day + 20.hours
    create_training_log_response(person, idx, date)
  end
end
