# frozen_string_literal: true

class DaysGenerator < QuestionTypeGenerator
  # This is the date format that the user filling out the questionnaire will see.
  # It can be overridden with the `date_format` option in the question.
  DATE_FORMAT = '%A %e %B'

  # These are the date formats sent to the backend. They are always the same, no matter
  # the locale of the user filling out the questionnaire. For ease of parsing, they are
  # in the year-month-date format. If there are separate morning and afternoon checkboxes
  # (i.e., the question option `morning_and_afternoon` is set to true), then the
  # date formats sent to the backend are postfixed by either AM or PM.
  DATE_FORMAT_BACKEND = '%Y-%m-%d'
  DATE_FORMAT_BACKEND_AM = '%Y-%m-%d AM'
  DATE_FORMAT_BACKEND_PM = '%Y-%m-%d PM'

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    checkbox_group = safe_join([
                                 tag.p(title, class: 'flow-text'),
                                 answer_options(question)
                               ])
    tag.div(checkbox_group, class: checkbox_group_klasses(question))
  end

  private

  def checkbox_group_klasses(question)
    klasses = 'checkbox-group'
    klasses += ' required' if question[:required].present?
    klasses
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/MethodLength
  def answer_options(question)
    body = []
    today = question[:include_today].present? ? 0 : 1
    from_days_ago = question[:from_days_ago]
    date_format = question[:date_format].presence || DATE_FORMAT
    from_days_ago.downto(today) do |days_ago|
      date = days_ago.days.ago
      next if [6, 0].include?(date.wday) && question[:exclude_weekends].present?

      formatted_date = I18n.l(date, locale: question[:locale], format: date_format)
      option = {
        title: formatted_date,
        value: I18n.l(date, locale: :en, format: DATE_FORMAT_BACKEND)
      }
      option[:shows_questions] = question[:shows_questions] if question[:shows_questions].present?
      option[:hides_questions] = question[:hides_questions] if question[:hides_questions].present?
      if question[:morning_and_afternoon]
        option[:title] = "#{formatted_date} #{I18n.t('time.am', locale: question[:locale])}"
        option[:value] = I18n.l(date, locale: :en, format: DATE_FORMAT_BACKEND_AM)
      end
      body << days_option_body(question, option.merge(raw: option.deep_dup))
      next unless question[:morning_and_afternoon]

      new_option = option.merge(title: "#{formatted_date} #{I18n.t('time.pm', locale: question[:locale])}",
                                value: I18n.l(date, locale: :en, format: DATE_FORMAT_BACKEND_PM))
      body << days_option_body(question, new_option.merge(raw: new_option.deep_dup))
    end
    safe_join(body)
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/MethodLength

  def question_options(elem_id)
    {
      type: 'checkbox',
      id: elem_id,
      name: answer_name(elem_id),
      value: true
    }
  end

  def days_option_body(question, option)
    elem_id = idify(question[:id], option[:raw][:value].presence || option[:raw][:title])
    tag_options = question_options(elem_id)
    tag_options = add_shows_hides_questions(tag_options, option[:shows_questions], option[:hides_questions])
    option_body = tag.input(tag_options)

    safe_join(
      [
        decorate_with_label(question, option_body, option)
      ]
    )
  end
end
