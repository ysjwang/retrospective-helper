class AddPersonToRetrospectiveItems < ActiveRecord::Migration[8.0]
  def change
    add_column :retrospective_items, :person, :string
  end
end
