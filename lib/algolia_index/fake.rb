module AlgoliaIndex
  class Fake
    attr_reader :name

    RESPONSE_ATTRS ||= {
      'processingTimeMS' => 7,
      'query' => '',
      'params' => 'filters=level%3D20',
      'cursor' => 'ARJmaWx0ZXJzPWxldmVsJTNEMjABARoGODA4OTIzvwgAgICAgICAgICAAQ=='
    }.freeze

    def initialize(index_name)
      @name = index_name
      @collection = []
    end

    def delete_object(id)
      collection.delete_if { |elem| elem.objectID == id }
    end

    def add_object(elem)
      stored_at = collection.index { |item| item.objectID == elem.objectID }

      if stored_at
        @collection[stored_at] = elem
      else
        @collection << elem
      end
    end

    def add_objects(elements)
      elements.each { |elem| add_object(elem) }
    end

    def replace_all_objects(elements)
      @collection = [elements]
    end

    def browse(_foo)
      {
        'hits' => collection
      }.merge(RESPONSE_ATTRS).to_json
    end

    def clear_index
      @collection = []
    end

    private

    attr_reader :collection
  end
end
