class CreateCritiqueComponents < ActiveRecord::Migration
  def change
    create_table :critique_components do |t|
      t.references :critique, null: false
      t.references :critique_category, null: false
      t.text :content
      t.text :reply
      t.datetime :reply_created_at
      t.datetime :reply_updated_at
      
      t.timestamps
    end
    add_index :critique_components, :critique_id
    add_index :critique_components, :critique_category_id
    add_foreign_key(:critique_components, :critiques, dependent: :delete)
    add_foreign_key(:critique_components, :critique_categories, dependent: :restrict)
  end
end
