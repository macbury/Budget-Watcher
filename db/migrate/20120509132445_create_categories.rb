class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :ancestry
      t.string :uid
      t.timestamps
    end

    add_index :categories, :uid
    add_index :categories, :ancestry

    add_column :transactions, :category_id, :integer
    add_index  :transactions, :category_id
  end
end
