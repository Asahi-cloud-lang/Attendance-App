class CreateApplies < ActiveRecord::Migration[5.1]
  def change
    create_table :applies do |t|
      t.string :month
      t.string :mark, default: 0
      t.integer :user_id
      t.string :user_name
      t.string :authorizer
      t.string :check_box, defalut: "true"
      t.timestamps
    end
  end
end