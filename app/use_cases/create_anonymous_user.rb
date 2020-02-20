# frozen_string_literal: true

class CreateAnonymousUser < ActiveInteraction::Base
  string :auth0_id_string
  string :team_name, default: nil
  string :role_title, default: nil
  string :access_level
  string :email, default: nil

  # Creates an anonymous user
  #
  # Params:
  # - auth0_id_string: the id retrieved from auth0
  def execute
    auth_user = create_or_find_auth_user(auth0_id_string, access_level)
    auth_user = create_or_find_person(auth_user, email)
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

  def create_or_find_person(auth_user, email_address)
    return auth_user if auth_user.person.present?

    if email_address.present?
      person = Person.find_by(email: email_address)
      if person.present? && person.auth_user.blank?
        ActiveRecord::Base.transaction do
          person.update!(auth_user: auth_user, email: nil, role: find_role,
                         account_active: Rails.application.config.settings.account_active_default)
          auth_user.person = person
          auth_user.save!
        end
        return auth_user
      end
    end

    create_new_person(auth_user)
  end

  def create_new_person(auth_user)
    auth_user.create_person!(first_name: auth_user.auth0_id_string,
                             last_name: auth_user.auth0_id_string,
                             gender: nil,
                             mobile_phone: nil,
                             role: find_role,
                             account_active: Rails.application.config.settings.account_active_default)
    auth_user
  end

  def find_role
    team = find_team

    role = team.roles.first
    if role_title.present?
      role = team.roles.find_by(title: role_title)
      return rerr("Specified role '#{role_title}' not found in team #{team_name}") if role.blank?

    end
    return rerr("Team '#{team_name}' has no roles") if role.blank?

    role
  end

  def find_team
    return rerr('Required payload attribute team not specified') if team_name.blank?

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
