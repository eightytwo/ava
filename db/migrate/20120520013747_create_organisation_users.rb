class CreateOrganisationUsers < ActiveRecord::Migration
  def change
    create_table :organisation_users do |t|
      t.references :organisation
      t.references :user
      t.boolean :admin

      t.timestamps
    end
    add_index :organisation_users, :organisation_id
    add_index :organisation_users, :user_id
  end
end
