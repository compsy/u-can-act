# frozen_string_literal: true

module ConversionHelper
  def str_or_num_to_num(value)
    # if we are a string that can't be converted to a number,
    # return nil so we can be registered as a missing value
    return nil if value.blank? || (value.is_a?(String) && (value =~ /\A-?\.?[0-9]/).blank?)

    (value.to_f % 1).positive? ? value.to_f : value.to_i
  end

  def number_to_string(num)
    i = num.to_i
    f = num.to_f
    i == f ? i.to_s : f.to_s
  rescue ArgumentError
    num.to_s
  end

  def idify(*strs)
    strs.map { |x| x.to_s.parameterize.underscore }.join('_')
  end

  def titles(question, attr)
    titles = []
    question[attr].each do |option|
      title = option
      title = option[:title] if option.is_a?(Hash) && option.key?(:title)
      raise "The following option could not be resolved to a string: #{option}" unless title.is_a?(String)

      titles << title
    end
    titles
  end
end
