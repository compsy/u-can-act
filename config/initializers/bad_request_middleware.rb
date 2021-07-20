require_relative '../../app/middleware/bad_request_error'

Rails.application.config.middleware.use BadRequestError
