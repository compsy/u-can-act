# frozen_string_literal: true

class QuestionnaireGenerator
  extend ActionView::Helpers
  TOOLTIP_DURATION = 6000
  OTHERWISE_TEXT = 'Anders, namelijk:'
  OTHERWISE_PLACEHOLDER = 'Vul iets in'
  TEXTAREA_PLACEHOLDER = 'Vul iets in'
  TEXTFIELD_PLACEHOLDER = 'Vul iets in'
  DATEFIELD_PLACEHOLDER = 'Vul een datum in'

  class << self
    def generate_questionnaire(response_id, content, title, submit_text, action, authenticity_token)
      response = Response.find_by_id(response_id) # allow nil response id for preview
      raw_content = content.deep_dup
      title = substitute_variables(response, title).first
      body = safe_join([
                         questionnaire_header(title),
                         questionnaire_hidden_fields(response_id, authenticity_token),
                         questionnaire_questions(content, response, raw_content),
                         submit_button(submit_text)
                       ])
      body = content_tag(:form, body, action: action, class: 'col s12', 'accept-charset': 'UTF-8', method: 'post')
      body
    end

    def generate_hash_questionnaire(response_id, content, title)
      response = Response.find_by_id(response_id) # allow nil response id for preview
      title = substitute_variables(response, title).first
      content = substitute_variables(response, content).first
      { title: title, content: content }
    end

    private

    def substitute_variables(response, obj_to_substitute)
      return obj_to_substitute if obj_to_substitute.blank?
      QuestionnaireExpander.expand_content(obj_to_substitute, response)
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

    def questionnaire_questions(content, response, raw_content)
      body = []
      content.each_with_index do |question, idx|
        new_question = question.deep_dup
        new_question = substitute_variables(response, new_question)
        new_question.each do |quest|
          quest[:response_id] = response&.id
          quest[:raw] = raw_content[idx]
          body << single_questionnaire_question(quest) if should_show?(quest)
        end
      end
      safe_join(body)
    end

    def should_show?(question)
      return true unless question.key?(:show_after)
      show_after_hash = ensure_show_after_hash(question[:show_after])
      if show_after_hash.key?(:offset)
        show_after_hash[:date] = convert_offset_to_date(show_after_hash[:offset],
                                                        question[:response_id])
      end
      ensure_date_validity(show_after_hash[:date])
      show_after = show_after_hash[:date].in_time_zone
      show_after < Time.zone.now
    end

    def ensure_show_after_hash(show_after)
      show_after_hash = if an_offset?(show_after)
                          { offset: show_after }
                        elsif a_time?(show_after)
                          { date: show_after }
                        else
                          raise "Unknown show_after type: #{show_after}"
                        end
      show_after_hash
    end

    def ensure_date_validity(date)
      raise "Unknown show_after date type: #{date}" unless a_time?(date)
    end

    def convert_offset_to_date(offset, response_id)
      raise "Unknown show_after offset type: #{offset}" unless an_offset?(offset)
      response = Response.find_by_id(response_id)
      return 2.seconds.ago if response.blank? # If we don't have a response, just show it
      TimeTools.increase_by_duration(response.protocol_subscription.start_date, offset)
    end

    def a_time?(value)
      TimeTools.a_time?(value)
    end

    def an_offset?(value)
      TimeTools.an_offset?(value)
    end

    def single_questionnaire_question(question)
      question_body = create_question_body(question)
      question_body = content_tag(:div, question_body, class: 'col s12')
      questionnaire_questions_add_question_section(question_body, question)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
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
      when :unsubscribe
        generate_unsubscribe(question)
      when :date
        generate_date(question)
      when :expandable
        generate_expandable(question)
      else
        raise "Unknown question type #{question[:type]}"
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
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
                                class: 'btn waves-effect waves-light',
                                data: { disable_with: 'Bezig...' })
      submit_body = content_tag(:div, submit_body, class: 'col s12')
      submit_body = content_tag(:div, submit_body, class: 'row section')
      submit_body
    end

    def answer_name(name)
      "content[#{name}]"
    end

    def stop_subscription_name(name)
      "stop_subscription[#{name}]"
    end

    def generate_radio(question)
      # TODO: Add radio button validation error message
      title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
      question = add_otherwise_label(question)
      safe_join([
                  content_tag(:p, title, class: 'flow-text'),
                  radio_options(question),
                  radio_otherwise(question)
                ])
    end

    def add_otherwise_label(question)
      question[:raw][:otherwise_label] = OTHERWISE_TEXT if question[:raw][:otherwise_label].blank?
      question[:otherwise_label] = OTHERWISE_TEXT if question[:otherwise_label].blank?
      question
    end

    def radio_options(question)
      body = []
      question[:options].each_with_index do |option, idx|
        body << radio_option_body(question[:id], add_raw_to_option(option, question, idx), question[:response_id])
      end
      safe_join(body)
    end

    def radio_option_body(question_id, option, response_id)
      elem_id = idify(question_id, option[:raw][:title])
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
      option_body_wrap(question_id, option, wrapped_tag, idify(question_id), option[:title], response_id)
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

    def time_dropdown(question_id, from_time, to_time, step, label)
      elem_id = idify(question_id, label)
      options = generate_dropdown((from_time...to_time).step(step), elem_id)
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
      tag_options = add_show_hide_question(tag_options, shows_questions, :shows_questions)
      tag_options = add_show_hide_question(tag_options, hides_questions, :hides_questions)
      tag_options
    end

    def generate_tooltip(tooltip_content)
      return nil if tooltip_content.blank?
      tooltip_body = content_tag(:i, 'info', class: 'tooltip flow-text material-icons info-outline')
      content_tag(:a,
                  tooltip_body,
                  onclick: "Materialize.toast('#{tooltip_content.gsub("'", %q(\\\'))}', #{TOOLTIP_DURATION})")
    end

    def add_show_hide_question(tag_options, questions_to_toggle, key)
      if questions_to_toggle.present?
        questions_to_toggle_str = questions_to_toggle.map { |qid| idify(qid) }.inspect
        append_tag(tag_options, :data, key => questions_to_toggle_str)
      end
      tag_options
    end

    def append_tag(tag_options, field, data)
      # The append_tag function allows us to specify both shows and hides attributes
      # in one question
      tag_options[field] ||= {}
      tag_options[field] = tag_options[field].merge data
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
                      id: idify(question[:id], question[:raw][:otherwise_label]),
                      value: question[:otherwise_label],
                      required: true,
                      class: 'otherwise-option'),
                  otherwise_option_label(question)
                ])
    end

    def otherwise_option_label(question)
      content_tag(:label,
                  question[:otherwise_label].html_safe,
                  for: idify(question[:id], question[:raw][:otherwise_label]),
                  class: 'flow-text')
    end

    def otherwise_textfield(question)
      # Used for both radios and checkboxes
      option_field = safe_join([
                                 tag(:input,
                                     id: idify(question[:id], question[:raw][:otherwise_label], 'text'),
                                     name: answer_name(idify(question[:id], question[:raw][:otherwise_label], 'text')),
                                     type: 'text',
                                     disabled: true,
                                     required: true,
                                     class: 'validate otherwise'),
                                 otherwise_textfield_label(question)
                               ])
      option_field = content_tag(:div, option_field, class: 'input-field inline')
      option_field
    end

    def otherwise_textfield_label(question)
      content_tag(:label,
                  OTHERWISE_PLACEHOLDER,
                  for: idify(question[:id], question[:raw][:otherwise_label], 'text'))
    end

    def generate_checkbox(question)
      title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
      question = add_otherwise_label(question)
      checkbox_group = safe_join([
                                   content_tag(:p, title, class: 'flow-text'),
                                   checkbox_options(question),
                                   checkbox_otherwise(question)
                                 ])
      content_tag(:div, checkbox_group, class: checkbox_group_klasses(question))
    end

    def checkbox_group_klasses(question)
      klasses = 'checkbox-group'
      klasses += ' required' if question[:required].present?
      klasses
    end

    def checkbox_options(question)
      body = []
      question[:options].each_with_index do |option, idx|
        body << checkbox_option_body(question[:id], add_raw_to_option(option, question, idx), question[:response_id])
      end
      safe_join(body)
    end

    def add_raw_to_option(option, question, idx)
      raw_option = question[:raw][:options][idx]
      raw_option = { title: raw_option } unless raw_option.is_a?(Hash)
      option = option.deep_dup
      option = { title: option } unless option.is_a?(Hash)
      option[:raw] = raw_option
      option
    end

    def checkbox_option_body(question_id, option, response_id)
      elem_id = idify(question_id, option[:raw][:title])
      tag_options = {
        type: 'checkbox',
        id: elem_id,
        name: answer_name(elem_id),
        value: true
      }
      tag_options = add_shows_hides_questions(tag_options, option[:shows_questions], option[:hides_questions])
      wrapped_tag = tag(:input, tag_options)
      option_body_wrap(question_id, option, wrapped_tag, elem_id, 'true', response_id)
    end

    def option_body_wrap(question_id, option, wrapped_tag, answer_key, answer_value, response_id)
      option_body = safe_join([
                                wrapped_tag,
                                content_tag(:label,
                                            option[:title].html_safe,
                                            for: idify(question_id, option[:raw][:title]),
                                            class: 'flow-text'),
                                generate_tooltip(option[:tooltip])
                              ])
      option_body = safe_join([
                                content_tag(:p, option_body),
                                stop_subscription_token(option, answer_key, answer_value, response_id)
                              ])
      option_body
    end

    def stop_subscription_token(option, answer_key, answer_value, response_id)
      return nil unless option[:stop_subscription]
      tag(:input, name: stop_subscription_name(answer_key),
                  type: 'hidden',
                  value: Response.stop_subscription_token(answer_key, answer_value, response_id))
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
                      id: idify(question[:id], question[:raw][:otherwise_label]),
                      name: answer_name(idify(question[:id], question[:raw][:otherwise_label])),
                      value: true,
                      class: 'otherwise-option'),
                  otherwise_option_label(question)
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
                       step: question[:step] || 1,
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
      body = safe_join([
                         textarea_tag(question),
                         textarea_label(question)
                       ])
      body = content_tag(:div, body, class: 'input-field col s12')
      body = content_tag(:div, body, class: 'row')
      body
    end

    def textarea_tag(question)
      content_tag(:textarea,
                  nil,
                  id: idify(question[:id]),
                  name: answer_name(question[:id]),
                  required: question[:required].present?,
                  class: 'materialize-textarea')
    end

    def textarea_label(question)
      content_tag(:label,
                  placeholder(question, TEXTAREA_PLACEHOLDER),
                  for: idify(question[:id]),
                  class: 'flow-text')
    end

    def generate_textfield(question)
      title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
      safe_join([content_tag(:p, title, class: 'flow-text'), textfield_field(question)])
    end

    def textfield_field(question)
      body = safe_join([
                         textfield_tag(question),
                         textfield_label(question)
                       ])
      body = content_tag(:div, body, class: 'input-field col s12')
      body = content_tag(:div, body, class: 'row')
      body
    end

    def textfield_tag(question)
      tag(:input,
          type: 'text',
          id: idify(question[:id]),
          name: answer_name(question[:id]),
          required: question[:required].present?,
          class: 'validate')
    end

    def textfield_label(question)
      content_tag(:label,
                  placeholder(question, TEXTFIELD_PLACEHOLDER),
                  for: idify(question[:id]),
                  class: 'flow-text')
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
        option = optorig.deep_dup
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
        sub_question_body = []
        question[:content].each_with_index do |sub_question, idx|
          sub_question_body << add_expandable_question(question, sub_question, idx, id)
        end

        sub_question_body = safe_join(sub_question_body)
        content_tag(
          :div,
          sub_question_body,
          class: " col s12 expandable_wrapper #{is_hidden ? 'hidden' : ''} #{question[:id]}"
        )
      end
    end

    def add_expandable_question(question, sub_question, idx, id)
      current = sub_question.deep_dup
      current[:raw] = question[:raw][:content][idx]
      current = update_current_question(current, id)
      single_questionnaire_question(current)
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

    def generate_unsubscribe(question)
      body = safe_join([
                         generate_unsubscribe_content(question),
                         generate_unsubscribe_action(question)
                       ])
      body = content_tag(:div, body, class: 'card light-grey-background-color')
      body
    end

    def generate_unsubscribe_content(question)
      body = []
      body << content_tag(:span, question[:title].html_safe, class: 'card-title') if question[:title].present?
      body << content_tag(:p, question[:content].html_safe) if question[:content].present?
      body = safe_join(body)
      body = content_tag(:div, body, class: 'card-content black-text')
      body
    end

    def generate_unsubscribe_action(question)
      response = Response.find_by_id(question[:response_id])
      url_href = '#'
      url_href = Rails.application.routes.url_helpers.questionnaire_path(uuid: response.uuid) if response
      body = content_tag(:a, (question[:button_text] || 'Uitschrijven').html_safe,
                         'data-method': 'delete',
                         href: url_href,
                         class: 'btn waves-effect waves-light navigate-away-allowed',
                         rel: 'nofollow')
      content_tag(:div, body, class: 'card-action')
    end

    def generate_date(question)
      title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
      safe_join([content_tag(:p, title, class: 'flow-text'), mydate_field(question)])
    end

    def mydate_field(question)
      body = safe_join([
                         mydate_tag(question),
                         mydate_label(question)
                       ])
      body = content_tag(:div, body, class: 'input-field col s12')
      body = content_tag(:div, body, class: 'row')
      body
    end

    def mydate_tag(question)
      tag(:input,
          type: 'text',
          id: idify(question[:id]),
          name: answer_name(question[:id]),
          required: question[:required].present?,
          class: 'datepicker',
          data: { min: question[:min], max: question[:max] })
    end

    def mydate_label(question)
      content_tag(:label,
                  placeholder(question, DATEFIELD_PLACEHOLDER),
                  for: idify(question[:id]),
                  class: 'flow-text')
    end

    def idify(*strs)
      strs.map { |x| x.to_s.parameterize.underscore }.join('_')
    end
  end
end
