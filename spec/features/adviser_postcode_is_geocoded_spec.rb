RSpec.feature 'Adviser postcode is geocoded' do
  scenario 'Valid Adviser is scheduled for geocoding' do
    when_i_have_created_a_valid_adviser
    then_it_is_scheduled_for_geocoding
  end

  def when_i_have_created_a_valid_adviser
    @adviser = build(:adviser)
  end

  def then_it_is_scheduled_for_geocoding
    expect { @adviser.save! }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.size }.by(1)
  end
end
