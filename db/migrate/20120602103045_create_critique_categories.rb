class CreateCritiqueCategories < ActiveRecord::Migration
  def change
    create_table :critique_categories do |t|
      t.references :organisation, null: false
      t.string :name, null: false
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
    add_index :critique_categories, :organisation_id
    add_foreign_key(:critique_categories, :organisations, dependent: :delete)
  end
end
