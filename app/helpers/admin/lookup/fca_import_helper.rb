module Admin::Lookup::FcaImportHelper
  def file_display
    [@files.empty?, @import, flash[:notice]].any? ? 'hide' : 'show'
  end
end
