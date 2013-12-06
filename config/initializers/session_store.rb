# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twittermentionmonitor.com_session',
  :secret      => '5df034a039b383d1c6c80ff2f1d1009f6ce1ce895a5d094e9382de6154590718dc657bbccbe9ec831967f9a371e84222b0eef81775245e738e5f7b8751a0912c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
