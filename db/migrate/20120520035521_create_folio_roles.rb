class CreateFolioRoles < ActiveRecord::Migration
  def change
    create_table :folio_roles do |t|
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
