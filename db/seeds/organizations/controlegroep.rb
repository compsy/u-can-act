organization_name = 'Controlegroep'

puts "Running seeds for #{organization_name}"
organization = Organization.find_by_name(organization_name)
organization ||= Organization.create!(name: organization_name)

student = organization.roles.where(group: Person::STUDENT).first
student ||= organization.roles.create!(group: Person::STUDENT, title: Person::STUDENT)
