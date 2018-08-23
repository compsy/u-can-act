# frozen_string_literal: true

class UnsubscribeGenerator < QuestionTypeGenerator
  def generate(question)
    body = safe_join([
                       generate_unsubscribe_content(question),
                       generate_unsubscribe_action(question)
                     ])
    body = content_tag(:div, body, class: 'card light-grey-background-color')
    body
  end

  private

  def generate_unsubscribe_content(question)
    body = []
    body << content_tag(:span, question[:title].html_safe, class: 'card-title') if question[:title].present?
    body << content_tag(:p, question[:content].html_safe) if question[:content].present?
    body = safe_join(body)
    body = content_tag(:div, body, class: 'card-content black-text')
    body
  end

  def generate_unsubscribe_action(question)
    url_href = '#'
    url_href = question[:unsubscribe_url] if question[:unsubscribe_url]
    body = content_tag(:a, (question[:button_text] || 'Uitschrijven').html_safe,
                       'data-method': (question[:data_method] || 'delete'),
                       href: url_href,
                       class: 'btn waves-effect waves-light navigate-away-allowed',
                       rel: 'nofollow')
    content_tag(:div, body, class: 'card-action')
  end
end
