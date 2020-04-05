# frozen_string_literal: true

module ApplicationHelper
  def student_mentor_class
    return '' if @use_mentor_layout.nil?
    return 'mentor' if @use_mentor_layout

    'student'
  end

  def current_user
    return @current_user if @current_user.present?

    @current_user ||= current_user_from_header
    @current_user ||= JwtAuthenticator.auth_from_params(cookies.signed, params)
    @current_user ||= TokenAuthenticator.auth(cookies.signed, params)
    @current_user ||= JwtAuthenticator.auth_from_cookies(cookies.signed)
    @current_user
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
    render json: {
      result: [
        {
          status: '204',
          title: 'no content',
          detail: 'no content provided',
          code: '100'
        }
      ]
    }, status: :no_content
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
    nil
  end

  def mentor_or_student_logo
    return Rails.application.config.settings.logo.mentor_logo if @use_mentor_layout

    Rails.application.config.settings.logo.student_logo
  end
end
