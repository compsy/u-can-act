# frozen_string_literal: true

if Person.count == 0 && (Rails.env.development? || Rails.env.staging?)
  def generate_phone
    "06#{rand(10 ** 8).to_s.rjust(8,'0')}"
  end
  puts 'Generating people - Started'

  students =[
    { first_name: 'Stu', last_name: 'Dent' },
    { first_name: 'Scho', last_name: 'Lier' },
    { first_name: 'Ado', last_name: 'Lecent' },
    { first_name: 'John', last_name: 'Doe' },
    { first_name: 'Jane', last_name: 'Doe' }
  ]
  organization = Organization.find_by_name('Default organization')
  organization ||= Organization.new(name: 'Default organization')

  student = organization.roles.where(group: 'Student')
  student ||= organization.roles.create(group: 'Student', title: 'student')

  mentor = organization.roles.where(group: 'Mentor')
  mentor ||= organization.roles.create(group: 'Mentor', title: 'mentor')
  
  students.each do |student|
    phone = generate_phone
    while Person.find_by_mobile_phone(phone).present?
      phone = generate_phone
    end
    Person.create!(first_name: student[:first_name],
                    last_name: student[:last_name],
                    mobile_phone: phone, role: student)
  end

  mentors =[
    { first_name: 'Men', last_name: 'Tor' },
    { first_name: 'Jan', last_name: 'Jansen' }
  ]

  mentors.each do |mentor|
    phone = generate_phone
    while Person.find_by_mobile_phone(phone).present?
      phone = generate_phone
    end
    Person.create!(first_name: mentor[:first_name],
                   last_name: mentor[:last_name],
                   mobile_phone: phone, role: mentor)
  end

  puts 'Generating people - Finished'
end
