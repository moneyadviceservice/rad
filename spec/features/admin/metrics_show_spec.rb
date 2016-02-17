RSpec.feature 'Admin metrics show page' do
  let(:metrics_show_page) { Admin::MetricsShowPage.new }

  scenario 'Viewing a snapshot' do
    given_i_have_a_snapshot
    when_i_am_on_the_metrics_show_page
    then_i_see_the_table_of_metrics
  end

  def given_i_have_a_snapshot
    @snapshot = Snapshot.create(firms_with_no_minimum_fee: 123)
  end

  def when_i_am_on_the_metrics_show_page
    metrics_show_page.load(snapshot_id: @snapshot.id)
    expect(metrics_show_page).to be_displayed
  end

  def then_i_see_the_table_of_metrics
    expect(metrics_show_page.table).to have_text('Firms with no minimum fee')
    expect(metrics_show_page.table).to have_text(123)
  end
end
