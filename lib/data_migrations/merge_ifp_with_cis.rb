class MergeIfpWithCis
  def run_migration
    remove_old_body_selections(adviser_ids_where_both_bodies_selected)
    update_old_body_selections(adviser_ids_where_only_one_body_selected)
  end

  private

  def adviser_ids_where_both_bodies_selected
    professional_standing_selection_counts
      .select { |selection_count| selection_count['count'].to_i == 2 }
      .map { |selection_count| selection_count['adviser_id'] }
  end

  def adviser_ids_where_only_one_body_selected
    professional_standing_selection_counts
      .select { |selection_count| selection_count['count'].to_i == 1 }
      .map { |selection_count| selection_count['adviser_id'] }
  end

  def professional_standing_selection_counts
    @professional_standing_selection_counts ||=
      ActiveRecord::Base
      .connection
      .execute(<<-SQL).to_a
        SELECT adviser_id, COUNT(adviser_id)
        FROM advisers_professional_standings
        WHERE professional_standing_id IN (#{old_body.id},#{new_body.id})
        GROUP BY adviser_id
    SQL
  end

  def old_body
    @old_body ||= ProfessionalStanding.find_by!(
      name: 'Institute of Financial Planning'
    )
  end

  def new_body
    @new_body ||= ProfessionalStanding.find_by!(
      name: 'The Chartered Institute for Securities and Investments'
    )
  end

  def remove_old_body_selections(adviser_ids)
    return if adviser_ids.blank?

    ActiveRecord::Base.connection.execute(<<-SQL)
      DELETE FROM advisers_professional_standings
      WHERE professional_standing_id = #{old_body.id}
      AND adviser_id in (#{adviser_ids.join(', ')})
    SQL
  end

  def update_old_body_selections(adviser_ids)
    return if adviser_ids.blank?

    ActiveRecord::Base.connection.execute(<<-SQL)
      UPDATE advisers_professional_standings
      SET professional_standing_id = #{new_body.id}
      WHERE professional_standing_id = #{old_body.id}
      AND adviser_id in (#{adviser_ids.join(', ')})
    SQL
  end
end
