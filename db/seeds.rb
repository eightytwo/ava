# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create my user.
admin = User.create(email: 'admin@null.net',
                    username: 'piers',
                    password: 'foobar',
                    password_confirmation: 'foobar')

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
                                   website: 'http://www.aps.org.au')

# Add the user to the organisation.
organisation_user = OrganisationUser.create(organisation: organisation,
                                            user: admin,
                                            admin: true)

# Create a folio.
folio = Folio.create(name: 'First Folio',
                     description: 'The first folio of APS.',
                     organisation: organisation)

# Add the user to the folio.
folio_user = FolioUser.create(folio: folio,
                              user: admin,
                              folio_role: admin_folio_role)

# Create a round.
round = Round.create(name: 'First Round',
                     folio: folio,
                     start_date: Date.today,
                     end_date: Date.today + 1.week)
