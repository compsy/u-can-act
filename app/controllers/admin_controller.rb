# frozen_string_literal: true

class AdminController < ApplicationController
  include AdminHelper
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD']
  before_action :set_questionnaire, only: %i[response_export questionnaire_export preview]

  def index
    # exclude pilot study questionnaires
    @used_questionnaires = Questionnaire.all.reject { |questionnaire| questionnaire.name =~ /x per week/ }
    @organization_overview = generate_organization_overview
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

  def protocol_subscription_export
    export_class('protocol_subscriptions', 'ProtocolSubscription', ProtocolSubscriptionExporter)
  end

  def questionnaire_export
    questionnaire_filename = idify('questionnaire', @questionnaire.name)
    export_class(questionnaire_filename, 'Questionnaire definition', QuestionnaireExporter, @questionnaire.name)
  end

  def generate_organization_overview
    Organization.all.map do |organization|
      organization_stats = stats_for_organization(organization)
      { name: organization.name, data: organization_stats }
    end
  end

  private

  def stats_for_organization(organization)
    organization.roles.each_with_object(Hash.new(0)) do |all_role_stats, role|
      all_role_stats[role.group] = stats_for_role(role)
    end
  end

  def stats_for_role(role)
    role.people.each_with_object(Hash.new(0)) do |all_person_stats, person|
      person_stats = stats_for_person(person)
      all_person_stats[:completed] += person_stats[:completed]
      all_person_stats[:total]     += person_stats[:total]
    end
  end

  def stats_for_person(person)
    person.protocol_subscriptions.each_with_object(Hash.new(0)) do |all_subscriptions, subscription|
      past_week = subscription.responses.in_week
      all_subscriptions[:completed] += past_week.completed.count
      all_subscriptions[:total] += past_week.count
    end
  end

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
    render(status: 404, plain: 'Questionnaire with that name not found.')
  end

  def questionnaire_params
    params.permit(:id)
  end
end
