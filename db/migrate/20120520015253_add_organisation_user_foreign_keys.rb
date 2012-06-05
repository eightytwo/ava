class AddOrganisationUserForeignKeys < ActiveRecord::Migration
  def up
    add_foreign_key(:organisation_users, :organisations, dependent: :delete)
    add_foreign_key(:organisation_users, :users, dependent: :delete)
  end

  def down
    remove_foreign_key(:organisation_users)
  end
end
