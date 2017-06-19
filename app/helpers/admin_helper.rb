# frozen_string_literal: true

module AdminHelper
  def file_headers!(name)
    file_name = "#{name}.csv"
    headers['Content-Type'] = 'text/csv'
    headers['Content-disposition'] = "attachment; filename=\"#{file_name}\""
  end

  def streaming_headers!
    # nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'
    headers['Cache-Control'] ||= 'no-cache'
    headers.delete('Content-Length')
  end

  def date_string
    Time.zone.now.to_date.to_s
  end
end
