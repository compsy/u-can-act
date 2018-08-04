# frozen_string_literal: true

class CreateAnonymousUser < ActiveInteraction::Base
  string :auth0_id_string
  string :team_name, default: nil

  # Creates an anonymous user
  #
  # Params:
  # - auth0_id_string: the id retrieved from auth0
  def execute
    auth_user = create_or_find_auth_user(auth0_id_string)
    auth_user = create_or_find_person(auth_user)
    Rails.logger.info auth_user
    auth_user
  end

  private

  def create_or_find_auth_user(auth0_id_string)
    auth_user = AuthUser.find_by_auth0_id_string(auth0_id_string)
    return auth_user if auth_user.present?
    AuthUser.create(
      auth0_id_string: auth0_id_string,
      password_digest: SecureRandom.hex(10)
    )
  end

  def create_or_find_person(auth_user)
    return auth_user if auth_user.person.present?
    team = Team.find_by_name(team_name)
    return auth_user unless team
    auth_user.person = Person.create(first_name: auth_user.auth0_id_string,
                                     last_name: auth_user.auth0_id_string,
                                     gender: nil,
                                     mobile_phone: generate_fake_phonenumber,
                                     role: team.roles.first,
                                     auth_user: auth_user)
    auth_user
  end

  def generate_fake_phonenumber
    "06#{Array.new(8) { rand(10) }.join}"
  end
end
