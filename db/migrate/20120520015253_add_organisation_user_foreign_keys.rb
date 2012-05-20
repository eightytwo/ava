class AddOrganisationUserForeignKeys < ActiveRecord::Migration
  def up
    add_foreign_key(:organisation_users, :organisations)
    add_foreign_key(:organisation_users, :users)
  end

  def down
    remove_foreign_key(:organisation_users)
  end
end
