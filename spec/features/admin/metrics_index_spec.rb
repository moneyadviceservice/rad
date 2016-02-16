RSpec.feature 'Admin metrics list page' do
  let(:metrics_index_page) { Admin::MetricsIndexPage.new }
  let(:metrics_show_page) { Admin::MetricsShowPage.new }

  scenario 'Viewing the list of snapshots' do
    given_there_are_snapshots
    when_i_am_on_the_metrics_index_page
    then_i_can_see_every_snapshot
  end

  scenario 'Clicking on a snapshot' do
    given_there_are_snapshots
    when_i_am_on_the_metrics_index_page
    and_i_click_on_a_snapshot_view_button
    then_i_am_on_the_metrics_show_page
  end

  def given_there_are_snapshots
    3.times { Snapshot.create }
  end

  def when_i_am_on_the_metrics_index_page
    metrics_index_page.load
  end

  def then_i_can_see_every_snapshot
    expect(metrics_index_page.snapshots.count).to eq(3)

    Snapshot.all.each_with_index do |snapshot, i|
      expect(metrics_index_page.snapshots.at(i)).to have_text(snapshot.created_at.strftime('%e %B %Y'))
    end
  end

  def and_i_click_on_a_snapshot_view_button
    random_snapshot = metrics_index_page.snapshots.sample
    random_snapshot.view_button.click
  end

  def then_i_am_on_the_metrics_show_page
    expect(metrics_show_page).to be_displayed
  end
end
