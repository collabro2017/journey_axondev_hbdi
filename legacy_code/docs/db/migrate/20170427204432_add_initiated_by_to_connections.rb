class AddInitiatedByToConnections < ActiveRecord::Migration[5.1]
  def change
    change_table :connections do |t|
      t.belongs_to :initiated_by,
                    polymorphic: true,
                    type: :uuid,
                    index: {name: "index_connection_on_initiated_by"}
    end
  end
end
