class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.date :log_worked_on
      t.integer :user_id
      t.datetime :log_started_at 
      t.datetime :log_finished_at
      t.datetime :log_changed_started_at
      t.datetime :log_changed_finished_at
      t.string :approval_authorizer
      
      t.timestamps
    end
  end
end
