require 'zip'

class Admin::Lookup::FcaImportController < Admin::ApplicationController
  def new
  end

  def upload_firms
    upload 'firms2'
  end

  def upload_subsidiaries
    upload 'firm_names'
  end

  def upload_advisers
    upload 'indiv_apprvd'
  end

  def upload_status
  end

  def import
    ::Lookup::Import::Firm.import_uploaded_fca_data
    ::Lookup::Import::Subsidiary.import_uploaded_fca_data
    ::Lookup::Import::Adviser.import_uploaded_fca_data

    render 'import_successful'
  end

  private

  def upload(file_prefix)
    file_content = unzip params['zip_file'], file_prefix
    original_filename = params['zip_file'].original_filename
    UploadFcaDataJob.perform_later(file_content, params['email'], original_filename)
  end

  def unzip(uploaded_zip, compressed_filename_prefix)
    result = nil
    Zip::File.open(uploaded_zip.tempfile) do |zip_file|
      zip_file.each do |entry|
        result = entry.get_input_stream.read if entry.name.include?(compressed_filename_prefix)
      end
    end
    result.force_encoding('iso-8859-1').encode('utf-8')
  end
end
