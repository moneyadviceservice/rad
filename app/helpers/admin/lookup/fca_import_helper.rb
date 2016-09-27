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
end
