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