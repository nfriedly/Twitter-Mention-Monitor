# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'rubygems'
require 'twitter_oauth'


class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
    
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def twitter_mm
    TwitterOAuth::Client.new(
      :consumer_key => TWITTER_KEY,
      :consumer_secret => TWITTER_SECRET,
      :token => MM_OAUTH_TOKEN,
      :secret => MM_OAUTH_SECRET
    )
  end
  
end
