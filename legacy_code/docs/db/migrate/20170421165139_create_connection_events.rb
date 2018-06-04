class CreateConnectionEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :connection_events do |t|
      t.belongs_to :connection,
                    foreign_key: { on_delete: :cascade }, null: false

      t.belongs_to :initiated_by,
                    polymorphic: true,
                    type: :uuid,
                    index: {name: "index_connection_events_on_initiated_by"}
      t.string :event, null: false
      t.timestamps
    end
  end
end
