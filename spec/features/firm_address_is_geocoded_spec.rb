RSpec.feature 'Firm address is geocoded' do
  scenario 'Valid Firm is scheduled for geocoding' do
    when_i_have_created_a_valid_firm
    then_it_is_scheduled_for_geocoding
  end

  def when_i_have_created_a_valid_firm
    @firm = build(:firm)
  end

  def then_it_is_scheduled_for_geocoding
    skip
    expect { @firm.save! }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.size }.by(1)
  end
end
