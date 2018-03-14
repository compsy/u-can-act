# frozen_string_literal: true

if Person.count == 0 && (Rails.env.development? || Rails.env.staging?)
  def generate_phone
    "06#{rand(10 ** 8).to_s.rjust(8,'0')}"
  end
  puts 'Generating people - Started'

  students =[
    { first_name: 'Jan', last_name: 'Jansen', gender: 'male' },
    { first_name: 'Klaziena', last_name: 'Kramer', gender: 'female' },
    { first_name: 'Erika', last_name: 'de Boer', gender: 'female' },
    { first_name: 'Eric', last_name: 'de Vries', gender: 'male' },
    { first_name: 'Henk', last_name: 'Veenstra', gender: 'male' },
    { first_name: 'Bert', last_name: 'Huizinga', gender: nil }
  ]
  organization = Organization.find_or_create_by(name: 'Default organization')
  team = organization.teams.find_or_create_by(name: 'Default team')

  student = team.roles.where(group: Person::STUDENT).first
  student ||= team.roles.create!(group: Person::STUDENT, title: 'student')

  mentor = team.roles.where(group: Person::MENTOR).first
  mentor ||= team.roles.create!(group: Person::MENTOR, title: 'mentor')

  students.each do |student_hash|
    phone = generate_phone
    while Person.find_by_mobile_phone(phone).present?
      phone = generate_phone
    end
    Person.create!(first_name: student_hash[:first_name],
                   last_name: student_hash[:last_name],
                   gender: student_hash[:gender],
                   mobile_phone: phone, role: student)
  end

  mentors =[
    { first_name: 'Koos', last_name: 'Barendrecht', gender: 'male', email: 'koos_barendrecht@example.com' },
    { first_name: 'Anna', last_name: 'Groen', gender: 'female', email: 'anna_groen@example.com' },
    { first_name: 'Men', last_name: 'Tor', gender: nil, email: 'men_tor@example.com' }
  ]

  mentors.each do |mentor_hash|
    phone = generate_phone
    while Person.find_by_mobile_phone(phone).present?
      phone = generate_phone
    end
    Person.create!(first_name: mentor_hash[:first_name],
                   last_name: mentor_hash[:last_name],
                   gender: mentor_hash[:gender],
                   email: mentor_hash[:email],
                   mobile_phone: phone, role: mentor)
  end

  puts 'Generating people - Finished'
end
