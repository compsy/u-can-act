# frozen_string_literal: true

class QuestionnaireGenerator 
  include ActionView::Helpers

  def initialize
    @generators = {
      radio: RadioGenerator.new,
      time: TimeGenerator.new,
      checkbox: CheckboxGenerator.new,
      range: RangeGenerator.new,
      textarea: TextareaGenerator.new,
      textfield: TextfieldGenerator.new,
      raw: RawGenerator.new,
      unsubscribe: UnsubscribeGenerator.new,
      date: DateGenerator.new,
      expandable: ExpandableGenerator.new
    }
  end

  def generate_questionnaire(response_id:, content:, title:, submit_text:, action:, unsubscribe_url:, params: {})
    params[:response_id] = response_id
    response = Response.find_by_id(response_id) # allow nil response id for preview
    raw_content = content.deep_dup
    title = substitute_variables(response, title).first
    body = safe_join([
                        questionnaire_header(title),
                        questionnaire_hidden_fields(params),
                        questionnaire_questions_html(content, response, raw_content, unsubscribe_url),
                        submit_button(submit_text)
                      ])
    body = content_tag(:form, body, action: action, class: 'col s12', 'accept-charset': 'UTF-8', method: 'post')
    body
  end

  def generate_hash_questionnaire(response_id, content, title)
    response = Response.find_by_id(response_id) # allow nil response id for preview
    title = substitute_variables(response, title).first
    content = questionnaire_questions(content, response) { |quest| quest }
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

  def questionnaire_hidden_fields(params)
    hidden_body = []
    hidden_body << tag(:input, name: 'utf8', type: 'hidden', value: '&#x2713;'.html_safe)
    params.each do |key, value|
      hidden_body << tag(:input, name: key.to_s, type: 'hidden', value: value) if value.present?
    end
    safe_join(hidden_body)
  end

  def questionnaire_questions_html(content, response, raw_content, unsubscribe_url)
    body = questionnaire_questions(content, response) do |quest, idx|
      quest[:response_id] = response&.id
      quest[:raw] = raw_content[idx]
      quest[:unsubscribe_url] = unsubscribe_url
      single_questionnaire_question(quest)
    end
    safe_join(body)
  end

  def questionnaire_questions(content, response)
    body = []
    content.each_with_index do |question, idx|
      new_question = question.deep_dup
      new_question = substitute_variables(response, new_question)
      new_question.each do |quest|
        (body << yield(quest, idx)) if should_show?(quest, response&.id)
      end
    end
    body
  end

  def should_show?(question, response_id)
    return true unless question.key?(:show_after)
    show_after_hash = ensure_show_after_hash(question[:show_after])
    if show_after_hash.key?(:offset)
      show_after_hash[:date] = convert_offset_to_date(show_after_hash[:offset],
                                                      response_id)
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

  def create_question_body(question)
    generator = @generators[question[:type]]
    raise "Unknown question type #{question[:type]}" unless generator
    generator.generate(question)
  end

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
    klasses += " #{Generator.idify(question[:id], 'toggle')}" if question.key?(:hidden) # hides_questions need hidden: false
    klasses
  end

  def section_start(section_title, question)
    body = content_tag(:h5, section_title)
    body = content_tag(:div, body, class: 'col s12')
    klasses = 'extra-spacing row'
    klasses += ' hidden' if question[:hidden].present?
    klasses += " #{Generator.idify(question[:id], 'toggle')}" if question.key?(:hidden) # hides_questions need hidden: false
    body = content_tag(:div, body, class: klasses)
    body
  end

  def section_end(_unused_arg, question)
    body = content_tag(:div, nil, class: 'divider')
    body = content_tag(:div, body, class: 'col s12')
    klasses = 'row'
    klasses += ' hidden' if question[:hidden].present?
    klasses += " #{Generator.idify(question[:id], 'toggle')}" if question.key?(:hidden) # hides_questions need hidden: false
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
end
