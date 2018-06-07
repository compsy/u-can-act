# frozen_string_literal: true

class AuthUser < ApplicationRecord
  has_secure_password
  validates :auth0_id_string, presence: true, uniqueness: true
  belongs_to :person
  AUTH0_KEY_LOCATION = 'sub'

  def self.from_token_payload(payload)
    Rails.logger.info '!' * 100
    Rails.logger.info payload
    id = payload[AUTH0_KEY_LOCATION]
    raise "Invalid payload #{payload}" unless payload.key?(AUTH0_KEY_LOCATION)
    obj = find_by_auth0_id_string(id)

    # TODO: Actually use the correct person parameters here! and make the used team name more generic.

    Rails.logger.info 'preMAKING USER!!!!!!!!!!!!!!!!!!!!'
    if obj.blank?
      obj = create(
        auth0_id_string: id,
        password_digest: SecureRandom.hex(10)
      )
      Rails.logger.info 'MAKING USER!!!!!!!!!!!!!!!!!!!!'
      team_name = 'KCT'
      team = Team.find_by_name(team_name)
      nr = "06#{8.times.map { rand(10) }.join}"
      obj.person = Person.create(first_name: id,
                                 last_name: id,
                                 gender: 'male',
                                 mobile_phone: nr,
                                 role: team.roles.first,
                                 auth_user: obj)
    end

    Rails.logger.info 'preMAKING PROTSUB!!!!!!!!!!!!!!!!!!!!!!!!'
    if obj.person.protocol_subscriptions.blank?
      Rails.logger.info 'MAKING PROTSUB!!!!!!!!!!!!!!!!!!!!!!!!'

      protocol = Protocol.find_by_name('mentoren voormeting/nameting')
      prot_sub = ProtocolSubscription.create(
        protocol: protocol,
        person: obj.person,
        state: ProtocolSubscription::ACTIVE_STATE,
        start_date: Time.zone.now.beginning_of_week
      )
    end
    obj
  end
end
