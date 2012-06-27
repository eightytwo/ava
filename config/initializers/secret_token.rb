# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
unless Rails.env.production?
  ENV['secret_token'] = '2002733de8ffdbfb57cabf40a9defb3ad1ed3bcdb32d92a4200777757f5a97ab704f66c15b3916293580a9d44336ed47395b40ca2736ceeb35a63a9d993edacd'
end

Ava::Application.config.secret_token = ENV['secret_token']
