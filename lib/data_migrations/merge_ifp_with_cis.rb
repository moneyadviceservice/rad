class MergeIfpWithCis
  def run_migration
    info 'BEGIN IFP Migration'
    info new_body_count

    in_need_of_selection_removal = adviser_ids_where_both_bodies_selected
    in_need_of_selection_update = adviser_ids_where_only_one_body_selected

    info 'Removing Institute of Financial Services selections'
    remove_old_body_selections(in_need_of_selection_removal)
    info 'Updating Institute of Financial Services selections'
    update_old_body_selections(in_need_of_selection_update)

    info new_body_count
    info 'END IFP Migration'
  end

  private

  def info(output)
    Rails.logger.info(output)
  end

  def new_body_count
    Adviser
      .includes(:professional_standings)
      .where(professional_standings: { id: new_body.id })
      .count
  end

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

    advisers = Adviser.where(id: adviser_ids)
    advisers.each do |adviser|
      log_updating(adviser)
      adviser.professional_standing_ids =
        adviser.professional_standing_ids - [old_body.id]
      adviser.save!
    end

    log_finish(advisers)
  end

  # rubocop:disable Metrics/AbcSize
  def update_old_body_selections(adviser_ids)
    return if adviser_ids.blank?

    advisers = Adviser.where(id: adviser_ids)
    info "Updating advisers #{advisers.pluck(:id).join(', ')}"
    advisers
      .select { |a| a.professional_standing_ids.include? old_body.id }
      .each do |adviser|
        log_updating(adviser)
        adviser.professional_standing_ids =
          adviser.professional_standing_ids - [old_body.id] + [new_body.id]
        adviser.save!
      end
    log_finish(advisers)
  end
  # rubocop:enable Metrics/AbcSize

  def log_finish(advisers)
    info "Finished, total records updated: #{advisers.length}"
  end

  def log_updating(adviser)
    info "Updating adviser #{adviser.id}"
  end
end
