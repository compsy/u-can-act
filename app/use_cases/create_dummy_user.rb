# frozen_string_literal: true

class CreateDummyUser < ActiveInteraction::Base
  string :team_name
  string :role_title
  string :role_group
  string :email
  string :first_name
  string :last_name, default: 'Test'
  string :auth0_id_string
  string :protocol_name

  # Creates a dummy person and associated auth_user, or reuses those if they already exist.
  # It is a dummy user because we subscribe it to a protocol and fill out a response for each
  # questionnaire (measurement) in that protocol. The goal is to have an easy way to view
  # results pages.
  # Only use this for dummy accounts, because we destroy all protocol subscriptions of the
  # user if they already exist.
  #
  # Params:
  # - team_name: the name of the team to create the person with
  # - role_title: title of a role within thie given team
  # - role_group: Should be a value in {Role::GROUPS}, e.g., Person::STUDENT, Person::MENTOR, etc.
  # - email: e-mail address of the person. Any existing person with this email address is destroyed unless
  #          their auth_user is the one with the given auth0_id_string.
  # - first_name: First name for the dummy person
  # - last_name: Optional. defaults to 'Test'
  # - auth0_id_string: auth0 id string of the auth_user of the person. If an AuthUser with this auth0_id_string exists,
  #                    that auth_user object is reused.
  # - protocol_name: the name of a protocol to subscribe the user to and to fill out
  def execute
    determine_team
    determine_role
    determine_protocol
    seed_person
    seed_auth_user
    seed_protocol_subscription
    seed_responses
    @person
  end

  private

  def determine_team
    @team = Team.find_by(name: team_name)
    raise "Team '#{team_name}' not found" unless @team.present?
  end

  def determine_role
    @role = @team.roles.where(group: role_group, title: role_title).first
    raise "Role with group '#{role_group}' and title '#{role_title}' not found" unless @role.present?
  end

  def determine_protocol
    @protocol = Protocol.find_by(name: protocol_name)
    raise "Protocol '#{protocol_name}' not found" unless @protocol.present?
  end

  def seed_person
    initialize_auth_user
    @person = nil
    @person = @auth_user.person if @auth_user.present?
    Person.find_by(email: email)&.destroy unless @person.present?
    @person ||= Person.new
    @person.email = email
    @person.first_name = first_name
    @person.last_name = last_name
    @person.role = @role
    @person.account_active = true
    @person.save!
  end

  def initialize_auth_user
    @auth_user = AuthUser.find_by(auth0_id_string: auth0_id_string)
  end

  def seed_auth_user
    @auth_user ||= @person.auth_user
    @auth_user ||= @person.build_auth_user(password_digest: SecureRandom.hex(10))
    @auth_user.person_id = @person.id
    @auth_user.access_level = AuthUser::USER_ACCESS_LEVEL
    @auth_user.auth0_id_string = auth0_id_string
    @auth_user.save!
  end

  def seed_protocol_subscription
    @person.protocol_subscriptions.destroy_all
    @protocol_subscription = ProtocolSubscription.create!(
      protocol: @protocol,
      person: @person,
      start_date: 1.hour.ago,
      informed_consent_given_at: Time.zone.now,
      state: ProtocolSubscription::ACTIVE_STATE
    )
  end

  def seed_responses
    @protocol.measurements.each do |measurement|
      questionnaire = measurement.questionnaire
      random_response_content = RandomResponseGenerator.generate(questionnaire.content)
      response = Response.create!(measurement: measurement, protocol_subscription: @protocol_subscription,
                                  open_from: 5.minutes.ago, opened_at: 3.minutes.ago)
      response_content = ResponseContent.create_with_scores!(content: random_response_content, response: response)
      response.update!(content: response_content.id.to_s)
      response.complete!
    end
  end
end
