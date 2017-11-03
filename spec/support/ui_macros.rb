# frozen_string_literal: true

module UiMacros
  def range_select(id, value)
    selector = %(input[type=range][id=\\"#{id}\\"])
    script = %-$("#{selector}").val(#{value})-
    page.execute_script(script)
  end

  def materialize_select(prompt, option)
    find("div.select-wrapper>input[value=\"#{prompt}\"]").click # open the dropdown
    find('div.select-wrapper li', text: option).click # select the option wanted
  end
end
