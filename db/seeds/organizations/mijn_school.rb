organization_name = 'Mijn school'
titles = ['PRO', 'Stagebegeleider']

puts "Running seeds for #{organization_name}"
organization = Organization.find_by_name(organization_name)
organization ||= Organization.create!(name: organization_name)

student = organization.roles.where(group: Person::STUDENT).first
student ||= organization.roles.create!(group: Person::STUDENT, title: 'Student')

titles.each do |title|
  entry = organization.roles.where(group: Person::MENTOR, title: title).first
  entry ||= organization.roles.create!(group: Person::MENTOR, title: title)
end
