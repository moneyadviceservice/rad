class FirmRepository
  attr_reader :client, :serializer

  def initialize(client = ElasticSearchClient, serializer = FirmSerializer)
    @client     = client.new
    @serializer = serializer
  end

  def store(firm)
    json = serializer.new(firm).as_json
    path = "#{firm.model_name.plural}/#{firm.to_param}"

    client.store(path, json)
  end

  def delete(id)
    path = "#{Firm.model_name.plural}/#{id}"
    client.delete(path)
  end
end
