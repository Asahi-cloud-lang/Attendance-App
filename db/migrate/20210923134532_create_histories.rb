class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.date :log_worked_on
      t.integer :user_id
      t.datetime :log_started_at 
      t.datetime :log_finished_at
      t.datetime :log_changed_started_at
      t.datetime :log_changed_finished_at
      t.string :overtime_approval, default: 0
      t.datetime :log_scheduled_end_time
      t.string :approval_authorizer
      t.string :note
      t.string :overtime_note
      
      t.timestamps
    end
  end
end
