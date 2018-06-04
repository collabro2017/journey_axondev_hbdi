class Thinker
  class Serializer < ActiveModel::Serializer
    # Clean up shared code for discover serializers and put into a module
    def self.serializer_for(model, options)
      model.class::Serializer rescue nil
    end

    type "thinker"

    def id
      [UUIDTools::UUID.parse(object.uuid).raw].pack('m*').tr('+/','-_').slice(0..21)
    end
  end
end
