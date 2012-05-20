class CreateFolioRoles < ActiveRecord::Migration
  def change
    create_table :folio_roles do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
