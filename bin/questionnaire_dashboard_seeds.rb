# frozen_string_literal: true

require 'csv'

demo_organization = 'sport-data-valley'
demo_team = 'sdv-team'
normal_role_title = 'normal'

organization = Organization.find_by_name(demo_organization)
team = organization.teams.find_by_name(demo_team)
normal_role = team.roles.where(title: normal_role_title).first

person = Person.find_by(email: $person_email)
person ||= Person.new(email: $person_email)

person.first_name = 'Voornaam'
person.last_name = 'Achternaam'
person.role = normal_role
person.account_active = true

person.save!

def convert_training_type(training_type)
  case training_type
  when 'Football'
    'voetballen'
  when 'MTB'
    'MTB'
  when 'Running'
    'hardlopen'
  when 'Strength'
    'kracht'
  else
    raise "unknown training type: #{training_type}"
  end
end

def convert_session_type(session_type)
  case session_type
  when 'Ext endurance'
    'ext uithoudingsvermogen'
  when 'Ext interval'
    'ext interval'
  when 'Fartlek'
    'fartlek'
  when 'General fitness'
    'general fitness'
  when 'Int endurance'
    'int uithoudingsvermogen'
  when 'Int interval'
    'int interval'
  when 'Int tempo'
    'int tempo'
  when 'Other'
    'anders'
  when 'Race'
    'race'
  when 'Recovery'
    'herstel'
  else
    raise "unknown session type: #{session_type}"
  end
end

def convert_rpe_score(rpe_score)
  case rpe_score
  when '1. Really easy'
    '1'
  when '2', '2. Easy'
    '2'
  when '3. Moderate'
    '3'
  when '4. Sort of hard'
    '4'
  when '5. Hard'
    '5'
  when '6'
    '6'
  when '7. Really hard'
    '7'
  when '8'
    '8'
  when '9. Really, really hard'
    '9'
  else
    raise "unknown rpe score: #{rpe_score}"
  end
end

def convert_satisfaction(satisfaction)
  case satisfaction
  when '2. Unsatisfied'
    '2'
  when '2,5'
    '2.5'
  when '3. Normal'
    '3'
  when '3,5'
    '3.5'
  when '4. Satisfied'
    '4'
  when '4,5'
    '4.5'
  when '5. Totally satisfied'
    '5'
  else
    raise "unknown satisfaction: #{satisfaction}"
  end
end

def convert_comments(comments)
  return '' if comments.blank?

  comments
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

def create_responses(protocol_name, person, file_name)
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
  questionnaire_id = Questionnaire.find_by_name(questionnaire_name).id
  measurement = protocol.measurements.where(questionnaire_id: questionnaire_id).first

  protsub_id = protsub.id
  measurement_id = measurement.id
  filled_out_by_id = protsub.person.id
  filled_out_for_id = protsub.filling_out_for.id

  Response.where(protocol_subscription_id: protsub_id, measurement_id: measurement_id).each do |response|
    ResponseContent.find(response.content).destroy if response.content.present?
    response.destroy
  end

  data = CSV.parse(File.read(file_name, encoding: 'bom|utf-8'), headers: true, col_sep: ';')
  data.each do |row|
    response_params = {}
    response_params[:protocol_subscription_id] = protsub_id
    response_params[:measurement_id] = measurement_id
    response_params[:filled_out_by_id] = filled_out_by_id
    response_params[:filled_out_for_id] = filled_out_for_id

    timestamp = Time.zone.strptime(row['Timestamp'], '%m-%d-%Y %H:%M:%S')
    response_params[:open_from] = timestamp
    response_params[:opened_at] = timestamp
    response_params[:completed_at] = timestamp

    content = {}
    content[:v1] = convert_training_type(row['Training type'])
    content[:v2] = convert_session_type(row['Session type'])

    starting_at = Time.zone.strptime(row['Starting at'], '%m-%d-%Y %H:%M:%S')
    content[:v3] = date_format(starting_at)
    content[:v4_uren] = hour_format(starting_at)
    content[:v4_minuten] = minute_format(starting_at)

    content[:v5] = row['Duration (min)']
    content[:v6] = convert_rpe_score(row['RPE score'])
    content[:v7] = convert_satisfaction(row['Training satisfaction'])
    content[:v8] = convert_comments(row['Comments'])

    response_content = ResponseContent.create!(content: content)
    response_params[:content] = response_content.id

    PushSubscriptionsJob.perform_later(Response.create!(response_params))
  end
end

create_responses('training_log', person, Rails.root.join('spec/fixtures/training_log.csv'))
# create_responses('daily_protocol', person, File.join(curdir, 'questionnaire_dashboard/daily_protocol.csv'))
