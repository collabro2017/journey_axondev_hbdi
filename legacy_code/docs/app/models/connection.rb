class Connection < ApplicationRecord
  # For now connections should only have two members a piece, but wanted to
  # keep this flexible and simplify the query structure to play nicer
  # with active_record
  has_many :connection_members
  has_many :connection_events
  belongs_to :initiated_by,
              polymorphic: true,
              foreign_key: :initiated_by_id,
              primary_key: :uuid

  scope :filtered_for_user, ->(user) do
    joins(:connection_members).where('connection_members.member' => user)
  end

  def target
    @target ||= connection_members.preload(:member).map(&:member)
                .reject{|member| member == initiated_by}.first
  end

  def to_param
    [UUIDTools::UUID.parse(uuid).raw].pack('m*').tr('+/','-_').slice(0..21)
  end
end
