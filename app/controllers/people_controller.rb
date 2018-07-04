# frozen_string_literal: true

class PeopleController < ApplicationController
  include Concerns::IsLoggedIn
  before_action :set_current_person
  before_action :set_layout

  def edit; end

  def update
    if @person.update_attributes(person_params)
      redirect_to NextPageFinder.get_next_page(current_user: current_user), flash: { notice: 'Gegevens geüpdatet' }
    else
      render :edit
    end
  end

  def unsubscribe
    Rails.logger.warn "[Attention] Stopping all protocol subscriptions for person #{@person.id}."
    # TODO: order prot subs by has measurement id or whatever
    @person.protocol_subscriptions.active.each do |protocol_subscription|
      stop_response = protocol_subscription.stop_response
      if stop_response.blank?
        protocol_subscription.cancel!
      else
        redirect_to NextPageFinder.get_next_page current_user: current_user,
                                                 next_response: stop_response,
                                                 params: { callback_url: '/person/unsubscribe' }
        break
      end
    end
    return if performed?
    flash[:notice] = 'Je hebt je uitgeschreven voor het u-can-act onderzoek. Bedankt voor je inzet!'
    redirect_to NextPageFinder.get_next_page current_user: current_user
  end

  private

  def set_layout
    @use_mentor_layout = @person.mentor?
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name, :email, :gender, :mobile_phone, :iban)
  end

  def set_current_person
    @person = current_user
  end
end
