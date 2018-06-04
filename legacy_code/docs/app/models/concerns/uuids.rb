module UUIDs
  extend ActiveSupport::Concern

  def pack_uuid(uuid)
    [UUIDTools::UUID.parse(object.uuid).raw].pack('m*').tr('+/','-_').slice(0..21)
  end
end
