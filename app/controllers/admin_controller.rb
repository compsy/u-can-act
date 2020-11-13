# frozen_string_literal: true

class AdminController < ApplicationController
  include AdminHelper
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD']
  before_action :set_questionnaire, only: %i[response_export questionnaire_export preview]
  before_action :set_locale, only: %i[preview]
  before_action :set_questionnaire_content, only: %i[preview]
  before_action :load_questionnaires, only: %i[export preview_overview]

  def preview
    # TODO: Add a migration to read the layout from the questionnaire database model.
    @use_mentor_layout = @questionnaire.name.match?(/mentor|evaluatieonderzoek|telefonische interviews/)
  end

  def preview_done
    redirect_to '/admin/preview_overview'
  end

  def preview_overview; end

  def export; end

  def response_export
    questionnaire_filename = idify('responses', @questionnaire.name)
    export_class(questionnaire_filename, 'Questionnaire responses', ResponseExporter, @questionnaire.name)
  end

  def person_export
    export_class('people', 'Person', PersonExporter)
  end

  def identifier_export
    unless Rails.application.config.settings.feature_toggles.allow_identifier_export
      raise 'Exporting identifiers is currently not allowed.'
    end

    export_class('identifiers', 'Person', IdentifierExporter)
  end

  def reward_export
    export_class('rewards', 'Person', RewardExporter)
  end

  def proof_of_participation_export
    export_class('participation', 'ProtocolSubscription', ProofOfParticipationExporter)
  end

  def protocol_subscription_export
    export_class('protocol_subscriptions', 'ProtocolSubscription', ProtocolSubscriptionExporter)
  end

  def invitation_set_export
    export_class('invitation_sets', 'InvitationSet', InvitationSetExporter)
  end

  def protocol_transfer_export
    export_class('protocol_transfers', 'ProtocolTransfer', ProtocolTransferExporter)
  end

  def questionnaire_export
    questionnaire_filename = idify('questionnaire', @questionnaire.name)
    export_class(questionnaire_filename, 'Questionnaire definition', QuestionnaireExporter, @questionnaire.name)
  end

  private

  def export_class(filename, data_type_string, exporting_class, *args)
    Rails.logger.warn "[Attention] #{data_type_string} data was exported by: #{request.ip}"
    filename = "#{filename}_#{date_string}"
    file_headers!(filename)
    streaming_headers!
    response.status = 200
    self.response_body = exporting_class.send(:export_lines, *args)
  end

  def set_questionnaire
    @questionnaire = Questionnaire.find_by(name: questionnaire_params[:id])
    return if @questionnaire.present?

    render(status: :not_found, html: 'Questionnaire with that name not found.', layout: 'application')
  end

  def set_locale
    @locale = questionnaire_params[:locale]
    return if @locale.present? && Rails.application.config.i18n.available_locales.map(&:to_s).include?(@locale)

    render(status: :bad_request, html: 'Invalid locale or no locale specified.', layout: 'application')
  end

  def set_questionnaire_content
    @content = QuestionnaireGenerator.new.generate_questionnaire(
      response_id: nil,
      content: @questionnaire.content,
      title: @questionnaire.title,
      submit_text: (@locale == 'en' ? 'Save' : 'Opslaan'),
      action: '/admin/preview_done',
      unsubscribe_url: nil,
      locale: @locale,
      params: { authenticity_token: form_authenticity_token(form_options: { action: '/admin/preview_done',
                                                                            method: 'post' }) }
    )
  end

  def load_questionnaires
    # exclude pilot study questionnaires
    @pilot_questionnaires = Questionnaire.pilot
    @normal_questionnaires = Questionnaire.all - @pilot_questionnaires
  end

  def questionnaire_params
    params.permit(:id, :locale)
  end
end
