# frozen_string_literal: true

class AdminController < ApplicationController
  include AdminHelper
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD']

  def index
  end

  def data_export
    head 404 and return unless params[:id] && QuestionnaireInformation.find_by_quby_key(params[:id])
    Rails.logger.warn "[Attention] Questionnaire data was exported by: #{current_user.email}"
    file_headers!(params[:id])
    streaming_headers!
    response.status = 200
    self.response_body = Exporters::DataExporter.export_lines(params[:id])
  end

  def person_export
    export_class('person_export', 'Person', PersonExporter)
  end

  def protocol_subscription_export
    export_class('protocol_subscription_export', 'ProtocolSubscription', ProtocolSubscriptionExporter)
  end

  private

  def export_class(filename, data_type_string, exporting_class)
    Rails.logger.warn "[Attention] #{data_type_string} data was exported by: #{request.ip}"
    filename = filename + '_' + date_string
    file_headers!(filename)
    streaming_headers!
    response.status = 200
    self.response_body = exporting_class.send(:export_lines)
  end
end
