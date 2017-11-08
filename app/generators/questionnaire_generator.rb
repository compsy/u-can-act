# frozen_string_literal: true

class QuestionnaireGenerator
  extend ActionView::Helpers
  TOOLTIP_DURATION = 6000
  OTHERWISE_TEXT = 'Anders, namelijk:'
  OTHERWISE_PLACEHOLDER = 'Vul iets in'
  TEXTAREA_PLACEHOLDER = 'Vul iets in'
  TEXTFIELD_PLACEHOLDER = 'Vul iets in'

  class << self
    def generate_questionnaire(response_id, content, title, submit_text, action, authenticity_token)
      title, content = substitute_variables(response_id, title, content)
      body = safe_join([
                         questionnaire_header(title),
                         questionnaire_hidden_fields(response_id, authenticity_token),
                         questionnaire_questions(content),
                         submit_button(submit_text)
                       ])
      body = content_tag(:form, body, action: action, class: 'col s12', 'accept-charset': 'UTF-8', method: 'post')
      body
    end

    private

    def substitute_variables(response_id, title, content)
      response = Response.find_by_id(response_id) # allow nil response id for preview
      return [title, content] if response.blank?
      student, mentor = response.determine_student_mentor
      [title, content].map do |obj|
        VariableEvaluator.evaluate_obj(obj,
                                       mentor&.role&.title,
                                       mentor&.gender,
                                       student.first_name,
                                       student.gender)
      end
    end

    def questionnaire_header(title)
      return ''.html_safe if title.blank?
      header_body = content_tag(:h4, title, class: 'header')
      header_body = content_tag(:div, header_body, class: 'col s12')
      header_body = content_tag(:div, header_body, class: 'row')
      header_body
    end

    def questionnaire_hidden_fields(response_id, authenticity_token)
      hidden_body = []
      hidden_body << tag(:input, name: 'utf8', type: 'hidden', value: '&#x2713;'.html_safe)
      hidden_body << tag(:input, name: 'authenticity_token', type: 'hidden', value: authenticity_token)
      hidden_body << tag(:input, name: 'response_id', type: 'hidden', value: response_id)
      safe_join(hidden_body)
    end

    def questionnaire_questions(content)
      body = []
      content.each do |question|
        body << single_questionnaire_question(question)
      end
      safe_join(body)
    end

    def single_questionnaire_question(question)
      question_body = create_question_body(question)
      question_body = content_tag(:div, question_body, class: 'col s12')
      questionnaire_questions_add_question_section(question_body, question)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def create_question_body(question)
      case question[:type]
      when :radio
        generate_radio(question)
      when :time
        generate_time(question)
      when :checkbox
        generate_checkbox(question)
      when :range
        generate_range(question)
      when :textarea
        generate_textarea(question)
      when :textfield
        generate_textfield(question)
      when :raw
        generate_raw(question)
      when :expandable
        generate_expandable(question)
      else
        raise "Unknown question type #{question[:type]}"
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def questionnaire_questions_add_question_section(question_body, question)
      body = []
      body << section_start(question[:section_start], question) unless question[:section_start].blank?
      body << content_tag(:div, question_body, class: question_klasses(question))
      body << section_end(question[:section_end], question) unless question[:section_end].blank?
      body
    end

    def question_klasses(question)
      klasses = 'row section'
      klasses += ' hidden' if question[:hidden].present?
      klasses += " #{idify(question[:id], 'toggle')}" if question.key?(:hidden) # hides_questions need hidden: false
      klasses
    end

    def section_start(section_title, question)
      body = content_tag(:h5, section_title)
      body = content_tag(:div, body, class: 'col s12')
      klasses = 'extra-spacing row'
      klasses += ' hidden' if question[:hidden].present?
      klasses += " #{idify(question[:id], 'toggle')}" if question.key?(:hidden) # hides_questions need hidden: false
      body = content_tag(:div, body, class: klasses)
      body
    end

    def section_end(_unused_arg, question)
      body = content_tag(:div, nil, class: 'divider')
      body = content_tag(:div, body, class: 'col s12')
      klasses = 'row'
      klasses += ' hidden' if question[:hidden].present?
      klasses += " #{idify(question[:id], 'toggle')}" if question.key?(:hidden) # hides_questions need hidden: false
      body = content_tag(:div, body, class: klasses)
      body
    end

    def submit_button(submit_text)
      submit_body = content_tag(:button,
                                submit_text,
                                type: 'submit',
                                class: 'btn waves-effect waves-light')
      submit_body = content_tag(:div, submit_body, class: 'col s12')
      submit_body = content_tag(:div, submit_body, class: 'row section')
      submit_body
    end

    def answer_name(name)
      "content[#{name}]"
    end

    def generate_radio(question)
      # TODO: Add radio button validation error message
      title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
      question[:otherwise_label] = OTHERWISE_TEXT if question[:otherwise_label].blank?
      safe_join([
                  content_tag(:p, title, class: 'flow-text'),
                  radio_options(question),
                  radio_otherwise(question)
                ])
    end

    def radio_options(question)
      body = []
      question[:options].each do |option|
        body << radio_option_body(question[:id], option)
      end
      safe_join(body)
    end

    def radio_option_body(question_id, option)
      option = { title: option } unless option.is_a?(Hash)
      elem_id = idify(question_id, option[:title])
      tag_options = {
        name: answer_name(idify(question_id)),
        type: 'radio',
        id: elem_id,
        value: option[:title],
        required: true,
        class: 'validate'
      }
      tag_options = add_shows_hides_questions(tag_options, option[:shows_questions], option[:hides_questions])
      wrapped_tag = tag(:input, tag_options)
      option_body_wrap(question_id, option[:title], option[:tooltip], wrapped_tag)
    end

    def generate_time(question)
      body = time_body(question)
      title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
      safe_join([content_tag(:p, title, class: 'flow-text'), body])
    end

    def time_body(question)
      from = question[:hours_from] || 0
      to = question[:hours_to] || 6
      step = question[:hours_step] || 1

      hours = time_dropdown(question[:id], from, to, step, 'Uren')
      minutes = time_dropdown(question[:id], 0, 60, 15, 'Minuten')

      safe_join([hours, minutes])
    end

    def time_dropdown(question_id, from, to, step, label)
      elem_id = idify(question_id, label)
      options = generate_dropdown((from...to).step(step), elem_id)
      options = safe_join([
                            options,
                            content_tag(:label, label)
                          ])
      content_tag(:div, options, class: "input-field col m6 l1 #{elem_id}")
    end

    def generate_dropdown(items, id)
      body = []
      items.each do |option|
        body << content_tag(:option, option, value: option)
      end
      body = safe_join(body)
      content_tag(:select, body, name: answer_name(id), id: id, required: true)
    end

    def add_shows_hides_questions(tag_options, shows_questions, hides_questions)
      tag_options = add_shows_questions(tag_options, shows_questions)
      tag_options = add_hides_questions(tag_options, hides_questions)
      tag_options
    end

    def generate_tooltip(tooltip_content)
      return nil if tooltip_content.blank?
      tooltip_body = content_tag(:i, 'info', class: 'tooltip flow-text material-icons info-outline')
      content_tag(:a,
                  tooltip_body,
                  onclick: "Materialize.toast('#{tooltip_content.gsub("'", %q(\\\'))}', #{TOOLTIP_DURATION})")
    end

    def add_shows_questions(tag_options, shows_questions)
      if shows_questions.present?
        shows_questions_str = shows_questions.map { |qid| idify(qid) }.inspect
        tag_options[:data] = { shows_questions: shows_questions_str }
      end
      tag_options
    end

    def add_hides_questions(tag_options, hides_questions)
      if hides_questions.present?
        hides_questions_str = hides_questions.map { |qid| idify(qid) }.inspect
        tag_options[:data] = { hides_questions: hides_questions_str }
      end
      tag_options
    end

    def radio_otherwise(question)
      return '' if question.key?(:show_otherwise) && !question[:show_otherwise]
      option_body = safe_join([
                                radio_otherwise_option(question),
                                otherwise_textfield(question),
                                generate_tooltip(question[:otherwise_tooltip])
                              ])
      option_body = content_tag(:div, option_body, class: 'otherwise-textfield')
      option_body
    end

    def radio_otherwise_option(question)
      safe_join([
                  tag(:input,
                      name: answer_name(idify(question[:id])),
                      type: 'radio',
                      id: idify(question[:id], question[:otherwise_label]),
                      value: question[:otherwise_label],
                      required: true,
                      class: 'otherwise-option'),
                  content_tag(:label,
                              question[:otherwise_label].html_safe,
                              for: idify(question[:id], question[:otherwise_label]),
                              class: 'flow-text')
                ])
    end

    def otherwise_textfield(question)
      # Used for both radios and checkboxes
      option_field = safe_join([
                                 tag(:input,
                                     id: idify(question[:id], question[:otherwise_label], 'text'),
                                     name: answer_name(idify(question[:id], question[:otherwise_label], 'text')),
                                     type: 'text',
                                     disabled: true,
                                     required: true,
                                     class: 'validate otherwise'),
                                 content_tag(:label,
                                             OTHERWISE_PLACEHOLDER,
                                             for: idify(question[:id], question[:otherwise_label], 'text'))
                               ])
      option_field = content_tag(:div, option_field, class: 'input-field inline')
      option_field
    end

    def generate_checkbox(question)
      title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
      question[:otherwise_label] = OTHERWISE_TEXT if question[:otherwise_label].blank?
      safe_join([
                  content_tag(:p, title, class: 'flow-text'),
                  checkbox_options(question),
                  checkbox_otherwise(question)
                ])
    end

    def checkbox_options(question)
      body = []
      question[:options].each do |option|
        body << checkbox_option_body(question[:id], option)
      end
      safe_join(body)
    end

    def checkbox_option_body(question_id, option)
      option = { title: option } unless option.is_a?(Hash)
      elem_id = idify(question_id, option[:title])
      tag_options = {
        type: 'checkbox',
        id: elem_id,
        name: answer_name(elem_id),
        value: true
      }
      tag_options = add_shows_hides_questions(tag_options, option[:shows_questions], option[:hides_questions])
      wrapped_tag = tag(:input, tag_options)
      option_body_wrap(question_id, option[:title], option[:tooltip], wrapped_tag)
    end

    def option_body_wrap(question_id, title, tooltip, wrapped_tag)
      option_body = safe_join([
                                wrapped_tag,
                                content_tag(:label,
                                            title.html_safe,
                                            for: idify(question_id, title),
                                            class: 'flow-text'),
                                generate_tooltip(tooltip)
                              ])
      option_body = content_tag(:p, option_body)
      option_body
    end

    def checkbox_otherwise(question)
      return '' if question.key?(:show_otherwise) && !question[:show_otherwise]
      option_body = safe_join([
                                checkbox_otherwise_option(question),
                                otherwise_textfield(question),
                                generate_tooltip(question[:otherwise_tooltip])
                              ])
      option_body = content_tag(:div, option_body, class: 'otherwise-textfield')
      option_body
    end

    def checkbox_otherwise_option(question)
      safe_join([
                  tag(:input,
                      type: 'checkbox',
                      id: idify(question[:id], question[:otherwise_label]),
                      name: answer_name(idify(question[:id], question[:otherwise_label])),
                      value: true,
                      class: 'otherwise-option'),
                  content_tag(:label,
                              question[:otherwise_label].html_safe,
                              for: idify(question[:id], question[:otherwise_label]),
                              class: 'flow-text')
                ])
    end

    def generate_range(question)
      title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
      safe_join([
                  content_tag(:p, title, class: 'flow-text'),
                  range_slider(question),
                  range_labels(question)
                ])
    end

    def range_slider(question)
      minmax = range_slider_minmax(question)
      range_body = tag(:input,
                       type: 'range',
                       id: idify(question[:id]),
                       name: answer_name(idify(question[:id])),
                       min: minmax[:min].to_s,
                       max: minmax[:max].to_s,
                       required: true)
      range_body = content_tag(:p, range_body, class: 'range-field')
      range_body
    end

    def range_slider_minmax(question)
      range_min = 0
      range_max = 100
      range_min = [range_min, question[:min]].max if question[:min].present? && question[:min].is_a?(Integer)
      range_max = [range_min + 1, question[:max]].max if question[:max].present? && question[:max].is_a?(Integer)
      { min: range_min, max: range_max }
    end

    def range_labels(question)
      # Works best with 2, 3, or 4 labels
      labels_body = []
      col_class = 12 / [question[:labels].size, 1].max
      question[:labels].each_with_index do |label, idx|
        align_class = case idx
                      when 0
                        'left-align'
                      when (question[:labels].size - 1)
                        'right-align'
                      else
                        'center-align'
                      end
        labels_body << content_tag(:div, label, class: "col #{align_class} s#{col_class}")
      end
      labels_body = safe_join(labels_body)
      labels_body = content_tag(:div, labels_body, class: 'row')
      labels_body
    end

    def generate_textarea(question)
      title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
      safe_join([content_tag(:p, title, class: 'flow-text'), textarea_field(question)])
    end

    def textarea_field(question)
      body = []
      body << content_tag(:textarea,
                          nil,
                          id: idify(question[:id]),
                          name: answer_name(question[:id]),
                          class: 'materialize-textarea')
      body << content_tag(:label,
                          placeholder(question, TEXTAREA_PLACEHOLDER),
                          for: idify(question[:id]),
                          class: 'flow-text')

      body = safe_join(body)
      body = content_tag(:div, body, class: 'input-field col s12')
      body = content_tag(:div, body, class: 'row')
      body
    end

    def generate_textfield(question)
      title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
      safe_join([content_tag(:p, title, class: 'flow-text'), textfield_field(question)])
    end

    def textfield_field(question)
      body = []
      body << tag(:input,
                  type: 'text',
                  id: idify(question[:id]),
                  name: answer_name(question[:id]),
                  class: 'validate')
      body << content_tag(:label,
                          placeholder(question, TEXTFIELD_PLACEHOLDER),
                          for: idify(question[:id]),
                          class: 'flow-text')
      body = safe_join(body)
      body = content_tag(:div, body, class: 'input-field col s12')
      body = content_tag(:div, body, class: 'row')
      body
    end

    def placeholder(question, default_placeholder)
      question[:placeholder].present? ? question[:placeholder] : default_placeholder
    end

    def generate_expandable(question)
      safe_join([
                  content_tag(:p, question[:title].html_safe, class: 'flow-text'),
                  expandables(question),
                  expandable_buttons(question)
                ])
    end

    def update_id(id, sub_id)
      return nil if id.nil?
      id = id.to_s

      # We don't want to inject the id if no _ is present
      return "#{id}_#{sub_id}".to_sym unless id.include? '_'
      id = id.split('_')
      start = id.first
      endd = id[1..-1].join('_')
      "#{start}_#{sub_id}_#{endd}".to_sym
    end

    def update_ids(ids, sub_id)
      result = []
      ids.each do |id|
        result << id # keep the original id
        result << update_id(id, sub_id)
      end
      result
    end

    def update_options(current_options, sub_id)
      current_options.map do |optorig|
        option = optorig.clone
        if option.is_a?(Hash)
          option[:hides_questions] = update_ids(option[:hides_questions], sub_id) if option[:hides_questions].present?
          option[:shows_questions] = update_ids(option[:shows_questions], sub_id) if option[:shows_questions].present?
        end
        option
      end
    end

    def update_current_question(current, id)
      current[:id] = update_id(current[:id], id)
      current[:options] = update_options(current[:options], id) if current.key?(:options)
      current
    end

    def expandables(question)
      default_expansions = question[:default_expansions] || 0
      Array.new((question[:max_expansions] || 10)) do |id|
        is_hidden = id >= default_expansions
        sub_question_body = question[:content].map do |sub_question|
          current = sub_question.clone
          current = update_current_question(current, id)
          single_questionnaire_question(current)
        end

        sub_question_body = safe_join(sub_question_body)
        content_tag(
          :div,
          sub_question_body,
          class: " col s12 expandable_wrapper #{is_hidden ? 'hidden' : ''} #{question[:id]}"
        )
      end
    end

    def expandable_buttons(question)
      body = []
      id = idify(question[:id])
      body << single_expandable_button(
        id,
        question[:add_button_label] || '+',
        'expand_expandable'
      )

      body << single_expandable_button(
        id,
        question[:remove_button_label] || '-',
        'collapse_expandable red'
      )

      body = safe_join(body)
      body = content_tag(:div, body, class: 'col s12')
      body
    end

    def single_expandable_button(id, label, klass)
      content_tag(
        :a,
        label,
        id: id + '_expand',
        data: { belongsto: id },
        class: "btn expandable_button waves-effect waves-light #{klass}"
      )
    end

    def generate_raw(question)
      question[:content].html_safe
    end

    def idify(*strs)
      strs.map { |x| x.to_s.parameterize.underscore }.join('_')
    end
  end
end
