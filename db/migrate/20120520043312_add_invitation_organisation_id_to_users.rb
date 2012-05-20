class AddInvitationOrganisationIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_organisation_id, :int
    add_column :users, :invitation_organisation_admin, :bool
    add_column :users, :invitation_folio_id, :int
    add_column :users, :invitation_folio_role_id, :int

    add_foreign_key(:users, :organisations, :column => 'invitation_organisation_id')
    add_foreign_key(:users, :folios, :column => 'invitation_folio_id')
    add_foreign_key(:users, :folio_roles, :column => 'invitation_folio_role_id')
  end
end
