# frozen_string_literal: true

class DrawingGenerator < QuestionTypeGenerator
  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([
                content_tag(:p, title, class: 'flow-text'),
                drawing(question)
              ])
  end

  private

  def drawing(question)
    body = []
    body << drawing_container(question)
    body << drawing_buttons(question)
    content_tag(:div, safe_join(body), class: 'drawing')
  end

  def drawing_container(question)
    body = []
    body << drawing_canvas(question)
    body << drawing_log(question)
    content_tag(:div, safe_join(body), class: 'row')
  end

  def drawing_canvas(question)
    body = content_tag(:div, nil,
                       class: 'drawing-container',
                       id: idify(question[:id], 'drawing_container'),
                       data: drawing_data_attributes(question))
    content_tag(:div, body, class: 'col s12 m6')
  end

  def drawing_data_attributes(question)
    {
      width: question[:width],
      height: question[:height],
      image: drawing_data_image(question),
      color: question[:color],
      radius: question[:radius].present? ? question[:radius] : 15,
      density: question[:density].present? ? question[:density] : 40
    }
  end

  def drawing_data_image(question)
    return "/assets/#{Rails.application.assets[question[:image]].digest_path}" if
      Rails.application.assets[question[:image]].present?

    question[:image]
  end

  def drawing_log(question)
    body = content_tag(:textarea, nil,
                       class: 'drawing-log',
                       id: idify(question[:id]),
                       name: answer_name(idify(question[:id])))
    content_tag(:div, body, class: 'col s12 m6 hideme')
  end

  def drawing_buttons(question)
    body = []
    body << content_tag(:button, 'Wissen', class: 'btn waves-effect waves-light drawing-clear', id: idify(question[:id], 'clear'))
    body << content_tag(:button, 'Ok', class: 'btn drawing-ok', id: idify(question[:id], 'ok'))
    body = content_tag(:div, safe_join(body), class: 'col s12')
    content_tag(:div, body, class: 'row section')
  end
end
