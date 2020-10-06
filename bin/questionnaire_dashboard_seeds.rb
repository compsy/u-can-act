# frozen_string_literal: true

require 'csv'

TIME_OFFSET = Time.zone.now.beginning_of_day - Time.zone.local(2019, 12, 13) # good one
# TIME_OFFSET = Time.zone.now.beginning_of_day - Time.zone.local(2020, 01, 24) # second set of data

demo_organization = 'sport-data-valley'
demo_team = 'sdv-team'
normal_role_title = 'normal'

organization = Organization.find_by(name: demo_organization)
team = organization.teams.find_by(name: demo_team)
normal_role = team.roles.where(title: normal_role_title).first

$person_email ||= 'demo@researchable.nl'
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

  data = CSV.parse(File.read(file_name, encoding: 'bom|utf-8'), headers: true, col_sep: ';')
  data.each do |row|
    response_params = {}
    response_params[:protocol_subscription_id] = protsub_id
    response_params[:measurement_id] = measurement_id
    response_params[:filled_out_by_id] = filled_out_by_id
    response_params[:filled_out_for_id] = filled_out_for_id

    timestamp = Time.zone.strptime(row['Timestamp'], '%m-%d-%Y %H:%M:%S') + TIME_OFFSET
    response_params[:open_from] = timestamp
    response_params[:opened_at] = timestamp
    response_params[:completed_at] = timestamp

    content = {}
    content[:v1] = convert_training_type(row['Training type'])
    content[:v2] = convert_session_type(row['Session type'])

    starting_at = Time.zone.strptime(row['Starting at'], '%m-%d-%Y %H:%M:%S') + TIME_OFFSET
    content[:v3] = date_format(starting_at)
    content[:v4_uren] = hour_format(starting_at)
    content[:v4_minuten] = minute_format(starting_at)

    content[:v5] = row['Duration (min)']
    content[:v6] = convert_rpe_score(row['RPE score'])
    content[:v7] = convert_satisfaction(row['Training satisfaction'])
    content[:v8] = convert_comments(row['Comments'])

    response_content = ResponseContent.create_with_scores!(
      content: content,
      response: Response.new(measurement_id: response_params[:measurement_id])
    )
    response_params[:content] = response_content.id

    PushSubscriptionsJob.perform_later(Response.create!(response_params))
  end
end

def convert_day(day)
  case day
  when 'Monday'
    'maandag'
  when 'Tuesday'
    'dinsdag'
  when 'Wednesday'
    'woensdag'
  when 'Thursday'
    'donderdag'
  when 'Friday'
    'vrijdag'
  when 'Saturday'
    'zaterdag'
  when 'Sunday'
    'zondag'
  else
    raise "unknown day: #{day}"
  end
end

def convert_sleep_quality(sleep_quality)
  case sleep_quality
  when '1,5'
    '1.5'
  when '2.   Restless sleep'
    '2'
  when '2,5'
    '2.5'
  when '3.   Difficulty falling asleep'
    '3'
  when '3,5'
    '3.5'
  when '4.   Good'
    '4'
  when '4,5'
    '4.5'
  when '5.   Very restful'
    '5'
  else
    raise "unknown sleep quality: #{sleep_quality}"
  end
end

def convert_sleep_duration_hours(sleep_duration)
  case sleep_duration
  when '4,25', '4,8'
    '4'
  when '5', '5,25', '5,5', '5,75', '5,8'
    '5'
  when '6', '6,1', '6,25', '6,5', '6,75', '6,8'
    '6'
  when '7', '7,1', '7,25', '7,3', '7,5', '7,7', '7,75'
    '7'
  when '8', '8,5'
    '8'
  when '9', '9,5', '9,75'
    '9'
  when '10'
    '10'
  else
    raise "unknown sleep duration hours: #{sleep_duration}"
  end
end

def convert_sleep_duration_minutes(sleep_duration)
  case sleep_duration
  when '5', '6', '6,1', '7', '7,1', '8', '9', '10'
    '0'
  when '4,25', '5,25', '6,25', '7,25', '7,3'
    '15'
  when '5,5', '6,5', '7,5', '8,5', '9,5'
    '30'
  when '5,75', '4,8', '5,8', '6,75', '6,8', '7,7', '7,75', '9,75'
    '45'
  else
    raise "unknown sleep duration hours: #{sleep_duration}"
  end
end

def convert_scale_value(value)
  return '' if value.blank?
  value.sub(/(\A[^.]*)\..*\z/,'\1').sub(',','.')
end

def convert_yes_no(value)
  return '' if value.blank?
  case value
  when 'Yes'
    'ja'
  when 'No'
    'nee'
  else
    raise "unknown yes no value: #{value}"
  end
end

def convert_numerical_radio_blessures(value)
  return '' if value.blank?
  case value
  when '0. Full participation without health problems'
    '0. Volledige deelname zonder gezondheidsproblemen.'
  when '0,5'
    '0.5.'
  when '1. Full participation, but with injury/illness'
    '1. Volledige deelname, maar met blessure/ziekte'
  when '2. Reduced participation due to injury/illness'
    '2. Verminderde deelname door blessure/ziekte'
  else
    raise "unknown numerical radio blessures value: #{value}"
  end
end

def convert_numerical_radio_training_volume(value)
  return '' if value.blank?
  case value
  when '0. No reduction'
    '0. Geen vermindering'
  when '0,5'
    '0.5.'
  when '2. To a moderate extent'
    '2. In gemiddelde mate'
  else
    raise "unknown numerical radio training volume value: #{value}"
  end
end

def convert_numerical_radio_prestatie(value)
  return '' if value.blank?
  case value
  when '0. No reduction'
    '0. Geen vermindering'
  when '0,5'
    '0.5.'
  when '1. To a mild extent'
    '1. In geringe mate'
  else
    raise "unknown numerical radio prestatie value: #{value}"
  end
end

def convert_numerical_radio_symptoms(value)
  return '' if value.blank?
  case value
  when '0. No symptoms/health complaints'
    '0. Geen symptomen of gezondheidsklachten'
  when '0,5'
    '0.5.'
  when '1. To a mild extent'
    '1. In geringe mate'
  else
    raise "unknown numerical radio symptoms value: #{value}"
  end
end

def create_daily_responses(protocol_name, person, file_name)
  puts "Creating responses for #{protocol_name}"
  protocol = Protocol.find_by(name: protocol_name)
  raise "Error: protocol named #{protocol_name} not found" unless protocol

  protsub = ProtocolSubscription.find_by(person: person, protocol: protocol)
  protsub ||= ProtocolSubscription.new(person: person, protocol: protocol)

  protsub.state = ProtocolSubscription::COMPLETED_STATE
  protsub.start_date = Time.new(2016).in_time_zone
  protsub.end_date = Time.new(2017).in_time_zone
  protsub.save!

  protsub_id = protsub.id
  filled_out_by_id = protsub.person.id
  filled_out_for_id = protsub.filling_out_for.id

  Response.where(protocol_subscription_id: protsub_id).each do |response|
    ResponseContent.find(response.content).destroy if response.content.present?
    response.destroy
  end

  data = CSV.parse(File.read(file_name, encoding: 'bom|utf-8'), headers: true, col_sep: ';')
  data.each do |row|

    dag = convert_day(row['Day'])
    questionnaire_name = "daily_questionnaire_#{dag}"
    questionnaire_id = Questionnaire.find_by(name: questionnaire_name).id
    measurement = protocol.measurements.where(questionnaire_id: questionnaire_id).first
    measurement_id = measurement.id

    response_params = {}
    response_params[:protocol_subscription_id] = protsub_id
    response_params[:measurement_id] = measurement_id
    response_params[:filled_out_by_id] = filled_out_by_id
    response_params[:filled_out_for_id] = filled_out_for_id

    timestamp = Time.zone.strptime(row['Timestamp'], '%m-%d-%Y %H:%M:%S') + TIME_OFFSET
    response_params[:open_from] = timestamp
    response_params[:opened_at] = timestamp
    response_params[:completed_at] = timestamp

    content = {}
    date = Time.zone.strptime(row['Date'], '%m-%d-%Y %H:%M:%S') + TIME_OFFSET
    content[:date_dontuse] = date_format(date) # store this somewhere in case we need it later
    content[:v1] = convert_scale_value(row['Sleep quality'])

    content[:v2_uren] = convert_sleep_duration_hours(row['Sleep duration (hours)'])
    content[:v2_minuten] = convert_sleep_duration_minutes(row['Sleep duration (hours)'])
    content[:v2_dontuse] = row['Sleep quality'].gsub(',','.')

    content[:v3] = convert_scale_value(row['Fatigue'])
    content[:v4] = convert_scale_value(row['Stress ']) # Note the space at the end of the attribute name
    content[:v5] = convert_scale_value(row['General muscle soreness'])
    content[:v6] = convert_scale_value(row['Mood'])
    content[:v7] = convert_scale_value(row['Readiness-to-train'])
    content[:v8] = row['Resting HR (bpm)']
    content[:v9] = convert_yes_no(row['Sick?'])
    content[:v10] = convert_yes_no(row['Injured?'])
    content[:v11] = convert_comments(row['Comments'])

    response_content = ResponseContent.create_with_scores!(
      content: content,
      response: Response.new(measurement_id: response_params[:measurement_id])
    )
    response_params[:content] = response_content.id

    PushSubscriptionsJob.perform_later(Response.create!(response_params))

    if dag == 'zondag'
      questionnaire_name = "sunday_questionnaire"
      questionnaire_id = Questionnaire.find_by(name: questionnaire_name).id
      measurement = protocol.measurements.where(questionnaire_id: questionnaire_id).first
      measurement_id = measurement.id

      response_params = {}
      response_params[:protocol_subscription_id] = protsub_id
      response_params[:measurement_id] = measurement_id
      response_params[:filled_out_by_id] = filled_out_by_id
      response_params[:filled_out_for_id] = filled_out_for_id

      timestamp = Time.zone.strptime(row['Timestamp'], '%m-%d-%Y %H:%M:%S') + TIME_OFFSET
      response_params[:open_from] = timestamp
      response_params[:opened_at] = timestamp
      response_params[:completed_at] = timestamp
      content = {}
      date = Time.zone.strptime(row['Date'], '%m-%d-%Y %H:%M:%S') + TIME_OFFSET
      content[:date_dontuse] = date_format(date) # store this somewhere in case we need it later
      content[:v1] = convert_scale_value(row['Fatigue (mental)'])
      content[:v2] = convert_scale_value(row['Fatigue (physical)'])
      content[:v3] = convert_numerical_radio_blessures(row['Difficulties participating due to injury, illness or other health problems?'])
      content[:v4] = convert_numerical_radio_training_volume(row['Reduced training volume due to injury, illness or other health problems?'])
      content[:v5] = convert_numerical_radio_prestatie(row['Did injury, illness or other health problems affect your performance?'])
      content[:v6] = convert_numerical_radio_symptoms(row['Did you experience symptoms/health complaints?'])
      content[:v7] = convert_comments(row['How did you experience last week?'])

      response_content = ResponseContent.create_with_scores!(
        content: content,
        response: Response.new(measurement_id: response_params[:measurement_id])
      )
      response_params[:content] = response_content.id

      PushSubscriptionsJob.perform_later(Response.create!(response_params))
    end
  end
end

create_responses('training_log', person, Rails.root.join('spec/fixtures/training_log.csv'))
create_daily_responses('daily_protocol', person, Rails.root.join('spec/fixtures/daily_log.csv'))
