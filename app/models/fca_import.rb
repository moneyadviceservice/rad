class FcaImport < ApplicationRecord
  STATUSES = %w[processing processed confirmed cancelled].freeze

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

  def exec(sql)
    result = ActiveRecord::Base.connection.execute(sql)
    result[0]['total'].to_i
  rescue StandardError
    0
  end
end
