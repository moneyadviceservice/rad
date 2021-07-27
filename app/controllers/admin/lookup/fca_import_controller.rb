class Admin::Lookup::FcaImportController < Admin::ApplicationController
  def index
    @files  = filter Cloud::Storage.list
    @import = FcaImport.not_confirmed.last
    @tables = FCA::Query.all
  end

  def create
    FcaImportJob.perform_later(files)
    flash[:notice] = 'The following files will be imported.'
    redirect_to admin_lookup_fca_import_index_path
  end

  def update
    @import = FcaImport.find(params[:id])

    if @import
      @import.commit(params[:commit])
      flash[:notice] = "Import has been #{committed}"
    else
      flash[:error] = 'Could not find last import'
    end
    redirect_to admin_lookup_fca_import_index_path
  end

  private

  def files
    params[:files]
  end

  def emails
    params[:emails]
  end

  def committed
    {
      'Confirm' => 'confirmed',
      'Cancel'  => 'cancelled'
    }.fetch(params[:commit], 'processed')
  end

  def filter(fs)
    fs.select { |f| f =~ /^incoming.*\.zip$/i }
  end
end
