class User < ActiveRecord::Base
  def twitter
    TwitterOAuth::Client.new(
        :consumer_key => TWITTER_KEY,
        :consumer_secret => TWITTER_SECRET,
        :token => oauth_token, 
        :secret => oauth_secret
    )
  end
  
  def mentions
    twitter.mentions( {:since_id => last_mention_id} )
  end
  
  def follow (follow_username, client=false )
    client = twitter unless client
    # they (moomerman) changed the api in github, so this tries the new (not-yet-gem) method, then the older (in-the-gem) method
    if (
        client.respond_to?('friends?') and not client.friends?(username, follow_username)
      ) or (
        client.respond_to?('exists?') and not client.exists?(username, follow_username)
      )
        client.friend(username)
    end
  end
end
