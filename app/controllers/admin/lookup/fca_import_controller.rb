class Admin::Lookup::FcaImportController < Admin::ApplicationController
  def index
    @files  = filter Cloud::Storage.list
    @import = FcaImport.not_confirmed.last
    @tables = FCA::Query.all
  end

  def create
    FcaImportJob.perform_async(files)
    flash[:notice] = "The following files will be imported.
You will be notified on the Slack channel #{channel} when it's done."
    redirect_to admin_lookup_fca_import_index_path
  end

  def update
    @import = FcaImport.find(params[:id])
    if @import
      @import.commit(params[:commit])
      flash[:notice] = "Import has been #{committed}"
      redirect_to admin_lookup_fca_import_index_path
    else
      flash[:error] = 'Could not find last import'
      redirect_to admin_lookup_fca_import_index_path
    end
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

  def channel
    FCA::Config.notify[:slack][:channel]
  end
end
