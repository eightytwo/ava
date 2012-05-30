# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create my user.
admin = User.create(email: 'art@admins.com',
                    username: 'art',
                    password: 'foobar',
                    password_confirmation: 'foobar',
                    first_name: 'Arthur',
                    last_name: 'Admin')

# Set myself as an administrator.
admin.admin = true
# Confirm the account.
admin.confirmed_at = Time.now
# Save the record.
admin.save!

# Create folio roles.
viewer_folio_role = FolioRole.create(name: 'Viewer',
                                     description: 'Users of this role can only view audio visuals.')
contributor_folio_role = FolioRole.create(name: 'Contributor',
                                    description: 'Users of this role can view, add and critique audio visuals.')
admin_folio_role = FolioRole.create(name: 'Administrator',
                                    description: 'Users of this role have  unrestricted access.')

# Create an organisation and add the user and folio.
organisation = Organisation.create(name: 'APS',
                                   description: 'The audio visual division of the Australian Photographic Society.',
                                   website: 'http://www.aps.org.au')

# Add the user to the organisation.
organisation_user = OrganisationUser.create(organisation_id: organisation_id,
                                            user_id: admin.id,
                                            admin: true)
