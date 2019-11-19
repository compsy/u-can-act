# frozen_string_literal: true

class CreateAnonymousUser < ActiveInteraction::Base
  string :auth0_id_string
  string :team_name, default: nil
  string :role_title, default: nil
  string :access_level

  # Creates an anonymous user
  #
  # Params:
  # - auth0_id_string: the id retrieved from auth0
  def execute
    auth_user = create_or_find_auth_user(auth0_id_string, access_level)
    auth_user = create_or_find_person(auth_user)
    auth_user
  end

  private

  def create_or_find_auth_user(auth0_id_string, access_level)
    auth_user = AuthUser.find_by(auth0_id_string: auth0_id_string)
    return auth_user if auth_user.present?

    AuthUser.create!(
      auth0_id_string: auth0_id_string,
      password_digest: SecureRandom.hex(10),
      access_level: access_level
    )
  end

  def create_or_find_person(auth_user)
    return auth_user if auth_user.person.present?

    auth_user.person = Person.create!(first_name: auth_user.auth0_id_string,
                                      last_name: auth_user.auth0_id_string,
                                      gender: nil,
                                      mobile_phone: nil,
                                      role: find_role,
                                      auth_user: auth_user)
    auth_user.save!
    auth_user
  end

  def find_role
    team = find_team

    role = team.roles.first
    if role_title
      role = team.roles.find_by(title: role_title)
      return rerr("Specified role '#{role_title}' not found in team #{team_name}") if role.blank?

    end
    return rerr("Team #{team_name} has no roles") if role.blank?

    role
  end

  def find_team
    return rerr('Required payload attribute team not specified') unless team_name

    team = Team.find_by(name: team_name)
    return rerr("Team #{team_name} not found ") if team.blank?

    team
  end

  def rerr(msg)
    # Note the somewhat duplicate logging here. This is because the jwt package catches
    # our errors and only shows that authentication is unauthorized (which is hard to debug).
    Rails.logger.error(msg)
    raise(message)
  end
end
