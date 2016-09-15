class Admin::Lookup::FcaImportController < Admin::ApplicationController
  def index
    @files  = filter Cloud::Storage.list
    @import = FcaImport.not_confirmed.last
    @tables = FCA::Query.all
  end

  def create
    FcaImportJob.perform_async(files, FCA::Config.emails)
    flash[:notice] = 'The following files will be imported<br/>You will be notified when it\'s done.'
    redirect_to :admin_lookup_fca_import_index
  end

  def update
    @import = FcaImport.find(params[:id])
    if @import
      @import.commit(commit)
      flash[:notice] = "Import has been #{committed}"
      redirect_to :admin_lookup_fca_import_index
    else
      flash[:error] = 'Could not find last import'
      redirect_to :admin_lookup_fca_import_index
    end
  end

  private

  def files
    params[:files]
  end

  def emails
    params[:emails]
  end

  def commit
    params[:commit].strip.downcase.to_sym if params[:commit]
  end

  def committed
    {
      'Confirm' => 'confirmed',
      'Cancel'  => 'cancelled'
    }.fetch(params[:commit], 'processed')
  end

  def filter(fs)
    fs.select { |f| f =~ /^incoming.+/ }
  end
end
