class CreateRetrospectiveSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :retrospective_sessions do |t|
      t.string :uuid

      t.timestamps
    end
    add_index :retrospective_sessions, :uuid, unique: true
  end
end
