# frozen_string_literal: true

module UiMacros
  def range_select(id, value)
    selector = %(input[type=range][id=\\"#{id}\\"])
    script = %-$("#{selector}").val(#{value})-
    page.execute_script(script)
  end
end
