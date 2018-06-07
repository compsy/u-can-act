# frozen_string_literal: true

module ApplicationHelper
  def student_mentor_class
    return '' if @use_mentor_layout.nil?
    return 'mentor' if @use_mentor_layout
    'student'
  end

  def current_user
    return @current_user if @current_user.present?
    token_auth || jwt_auth
    @current_user
  end

  def token_auth
    person_external_identifier = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::PERSON_ID_COOKIE)
    @current_user = Person.find_by_external_identifier(person_external_identifier)
  end

  def jwt_auth
    begin
      token = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::JWT_TOKEN_COOKIE)
      token ||= JWT.decode(params[:auth], nil, false)
      auth_user = AuthUser.find_by_auth0_id_string(token.first["sub"])
      @current_user = auth_user.person if auth_user.present?

      cookie = { TokenAuthenticationController::JWT_TOKEN_COOKIE => token }
      CookieJar.set_or_update_cookie(cookies.signed, cookie)

    # Rescue if the argument passed is not a JWT token
    rescue JWT::DecodeError => e
      Rails.logger.info e.message
    end
  end

  def logo_image
    return 'U_can_act_logo_ZWART.png' if @use_mentor_layout.nil?
    @use_mentor_layout ? 'U_can_act_logo_CMYK_BLAUW.png' : 'U_can_act_logo_CMYK_GROEN.png'
  end
end
