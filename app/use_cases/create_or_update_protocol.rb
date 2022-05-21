# frozen_string_literal: true

class CreateOrUpdateProtocol < ActiveInteraction::Base
  string :name
  integer :duration
  string :invitation_text
  string :informed_consent_questionnaire_key, default: nil

  attr_reader :protocol

  array :questionnaires do
    hash do
      string :key
      hash :measurement do
        integer :open_from_offset
        string :open_from_day, default: nil
        integer :period, default: nil
        integer :open_duration, default: nil
        integer :reminder_delay, default: nil
        integer :priority
        boolean :stop_measurement
        boolean :should_invite
        boolean :only_redirect_if_nothing_else_ready
        string :redirect_url, default: nil
        boolean :prefilled, default: false
      end
    end
  end

  array :push_subscriptions, default: nil do
    hash do
      string :name
      string :url
      string :method
    end
  end

  def execute
    ActiveRecord::Base.transaction do
      return errors.merge!(@protocol.errors) unless initialize_protocol

      unless create_measurements
        errors.merge!(@measurement.errors) if @measurement.present?
        # If we reach this point the protocol has been created but a measurement couldn't be. The user expects the
        # action to be atomic, so we must rollback the creation of the protocol and all the other measurements that
        # succeeded
        raise ActiveRecord::Rollback
      end

      unless create_push_subscriptions
        @created_push_subscriptions.each { |ps| errors.merge!(ps.errors) }
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def initialize_protocol
    @protocol = Protocol.find_by(name: name)
    @protocol ||= Protocol.new(name: name)
    @protocol.duration = duration
    @protocol.invitation_text = invitation_text

    return @protocol.save if informed_consent_questionnaire_key.blank?

    @protocol.informed_consent_questionnaire = Questionnaire.find_by(key: informed_consent_questionnaire_key)

    return @protocol.save if @protocol.informed_consent_questionnaire.present?

    errors.add :informed_consent_questionnaire_key,
               "key '#{informed_consent_questionnaire_key}' not found"
    false
  end

  def create_push_subscriptions
    # Note that if this use case was called for an existing protocol with existing push subscriptions but with an
    # empty push subscription definition, the existing push subscriptions would be deleted. This is intended, since this
    # use case is meant to create a new protocol OR update an existing one. (Consider this endpoint to be a PUT rather
    # than PATCH)
    @protocol.push_subscriptions.destroy_all

    return true if push_subscriptions.blank?

    push_subscriptions.map { |ps| create_push_subscription(ps) }.all?
  end

  def create_push_subscription(params)
    @created_push_subscriptions ||= []
    @created_push_subscriptions << @protocol.push_subscriptions.build(**params)
    @created_push_subscriptions.last.save
  end

  def create_measurements
    questionnaires.each do |questionnaire|
      return false unless process_questionnaire(params: questionnaire)
    end

    true
  end

  def process_questionnaire(params:)
    questionnaire = Questionnaire.find_by key: params[:key]

    unless questionnaire.present?
      errors.add :questionnaires, "key '#{params[:key]}' not found"
      return false
    end

    create_measurement(params: params[:measurement], questionnaire: questionnaire)
  end

  # rubocop:disable Metrics/AbcSize
  def create_measurement(params:, questionnaire:)
    @measurement = @protocol.measurements.find_by(questionnaire_id: questionnaire.id)
    @measurement ||= @protocol.measurements.build(questionnaire_id: questionnaire.id)

    @measurement.open_from_offset = params[:open_from_offset]
    @measurement.open_from_day = params[:open_from_day]
    @measurement.period = params[:period]
    @measurement.open_duration = params[:open_duration]
    @measurement.reminder_delay = params[:reminder_delay]
    @measurement.priority = params[:priority]
    @measurement.stop_measurement = params[:stop_measurement]
    @measurement.should_invite = params[:should_invite]
    @measurement.only_redirect_if_nothing_else_ready = params[:only_redirect_if_nothing_else_ready]
    @measurement.redirect_url = params[:redirect_url]
    @measurement.prefilled = params[:prefilled]

    @measurement.save
  end
  # rubocop:enable Metrics/AbcSize
end
