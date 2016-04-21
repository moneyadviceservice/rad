class Admin::Lookup::FcaImportController < Admin::ApplicationController
  def new
  end

  def upload
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

    from.all.each do |import_instance|
      to.create import_instance.attributes
    end
  end
end
