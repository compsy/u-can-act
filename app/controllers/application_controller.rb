# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery prepend: true, with: :exception, except: :options

  def options
    head :ok
  end
end
