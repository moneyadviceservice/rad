class Admin::Lookup::FcaImportController < Admin::ApplicationController
  def index
    @files = Cloud::Storage.init.list
  end

  def create
    FcaImportJob.perform_async(params[:files])
    flash[:notice] = 'The following files will be imported'
    redirect_to :admin_lookup_fca_import_index
  end
end
