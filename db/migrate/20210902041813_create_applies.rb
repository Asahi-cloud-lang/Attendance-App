class CreateApplies < ActiveRecord::Migration[5.1]
  def change
    create_table :applies do |t|
      t.date :month
      t.string :mark, default: 0
      t.integer :user_id
      t.string :user_name
      t.string :authorizer
      t.timestamps
    end
  end
end