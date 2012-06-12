class CreateCritiqueCategories < ActiveRecord::Migration
  def change
    create_table :critique_categories do |t|
      t.references :organisation, null: false
      t.string :name, null: false
      t.boolean :critiquable, null: false, default: true
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.references :status_type, null: false, default: 1

      t.timestamps
    end
    add_index :critique_categories, :organisation_id
    add_foreign_key(:critique_categories, :organisations, dependent: :delete)
    add_foreign_key(:critique_categories, :status_types, dependent: :restrict)
  end
end
