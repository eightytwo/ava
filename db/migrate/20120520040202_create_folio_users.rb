class CreateFolioUsers < ActiveRecord::Migration
  def change
    create_table :folio_users do |t|
      t.references :folio, :null => false
      t.references :user, :null => false
      t.references :folio_role, :null => false

      t.timestamps
    end
    add_index :folio_users, :folio_id
    add_index :folio_users, :user_id
    add_index :folio_users, :folio_role_id
    add_foreign_key(:folio_users, :folios, :dependent => :delete)
    add_foreign_key(:folio_users, :users, :dependent => :delete)
    add_foreign_key(:folio_users, :folio_roles, :dependent => :delete)
  end
end
