# frozen_string_literal: true

module UiMacros
  # Used JS because the range input is not a standard select element
  # and Capybara does not support it natively.
  # This function simulates a user changing the value of a range input.
  def range_select(id, value)
    page.execute_script(<<~JS)
      const input = document.querySelector('input[type="range"][name="content[#{id}]"]');
      if (!input) {
        console.warn("No slider input found for content[#{id}]");
        return;
      }

      input.value = #{value};
      input.dispatchEvent(new Event('input', { bubbles: true }));
      input.dispatchEvent(new Event('change', { bubbles: true }));

      const container = input.closest('.range-container');
      if (container) {
        container.classList.remove('notchanged');
      }

      input.setAttribute('name', 'content[#{id}]'); // reapply just in case
    JS
  end

  def materialize_select(prompt, option, superelement = nil)
    base = 'div.select-wrapper'
    base = superelement + base if superelement.present?

    # 1. Find the element that matches the prompt
    # 2. Go to the parent ul
    # 3. Go to the parent div
    # 4. Click on it to open the dropdown
    sleep(1)
    find_all("#{base}>ul>li", text: prompt).first.find(:xpath, '..').find(:xpath, '..').click
    # Add some delay because the thing folds out slowly
    sleep(2)
    find("#{base} li", text: option).click # select the option wanted
    sleep(1)
  end

  def normal_select(scope, value)
    find(scope).find(:xpath, "option[@value='#{value}']").select_option
  end
end
