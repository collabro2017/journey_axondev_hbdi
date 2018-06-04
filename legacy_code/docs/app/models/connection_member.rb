class ConnectionMember < ApplicationRecord
  belongs_to :connection
  belongs_to :member,
              polymorphic: true,
              foreign_key: :member_id,
              primary_key: :uuid

  # attrs
  # status :active, :invited, :disabled?
  # timestamps
end
