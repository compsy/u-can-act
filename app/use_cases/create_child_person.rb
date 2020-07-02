# frozen_string_literal: true

class CreateChildPerson < ActiveInteraction::Base
  object :parent, class: :person
  string :email
  string :team_name
  string :first_name
  string :role_title

  # Registers a child person
  def execute
    Person.create!(first_name: first_name,
                   email: email,
                   gender: nil,
                   mobile_phone: nil,
                   role: find_role,
                   parent: parent)
  end

  private

  def find_role
    team = find_team

    role = team.roles.find_by(title: role_title)
    return rerr("Specified role '#{role_title}' not found in team #{team_name}") if role.blank?

    role
  end

  def find_team
    team = Team.find_by(name: team_name)
    return rerr("Team '#{team_name}' not found") if team.blank?

    team
  end

  def rerr(msg)
    # Note the somewhat duplicate logging here. This is because the jwt package catches
    # our errors and only shows that authentication is unauthorized (which is hard to debug).
    Rails.logger.error(msg)
    raise(msg)
  end
end
