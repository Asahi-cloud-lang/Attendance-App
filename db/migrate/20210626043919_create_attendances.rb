class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.datetime :scheduled_end_time
      t.datetime :changed_started_at
      t.datetime :changed_finished_at
      t.string :change_approval, default: 0
      t.string :overtime_approval, default: 0
      t.string :approval_authorizer, default: 1
      t.string :note
      t.string :overtime_note
      t.string :check_box, defalut: "true"
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
