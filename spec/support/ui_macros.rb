# frozen_string_literal: true

module UiMacros
  def range_select(id, value)
    selector = %(input[type=range][id=\\"#{id}\\"])
    script = %-$("#{selector}").val(#{value})-
    page.execute_script(script)
  end

  def materialize_select(prompt, option, superelement = nil)
    sleep(1)
    base = 'div.select-wrapper'
    base = superelement + base if superelement.present?

    # 1. Find the element that matches the prompt
    # 2. Go to the parent ul
    # 3. Go to the parent div
    # 4. Click on it to open the dropdown
    find_all("#{base}>ul>li", text: prompt).first.find(:xpath, '..').find(:xpath, '..').click
    find("#{base} li", text: option).click # select the option wanted
  end
end
