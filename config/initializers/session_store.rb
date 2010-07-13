# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bizdiary_session',
  :secret      => '72c2488d52bf998e6f54080e14f9c33c30db35af563042049d944e26203b7971bfaa60942e67478a10b57cbcc7dd08ced466e1f6fc538be1387543a4fc80bc67'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
