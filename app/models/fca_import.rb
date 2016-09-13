class FcaImport < ActiveRecord::Base
  scope :not_confirmed, -> { where.not(confirmed: true) }

  def lookup_advisers
    a = Lookup::Adviser.count
    b = import_advisers
    {
      before:  a,
      after:   b,
      diff:    b - a
    }
  end

  def lookup_firms
    a = Lookup::Firm.count
    b = import_firms
    {
      before:  a,
      after:   b,
      diff:    b - a
    }
  end

  def lookup_subsidiaries
    a = Lookup::Subsidiary.count
    b = import_subsidiaries
    {
      before:  a,
      after:   b,
      diff:    b - a
    }
  end

  def files
    super.split('|')
  end

  def commit(confirmation)
    if confirmation == :confirm
      FcaConfirmationJob.perform_async(id)
    else
      update_column(:cancelled, false)
    end
  end

  def import_advisers
    exec('SELECT COUNT(*) AS total FROM fcaimport_lookup_advisers;')
  end

  def import_firms
    exec('SELECT COUNT(*) AS total FROM fcaimport_lookup_firms;')
  end

  def import_subsidiaries
    exec('SELECT COUNT(*) AS total FROM fcaimport_lookup_subsidiaries;')
  end

  private

  def exec(sql)
    result = ActiveRecord::Base.connection.execute(sql)
    result[0]['total'].to_i
  end
end
