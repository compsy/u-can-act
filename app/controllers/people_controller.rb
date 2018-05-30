# frozen_string_literal: true

class PeopleController < ApplicationController
  include Concerns::IsLoggedIn
  before_action :set_current_person
  before_action :set_layout

  def edit; end

  def update
    if @person.update_attributes(person_params)
      redirect_to klaar_path, flash: { notice: 'Profile geüpdatet' }
    else
      render :edit
    end
  end

  private

  def set_layout
    @use_mentor_layout = @person.mentor?
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name, :email, :gender, :mobile_phone)
  end

  def set_current_person
    @person = current_user
  end
end
