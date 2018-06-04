class CreateConnectionsAndUsersTables < ActiveRecord::Migration[5.0]
  def change
    create_table :connections do |t|
      t.string :status, null: false
      t.uuid :uuid, unique: true, null: false, default: "public.uuid_generate_v4()"
      t.timestamps
    end

    create_table :connection_members do |t|
      t.belongs_to :connection, foreign_key: { on_delete: :restrict }, null: false
      t.belongs_to :member, polymorphic: true, type: :uuid, null: false
      t.timestamps
    end
    add_index :connection_members, [:connection_id, :member_id], :unique => true
    # Making the connection_members->connections foreign_key
    # defferrable makes fixtures play much nicer, and is
    # has no real impact on the rest of the application.
    # Before when it wasn't defferrable, the fixtures loader would cascade delete
    # the connection members. This is supposed to be handled by rails, but for
    # some reason that wasn't working
    execute %{
      ALTER TABLE connection_members
      ALTER CONSTRAINT fk_rails_8b5000f871 DEFERRABLE
    }

    create_table :thinkers do |t|
      t.string :name, null: false
      t.citext :email, null: false
      t.uuid :uuid, unique: true, null: false
      t.timestamps
    end
    add_index :thinkers, :uuid, :unique => true
    add_index :thinkers, :email, :unique => true

    create_table :scores do |t|
      t.string :name, null: false
      t.belongs_to :thinker, foreign_key: { on_delete: :cascade }, null: false
      t.json :data, null: false
      t.uuid :uuid, unique: true, null: false
      t.timestamps
      t.datetime :generated_at, null: false
    end
    add_index :scores, :uuid, :unique => true
  end
end
