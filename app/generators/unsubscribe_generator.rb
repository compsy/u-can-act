# frozen_string_literal: true

class UnsubscribeGenerator < QuestionTypeGenerator
  def generate(question)
    body = safe_join([
                       generate_unsubscribe_content(question),
                       generate_unsubscribe_action(question)
                     ])
    tag.div(body, class: 'card light-grey-background-color')
  end

  private

  def generate_unsubscribe_content(question)
    body = []
    body << tag.span(question[:title].html_safe, class: 'card-title') if question[:title].present?
    body << tag.p(question[:content].html_safe) if question[:content].present?
    body = safe_join(body)
    tag.div(body, class: 'card-content black-text')
  end

  def generate_unsubscribe_action(question)
    url_href = '#'
    url_href = question[:unsubscribe_url] if question[:unsubscribe_url]
    body = tag.a((question[:button_text] || 'Uitschrijven').html_safe,
                 'data-method': question[:data_method] || 'delete',
                 href: url_href,
                 class: 'btn waves-effect waves-light navigate-away-allowed',
                 rel: 'nofollow')
    tag.div(body, class: 'card-action')
  end
end
