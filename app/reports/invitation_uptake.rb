class InvitationUptake
  def run
    CSV.generate do |csv|
      csv << ['FCA Number', 'Registered Name', 'Invitation Sent', 'Invitation Accepted', 'Password Reset Sent']
      query.all.each do |row|
        csv << [
          row.fca_number,
          row.registered_name,
          nice_date(row.invitation_sent_at),
          nice_date(row.invitation_accepted_at),
          nice_date(row.reset_password_sent_at)
        ]
      end
    end
  end

  private

  def query
    User.where.not(invitation_sent_at: nil)
      .joins(principal: [:firm])
      .select(
        'firms.fca_number',
        'firms.registered_name',
        'users.invitation_sent_at',
        'users.invitation_accepted_at',
        'users.reset_password_sent_at'
      )
      .order('firms.fca_number')
  end

  def nice_date(date)
    date.try(:strftime, '%d-%b-%Y %H:%M')
  end
end
