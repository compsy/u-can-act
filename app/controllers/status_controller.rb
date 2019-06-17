# frozen_string_literal: true

class StatusController < ApplicationController
  def show
    render(status: :ok, plain: 'OK')
  end
end
