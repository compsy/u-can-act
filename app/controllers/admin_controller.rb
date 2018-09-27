# frozen_string_literal: true

class AdminController < ApplicationController
  include AdminHelper
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD']
  before_action :set_questionnaire, only: %i[response_export questionnaire_export preview]

  def index
    # exclude pilot study questionnaires
    @used_questionnaires = Questionnaire.all - Questionnaire.pilot
  end

  def preview
    @use_mentor_layout = @questionnaire.name.match?(/mentor/)
  end

  def preview_done
    redirect_to '/admin'
  end

  def response_export
    questionnaire_filename = idify('responses', @questionnaire.name)
    export_class(questionnaire_filename, 'Questionnaire responses', ResponseExporter, @questionnaire.name)
  end

  def person_export
    export_class('people', 'Person', PersonExporter)
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
    filename = filename + '_' + date_string
    file_headers!(filename)
    streaming_headers!
    response.status = 200
    self.response_body = exporting_class.send(:export_lines, *args)
  end

  def set_questionnaire
    @questionnaire = Questionnaire.find_by_name(questionnaire_params[:id])
    return if @questionnaire.present?

    render(status: 404, html: 'Questionnaire with that name not found.', layout: 'application')
  end

  def questionnaire_params
    params.permit(:id)
  end
end
