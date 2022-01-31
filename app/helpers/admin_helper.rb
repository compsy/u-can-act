# frozen_string_literal: true

module AdminHelper
  include ActionView::Helpers::NumberHelper
  def file_headers!(name)
    file_name = "#{name}.csv"
    headers['Content-Type'] = 'text/csv'
    headers['Content-Disposition'] = "attachment; filename=\"#{file_name}\""
  end

  def streaming_headers!
    # nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'
    headers['Cache-Control'] ||= 'no-cache'
    # The Last-Modified header is required for streaming, see https://github.com/rack/rack/issues/1619
    response.headers['Last-Modified'] = Time.now.httpdate
    headers.delete('Content-Length')
  end

  def date_string
    Time.zone.now.to_date.to_s
  end

  def idify(*strs)
    strs.map { |x| x.to_s.parameterize.underscore }.join('_')
  end

  def questionnaire_select_options(questionnaires)
    result = [['Select a questionnaire...', '']]
    questionnaires.each do |questionnaire|
      result << [questionnaire.name, questionnaire.name]
    end
    result
  end

  def print_as_money(amount)
    number_to_currency(amount, locale: :nl)
  end
end
