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

  student = organization.roles.where(group: Person::STUDENT).first
  student ||= organization.roles.create(group: Person::STUDENT, title: 'student')

  mentor = organization.roles.where(group: Person::MENTOR).first
  mentor ||= organization.roles.create(group: Person::MENTOR, title: 'mentor')
  
  students.each do |student_hash|
    phone = generate_phone
    while Person.find_by_mobile_phone(phone).present?
      phone = generate_phone
    end
    Person.create!(first_name: student_hash[:first_name],
                    last_name: student_hash[:last_name],
                    mobile_phone: phone, role: student)
  end

  mentors =[
    { first_name: 'Men', last_name: 'Tor' },
    { first_name: 'Jan', last_name: 'Jansen' }
  ]

  mentors.each do |mentor_hash|
    phone = generate_phone
    while Person.find_by_mobile_phone(phone).present?
      phone = generate_phone
    end
    Person.create!(first_name: mentor_hash[:first_name],
                   last_name: mentor_hash[:last_name],
                   mobile_phone: phone, role: mentor)
  end

  puts 'Generating people - Finished'
end
