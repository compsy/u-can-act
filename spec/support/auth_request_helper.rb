# frozen_string_literal: true

module AuthRequestHelper
  # Based on https://gist.github.com/mattconnolly/4158961
  #
  # pass the @env along with your request, eg:
  #
  # GET '/labels', {}, @env
  #
  def basic_auth(name, password)
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(name, password)
  end

  def http_auth_as(username, password, &block)
    @env ||= {}
    old_auth = @env['HTTP_AUTHORIZATION']
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    yield block
    @env['HTTP_AUTHORIZATION'] = old_auth
  end

  def auth_get(url, params = {}, env = {})
    get url, params: params, env: @env.merge(env)
  end

  def auth_post(url, params = {}, env = {})
    post url, params: params, env: @env.merge(env)
  end

  def auth_put(url, params = {}, env = {})
    put url, params: params, env: @env.merge(env)
  end

  def auth_patch(url, params = {}, env = {})
    patch url, params: params, env: @env.merge(env)
  end

  def auth_delete(url, params = {}, env = {})
    delete url, params: params, env: @env.merge(env)
  end
end
