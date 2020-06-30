# frozen_string_literal: true

organization_name = 'Evaluatieonderzoek'
puts "Running seeds for organization #{organization_name}"
organization = Organization.find_by(name: organization_name)
organization ||= Organization.create!(name: organization_name)
