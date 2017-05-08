# frozen_string_literal: true

if Person.count == 0 && (Rails.env.development? || Rails.env.staging?)
  puts 'Generating people - Started'
  Student.create(first_name: 'Stu', last_name: 'Dent', mobile_phone: '0611111111')
  puts 'Generating people - Finished'
end
