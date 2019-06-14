RSpec.shared_context 'fca api ok response' do
  before do
    allow(FcaApi::Request)
      .to receive(:new)
      .and_return(instance_double(
        FcaApi::Request, get_firm: instance_double(FcaApi::Response, ok?: true)
      )
    )
  end
end
