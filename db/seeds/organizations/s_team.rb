organization_name = 'Het S-Team'
teams = ['Het Nordwin College Niveau 1-2',
         'Het Nordwin College Niveau 3-4',
         'Het ROC FRIESE POORT' ]

puts "Running seeds for organization #{organization_name}"
organization = Organization.find_by_name(organization_name)
organization ||= Organization.create!(name: organization_name)

teams.each do |team|
  puts "- adding #{team} to #{organization_name}"
  current_team = Team.find_by_name(team)
  current_team.update_attributes!(organization: organization)
end
