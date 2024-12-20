class CreateCollaborators < ActiveRecord::Migration[7.1]
  def change
    create_table :collaborators do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role, null: false, default: 1

      t.timestamps
    end
    add_index :collaborators, %i[project_id user_id], unique: true
  end
end
