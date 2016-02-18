RSpec.describe TakeSnapshotJob, type: :job do
  it 'takes a new snapshot' do
    snapshot_double = double(run_queries_and_save: true)
    allow(Snapshot).to receive(:new).and_return(snapshot_double)
    expect(snapshot_double).to receive(:run_queries_and_save)
    described_class.new.perform
  end
end
