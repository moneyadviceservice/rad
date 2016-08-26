class Admin::Lookup::FcaImportController < Admin::ApplicationController
  def index
    @files = Cloud::Storage.init.list
  end
end
