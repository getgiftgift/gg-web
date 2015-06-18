class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.string :state
      t.datetime :subscribed_at
      t.datetime :unsubscribed_at
      t.timestamps null: false
    end
  end
end
