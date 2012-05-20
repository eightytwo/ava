class CreateFolios < ActiveRecord::Migration
  def change
    create_table :folios do |t|
      t.string :name
      t.string :description
      t.references :organisation

      t.timestamps
    end
    add_index :folios, :organisation_id
    add_foreign_key(:folios, :organisations, :dependent => :delete)
  end
end
