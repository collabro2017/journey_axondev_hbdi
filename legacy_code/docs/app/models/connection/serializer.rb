class Connection
  class Serializer < ActiveModel::Serializer
    type "connection"

    attributes :status,
               :invited_email_address

    has_one :to do
      object.connection_members.where.not(member: scope).first
    end

    def id
      [UUIDTools::UUID.parse(object.uuid).raw].pack('m*').tr('+/','-_').slice(0..21)
    end
  end
end
