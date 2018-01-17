# frozen_string_literal: true

class StatusController < ApplicationController
  def show
    render(status: 200, plain: 'OK')
  end
end
