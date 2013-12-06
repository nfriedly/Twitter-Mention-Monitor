# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false


# my app id's and keys
TWITTER_KEY = "EOQ5iINQEXNtEMizqAWMuQ"
TWITTER_SECRET = "HR8nnuTWsBjyh5yvbIscI1YXd9ogJ7encQPNFcs7Eh8"

# mm's oauth account
#MM_OAUTH_TOKEN = "147611161-RaJnakWEiDWJ4Xnhy4cQFq4PGCVEA0QBNC8JP8qI"
#MM_OAUTH_SECRET = "nPDGfQEGdLDZEVuSdQJNXtOxvLbaMuDtbqa75rX1ej4"
#MM_USERNAME = "mentionmonitor"

# your_mention's oauth account
MM_OAUTH_TOKEN = "162490527-XCtwLkHZjRU73f2B5Eq5kqTXZW7fgVwH8CjVHvr3"
MM_OAUTH_SECRET = "k2vZpv7pDAenmgxcjMJ27DBbMHUTcKonMwgASjeHGI"
MM_USERNAME = "your_mentions"
MM_NEWS_USERNAME = "mentionmonitor"

# won't be needing these, they'll be in the database
#define('NFRIEDLY_OAUTH_TOKEN', '1139651-hIU2jhWeAL7AfR71BnfAlwYvLgcAwZxolbgVBFDc');
#define('NFRIEDLY_OAUTH_TOKEN_SECRET', 'DJt61mq7rwBsAIvwiOY5tPau6OTq47psaxDnzQdsk');

# local gem path (can't ruby get this from the .profile?)
ENV['GEM_PATH']='/home/nfriedly/.gems:/usr/lib/ruby/gems/1.8'

