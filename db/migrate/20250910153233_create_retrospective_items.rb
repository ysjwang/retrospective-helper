class CreateRetrospectiveItems < ActiveRecord::Migration[8.0]
  def change
    create_table :retrospective_items do |t|
      t.references :retrospective_session, null: false, foreign_key: true
      t.string :category
      t.string :name
      t.text :comments
      t.date :due_date

      t.timestamps
    end
  end
end
