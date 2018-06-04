class Thinker < ApplicationRecord
  has_many :connection_members, as: :member, primary_key: :uuid
  has_many :connections, through: :connection_members

  def connected_thinkers
    Thinker.joins(:connection_members).where(connection_id: connections.select(:id))
  end
end
