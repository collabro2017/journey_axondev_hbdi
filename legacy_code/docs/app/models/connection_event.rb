class ConnectionEvent < ApplicationRecord
  belongs_to :connection
  belongs_to :initiated_by,
              polymorphic: true,
              foreign_key: :initiated_by_id,
              primary_key: :uuid


  def to_param
    [UUIDTools::UUID.parse(uuid).raw].pack('m*').tr('+/','-_').slice(0..21)
  end
end
