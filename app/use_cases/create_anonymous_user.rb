# frozen_string_literal: true

class CreateAnonymousUser < ActiveInteraction::Base
  string :team_name, default: nil
  # Creates an anonymous user
  #
  # Params:
  # - team_name: the name of the team to create the person with
  def execute
    Person.create!(first_name: 'Anonymous',
                   last_name: '',
                   gender: nil,
                   role: find_role)
  end

  private

  def find_role
    team = Team.find_by_name(team_name)
    role = team&.roles&.first
    return role if role.present?

    raise "Team #{team_name} not found or does not have roles!"
  end
end
