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
admin.save
