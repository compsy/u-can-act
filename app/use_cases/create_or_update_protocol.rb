# frozen_string_literal: true

class CreateOrUpdateProtocol < ActiveInteraction::Base
  string :name
  integer :duration
  string :invitation_text
  string :informed_consent_questionnaire_key, default: nil
  string :language_questionnaire_key, default: nil

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

    return false unless add_special_questionnaire(
      :informed_consent_questionnaire_key,
      informed_consent_questionnaire_key,
      'informed_consent_questionnaire'
    )

    return false unless add_special_questionnaire(
      :language_questionnaire_key,
      language_questionnaire_key,
      'language_questionnaire'
    )

    @protocol.save
  end

  def create_push_subscriptions
    return true if push_subscriptions.blank?

    push_subscriptions.map { |ps| create_push_subscription(ps) }.all?
  end

  def create_push_subscription(params)
    @created_push_subscriptions ||= []
    @created_push_subscriptions << @protocol.push_subscriptions.build(**params)
    @created_push_subscriptions.last.save
  end

  def add_special_questionnaire(key_name, key_value, attr_name)
    return true if key_value.blank?

    questionnaire = Questionnaire.find_by key: key_value

    if questionnaire.present?
      @protocol.send("#{attr_name}=", questionnaire)
      return true
    end

    errors.add key_name, "key '#{key_value}' not found"
    false
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
