RSpec.feature 'Adviser is geocoded and indexed' do
  scenario 'Adviser is scheduled for geocoding and indexing' do
    when_i_have_created_a_valid_adviser
    then_it_is_scheduled_for_geocoding_and_indexing
  end

  def when_i_have_created_a_valid_adviser
    @adviser = build(:adviser)
  end

  def then_it_is_scheduled_for_geocoding_and_indexing
    expect { @adviser.save! }.to change {
      ActiveJob::Base.queue_adapter.enqueued_jobs.size
    }.by(1)
  end
end
