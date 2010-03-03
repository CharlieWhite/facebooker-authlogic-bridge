# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_facebooker-authlogic-bridge_session',
  :secret      => '07e815d783805965dd806d72d18e724fcbc85eda702312d9c258f2c46df70f850265ab6778b9ae97df42768cbcb88d7339324e0883932ff65385684ab1f45c48'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
