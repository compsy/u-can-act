# frozen_string_literal: true

class DateRangeGenerator < QuestionTypeGenerator
  include React::Rails::ViewHelper
  DATEFIELD_PLACEHOLDER = { nl: 'Vul een datum in', en: 'Fill out a date' }.freeze

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([tag.p(title, class: 'flow-text'), mydate_field(question)])
  end

  private

  def mydate_field(question)
    body = mydate_tag(question)
    body = tag.div(body, class: 'col s12 m6')
    tag.div(body, class: 'row')
  end

  def mydate_tag(question)
    locale = (question[:locale].presence || Rails.application.config.i18n.default_locale).to_sym
    react_component(
      'DatePicker',
      id: idify(question[:id]),
      name: answer_name(question[:id]),
      required: question[:required].present?,
      placeholder: placeholder(question, DATEFIELD_PLACEHOLDER[locale]),
      min: question[:min],
      max: question[:max]
    )
  end
end
