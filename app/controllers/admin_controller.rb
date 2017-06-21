# frozen_string_literal: true

class AdminController < ApplicationController
  include AdminHelper
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD']
  before_action :set_questionnaire, only: %i[data_export questionnaire_export]

  def index; end

  def data_export
    Rails.logger.warn "[Attention] Questionnaire data was exported by: #{current_user.email}"
    file_headers!(params[:id])
    streaming_headers!
    response.status = 200
    self.response_body = Exporters::DataExporter.export_lines(params[:id])
  end

  def person_export
    export_class('people', 'Person', PersonExporter)
  end

  def protocol_subscription_export
    export_class('protocol_subscriptions', 'ProtocolSubscription', ProtocolSubscriptionExporter)
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
    self.response_body = exporting_class.send(:export_lines, args)
  end

  def set_questionnaire
    @questionnaire = Questionnaire.find_by_name(params[:id])
    return if @questionnaire.present?
    render(404, plain: 'Questionnaire with that name not found.')
  end
end
