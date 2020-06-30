role_titles = ['Docenten', 'Scholieren']


teams = []
# 11 is a special protocol
special_team = 11
(1..14).map do |team_id|
  next if team_id == special_team
  teams << "#{team_id}"
end

['a','b'].each { |sub_id| teams << "#{special_team}#{sub_id}" }

organization_name = 'Differentiatie Binnenstebuiten'
organization = Organization.find_by(name: organization_name)

teams.each do |team_name|
  puts "Running seeds for #{team_name}"
  team = Team.find_by(name: team_name)
  team ||= Team.create!(name: team_name, organization: organization)
  team.update_attributes!(organization: organization)

  role_titles.each do |title|
    entry = team.roles.where(group: Person::STUDENT, title: title).first
    entry ||= team.roles.create!(group: Person::STUDENT, title: title)
  end
end
