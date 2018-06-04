class AddInvitedEmailAddress < ActiveRecord::Migration[5.0]
  def change
    change_table :connections do |t|
      t.citext :invited_email_address
    end
  end
end
