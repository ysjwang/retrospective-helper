class ChangeCategoryToIntegerInRetrospectiveItems < ActiveRecord::Migration[8.0]
  def up
    # First, add a new integer column
    add_column :retrospective_items, :category_int, :integer, default: 0
    
    # Update the new column based on string values
    execute <<-SQL
      UPDATE retrospective_items 
      SET category_int = CASE 
        WHEN category = 'continue' THEN 0
        WHEN category = 'start' THEN 1
        WHEN category = 'stop' THEN 2
        WHEN category = 'misc' THEN 3
        ELSE 0
      END
    SQL
    
    # Remove the old column and rename the new one
    remove_column :retrospective_items, :category
    rename_column :retrospective_items, :category_int, :category
  end

  def down
    # Reverse the process
    add_column :retrospective_items, :category_string, :string
    
    execute <<-SQL
      UPDATE retrospective_items 
      SET category_string = CASE 
        WHEN category = 0 THEN 'continue'
        WHEN category = 1 THEN 'start'
        WHEN category = 2 THEN 'stop'
        WHEN category = 3 THEN 'misc'
        ELSE 'continue'
      END
    SQL
    
    remove_column :retrospective_items, :category
    rename_column :retrospective_items, :category_string, :category
  end
end
