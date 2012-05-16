class CreateKeywordData < ActiveRecord::Migration
  def change
    create_table :keyword_data do |t|
      t.string :word
      t.integer :category_id
      t.integer :sum, default: true
      t.boolean :banned
      t.integer :user_id 
      t.timestamps
    end
  end
end
