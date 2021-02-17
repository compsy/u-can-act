# frozen_string_literal: true

class PeopleController < ApplicationController
  include ::IsLoggedIn
  before_action :set_current_person
  before_action :set_layout

  def edit; end

  def update
    if @person.update(people_params)
      redirect_to NextPageFinder.get_next_page(current_user: current_user), flash: { notice: 'Gegevens opgeslagen.' }
    else
      render :edit
    end
  end

  def unsubscribe
    Rails.logger.warn "[Attention] Stopping all protocol subscriptions for person #{@person.id}."
    @person.active_protocol_subscriptions_with_stop_responses_first.each do |protocol_subscription|
      stop_response = protocol_subscription.stop_response
      if stop_response.blank? || stop_response.completed?
        protocol_subscription.cancel!
      else
        redirect_to NextPageFinder.get_next_page current_user: current_user,
                                                 next_response: stop_response,
                                                 params: { callback_url: '/person/unsubscribe' }
        break
      end
    end
    unsubscribed
  end

  private

  def set_layout
    @use_mentor_layout = @person.mentor? || @person.solo?
  end

  def people_params
    base_params = params.require(:person).permit(:first_name, :last_name, :email, :gender, :mobile_phone, :iban)
    return base_params if cannot? :update, Person, :ip_hash

    base_params.merge(ip_hash: calculate_ip_hash)
  end

  def calculate_ip_hash
    HashGenerator.generate(request.remote_ip, salt: ENV.fetch('IP_HASH_SALT'))
  end

  def set_current_person
    @person = current_user
  end

  def unsubscribed
    return if performed?

    flash[:notice] = unsubscribe_notice
    redirect_to NextPageFinder.get_next_page current_user: current_user
  end

  def unsubscribe_notice
    return 'Bedankt voor het invullen van de vragenlijst!' if @person.role.group == Person::SOLO

    "Je hebt je uitgeschreven voor het #{Rails.application.config.settings.application_name} onderzoek."\
      ' Bedankt voor je inzet!'
  end
end
