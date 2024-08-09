# frozen_string_literal: true

module ApplicationHelper
  def student_mentor_class
    return '' if @use_mentor_layout.nil?
    return 'mentor' if @use_mentor_layout

    'student'
  end

  def current_user
    return @current_user if @current_user.present?

    @current_user ||= current_user_from_request_path
    @current_user ||= current_user_from_header
    @current_user ||= JwtAuthenticator.auth_from_params(cookies.signed, params)
    @current_user ||= TokenAuthenticator.auth(cookies.signed, params)
    @current_user ||= JwtAuthenticator.auth_from_cookies(cookies.signed)
    @current_user
  end

  def store_verification_cookie
    cookie = { ApplicationController::TEST_COOKIE => ApplicationController::TEST_COOKIE_ENTRY }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
  end

  def store_person_cookie(identifier)
    cookie = { TokenAuthenticationController::PERSON_ID_COOKIE => identifier }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
    # Remove the JWTAuthenticator cookie if set, so we log out any other sessions on this browser.
    CookieJar.delete_cookie(cookies.signed, TokenAuthenticationController::JWT_TOKEN_COOKIE)
    store_verification_cookie
  end

  def logo_image
    return nil if Rails.application.config.settings.hide_logo
    return Rails.application.config.settings.logo.fallback_logo if @use_mentor_layout.nil?

    mentor_or_student_logo
  end

  # renders a resource (eg json file) or rendes an error of there are errors in the resource
  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource.errors)
    end
  end

  # Method to render validation errors in a consistent way
  # @param resource_errors the errors to render
  def validation_error(resource_errors)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource_errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end

  # Method to render access denied errors in a consistent way
  # @param resource_errors the errors to render
  def access_denied(resource_errors)
    render json: {
      errors: [
        {
          status: '403',
          title: 'Access Denied',
          detail: resource_errors,
          code: '100'
        }
      ]
    }, status: :forbidden
  end

  # Method to render not found errors in a consistent way
  # @param resource_errors the errors to render
  def not_found(resource_errors)
    render json: {
      errors: [
        {
          status: '404',
          title: 'Not Found',
          detail: resource_errors,
          code: '100'
        }
      ]
    }, status: :not_found
  end

  # Method to render created status in a consistent way
  def created(instance = nil)
    render json: {
      result: [
        {
          status: '201',
          title: 'created',
          detail: 'resource created',
          code: '100',
          instance: ActiveModelSerializers::SerializableResource.new(instance)
        }
      ]
    }, status: :created
  end

  # Method to render destroyed status in a consistent way
  def destroyed
    render json: {
      result: [
        {
          status: '200',
          title: 'destroyed',
          detail: 'resource destroyed',
          code: '100'
        }
      ]
    }, status: :ok
  end

  # Method to render unprocessable entity errors in a consistent way
  # @param resource_errors the errors to render
  def unprocessable_entity(resource_errors)
    render json: {
      errors: [
        {
          status: '422',
          title: 'unprocessable',
          detail: resource_errors,
          code: '100'
        }
      ]
    }, status: :unprocessable_entity
  end

  # Method to render no content in a consistent way
  def no_content
    head :no_content
  end

  private

  def current_user_from_header
    # current_auth_user is not defined if the including class does not
    # include Knock::Authenticable. Hence we need to check if it is
    # actually defined.
    # @note We need to call this function first, and then fail. We cannot just
    #   check if it is defined, as it is generated automatically.
    current_auth_user&.person
  rescue NameError => _e
    # We don't need to let Appsignal know because this will happen every time we call current_user
    # from a non-api route that doesn't log the user in automatically. Because the current_auth_user
    # stuff is only defined for API routes. However, we only want to use a single current_user method
    # for both API and non-API routes, hence we have to catch this error here and do nothing with it.
    nil
  rescue OpenSSL::PKey::RSAError => e
    # Do notify appsignal if we get a weird OpenSSL error.
    Appsignal.set_error(e)
    nil
  end

  # Allow a user to log in as a person if they know the uuid of an opened response.
  def current_user_from_request_path
    # Since this potentially has security implications, make it a feature toggle. Defaults to false.
    return nil unless Rails.application.config.settings.feature_toggles.allow_response_uuid_login

    # Works on both the questionnaire and the questionnaire/preference urls
    # uuid_match[1] is the uuid part, because the (?:) prevents the preference part
    # from introducing a backref.
    uuid_match = %r{\A/questionnaire/(?:preference/)?([a-z0-9-]+)/?\z}.match(request&.path)
    return nil unless uuid_match.present?

    # The response must be opened and cannot be completed already
    # (this is so that once a response has been completed, that link cannot
    # be used to log in for that same user again)
    response = Response.opened.find_by(uuid: uuid_match[1])
    return nil unless response.present?

    # Store cookie for next time
    store_person_cookie(response.person.external_identifier)
    response.person
  end

  def mentor_or_student_logo
    return Rails.application.config.settings.logo.mentor_logo if @use_mentor_layout

    Rails.application.config.settings.logo.student_logo
  end
end
