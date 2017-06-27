module CheckboxGroupHelpers
  def get_option_group_state(all_options, checked_options)
    all_options.map do |option|
      [checked_options.include?(option), option]
    end
  end

  def set_checkbox_group_state(page_object, all_options, checked_options, label: :name)
    checkbox_states = get_option_group_state(all_options,
                                             checked_options)
    checkbox_states.each do |state, advice_method|
      page_object.find_field(advice_method.send(label)).set(state)
    end
  end

  def expect_checkbox_group_state(page_object, all_options, checked_options, label: :name)
    checkbox_states = get_option_group_state(all_options,
                                             checked_options)
    checkbox_states.each do |selected, advice_method|
      expect(page_object).to have_checked_field(advice_method.send(label)) if selected
      expect(page_object).to have_unchecked_field(advice_method.send(label)) unless selected
    end
  end
end
