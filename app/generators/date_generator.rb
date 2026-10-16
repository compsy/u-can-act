# frozen_string_literal: true

class DateGenerator < QuestionTypeGenerator
  DATEFIELD_PLACEHOLDER = { nl: 'Vul een datum in', en: 'Fill out a date', fi: 'Valitse päivämäärä' }.freeze

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([tag.p(title, class: 'flow-text'), mydate_field(question)])
  end

  private

  def mydate_field(question)
    body = safe_join([
                       mydate_tag(question),
                       mydate_label(question)
                     ])
    body = tag.div(body, class: 'input-field col s12 m6')
    tag.div(body, class: 'row')
  end

  def mydate_tag(question)
    tag.input(type: 'text',
              id: idify(question[:id]),
              name: answer_name(question[:id]),
              required: question[:required].present?,
              class: 'datepicker',
              data: mydate_data(question))
  end

  def mydate_data(question)
    data = { min: question[:min], max: question[:max], 'set-default-date': false, locale: question[:locale] }
    if question[:today].present?
      data[:'default-date'] = Time.zone.today
      data[:'set-default-date'] = true
    end
    if question[:default_date].present?
      data[:'default-date'] = Date.parse(question[:default_date])
      data[:'set-default-date'] = false
    end
    data
  end

  def mydate_label(question)
    locale = (question[:locale].presence || Rails.application.config.i18n.default_locale).to_sym
    tag.label(placeholder(question, DATEFIELD_PLACEHOLDER.fetch(locale, DATEFIELD_PLACEHOLDER[:en])),
              for: idify(question[:id]),
              class: 'flow-text')
  end
end
