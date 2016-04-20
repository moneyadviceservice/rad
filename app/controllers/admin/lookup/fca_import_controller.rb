class Admin::Lookup::FcaImportController < Admin::ApplicationController
  def new
    @fca_import = OpenStruct.new
  end

  def upload
    100.times{ puts 'The files arrived!' }
  end

  def import
    render 'import_successful'
  end
end
