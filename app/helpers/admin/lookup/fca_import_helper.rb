module Admin::Lookup::FcaImportHelper
  def file_display
    [@files.empty?, @import, flash[:notice]].any? ? 'hide' : 'show'
  end

  def formatted_diff(a, b)
    {
      before:  a,
      after:   b,
      diff:    b - a
    }
  end

  def prepare_table_info(import, table_name)
    formatted_diff(*import.send(table_name.to_sym))
  # rubocop:disable Style/RescueStandardError
  rescue
    { error: 'Could not calculate difference. Try reloading the page.' }
  end
  # rubocop:enable Style/RescueStandardError
end
