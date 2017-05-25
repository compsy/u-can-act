# frozen_string_literal: true

if Person.count == 0 && (Rails.env.development? || Rails.env.staging?)
  puts 'Generating people - Started'

  students =[
    { first_name: 'Stu', last_name: 'Dent' },
    { first_name: 'Scho', last_name: 'Lier' },
    { first_name: 'Ado', last_name: 'Lecent' },
    { first_name: 'John', last_name: 'Doe' },
    { first_name: 'Jane', last_name: 'Doe' }
  ]
  students.each do |student|
    phone = "06#{rand(10 ** 8)}" 
    Student.create(first_name: student[:first_name],
                   last_name: student[:last_name],
                   mobile_phone: phone)
  end

  mentors =[
    { first_name: 'Men', last_name: 'Tor' },
    { first_name: 'Jan', last_name: 'Jansen' }
  ]

  mentors.each do |mentor|
    phone = "06#{rand(10 ** 8)}" 
    Mentor.create(first_name: mentor[:first_name],
                  last_name: mentor[:last_name],
                  mobile_phone: phone)
  end

  puts 'Generating people - Finished'
end

