require 'zip'

class Admin::Lookup::FcaImportController < Admin::ApplicationController
  def new
  end

  def upload_firms
    firm_file_content = unzip params['a_file'], 'firms2'
    original_filename = params['a_file'].original_filename
    UploadFcaDataJob.perform_later(firm_file_content, params['email'], original_filename)
  end

  def upload_subsidiaries
    subsidiary_file_content = unzip params['c_file'], 'firm_names'
    original_filename = params['c_file'].original_filename
    UploadFcaDataJob.perform_later(subsidiary_file_content, params['email'], original_filename)
  end

  def upload_advisers
    adviser_file_content = unzip params['f_file'], 'indiv_apprvd'
    original_filename = params['f_file'].original_filename
    UploadFcaDataJob.perform_later(adviser_file_content, params['email'], original_filename)
  end

  def upload_status
  end

  def import
    import_fca_feed from: ::Lookup::Import::Firm, to: ::Lookup::Firm
    import_fca_feed from: ::Lookup::Import::Subsidiary, to: ::Lookup::Subsidiary
    import_fca_feed from: ::Lookup::Import::Adviser, to: ::Lookup::Adviser

    render 'import_successful'
  end

  private

  def import_fca_feed(from:, to:)
    to.delete_all

    ActiveRecord::Base.connection.execute("INSERT INTO #{to.table_name} (SELECT * FROM #{from.table_name});")
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
