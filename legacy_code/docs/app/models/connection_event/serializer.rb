class ConnectionEvent
  class Serializer < ActiveModel::Serializer
    def self.serializer_for(model, options)
      model.class::Serializer rescue nil
    end

    type "connection_event"

    attributes :event, :created_at

    has_one :connection
    has_one :initiated_by

    def id
      [UUIDTools::UUID.parse(object.uuid).raw].pack('m*').tr('+/','-_').slice(0..21)
    end
  end
end
