class FcaImport < ApplicationRecord
  STATUSES = %w[processing processed confirmed cancelled].freeze
  FCA_IMPORT_EXCEPTIONS = [PG::InFailedSqlTransaction, StandardError].freeze

  scope :not_confirmed, -> { where(status: STATUSES.take(2)) }

  validates :files, uniqueness: { case_sensitive: false, scope: :status }
  validates :status, inclusion: { in: STATUSES }

  def lookup_advisers
    [Lookup::Adviser.count, imported_advisers]
  end

  def lookup_firms
    [Lookup::Firm.count, imported_firms]
  end

  def lookup_subsidiaries
    [Lookup::Subsidiary.count, imported_subsidiaries]
  end

  def commit(confirmation)
    if confirmation.present? && confirmation.downcase.strip == 'confirm'
      FcaConfirmationJob.perform_later(id)
    else
      # rubocop:disable Rails/SkipsModelValidations
      update_column(:status, 'cancelled')
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  def imported_advisers
    exec('SELECT COUNT(*) AS total FROM fcaimport_lookup_advisers;')
  end

  def imported_firms
    exec('SELECT COUNT(*) AS total FROM fcaimport_lookup_firms;')
  end

  def imported_subsidiaries
    exec('SELECT COUNT(*) AS total FROM fcaimport_lookup_subsidiaries;')
  end

  def processing?
    status == 'processing'
  end

  def processed?
    status == 'processed'
  end

  def confirmed?
    status == 'confirmed'
  end

  def cancelled?
    status == 'cancelled'
  end

  private

  # Comment TG (19-01-2021): Consider refactoring
  # FCA Import uses multiple temporary tables which aren't Rails models
  # Therefore error catching code, like the below is required.
  # Either remove the need for temporary tables
  # Use the API instead of file imports
  # Or failing the above make the temporary tables Rails models.

  def exec(sql)
    result = ActiveRecord::Base.connection.execute(sql)
    result[0]['total'].to_i
  rescue *FCA_IMPORT_EXCEPTIONS
    ActiveRecord::Base.connection.clear_cache!
    0
  end
end
