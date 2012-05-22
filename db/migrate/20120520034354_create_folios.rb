class CreateFolios < ActiveRecord::Migration
  def change
    create_table :folios do |t|
      t.string :name, :null => false
      t.string :description, :null => false
      t.references :organisation, :null => false

      t.timestamps
    end
    add_index :folios, :organisation_id
    add_foreign_key(:folios, :organisations, :dependent => :delete)
  end
end
