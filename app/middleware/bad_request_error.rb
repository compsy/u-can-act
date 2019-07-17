# frozen_string_literal: true

class BadRequestError
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionDispatch::Http::Parameters::ParseError
    Api::V1::ApiController.action(:raise_bad_request).call(env)
  end
end
