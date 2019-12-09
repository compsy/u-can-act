# frozen_string_literal: true

class UpdateChildPerson < ActiveInteraction::Base
  object :person
  string :email, default: nil
  string :first_name
  string :role

  # Updates a child person
  def execute
    unless person.update(email: email,
                         first_name: first_name,
                         role: find_role)
      errors.merge!(person.errors)
    end
    person
  end

  private

  def find_role
    team = find_team

    role_obj = team.roles.find_by(title: role)
    return rerr("Specified role '#{role}' not found in team #{team.name}") if role_obj.blank?

    role_obj
  end

  def find_team
    team = person.role.team
    return rerr('Team not found') if team.blank?

    team
  end

  def rerr(msg)
    # Note the somewhat duplicate logging here. This is because the jwt package catches
    # our errors and only shows that authentication is unauthorized (which is hard to debug).
    errors.add(:person, msg)
    Rails.logger.error(msg)
    raise(msg)
  end
end
