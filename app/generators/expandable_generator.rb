# frozen_string_literal: true

class ExpandableGenerator < QuestionTypeGenerator
  def generate(question)
    safe_join([
                tag.p(question[:title].html_safe, class: 'flow-text'),
                expandables(question),
                expandable_buttons(question)
              ])
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
      tag.div(
        sub_question_body,
        class: " col s12 expandable_wrapper #{is_hidden ? 'hidden' : ''} #{question[:id]}"
      )
    end
  end

  def add_expandable_question(question, sub_question, idx, id)
    current = sub_question.deep_dup
    current[:raw] = question[:raw][:content][idx]
    current = update_current_question(current, id)
    questionnaire_question_qenerator = QuestionnaireQuestionGenerator.new
    questionnaire_question_qenerator.generate(current)
  end

  def expandable_buttons(question)
    body = []
    body << add_button(question)
    body << remove_button(question)
    body = safe_join(body)
    body = tag.div(body, class: 'row')
    tag.div(body, class: 'col s12')
  end

  def add_button(question)
    single_expandable_button(
      idify(question[:id]),
      safe_join([tag.i('add', class: 'material-icons left'), question[:add_button_label] || '']),
      'expand_expandable success',
      true
    )
  end

  def remove_button(question)
    single_expandable_button(
      idify(question[:id]),
      safe_join([tag.i('remove', class: 'material-icons left'), question[:remove_button_label] || '']),
      'collapse_expandable warning',
      false
    )
  end

  def single_expandable_button(id, label, klass, expand)
    tag.a(
      label,
      id: "#{id}_#{expand ? 'expand' : 'collapse'}",
      data: { belongsto: id },
      class: "btn expandable_button waves-effect waves-light #{klass}"
    )
  end

  def update_current_question(current, id)
    current[:id] = update_id(current[:id], id)
    current[:options] = update_options(current[:options], id) if current.key?(:options)
    current
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

  def update_id(id, sub_id)
    return nil if id.nil?

    id = id.to_s

    # We don't want to inject the id if no _ is present
    return "#{id}_#{sub_id}".to_sym unless id.include? '_'

    id = id.split('_')
    start = id.first
    endd = id[1..].join('_')
    "#{start}_#{sub_id}_#{endd}".to_sym
  end
end
