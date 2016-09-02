class Admin::Lookup::FcaImportController < Admin::ApplicationController
  def index
    @files = Cloud::Storage.list
  end

  def create
    FcaImportJob.perform_async(files, emails)
    flash[:notice] = 'The following files will be imported'
    redirect_to :admin_lookup_fca_import_index
  end

  private

  def files
    params[:files]
  end

  def emails
    params[:emails]
  end
end
