# frozen_string_literal: true

class InvitationMailer < ApplicationMailer
  helper ApplicationHelper

  layout 'mailer'

  default from: ENV.fetch('FROM_EMAIL_ADDRESS', nil)

  def invitation_mail(email_address, message, invitation_url, template, locale, open_from_date)
    @invitation_url = invitation_url
    @message = message
    # Use the default template if the given template does not exist.
    template = 'invitation_mailer/invitation_mail' if lookup_context.find_all(template, []).blank?
    mail(subject: default_invitation_subject(locale, open_from_date), to: email_address) do |format|
      format.html { render template: template }
    end
  end

  # TODO: Only used for u-can-act symposium registration. Remove when removing the u-can-act project.
  def confirmation_mail(email_address, subject, message)
    @message = message
    mail(subject: subject, to: email_address)
  end

  # TODO: Only used for the IKIA project for parents to invite children. Remove when removing the ikia project.
  def registration_mail(email_address, message, registration_url)
    @registration_url = registration_url
    @message = message
    mail(subject: Rails.application.config.settings.registration.subject_line, to: email_address)
  end

  private

  def default_invitation_subject(locale, open_from_date)
    project_name = ENV.fetch('PROJECT_NAME', nil)
    questionnaire_localized = I18n.t('questionnaires.questionnaire', locale: locale)
    date_string = open_from_date.strftime('%d-%m-%Y')
    "#{questionnaire_localized} #{project_name} #{date_string}"
  end
end
