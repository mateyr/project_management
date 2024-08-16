class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description, null: false, default: ""
      t.date :end_date, null: false
      t.integer :status, null: false, default: 0
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tasks, :name, unique: true
  end
end
