# frozen_string_literal: true

class DateAndTimeGenerator < QuestionTypeGenerator
  include React::Rails::ViewHelper
  DATETIMEFIELD_PLACEHOLDER = { nl: 'Vul een datum en tijd in', en: 'Fill out a date and time' }.freeze

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([tag.p(title, class: 'flow-text'), mydate_and_time_field(question)])
  end

  private

  def mydate_and_time_field(question)
    body = mydate_and_time_tag(question)
    body = tag.div(body, class: 'col s12 m6')
    tag.div(body, class: 'row')
  end

  # rubocop:disable Metrics/AbcSize
  def mydate_and_time_tag(question)
    locale = (question[:locale].presence || Rails.application.config.i18n.default_locale).to_sym
    react_component(
      'DateAndTimePicker',
      id: idify(question[:id]),
      name: answer_name(question[:id]),
      hours_name: answer_name(question[:hours_id]),
      minutes_name: answer_name(question[:minutes_id]),
      required: question[:required].present?,
      today: question[:today].present?,
      default_date: question[:default_date].present?,
      placeholder: placeholder(question, DATETIMEFIELD_PLACEHOLDER[locale]),
      min: question[:min],
      max: question[:max],
      locale: question[:locale]
    )
  end
  # rubocop:enable Metrics/AbcSize
end
