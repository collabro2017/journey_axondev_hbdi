class AddUuidToConnectionEvents < ActiveRecord::Migration[5.0]
  def change

    change_table :connection_events do |t|
      t.uuid :uuid, unique: true, null: false, default: "public.uuid_generate_v4()"
    end
  end
end
